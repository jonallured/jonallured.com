---
layout: post
title: Notes Help You Learn; Changing Directories
---

{{ page.title }}
================

<p id="articleDate">published Saturday, December 17, 2011</p>

I read about [the value of taking notes](http://swombat.com/2011/12/11/taking-notes) and was inspired to try taking notes while I read. This topic reminded me of that part of Junior High where we were taught note taking styles. One thing I remember was folding a paper in half and then writing stuff on one side or the other.

I struggle with retaining all the shit I read, so if this help, then great. And I'm going to post these notes here.

---

During my audition week at [Hashrocket](http://www.hashrocket.com) I saw someone type this at the command line:

	$ cd ..; cd -

They were working with RVM and they had just cloned down a repo, but the `--create` flag wasn't in the [.rvmrc file](http://beginrescueend.com/workflow/rvmrc/) so they had the right Ruby, but no Gemset. You can fix this by creating the Gemset, but its better to add the flag to the rc file. Once you've done that, you can run the command above and you'll cd up a level and then back down and trigger the .rvmrc file again. I could look at it and know that's probably what it did, but I never really knew what that last bit was all about.

But to take a small step back, the first thing to know is that `;` can be used to input a series of commands to run in sequence. Then, while reading a [list of unix commands](http://www.commandlinefu.com/commands/browse/sort-by-votes) I noticed the last bit. The `cd -` command returns you to the previous working directory. Mystery solved.

There were some other interesting things in there, have a look!