---
number: 89
tags: article
title: "Configure Spec Task Without Verbose Output"
---

My Ruby projects use the default Rake task to run linting and the test suite
plus anything else that might gate the merging of a PR. These days that is
[Standard Ruby][standardrb] and good old [RSpec][] but I sometimes add other
things too. Like this site includes a step of ensuring [Jekyll][] builds the
site correctly.

Here's what this looks like for my cli project called [mli][]:

{%
  include
  framed_image.html
  alt="Terminal output with noise"
  caption="I do not care about those RSpec details!"
  loading="eager"
  slug="before"
%}

To set this up I have Rakefile that looks like this:

```
require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "standard/rake"

RSpec::Core::RakeTask.new(:spec)

task default: %i[standard spec]
```

There's not too much here just some requires so things are available and then I
setup the default task to run Standard Ruby and RSpec in that order.

But did you notice that noise in the output? I hate it when there is noise in my
default Rake task. My goal is to eliminate anything that is not green dots. I
recently learned that you can silence some of that RSpec output like this:

```
RSpec::Core::RakeTask.new(:spec) { |t| t.verbose = false }
```

Updating my Rakefile with that `verbose` attribute set to `false` and now the
output looks like this:

{%
  include
  framed_image.html
  alt="Terminal output without noise"
  caption="Looks so much better!"
  loading="lazy"
  slug="after"
%}

Then I wondered why or where this comes from and so I did a little digging. I
ended up finding [the source code][code] for `RSpec::Core::RakeTask` and sure
enough there is the explanation:

```
# Use verbose output. If this is set to true, the task will print the
# executed spec command to stdout. Defaults to `true`.
attr_accessor :verbose
```

I'm still a bit puzzled by this choice. Seems like verbose output should be
disabled by default but at least now I know why and how to turn it off.

[standardrb]: https://github.com/standardrb/standard
[RSpec]: https://rspec.info
[Jekyll]: https://jekyllrb.com
[mli]: https://github.com/jonallured/mli
[code]: https://github.com/rspec/rspec/blob/299be812ea79ee2a0c55c76053d3ed3cd1ffe9fe/rspec-core/lib/rspec/core/rake_task.rb
