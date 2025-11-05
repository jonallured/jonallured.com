---
number: 51
tags: review
title: "Week in Review: Week 13, 2021"
---

I've mentioned this before but at work we're integrating with a new marketing
platform called Braze. I did some research on Ruby gems that wrap their API and
saw an [opportunity to consolidate][appboy-issue] efforts. This week I got
access to the [braze_ruby][] gem and did some tinkering with it to get a good CI
pipeline running. I made a minor change to get it compatible with Ruby 3 so that
was cool.

I also used this project as an opportunity to kick the tires on [StandardRB][]
and did [a PR that sets it up and complies][standard_pr]. I really like the idea
of opinionated linters with (near) zero config!

My only gripe is that I can't figure out how to run both StandardRB and RuboCop
on my local [vim ale][ale] setup. The way this is configured is with a line in
your `.vimrc` like this:

```
let g:ale_linters = { 'ruby': ['rubocop', 'standardrb'] }
```

Items can be added to that array and ordered to ones liking but violations stop
the sequence. As an example, the default for RuboCop is single quotes and the
default for StandardRB is doubles. That means that regardless of the order of
those two linters, you'll always be stuck in a loop of violation. 🤷

I can't remove RuboCop in favor of StandardRB because then all the many many
projects I work on that are using RuboCop suddenly have violations for
StandardRB even though they are green for RuboCop. And I can't migrate them all
over to StandardRB from RuboCop nor would I want to.

So yeah, been pondering this and haven't come up with a good solution...

## Highlights

* worked 40:30, no PTO
* published [a Pudding Time episode][pt] with Josh's friend Joe

[appboy-issue]: https://github.com/DynamoMTL/appboy/issues/25
[braze_ruby]: https://github.com/jonallured/braze_ruby
[StandardRB]: https://github.com/testdouble/standard
[standard_pr]: https://github.com/jonallured/braze_ruby/pull/28
[ale]: https://github.com/dense-analysis/ale

[pt]: https://puddingtime.buzzsprout.com/1470301/8263706-with-joe

[gh-activity]: https://github.com/search?s=created&o=desc&q=author:jonallured+created:2021-03-28..2021-04-03
