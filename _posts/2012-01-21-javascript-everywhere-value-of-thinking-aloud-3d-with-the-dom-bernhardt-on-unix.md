---
layout: post
title: JavaScript Everywhere; The Value of Thinking Aloud; 3D With Just the DOM; Bernhardt on Unix
published_at: Saturday, January 21, 2012
---

Luke Wroblewski does a great job [articulating why JavaScript is so hot right now](http://www.lukew.com/ff/entry.asp?1482). It didn't occur to me that MongoDB is really just JavaScript, but that's the "J" in JSON, right? Reading this really makes me want to work on something with Node.

---

Nielsen talks about the [value of thinking alound](http://www.useit.com/alertbox/thinking-aloud-tests.html) and reiterates something he's said before:

> Thinking aloud may be the single most valuable usability engineering method.

I know in my work, encouraging people to think aloud while they test something for me has always gleaned a lot of insight into things like positioning of elements on the page or flow of screens or even just labels that might not make sense. I'm a big believer in this idea. Here's Nielsen's official definition:

> In a thinking aloud test, you ask test participants to use the system while continuously thinking out loud — that is, simply verbalizing their thoughts as they move through the user interface.

He goes on to note that its not always very natural for people to keep up a monologue of what they're doing and helping them do this is one of the jobs of a test facilitator. I've actually seen this is action and can attest to both the truth of that assertion and the value of a good facilitator.

This is a fantastic write up on one of my favorite techniques for getting feedback on a project.

---

Steven Wittens does a [write up for his blog's most recent redesign](http://acko.net/blog/making-love-to-webkit/) and the tech he used to achieve the most bad-ass header I've seen in quite a while. But before I got to that, I had to look up a solid definition of parallax:

> Parallax is a displacement or difference in the apparent position of an object viewed along two different lines of sight, and is measured by the angle or semi-angle of inclination between those two lines.

As with most visual things, its easier to see the definition than to read it, so check out the sweet animated gif on the [Wikipedia page for parallax](http://en.wikipedia.org/wiki/Parallax) where this definition comes from.

Ok, so some of the details are over my head, but basically Witten wrote a [CSS 3D Editor](http://acko.net/editor.html) that he uses to create 3D effects with nothing but native HTML elements and some JavaScript, no WebGL required. Its cray-cray - go play around with the CSS 3D Editor he built (click and drag to move around, keyboard controls defined in the write up).

Oh, and if you have both Safari and Chrome, check out the page in both and see if you can detect a performance difference, I sure could.

---

Watched a [great presentation from Gary Bernhardt](http://confreaks.net/videos/615-cascadiaruby2011-the-unix-chainsaw) on Unix where he talks about how to compose the command line. The first thing that jumped out at me was this great quote:

> Half-assed is OK when you only need half of an ass.

Here he's letting us off the hook on completely solving problems that aren't our concern.

Then he goes into talking about what it means to be a programmable system and throws another quote at us:

> The language used at each level of a stratified design has **primatives, means of combination and means of abstraction** appropriate to that level of detail.

So, there are three things needed for a truly programmable system and in the case of Unix, these break down like this:

Primatives:

* Files
* Binaries

Means of Composition:

* Pipes
* Loops
* Subshells

Means of Abstraction:

* Functions
* Scripts

He walks through each giving examples and talking about how this all ties together. Made me think about the command line in a whole different way.

Something that I picked up was how Bernhardt was making shell functions and I didn't know you could do that. I searched and found a [write up](http://tldp.org/LDP/abs/html/functions.html) that talks about shell functions:

	$ bamf { echo 'still alive?'; }
	$ bamf # => still alive?

So, that's pretty cool and kind of obvious, but I never knew it before.

Back to the talk - after Bernhardt finishes going through the three sections on what makes up a programmable shell, he gives us a couple things to avoid:

* Tar pit of immediacy
* Proficiency fatalism

The tar pit is about getting stuck doing something one way and never reevaluating whether its the best way to go. He offers pair-programming as a way to keep you from getting stuck in this way.

Proficiency fatalism is where you see someone that's great at something and think that you could never do what they can. This one is something that I've experienced and struggle with. Heck watching Bernhardt's [Destroy All Software](https://www.destroyallsoftware.com/screencasts) series is an example of something that causes me to feel this way. But looking back helps me - I think about where I was at before I taught myself Rails and got serious about web development and its clear that I can pick this stuff up and there isn't anything intrinsically different between me and someone that knows more than I do. Its actually quite liberating.

Then he gives us two things we should do:

* Use more pipes and functions
* Pay attention to how much ass you need

The first is about how sometimes its worth writing stupid lines just to learn and sear into your brain better ways of composing the shell. Maybe not appropriate while doing billable work, but on your own, try to come up with wacky one-liners because it will get you better at the shell.

The second is about quality and completeness, which he affectionately refers to as "ass" and I think its a great point. He talks about how there is actually a spectrum of quality, with something like the [Software Craftsmanship](http://manifesto.softwarecraftsmanship.org/) movement on one side and something like [Lean Startup](http://theleanstartup.com/) on the other. Neither are right or wrong, but its up to us to know where we should be on this spectrum for the project we're working on, or even just the problem in front of us at the moment.