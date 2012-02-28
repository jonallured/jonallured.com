---
layout: post
title: Kosman on Better jQuery Code
published_at: Monday, January 2, 2012
---

24 Ways had one on [writing less sucky jQuery](http://24ways.org/2011/your-jquery-now-with-less-suck) and in the intro Scott Kosman talks about how its really easy to use jQuery to write spaghetti code. I've heard this term before, but never really knew what it meant other than the obvious implication that its something to avoid.

Wikipedia had this to say about [spaghetti code](http://en.wikipedia.org/wiki/Spaghetti_code):

> Spaghetti code is a pejorative term for source code that has a complex and tangled control structure, especially one using many GOTOs, exceptions, threads, or other "unstructured" branching constructs.

There's also an example there written in BASIC that shows an `IF` statement and a `GOTO` being used where a `FOR` loop makes much more sense. So the term spaghetti code is really just talking about hard to follow control flow.

With this distraction resolved, I got back to the article and learned some cool shit.

There are two ways of writing jQuery selectors that are always much faster than other ways:

	$('#id');
	$('p');

Under the hood these selectors are able to rely on native Javascript functions and thus are super quick. The former uses `document.getElementById()` and the latter uses `document.getElementsByTagName()`.

The `$('.class');` selector is going to be slow in browsers that don't support `document.getElementsByClassName()`, so that's IE8 and below. Use it when you are free to be a browser snob.

There's more to it that Scott goes into, but my take-away was: try to write selectors that find your elements using native Javascript functions. If you can't, at least try to use these faster selectors to get at a parent element and then throw a `.find()` on that to drill down further.

Oh and he reminds us that these selectors return a jQuery object that can be "cached" by setting it to a variable. So don't be a dick and write the same selector three times causing three DOM lookups, either chain your actions on the first lookup or save the first lookup in a variable and use it instead.

Then he goes into his second topic, Event Delegation. Here he demonstrates how one might use delegation to improve performance by reducing 100 event listeners to 1 with the `.on()` event listener method introduced in jQuery 1.7. Cool stuff.

Finally, he goes into DOM Manipulation and we get a reminder on a much more performant way to iterate through a collection of image urls, create an element and append it to the DOM.