---
favorite: false
id: 19
title: Delayed Job hits 3.0; Marston on Deprecating Legacy Code
---

Delayed Job [went 3.0 recently][dj_post] with two major changes: named queues
and callbacks on the lifecycle of a job. They also changed it so that the
ActiveRecord backend is provided by a gem, which means one could provide another
backend if they were so inclined.

I think the named queues are the only thing I'd use. This could give you a way
to segment jobs and assign a different number of workers based on the importance
of the jobs. Maybe you'd have a "normal" queue and an "important" queue and have
more workers per job on the important one. Looks easy to use:

```
object.delay(:queue => 'important').method
```

Then if you're using rake to work your jobs, just start your worker like this:

```
$ QUEUE=important rake jobs:work
```

They also fixed a couple bugs, but none of them were familiar to me.

---

Really [excellent write-up][dep_rails] of Myron Marston's experience refactoring
some legacy code. He gives us some great insight into the techniques they used,
which were totally new to me. I love this idea that you could add a field to
your user indicating if they should be using the old or new code and then the
surprisingly few places in Rails where they needed to use this flag. Very clean
and organized.

[dj_post]: http://collectiveidea.com/blog/archives/2012/01/04/the-big-three-oh
[dep_rails]: http://myronmars.to/n/dev-blog/2011/12/deprecating-a-legacy-subsystem-in-rails
