---
number: 10
tags: article
title: "Rails 3.2; Command Reuse; Fixed Position on Mobile; Ruby Metaprogramming"
---

DHH [announced Rails 3.2, RC1][rails_post] and highlighted a few of the cool new
things that landed. What stood out to me was the bit about Active Record Store.
More details please!

---

Jakob Nielsen reviews why command reuse or overloading a command is often
[confusing to users][overloaded]. The example about two search fields on the
same page is something I've actually seen first-hand in user studies and worked
very hard to eliminate at Allured.

I also found the part about confusion in Android with the home and back buttons
pretty compelling. He gives the example of a magazine app that has a home button
that will send you back to the app's list of issues and another home button at
the system-level that takes you back to your phone's home screen.

This is exactly why I never liked Android, the best things about iOS is that
when you're in an app, the whole screen is for that app and the only way out is
the one and only hardware button. This design side-steps lots of confusion and
lets the app be in total control of what a user sees.

---

PPK does a nice little [roundup][position_fixed] of `position: fixed`
implementations, with video! I'm not sure how I feel about this, but I do know
its getting better. It wasn't that long ago that you'd git a site with one of
those goofy 'toolbars' that would just sit there covering up part of the screen.

---

I recently found out about the dynamic `find_by` methods from the great [Matt
Polito][polito], and while reading a post by Pat Shaughnessy, I found out about
the `scoped_by` dynamic methods.

There was more in his [article about metaprogramming][metaprogramming], for
instance, I saw `Enumerable#zip` and didn't know what it was, so I found out: it
can merge two arrays:

```
[:a, :b].zip([:c, :d]) # => [[:a, :c], [:b, :d]]
```

So that's neat. Worth a read also for his reminder about how to metaprogram so
that 'future-you' wont be pissed at 'present-you'.

[rails_post]: http://weblog.rubyonrails.org/2011/12/20/rails-3-2-rc1-faster-dev-mode-routing-explain-queries-tagged-logger-store
[overloaded]: http://www.useit.com/alertbox/overloaded-commands.html
[position_fixed]: http://www.quirksmode.org/blog/archives/2011/12/position_fixed.html
[polito]: https://twitter.com/mattpolito
[metaprogramming]: http://patshaughnessy.net/2011/12/20/learning-from-the-masters-part-2-three-metaprogramming-best-practices
