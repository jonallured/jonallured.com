---
title: Kellum on Pixels; Shaughnessy on Shared Strings
---

Scott Kellum [explores][crisis] how devices where a pixel is not always a pixel
are making the lives of designers even harder than they already were. He starts
out by establishing some vocabulary:

> The truth is that there are two different definitions of pixels: they can be
> the smallest unit a screen can support (a hardware pixel) or a pixel can be
> based on an optically consistent unit called a “reference pixel.”

> \[A **hardware pixel** is\] the smallest point a screen can physically display
> and is usually comprised of red, green, and blue sub-pixels...it cannot be
> stretched, skewed, or subdivided.

> The w3c currently defines the **reference pixel** as the standard for all
> pixel-based measurements. This new pixel should look exactly the same in all
> viewing situations.

Hardware pixels were clear to me, but I had a harder time understanding
reference pixels until I took a look at Figure 1. A hardware pixel is the actual
pixel bounded by the physical pixel square on the device while a reference pixel
is used by the hardware pixels to draw things.

Next he talks about how you can use the `device-pixel-ratio` media query to
identify devices with scaled pixels. He is able to use some media query magic to
normalize two devices with the same number of hardware pixels, but different
scaled pixels. Pretty neat and also, I'm glad I don't have to deal with this
stuff.

---

Pat Shaughnessy [discusses][share_strings] how the Ruby interpreter uses an
optimization called "copy on write" by diving deep into its code.

He starts off by outlining an example he used in [another post he did on Ruby
and Strings][another_post] and shows us using a debug script that Ruby will try
not to duplicate a string if it doesn't need to. He is able to get down to the
hexadecimal values and show the relationship between two Ruby variables that
point to the same RString structure that itself points to one Heap String.

Then he shows how `Object#dup` will make two RString structures that are
pointing to one Heap String. This is what a "Shared String" really is, so if you
have this:

```ruby
str = "Lorem ipsum dolor sit amet, consectetur adipisicing elit"
str2 = String.dup(str)
```

Then `str` and `str2` both point to different RString structures and those in
turn point to the same Heap String. But the RString structure that `str2` points
to is actually different from the RString `str` points to. The former has a
pointer to the latter. So far, so good.

Next he goes into what happens when you start modifying that duplicate string.
Turns out when you modify `str2` the first thing that happens is that Ruby
creates a copy of the heap data and removes the pointer connecting the two
RString structures. Once that's done, then it performs the modification. This is
true for a modification like `upcase`, but it also applies to `slice` - it will
create new heap data for the substring.

But this isn't always true: if your slice is less than 24 characters long then
you'll get an Embedded String. Also, if your substring is longer than 24
characters, but includes all of the remaining characters, then Ruby does
something else cool. Say you do this:

```ruby
str = "Lorem ipsum dolor sit amet, consectetur adipisicing elit"
str2 = str[1..-1]
```

Then `str2` will point to a different RString structure, but that structure will
point to the same heap data, its just that its `ptr` value will be advanced one
position.

He concludes by reminding us that in most cases, Ruby developers shouldn't worry
too much about these details, that the interpreter is there to do this stuff for
us. Its interesting to know what's going on behind the scenes and in certain
edge cases, this knowledge could help you write faster programs, but mostly this
feels like an academic exercise and its one that I really enjoyed.

[crisis]: http://www.alistapart.com/articles/a-pixel-identity-crisis/
[share_strings]: http://patshaughnessy.net/2012/1/18/seeing-double-how-ruby-shares-string-values
[another_post]: /posts/2012/01/09/shaughnessy-explores-strings-klabnik-on-whats-wrong-with-mvc.html
