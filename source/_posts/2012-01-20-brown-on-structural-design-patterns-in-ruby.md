---
favorite: false
number: 20
title: Brown on Structural Design Patterns in Ruby
---

Gregory Brown considers [how the classic design patterns pertain to
Ruby](/rotten.html#13) and explores how one could interpret them by giving some
examples. This is the second part of a two-part series, this time focusing on
the structural patterns.  I've heard of the [Design Patterns][patterns_book]
book, we have a copy at the office, but I've not read it. And I've read a little
about the patterns, but I took this post as an opportunity to get a little
better acquainted with them.

## Adapter

This pattern made sense right away and had me thinking of places where I've
seen. The example was really clear: there are a bunch of different Markdown
libraries for Ruby, Mitko Kostov wrote [Marky][marky] to sit in between them and
your code. What you get is the ability to change which Markdown processor you
use under the hood without actually needing to change any of your code. Marky
abstracts away the details of each Markdown library's implementation and instead
you just write to the Adapter.

If you look at Marky's README, there's a list of "Adapters", just pick one and
you can convert some Markdown to html like this:

```ruby
Marky.adapter = :maruku
Marky.to_html("Hello, Marky")
```

Easy, but it seems strange to me that Marky calls Maruku an adapter. Its Marky
itself that's the Adapter and Maruku is the library it sits in front of. I would
have expected to see a list of Processors and would pick one like this:

```ruby
Marky.processor = :maruku
Marky.to_html("Hello, Marky")
```

Either way, this is a neat little gem that serves as a nice example when
explaining the Adapter pattern.

I was thinking about this pattern from the point of view of someone writing an
Adapter and it occurred to me that this pattern has a side-effect: it encourages
an Adapter author to only support the super-set of library features. If you have
five libraries, but only two of them implement a certain feature, then it would
be natural to ignore it when writing an Adapter for these libraries. Either
they've all got a feature and your Adapter exposes it, or they don't and you
ignore it.

The other approach would be to only let clients of your Adapter who've picked a
library with that feature use it. You'd have to maintain some code that knows
which libraries support which features and `raise` when a client tries to do
something that's not implemented. This seems counter to the spirit of an Adapter
to me.

Which leaves me thinking that the sane way to design an Adapter is to support
only the super-set of features. That means that when you choose to use an
Adapter rather than picking one of its underlying libraries, you should probably
be doing it because you really need the ability to switch out the underlying
library. If that's not important to you, then its possible that just picking a
library with the features you need would actually be better.

## Bridge

I think its funny that Brown describes a bridge using the word "physically" -
how exactly does a programming pattern *physically* do anything? Anyway...

I got far less out of this one. The [SourceMaking article][bridge_post] he
linked to had a bit about describing a bridge by making a comparison about light
switches and that did help build a mental model for this.

Then he goes on to give an example he feels is contrived and complain that its
hard to figure out a purpose for this pattern in Ruby. Didn't get much out of
this one.

## Composite

I was unsatisfied with the example here. As Brown said towards the end of this
section, the example was pretty intense and I couldn't see the pattern properly.
I searched for another example and found [a write up](/rotten.html#14) from Jim
Weirich that gave an example that was much easier to wrap my head around.

Weirich uses Robert Martin's programming problem called "Mark IV Coffee Maker"
to help define the Composite pattern. He describes how a Boiler object is a
composite of both a Heater and a Relief Valve. Then he says:

> The Boiler becomes a single object to the brewer which just issues on/off
> commands to the boiler. The boiler is responsible for making sure all its
> subcomponents (the heater and the relief valve) are properly operated.

So the Brewer can just issue its on/off commands to our Boiler composite object,
then the Boiler can handle the grunt work of figuring out how to talk to the
objects that make it up.

This one is really interesting and I'll be on the lookout for places where I can
use it in my own work.

## Proxy

As with the Adapter pattern, Brown gives us an example for this pattern from
Rails and as such it wasn't too hard to understand. A Proxy object sits in front
of another object and in this way its similar to an Adapter. But this pattern
implies that the Proxy can do some mutating where an Adapter is just abstracting
the implementation.

The example here is how ActiveRecord does association collections, like
`has_many`. So if a post has many comments, then you can do:

```ruby
post.comments # => array of post's comments
post.comments.class # => Array
```

But you can also do:

```ruby
post.comments.create(author: user, body: "Great post!")
```

And `Array` definitely does not implement `#create`, so what's going on here is
that `#comments` is actually a Proxy. It acts like an `Array` when it needs to,
but is also able to do its own thing.

Brown shows us a couple ways to implement this pattern, the first uses
[delegate][delegator] from standard lib and the second uses `method_missing`. He
prefers using delegate, but wonders if Rails uses the `method_missing` approach.

I took a little dive into the Rails code and found ActiveRecord's
[`HasManyAssociation`][has_many], which ends up using a
[`CollectionProxy`][proxy] and sure enough, you'll see `method_missing`
implemented in there. Its worth reading through that code a little and seeing
the trickery that gets these Proxies all their magic.

## Decorator

These are similar to Proxies, but are typically used to add or extend the
behavior of the object. Decorators are hot right now with gems like
[Draper][draper] and are something I have already been thinking about. Since
Brown basically skips this one, I will too.

## Facade

The Facade pattern is used when you want to abstract something to act like
something else. So, he uses `open_uri` as his example because it acts as a
Facade for File; its aim is to abstract working with a url into feeling like
working with a file. I really liked this line:

> It’s worth keeping in mind that pretty much every DSL you encounter is a
> Facade of some form or another.

This pattern also made sense right away and seems pretty easy to grok.

## Flyweight

This pattern seems to be about optimizing memory. You can use this one to store
what seems like a lot of data in a lighter weight way. The example given was
about storing the font information for each letter separately and then when
creating a string just look up each letter's font info by the letter instead of
re-creating it.

So given a string like "Hello World", the font information for "l" would only be
stored once, but the lighter weight character "l" appears three times. Brown
concedes that this might not fit Flyweight exactly, but that its a good way to
think about the higher level concepts.

## Reflections

Brown's reflections talk about how design patterns should help us have a common
vocabulary when we're talking about code, but that it might not be possible
without creating new ones specifically for Ruby. I know that when I hear people
talking about patterns, I often feel like the hardest part is making sure we're
talking about the same things. The ideas aren't the hard part, its the
communicating about them that can be difficult.

[patterns_book]: http://www.amazon.com/Design-Patterns-Elements-Reusable-Object-Oriented/dp/0201633612
[marky]: https://github.com/mytrile/marky
[bridge_post]: http://sourcemaking.com/design_patterns/bridge
[delegator]: http://www.ruby-doc.org/stdlib-1.9.3/libdoc/delegate/rdoc/Delegator.html
[has_many]: https://github.com/rails/rails/blob/master/activerecord/lib/active_record/associations/has_many_association.rb
[proxy]: https://github.com/rails/rails/blob/master/activerecord/lib/active_record/associations/collection_proxy.rb
[draper]: https://github.com/jcasimir/draper
