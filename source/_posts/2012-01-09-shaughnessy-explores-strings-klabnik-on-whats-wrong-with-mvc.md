---
number: 16
tags: article
title: "Shaughnessy Explores Strings; Klabnik on What's Wrong With MVC"
---

Pat Shaughnessy spent some time exploring how MRI actually processes strings and
[wrote up those results][string_post]. He found that under the hood there are
actually three types of Strings used:

* Heap Strings
* Shared Strings
* Embedded Strings

A Heap String is one where the Ruby Interpreter saves the actual value of the
string in something called "The Heap". A Shared String is easy, its created when
you do something like this:

```
string_one = "Some awesome string"
string_two = string_one
```

Ruby is smart enough to know that when you create `string_two` you really have
the same string value as `string_one`, so rather than creating a new Heap
String, it just points the second variable to the first Heap String.

The third type of string, the Embedded String is different from the first two
because it avoids "The Heap" and instead embeds the value of the string right in
the C Struct using a character array. But there's a limit set for the size of
this character array - the value stored can be no larger than 23 characters.

When a Heap String is created, a call to `malloc` happens and this is far slower
than the creation of a character array, so Embedded Strings are faster than Heap
Strings. Shared Strings are faster than either because all they are is a pointer
to another string.

He's got some benchmark data with nifty graphs, but that's about it. He also
acknowledges that it would be ridiculous to optimize any code for this quirk.
Mostly I think he just enjoyed learning more about the internals of the Ruby
Interpreter and I loved reading about his exploration.

---

Steve Klabnik takes a look at a few Rails components and [shares his
views][ar_harm] about how they can mess up someone's understanding of good
Object-Oriented programming. He sees a few problems and discusses each in a
different section.

### ActiveRecord

Here he's talking about how clunky it is to separate a Model name and its table
name in the database. He points out that this coupling means that its
"impossible to de-couple your persistence mechanism from your domain logic".

The thing that jumped out at me in this section was the bit about how it took
him a couple years to realize that you could have a model in your app that
didn't inherit from ActiveRecord - me too!

### ActionController

The bad habits pointed out here are instance variables and logic in templates. I
wonder what he'd think about how [decent exposure][de] doesn't litter instance
variables anywhere, is that better? I know I like it better.

Also, I'm not sure its fair to criticize ActionController for having 200 line
method when you just said that ActiveRecord has encouraged skinny-controller,
fat-model. This doesn't seem like a strong argument to me because I don't think
anyone is arguing for 200 line methods in the controller.

### ActionView

I didn't think there was support for logic in templates - I thought we were all
trying to minimize this as much as possible. Maybe what he's really talking
about is going even further and getting more Decorators in your code? Not sure
what he's talking about here, I think he had point, but didn't spend enough time
fleshing it out.

### MVC

At this point he's hit each initial in the MVC acronym, so really he's unhappy
with the whole.

Steve closes by reaffirming his love of Rails and saying that its because of
this love that he feels compelled to criticize it. He acknowledges that his post
is light on examples and promises more on the topic which is awesome because I'd
like to know more about what he's thinking here.

[string_post]: http://patshaughnessy.net/2012/1/4/never-create-ruby-strings-longer-than-23-characters
[ar_harm]: http://blog.steveklabnik.com/posts/2011-12-30-active-record-considered-harmful
[de]: https://github.com/voxdolo/decent_exposure
