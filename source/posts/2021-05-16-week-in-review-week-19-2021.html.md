---
favorite: false
id: 57
title: "Week in Review: Week 19, 2021"
---

Mother's Day was last weekend and we were so busy I didn't have time to write
anything up so playing a bit of catch up here - I shipped a bunch of podcast
episodes but didn't make much progress on my DigitalOcean setup so that's still
WIP.

I did find some time at work to improve the [braze_ruby][] gem that I've been
tinkering with. What I wanted to get going was automated publishing. There are
lots of ways to do this, my current preferences is:

* run a script locally when you want to publish a new version
* that script bumps the version and tags the resulting SHA
* that work is then pushed to GitHub
* CircleCI sees the tag being pushed and that triggers a publish job
* the publish job uses a RubyGems API key to release the new version

So that's what I setup with these two PRs:

* [Add release workflow to publish gem from CI](https://github.com/jonallured/braze_ruby/pull/29)
* [Add script to help automate releases](https://github.com/jonallured/braze_ruby/pull/30)

And I used this config to publish version `0.5.0` just to be sure everything was
setup correctly.

## Highlights

* worked 39:30, no PTO
* published [Kid Swap][pt-22] for Pudding Time
* published [What a Crock][pt-23] for Pudding Time
* published [Request for Comment #3][aer-17] for Artsy Engineering Radio
* shipped [minor fix][jay-45] for jay

## Next Week

I'd love to return to my static site work and finish up that DigitalOcean server
post. Let's see if I can make that happen.

[braze_ruby]: https://github.com/jonallured/braze_ruby
[pt-22]: https://puddingtime.buzzsprout.com/1470301/8480831-kid-swap
[pt-23]: https://puddingtime.buzzsprout.com/1470301/8523115-what-a-crock
[aer-17]: https://podcasts.apple.com/us/podcast/17-request-for-comment-3/id1545870104?i=1000521629173
[jay-45]: https://github.com/jonallured/jay/pull/45

[gh-activity]: https://github.com/search?s=created&o=desc&q=author:jonallured+created:2021-05-02..2021-05-15
