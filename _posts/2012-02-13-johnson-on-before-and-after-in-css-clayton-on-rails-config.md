---
layout: post
title: Johnson on :before and :after in CSS; Clayton on Rails Config
published_at: Monday, February 13, 2012
---

Joshua Johnson writing for Design Shack [explains](http://designshack.net/articles/css/the-lowdown-on-before-and-after-in-css/) how the `:before` and `:after` CSS pseudo-elements work. I was confused about why he was calling them pseudo-elements and not a pseudo-class like `:hover` or `:active`, so it was nice that he anticipated this confusion and started out by addressing it. The difference between these two parts of CSS turns out to be pretty simple:

* pseudo-classes target an entire element, think `a:hover` -- the entire link is styled
* pseudo-elements target a part of an element, think `p::first-letter` -- just the first letter of the `p` is styled

In the CSS3 spec, pseudo-elements use two colons and pseudo-classes just need one -- prior to this clarification both types would use just one. Johnson then tells us that he usually sees `:before`, not `::before` and explains that its because IE8 doesn't understand the double-colon syntax and since the single-colon version still works, most developers use that form.

So, with these distinction out of the way, Johnson goes into what `:before` and `:after` are. They allow one to add content either before or after an element without having to actually add this content to the markup. You use this selector and then use the `content` property, like so:

	.phoneNumber:before {
	  content: "&#9742;";
	}

This would add the phone glyph (&#9742;) before any element with the `phoneNumber` class.

And then `:after` is the same way. This is a neat example that gives a simple idea of why one would use the pseudo-elements, but then his next example shows how fancy one can get with this technique by styling a button with just the barest amount of markup. The button example actually seems a little crazy to me but its impressive nonetheless.

Johnson finishes up by showing a couple obscure uses of `:before` and `:after`. First, using them to clear floats and second, to create pure-CSS shapes. This was a good write up and I appreciated the time he took to find out a little more about these selectors.

---

I've recently been thinking about configuring Rails apps mostly because I'm tired of having a file full of environment variables for all the apps I run locally that has to be loaded in my shell to match those at Heroku. What I wanted to move to was a setup where the config file for each environment could decide if it should use environment variables (production) or just parse them out of a YAML file not checked into the repo (development).

So, when I saw [the post](http://robots.thoughtbot.com/post/16466303962/inject-that-rails-configuration-dependency?a408c0a0) Josh Clayton did on injecting Rails configuration into tests the thing that stood out most was actually how he was using the config:

	Doit::Application.config.default_creator

I've been doing this same thing another way -- using the `Rails` object, so like this:

	Rails.configuration.default_creator

Reading Josh's post I realized these are both ways to accomplish the same thing.

But his point was more about testing with these configuration settings. What Clayton is saying is that you shouldn't be stubbing at the application config level, instead inject a dependency on this information into your model and then test that. There are some good examples and I liked how he approached this.