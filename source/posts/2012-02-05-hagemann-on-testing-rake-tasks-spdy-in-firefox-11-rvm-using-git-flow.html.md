---
title: Hagemann on Testing Rake Tasks; SPDY in FireFox 11; RVM Using Git Flow
---

Stephan Hagemann had a good [post on testing Rake tasks](http://pivotallabs.com/users/shagemann/blog/articles/1967-test-your-rake-tasks-). What I liked about it was the "before/after" structure of the post -- first he shows the anti-pattern and then he describes the approach he prefers. This is a good model for technical posts of this nature and I will try to remember it for my own writing.

The content was great too -- I've always been a little lost when it comes to testing Rake tasks, but Hagemann's suggestions seem like good ones.

---

SPDY just [landed in FireFox 11](http://hacks.mozilla.org/2012/02/spdy-brings-responsive-and-scalable-transport-to-firefox-11/). SPDY is a protocol for transporting web content. You've probably heard of HTTP, another protocol for transporting web content, so what makes SPDY different? Its the way it prioritizes and multiplexes the downloading of web page elements such that only one connection is made to the server. The exact technical details are over my head, but this is good work that could make some headaches for web developers a little easier. I'm especially excited about it for mobile devices where server connections aren't cheap over lousy 3G connections.

I first heard about it on [an episode of Hypercritical](http://5by5.tv/hypercritical/36) and thought it was neat but maybe just a wacky Google experiment that would never go anywhere, so I was fairly surprised to see that Mozilla took a run at it for their Browser.

Its not an official spec yet, but its going that way -- it will be interesting to see if its implemented by Opera, Microsoft or Apple, but I think its something to watch.

---

The RVM team switched to using the [Git Flow](http://nvie.com/posts/a-successful-git-branching-model/) approach to structuring their project and have [finished the transition](http://www.engineyard.com/blog/2012/rvm-stable-and-more), so now you can run:

	$ rvm get stable

And you'll stay on the stable branch. Neato. Check that post for a few other changes to the behavior of RVM.

I had heard of Git Flow before, but took this as an opportunity to read up about it. After reading Vincent Driessen's original post about Git Flow (above), I found Jeff Kreeftmeijer's post on [why he likes this approach so much](http://jeffkreeftmeijer.com/2010/why-arent-you-using-git-flow/). He talks about using the [git extensions](https://github.com/nvie/gitflow) and how he uses them in various situations. I enjoyed thinking about another workflow and would be interested in trying this system in a future project.

