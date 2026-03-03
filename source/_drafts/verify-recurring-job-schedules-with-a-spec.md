---
number: 99
tags: article
title: "Verify Recurring Job Schedules With a Spec"
---

My Ruby on Rails app [Monolithium][] uses [Solid Queue][sq] for background jobs
but also has some recurring jobs. When I [migrated to Solid
Queue][monolithium-258] I typoed the schedule strings for these recurring jobs
and then had to [make a PR to fix them][monolithium-259]. This felt like a silly
mistake and seemed like something that could have easily been prevented. I made
a mental note but moved on with my life.

Then this verification topic came up at work this week. I addressed it there and
then took the opportunity to apply it to my Rails app as well.

## Solid Queue Recurring Job Schedules

The recurring jobs that are managed by Solid Queue are configured with a YAML
file that looks something like this:

```
# config/recurring.yml

production:
  name_of_job:
    class: MyBestJob
    schedule: every 10 minutes
```

The top-most key is the environment to run so here I'm using `production` but
you could also specify jobs just for `development` but I never have. From there
the next level of key is the name of the recurring job or task that you want to
define. Then inside that key you specify the `class` and `schedule` and any
additional configuration. What I've specified here is that every 10 minutes the
`MyBestJob` class should be enqueued and worked.

For that `schedule` string here's what the Solid Queue docs have to say:

> Each task needs to have also a schedule, which is parsed using Fugit, so it
> accepts anything that Fugit accepts as a cron.

Ah ha so now we know how these schedule strings are used - they are passed off
to [Fugit][] and whatever that gem accepts is allowed here.

[Fugit]: https://github.com/floraison/fugit

## Fugit Parsing

The Fugit gem can parse a lot of different types of inputs. It can take
something high level like "every 10 minutes" but then it can also take low level
cron strings like "5 4 * * sun" which I just randomly generated from
[crontab.guru][cg]. That range of inputs then is inherited by Solid Queue. Neat!

## Writing a Spec to Verify Schedule Strings

With all this in mind the idea for this spec is to read in the config file, grab
the schedule strings, and then parse them with Fugit. I learned from the Fugit
docs that I could use `Fugit.parse` for this and it will return nil if the input
string cannot be parsed.

I made [Verify recurring job schedules with a spec][monolithium-302] and here's
what I ended up with:

```
describe "recurring schedules" do
  it "only has valid schedule strings" do
    config_path = Rails.root.join("config/recurring.yml")
    recurring_config = ActiveSupport::ConfigurationFile.parse(config_path)
    tasks = recurring_config.values.map(&:values).flatten
    schedules = tasks.map { |task| task["schedule"] }
    schedules.each do |schedule|
      expect(Fugit.parse(schedule)).to_not eq nil
    end
  end
end
```

What this spec does is use the `ActiveSupport::ConfigurationFile` helper to grab
the contents of the recurring jobs config file. That will already have converted
it into a hash so then I deconstruct that hash and pluck out the values of the
`schedule` keys and make an array out of that. Then I loop over that array and
send each string to the `Fugit.parse` method with an assertion that the result
is not nil. If the config file is valid then the test passes. If I edit the file
and use a schedule that is invalid then the test fails. Confidence restored!

## Conclusion

This is exactly what I wanted - a safety net that will ensure I do not repeat
the mistake of using an incorrect schedule string. I'm not fully satisfied
though. There are two things bothering me: the lack of help when the test fails
and that Solid Queue should be helping me here.

For that first one what I noticed is that if I intentionally make the test fail
then the error message is all about how something is nil. What I think a better
test would do is give me which schedule broke. I bet I could write something
like a custom matcher for this but who has the time??

Then the other thing is that honestly why doesn't Solid Queue give me something
to work with here? If I had the idea for this spec then I'm sure others have as
well. In my imagination there are all these teams using Solid Queue and writing
the exact same type of test - what a waste! Many Rails related gems have a test
helper or test mode or something like that. I guess if I really cared about this
what I would do is open up an issue or PR on that project but who has the time??

[Fugit]: https://github.com/floraison/fugit
[Monolithium]: https://github.com/jonallured/monolithium
[cg]: https://crontab.guru
[monolithium-258]: https://github.com/jonallured/monolithium/pull/258
[monolithium-259]: https://github.com/jonallured/monolithium/pull/259
[monolithium-302]: https://github.com/jonallured/monolithium/pull/302
[sq]: https://github.com/rails/solid_queue
