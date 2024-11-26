---
favorite: false
number: 32
title: Cheek and Grimm on Modules
---

Josh Cheek [shares some thoughts][josh_post] he's had about Module inclusion and
challenges some of the standard Ruby practices around them. Cheek seems to be
unhappy that its idiomatic Ruby to `include` a Module only because you want to
get the `included` callback. He would rather see us writing methods that add
this behavior explicitly. He provides some examples of alternatives to the
typical way one might use a Module and they seemed interesting.

Then Avdi Grimm responds in a [post of his own][avdi_post] where he agrees with
some of Cheek's ideas and not with others. Grimm has this idea of being able to
compose with ActiveRecord rather than having it pollute the public methods and
the pseudo code is worth a read.

[josh_post]: http://blog.8thlight.com/josh-cheek/2012/02/03/modules-called-they-want-their-integrity-back.html
[avdi_post]: http://devblog.avdi.org/2012/02/03/on-module-integrity
