---
number: 38
tags: article favorite
title: "Commit Lint for Danger"
---

I love using [Danger][danger] to automate routine Pull Request feedback and so I
made a plugin that [lints commit messages][plugin]. It was an interesting
process and I wanted to share some thoughts about it.

## Commit Guidelines

I tend to follow [Tim Pope's ideas][tpope] about commit messages. To boil down a
great post into something Danger could automate, I started with these three
rules:

* Message subject should be no longer than 50 characters
* Message subject should not end in a period
* Message subject and body should be separated by an empty line

## Using the Plugin

After having [setup Danger][setup], simply add this line to your Dangerfile:

```ruby
commit_lint.check
```

Additionally, you may want to [configure the plugin][config]. Maybe you'd rather
warn instead of fail the PR, you can do that like this:

```ruby
commit_lint.check warn: :all
```

Or maybe you don't care about subjects ending in a period, you can disable a
particular check like this:

```ruby
commit_lint.check disable: [:subject_period]
```

## Initial Code

This plugin started life as just a few lines in the [Dangerfile of
RubyConferences.org][rc_dangerfile]:

```ruby
# not included here is the error_messages hash
# but this is the interesting part ;)

for commit in git.commits
  (subject, empty_line, *body) = commit.message.split("\n")
  fail error_messages[6] if subject.length > 50
  fail error_messages[7] if subject.split('').last == '.'
  fail error_messages[8] if empty_line && empty_line.length > 0
end
```

It was a great start and actually caught a couple mistakes!

## Plugin Extraction

As I worked on extracting the plugin, I realized that there were things I'd want
to do, like the configuration I mentioned above. I also was able to get tests
around the plugin's behavior, which (surprise!) found bugs and helped improve
the code quite a bit.

A Danger plugin is simply a Ruby class that inherits from `Danger::Plugin` and
exposes some public methods. In my case, I wrote a class called
`Danger::DangerCommitLint` and exposed a `check` method:

```ruby
module Danger
  class DangerCommitLint < Plugin
    NOOP_MESSAGE = 'All checks were disabled, nothing to do.'.freeze

    def check(config = {})
      @config = config

      if all_checks_disabled?
        warn NOOP_MESSAGE
      else
        check_messages
      end
    end
  end
end
```

At a high-level that's about it - we take in some config, ensure there is at
least one check to perform and then perform those checks. Pretty small public
interface to test, right??

## Testing Danger Plugins

The plugin template includes a spec helper that provides you a Dangerfile
context and you simply grab a reference to your plugin and then call methods on
it:

```ruby
commit_lint = testing_dangerfile.commit_lint
commit_lint.check
```

Probably the easiest way to test your plugins is by asserting about their
`status_report`, a hash of `:errors`, `:warnings`, `:messages` and `:markdowns`.
I wrote a little helper to assert about the counts:

```ruby
def report_counts(status_report)
  status_report.values.flatten.count
end
```

I've got a constant with various test messages and then I wrote a bunch of
integration-style tests like this:

```ruby
describe 'check without configuration' do
  context 'with all errors' do
    it 'fails every check' do
      commit_lint = testing_dangerfile.commit_lint
      commit = double(:commit, message: TEST_MESSAGES[:all_errors])
      allow(commit_lint.git).to receive(:commits).and_return([commit])

      commit_lint.check

      status_report = commit_lint.status_report
      expect(report_counts(status_report)).to eq 3
      expect(status_report[:errors]).to eq [
        SubjectLengthCheck::MESSAGE,
        SubjectPeriodCheck::MESSAGE,
        EmptyLineCheck::MESSAGE
      ]
    end
  end
end
```

We use the `:all_errors` test message to create a double and stub out the git
commits with it. Then, we run our checks and ensure that both the error count
and particular error messages match our expectations. Easy!

## Check Classes

I like classes, so it wasn't long before I was extracting those simple lines in
the initial implementation into classes that I could use to check the commits.
Here's the superclass I came up with and then the checker for subject length:

```ruby
module Danger
  class DangerCommitLint < Plugin
    class CommitCheck # :nodoc:
      def self.fail?(message)
        new(message).fail?
      end

      def initialize(message); end

      def fail?
        raise 'implement in subclass'
      end
    end
  end
end

module Danger
  class DangerCommitLint < Plugin
    class SubjectLengthCheck < CommitCheck # :nodoc:
      MESSAGE = 'Please limit commit subject line to 50 characters.'.freeze

      def self.type
        :subject_length
      end

      def initialize(message)
        @subject = message[:subject]
      end

      def fail?
        @subject.length > 50
      end
    end
  end
end
```

All the superclass really does is provide a class method that instantiates and
then calls that `fail?` method. I really like this pattern and use it all the
time on simple classes like this. More on this in a bit.

The main job of the `SubjectLengthCheck` class is to implement that `fail?`
method and provide both a `MESSAGE` and `type`. The former gets sent to the user
when this check fails and the latter is used to map the config symbols to
checker classes.

## The Private Parts

I sorta avoided the details when showing the `DangerCommitLint` class above, but
I wanted to lay some groundwork first. Let's look at the private parts of that
file:

```ruby
module Danger
  class DangerCommitLint < Plugin
    # public stuff ...

    private

    def check_messages
      for message in messages
        for klass in warning_checkers
          messaging.warn klass::MESSAGE if klass.fail? message
        end

        for klass in failing_checkers
          messaging.fail klass::MESSAGE if klass.fail? message
        end
      end
    end

    def checkers
      [SubjectLengthCheck, SubjectPeriodCheck, EmptyLineCheck]
    end

    def checks
      checkers.map(&:type)
    end

    def enabled_checkers
      checkers.reject { |klass| disabled_checks.include? klass.type }
    end

    def warning_checkers
      enabled_checkers.select { |klass| warning_checks.include? klass.type }
    end

    def failing_checkers
      enabled_checkers - warning_checkers
    end

    def all_checks_disabled?
      @config[:disable] == :all || disabled_checks.count == checkers.count
    end

    def disabled_checks
      @config[:disable] || []
    end

    def warning_checks
      return checks if @config[:warn] == :all
      @config[:warn] || []
    end

    def messages
      git.commits.map do |commit|
        (subject, empty_line) = commit.message.split("\n")
        { subject: subject, empty_line: empty_line }
      end
    end
  end
end
```

An Array of classes?? Sure, this is Ruby, we can do whatever we want!

Our public interface simply ensures `all_checks_disabled?` return false and then
calls `check_messages`. That method then iterates over the commits in the PR and
runs whatever checks are supposed to be run.

To determine which checks should be run we get to think about classes and their
types (symbols). We've abstracted this code to the point where [adding a new
check][new_check] is as easy as adding an item to that `checkers` array - nice!

