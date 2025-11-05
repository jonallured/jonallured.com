---
number: 6
tags: article
title: "Playing Around With Content Editable in Rails"
---

I recently tried working with the `contenteditable` attribute on an internal
project at [Hashrocket](http://hashrocket.com) with my pair [Dave
Lyon](http://twitter.com/daveisonthego) and wanted to share what I thought about
the experience. Our use case was simple:

> In order to remember things about a Project
> As a Project Manager on the list of Projects page
> I want to make or edit a Note

Said another way, we've got a Project list page, each Project can have a Note
and we want to be able to create a Note for a given project or edit an existing
Note. For such a case you might make a bunch of `<textarea>` tags and then wrap
them in forms or maybe bind to `blur` and either create or update a Note all
AJAXey.

But this was an internal project and we wanted to try something different. We
went through a couple different ideas, starting with something like this:

```html
<p contenteditable="true" class="note">Note content here!</p>
```

We created an event handler to fire on `blur` and sent the content of the `<p>`
tag to the server. But it wasn't long before we hit enter while editing that
`<p>` tag and found that new `<div>` tags were being created. That didn't work
like we wanted, so then we wrapped the `<p>` with a `<section>`, like so:

```html
<section contenteditable="true" class="note">
  <p>Note content here!</p>
</section>
```

This way when you hit enter and create more `<p>` tags, they'd be contained
inside the parent and we could send the content of `<section>` to the server.
That was closer, but didn't feel quite right. Next we had the idea to just use a
`<ul>`, like this:

```html
<ul contenteditable="true" class="note">
  <li>Note content here!</li>
</ul>
```

We liked this because then we'd just store the `<li>` tags in the database and
it was nice and clean. I threw together a little [demo page](/rotten.html#8) you
can use to play around with our different approaches.

My take away here is that `contenteditable` is really only suitable for cases
where you actually want HTML nodes to be created. Its perfect for something like
a WYSIWYG editor or the [Mercury Editor][mercury], things that aim to allow
editing of a page right in the page. But for something like what we were doing,
I think it was overkill.

Also, I'm not completely comfortable with its cross-browser support. I don't
have access to IE anymore, but I was able to experiment with Chrome, Safari and
FireFox. From what I could tell the two WebKit browsers were fairly consistent
in how they implemented the details of this attribute, but FireFox does some
different things. For instance, `<br>` tags seem to be added at the end of
everything.

Still, `contenteditable` is a cool attribute and I was glad to learn a little
more about it. Give [that demo](/rotten.html#8) a whirl and consider it the next
time you need something like this.

[hashrocket]: http://hashrocket.com
[dave]: http://twitter.com/daveisonthego
[mercury]: http://railscasts.com/episodes/296-mercury-editor
