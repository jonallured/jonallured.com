---
layout: post
title: Making URLs Pretty; Uncle Bob on SRP; Grimm on ActiveRecord Associations; Heilmann on classList
published_at: Tuesday, February 7, 2012
---

Watched [RailsCasts 314: Pretty URLs with FriendlyId](http://railscasts.com/episodes/314-pretty-urls-with-friendlyid) and learned that Rails uses a method on its Models called `#to_param` to decide what to put in a show path. This means you can override it and use something besides an id:

	class Post < ActiveRecord::Base
	  def to_param
	    post.title.parameterize
	  end
	end
	
	# gives you this path:
	/posts/title-of-post

But if you leave off the id, then your `ActiveRecord#find` is going to be a pain -- this is where [`friendly_id`](https://github.com/norman/friendly_id) comes in. You `extend` your model with `FriendlyId` and then you can use the `friendly_id` method to set which column to use in the url.

There's an option to create slugs for your objects that will make your friendly urls even more friendly by taking that column and applying some formatting rules to it. You can also store the history of a slug's value so that when you change it the old values will still work.

---

I was reading [Uncle Bob's post](http://blog.8thlight.com/uncle-bob/2012/02/01/Service-Oriented-Agony.html) about running a retrospective on an app that's partitioned into services. Its an interesting walk through of what happened and how it caused pain for the developers. He gets to a point where he's reminding us about what the Single Responsibility Principle means. I usually think about that principle when I'm looking at a Class that does more than one thing, but as I was reading his definition I realized that there's another side to it: grouping together things that change together. Kind of an "ah-ha" moment for me: I was only internalizing half of the principle.

---

Avdi Grimm [reminds us](http://avdi.org/devblog/2012/01/19/activerecord-default-association-extensions/) of just how awesome `#scoped` is, this time in the context of wanting to define a method on a collection of ActiveRecord associations. Pretty neat.

---

Learned about the HTML `classList` property from a [write up](http://hacks.mozilla.org/2012/01/hidden-gems-of-html5-classlist/) by Chris Heilmann. Its not implemented in every browser, IE being the glaring problem, but its still interesting.

This property is an array-like object with the classes on a given DOM node and it comes with a handful of helpful functions:

* `element.classList`: returns an array of classes
* `element.classList.add('some-class')`: add 'some-class' to `element`
* `element.classList.remove('another-class')`: remove 'another-class' from `element`
* `element.classList.contains('some-class')`: does `element` have class 'some-class' (returns boolean)
* `element.classList.toggle('some-class')`: either add or remove 'some-class' on `element`, depending on whether its already on there

Hadn't heard of this one before, so it was fun to play around with it in the console, works much better than the days of managing classes by hand!