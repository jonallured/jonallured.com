---
number: 60
tags: review
title: "Week in Review: Week 22, 2021"
---

Well I've missed a few weekly update posts but that's ok, posting these every
week isn't the goal - the goal is the habit and life happens around it. Last
weekend was my birthday and we were out of town which was so so nice. It meant a
short work week but I actually got a lot done!

Anyway, I _finally_ finished setting up a new server for my static sites and
wrote up the notes for a post (see below). A notable change I'm trying out:
separate the work of CI from the deployment. So given a static site like
[cybertail.systems][] have CircleCI run the tests but then configure GitHub
Actions with a workflow that deploys the site to DigitalOcean:
[verynicecode/cybertail-site#4][pull-4].

Why this extra complexity? Well the thing is that when it comes to deploying I
have to specify some secrets. If I do this with CircleCI then that prevents me
from building forked pull requests. This doesn't really matter for a project
like the Cybertail site, but I noticed that when my pal Steve Hicks [opened a
PR][pull-28] on [pear][] it did not build.

That got me thinking about my approach and while pondering I remembered that
GitHub Actions existed and that I could build a separate deployment pipeline and
not interfere with the PR feedback pipeline. More complex yes, but also simple
in the sense that what happens at CircleCI is open and what happens with GitHub
Actions is closed. That's a simple mental model so I like that aspect of this
setup. We shall see!

## Highlights

* worked 32:00, 8:00 PTO
* published [Configure Prompt on iOS With SSH Keys][post-58] on here
* published [Updated DigitalOcean Server Setup][post-59] on here

## Next Week

Like I said, I have a brand new spiffy server to host my static sites - woo!
I've migrated a couple sites over and hope to find the time to migrate the rest
over the next week.

I think the next milestone on this front is figuring out what to do with the
Apache log files I'm generating. I'd really like to drop Google Analytics from
any sites I host but want to have server logs as a close-enough replacement. My
bet is that I can find some tool to parse and display these log files so it'll
probably just take a bit of research/tinkering to set it all up.

[cybertail.systems]: https://www.cybertail.systems
[pull-4]: https://github.com/verynicecode/cybertail-site/pull/4
[pull-28]: https://github.com/jonallured/pear/pull/28
[pear]: https://github.com/jonallured/pear
[post-58]: https://www.jonallured.com/posts/2021/06/05/configure-prompt-on-ios-with-ssh-keys.html
[post-59]: https://www.jonallured.com/posts/2021/06/05/updated-digitalocean-server-setup.html

[gh-activity]: https://github.com/search?s=created&o=desc&q=author:jonallured+created:2021-05-23..2021-06-05
