---
favorite: false
id: 62
title: "Week in Review: Week 24, 2021"
---

I had high hopes for this week but ended up not having much time to tinker with
things until this morning. That's ok, I was pretty productive and got the
remainder of my static sites migrated over to my new server and updated to use
GitHub Actions to deploy.

When I went to migrate and deploy this site I also wanted to upgrade Ruby to 3
and found it pretty challenging. I ran into issues with the latest 4.x Middleman
release on RubyGems but when I switched over to GitHub and the master branch it
worked great. I don't love being on an unreleased version of the main lib I'm
using for a project but I didn't feel like I had many better options.

I did run into a couple relevant comments on GitHub:

* [middleman/middleman#2400][mm-2400]
* [middleman/middleman#2422][mm-2422]


So my particular problem was fixed but unreleased on the 4.x branch but also the
v5 work seems like it might not come out? Very confused and yeah open source can
be like this.

## Highlights

* worked 31:00, 9:00 PTO
* published [Season 1 Finale][pt-25] for Pudding Time
* published [Request for Comment #5][aer-22] for Artsy Engineering Radio

## Next Week

Now that I've got all my static sites migrated it's time to decommission the old
server. I _think_ this will be as easy as destroying the Droplet in DO's
interface but I'm going to give it a few more days to be sure that my DNS
changes have had a chance to propagate out.

Either way, my next goal was to drop Google Analytics. The aforementioned
difficulties upgrading to Ruby 3/Middleman 5 caused me to actually already do
this. The existing Middleman extension for GA isn't compatible with MM5 so I
just dropped it outright.

But I'd like to return to this topic of analytics. I think the MVP here is some
routine process that scrapes my log files and computes a report that's sent to
my email. Just something simple like a table of the sites hosted and each day's
total requests or something. I can iterate from there.

[mm-2400]: https://github.com/middleman/middleman/issues/2400#issuecomment-732464743
[mm-2422]: https://github.com/middleman/middleman/issues/2422#issuecomment-819745887

[pt-25]: https://puddingtime.buzzsprout.com/1470301/8727720-season-1-finale
[aer-22]: https://www.buzzsprout.com/1781859/8721383

[gh-activity]: https://github.com/search?s=created&o=desc&q=author:jonallured+created:2021-06-13..2021-06-19
