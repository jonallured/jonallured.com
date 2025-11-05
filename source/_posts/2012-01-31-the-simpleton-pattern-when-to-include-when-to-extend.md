---
number: 26
tags: article
title: "The Simpleton Pattern; When to Include, When to Extend"
---

After [my post on the Singleton pattern][singleton], fellow Rocketeer [Stephen
Caudill][voxdolo] directed me towards Steve Yegge's post on the [Simpleton
Pattern][simpleton]. Its a fairly snarky post, but there's real insight to be
had. I think his main point is that the Singleton pattern is overused and that
its usually bad design to use it because of its global nature.

Yegge says that the Singleton is actually a throwback to non OO programming,
that it is an escape hatch one can use when OO gets too intense. He talks about
how he loved this pattern and used it quite a bit until he realized that all he
was doing was using these classes as namespaces for global functions. Its great
to read criticism like this, helps me have a more well-rounded view of things.

---

I haven't had much experience with writing Modules in Ruby and so I've always
been a little confused about the difference between `include` and `extend`, but
Aaron Lasseigne's [write up on the topic](/rotten.html#23) was really helpful. He
starts out by giving us the common definition of when you use one or the other:

> You **include** a module to add instance methods to a class and **extend** to
> add class methods.

He goes on to explain why this isn't the whole story, staring with how instance
and class methods are stored. So, given this class:

```ruby
class Klass
  def foo; end
  def self.bar; end
end
```

You can find `#foo` and `.bar` like this:

```ruby
Klass.new.methods - methods # => [:foo]
Klass.methods - Object.methods # => [:bar]
Klass.singleton_methods # => [:bar]
```

I had never seen `Object#singleton_methods` before and I got curious what else
was out there, so I jumped over to `irb` and ran:

```ruby
Object.methods.select { |method| method.to_s =~ /single/ }
# => [:singleton_class, :singleton_methods, :define_singleton_method]
```

And this is when I remembered some conversations [Brian Dunn][brian] (another
Rocketeer) and I have had about the eigenclass. I went hunting for more
information to make sure I was putting this together correctly and found a
[write up](/rotten.html#18) from Andrea Singh that confirmed it.

When `.bar` is defined for Klass, its actually being defined on the eigenclass
of Klass, thus the `singleton_methods` method inspects this for methods and
that's what its returning.

Lasseigne then defines `include` and `extend` with this information in mind:

> **include:** adds methods from the provided Module to the object
> **extend:** calls include on the singleton class (eigenclass) of the object

Reading these two posts and their diagrams really helped clarify that the
Eigenclass is just another name for the Singleton class that's created when you
define methods on an object and the relationship between Module instance methods
and class methods with the thing that's getting them mixed in.

[singleton]: /posts/2012/01/27/brown-on-the-singleton-in-ruby.html
[voxdolo]: http://twitter.com/voxdolo
[simpleton]: https://sites.google.com/site/steveyegge2/singleton-considered-stupid
[brian]: http://twitter.com/higgaion
