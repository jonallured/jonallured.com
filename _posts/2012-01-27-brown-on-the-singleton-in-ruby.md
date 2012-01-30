---
layout: post
title: Brown on the Singleton in Ruby
---

{{ page.title }}
================

<p id="articleDate">published Friday, January 27, 2012</p>

[I read the second post](http://jonallured.com/2012/01/20/brown-on-structural-design-patterns-in-ruby.html) Gregory Brown did on design patterns in Ruby first, but I wanted to go back and read [the first one on creational patterns](http://blog.rubybestpractices.com/posts/gregory/059-issue-25-creational-design-patterns.html). I ended up spending a lot of time working through just the Singleton pattern because he updated his thoughts there with [another write up](http://practicingruby.com/articles/shared/jleygxejeopq) that was equally insightful and thorough.

A singleton is used when you only need one instance of a class. There is official support for this pattern in Ruby with [the Singleton module](http://ruby-doc.org/stdlib-1.9.3/libdoc/singleton/rdoc/Singleton.html) in standard lib. I took a look there and saw this:

	class Klass; include Singleton; end
	a, b = Klass.instance, Klass.instance
	a == b # => true
	Klass.new # => NoMethodError - new is private ...

This shows what it means to be a Singleton in Ruby - once `#instance` is called and an instance of `Klass` is created, then all variables pointing to it are pointing at the same thing and you can't new up another one. Note that when you call `#instance` the first time, `#initialize` gets called as if you had called `#new`.

Brown notes two main benefits of using the Singleton module:

* instantiation is lazy evaluated
* Ruby enforces the single instance limitation for you

And explains them:

> The former provides a potential performance and memory bonus when the object never ends up getting used, and the latter helps prevent accidental object creation. Both of these things are nice to have, and it only takes a bit of extra effort make them happen.

I get the benefit of letting Ruby prevent you from accidentally creating another instance, but I don't really see how there's much to be gained from "a potential performance and memory bonus". Seems like one object isn't going to affect performance or memory that much and if it would, then maybe that's a smell that you're doing something wrong.

Next Brown talks about how he likes to implement this pattern in Ruby. He thinks the Singleton module is fine, but also maybe too literal; he prefers to just use a module and then define methods off of it.

Had to be reminded about what he was doing on line 2, with `extend self` - this is just a shortcut like `class << self`:

	class Klass
	  class << self
	    def foo; :bear; end
	  end
	end
	
	Klass.foo # => :bear
	
	module Mod
	  extend self
	
	  def foo; :bear; end
	end
	
	Mod.foo # => :bear

So, both `class <<  self` and `extend self` are doing the same thing: we can write our Classes and Modules without having to preface our method definition with `self`.

Brown finishes up this section by reminding us that the Singleton pattern should be used sparingly because of its global nature:

> \[A Singleton's global nature\] makes them more difficult to test, easier to corrupt, and harder to isolate when it comes time to debug issues with them.

Then, after all that I went back and read his [updated thoughts on Singletons](http://practicingruby.com/articles/shared/jleygxejeopq). In this write up he explores seven ways to implement the pattern:

1. Using the Singleton module provided by the standard library
2. Using a class consisting of only class methods
3. Using a module consisting of only module methods
4. Using a module with module_function
5. Using a module with extend self
6. Using a bare instance of Object
7. Using a hand-rolled construct

I've discussed the first method above. Methods 3, 4 and 5 are close to the other method I described above with 2 being a slight variation on it. But then he goes into a couple strange areas, like using a bare instance of an Object or hand-rolling a new Ruby construct. My takeaway is actually that I prefer the 5th method, the one described second above: defining methods right on a Module and then just using it directly. It was a fun thought experiment to contemplate his Universe construct, but being that its purely theoretical, doesn't really offer any practical help with Singletons.

Brown's comments on avoiding Singletons and his reflections on writing about this pattern were very insightful. He talks about how there's actually very little practical difference between these fancy approaches to Singletons and just newing up an instance of a normal Class and that really rings true to me. Seems like unless I'm in a very particular situation, I'll probably just write a class and use an instance of it. If I need more than that, I'll probably try the Module with extend self approach and see how far that gets me.

Oh and he describes modules like `Math` module as "Function bags", which actually made me laugh out loud.