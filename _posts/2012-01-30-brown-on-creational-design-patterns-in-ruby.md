---
layout: post
title: Brown on Creational Design Patterns in Ruby
---

{{ page.title }}
================

<p id="articleDate">published Monday, January 30, 2012</p>

I've read Gregory Brown's post on [structural design patterns](http://jonallured.com/2012/01/20/brown-on-structural-design-patterns-in-ruby.html) in Ruby and I've also spent some time with a couple of his write ups focusing on just [the Singleton pattern](http://jonallured.com/2012/01/27/brown-on-the-singleton-in-ruby.html). Next I wanted to finish the rest of the [creational patterns](http://blog.rubybestpractices.com/posts/gregory/059-issue-25-creational-design-patterns.html) - as in the post on structural patterns, his aim is not to explain each pattern as much as it is to show some examples of the patterns in real Ruby code.

Multiton
--------

This pattern shares some similarities with the Singleton, if fact its really just a Singleton where you want to have unique instances for each key used. The example Brown uses from Prawn was pretty clear and I was able to see the pattern shine through.

I hadn't run into `Hash.update` before - its called on a hash and passed another hash and it combines them with the key/value pairs from the argument overriding those of the hash its called on.

Factory Method
--------------

To help describe this pattern, Brown starts by walking us through some code a student of his was writing. This code started as a typical Ruby class that had a boolean as an argument. It was quickly suggested that instead of this, a hash be used:

	# starts this way
	class AdjacencyMatrix
	  def initialize(data, directed=false)
	    # some code
	  end
	end
	
	undirected_matrix = AdjacencyMatrix.new(data)
	directed_matrix   = AdjacencyMatrix.new(data, true)
	
	# refactored with an options hash
	class AdjacencyMatrix
	  def initialize(data, options)
	    directed = options[:directed]
	    # some code
	  end
	end
	
	undirected_matrix = AdjacencyMatrix.new(data)
	directed_matrix   = AdjacencyMatrix.new(data, :directed => true)

Having an options hash like this is a good start, but in this case it made sense to use the Factory pattern:

	class AdjacencyMatrix
	  class << self
	    def undirected(data)
	      new(data)
	    end

	    def directed(data)
	      new(data,true)
	    end

	    private :new
	  end

	  def initialize(data, directed=false)
	    #...
	  end
	end

	undirected_matrix = AdjacencyMatrix.undirected(data)
	directed_matrix   = AdjacencyMatrix.directed(data)

So the `#undirected` and `#directed` class methods are builder methods. Rather than calling `#new`, you call one of these and they instantiate your object in the desired state.


Abstract Factory
----------------

This one was harder to deal with. From what Brown says, this pattern doesn't really make that much sense in Ruby because of "the flexible nature of Ruby’s type system", whatever that means. All I really got from this one is that I probably don't need to worry about it and that's fine by me.

Builder
-------

The Builder pattern is another one where Brown feels Ruby's dynamic nature means its not necessary for some formal construct. Instead there's a spirit of the Builder pattern that can be used:

> \[C\]reate an abstract blueprint describing the steps of creating an object, and then allow many different implementations to actually carry out that process as long as they provide the necessary steps.

He gives us an example from code he's written and it made sense, but didn't really jump out at me as something I've had to deal with in my own code.

Prototype
---------

The last pattern is another one where Brown doesn't have much concrete to say. He talks about it in a theoretical way, but admits that he can't come up with a meaningful example where it might be helpful in Ruby.

Reflections
-----------

With that Brown goes into some notes about writing this post and what he's taken away from it. He talks about how he feels design patterns are an advanced topic that can be challenging for beginner and intermediate developers. I don't know how Brown would judge me, but I felt like some of the patterns are pretty easy to get and others are vague and hard to get much out of.

For me the main thing is to be exposed to this stuff so that when it comes up on conversation with other developers, we have the same vocabulary with which to discuss design and Brown seems to agree with this.