Remember that superclass and the class-level `fail?` method? That's what we're
using so that we can write this super cute line:

```ruby
messaging.warn klass::MESSAGE if klass.fail? message
```

## Rubocop

I had never used [Rubocop][rubocop] before, but the plugin template sets it up
for you, so I thought I'd give it a shot. I was really enjoying
[SwiftLint][swiftlint] in my current work project, so I figured it would be easy
to get setup and [configured][rubocop_config] the way [I like things][dont_kid].

Boy was my initial code bad!

I got warnings about things like [cyclomatic complexity][cyclo], [perceived
complexity][perceived] and [ABC Metric][abc]. Huh? What am I, a computer
scientist??

I had tons of work to do to make Rubocop happy, but it was worth it. I feel like
I ended up with a very readable codebase and some of that is because of
Rubocop's nudges.

I initially had some pain because the default template uses `fail` and that was
causing a Rubocop warning. Once [I learned][learned] that you can use
`messaging.fail` instead, I was able to [remove the comment][remove_comment]
that disabled the warning.

## Conclusion

What started as just a few lines of code ended up [cloc][cloc]ing in at around
450 lines, so that's pretty good, right??

But seriously, I have to give a big thanks to [Orta][orta] and [Felix][felix]
for creating Danger, I think it's a really great tool and I hope to use it on
many future projects! Also: check out this [VISION.md][vision] file - sick,
right??

I had a lot of fun extracting this plugin and working on improving the code
until not only the tests passed, but the Rubocop and documentation checks also
passed. And I even got it on the [official plugin list][list]!!

[danger]: http://danger.systems
[plugin]: https://github.com/jonallured/danger-commit_lint
[tpope]: http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html
[setup]: http://danger.systems/guides/getting_started.html
[config]: https://github.com/jonallured/danger-commit_lint#configuration
[rc_dangerfile]: https://github.com/ruby-conferences/ruby-conferences.github.io/blob/af8bc12b6c4ee027e2006b01e1f76c1d00b6cf9c/Dangerfile#L16
[rubocop_config]: https://github.com/jonallured/danger-commit_lint/blob/master/.rubocop.yml#L4
[dont_kid]: https://twitter.com/jonallured/status/769018523393941504
[cyclo]: https://en.wikipedia.org/wiki/Cyclomatic_complexity
[perceived]: http://mattgemmell.com/perceived-software-complexity/
[abc]: http://c2.com/cgi/wiki?AbcMetric
[new_check]: https://github.com/jonallured/danger-commit_lint/pull/2
[rubocop]: https://github.com/bbatsov/rubocop
[swiftlint]: https://github.com/realm/SwiftLint
[learned]: https://twitter.com/orta/status/769279173214994432
[remove_comment]: https://github.com/jonallured/danger-commit_lint/commit/9ca11d66b5bb53530fc8abe6c1a753711af40a72
[cloc]: https://github.com/AlDanial/cloc/
[orta]: http://orta.io/
[felix]: https://krausefx.com/
[vision]: https://github.com/danger/danger/blob/master/VISION.md
[list]: https://github.com/danger/danger.systems/pull/93
