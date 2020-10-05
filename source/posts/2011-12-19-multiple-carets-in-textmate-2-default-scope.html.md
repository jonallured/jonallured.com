---
favorite: false
id: 9
title: Multiple Carets in TextMate 2.0; Default Scope
---

Don't get me wrong, I'm quickly learning to love VIM since that's all we use at
Hashrocket, but TextMate will always be the first text editor that I loved. I
haven't been following the Alpha that closely, but I did read about the new
[Multiple Caret features][multiple_carets] and I'm really excited about it, I
think it looks pretty great.

---

Found out about `default_scope` on [Destroy All Software 21: Coupling and
Abstraction][das_screencast]. When you do:

```
User.all
```

And you've got:

```
class User < ActiveRecord::Base
  default_scope where(active: true)
end
```

Then the `all` method will use that default and only return active users. Pretty neat.

Gregory warns though, that you can easily become coupled to this behavior in a
bad way and advises that if you actually want to use this default, you might
want to try using an alias instead:

```
class User < ActiveRecord::Base
  default_scope where(active: true)

  class << self
    alias_method :all_active_users, :all
  end
end
```

And then you can use `User.all_active_users` instead. What's nice about this
approach is that if you later want to change the default scope, you'll notice
that the `all_active_users` is using it and can make a better choice about your
change.

[multiple_carets]: http://blog.macromates.com/2011/multiple-carets
[das_screencast]: https://www.destroyallsoftware.com/screencasts/catalog/coupling-and-abstraction
