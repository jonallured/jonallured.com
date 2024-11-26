---
favorite: false
number: 18
title: Blocks in JavaScript; HATEOAS in Rails; Davey's turbux; watchr for Ruby Koans; Using a Single Ampersand
---

If Yehuda Katz has it his way, [JavaScript would get blocks][js_blocks] and he
supports his position with some examples.

A lot of this was over my head because the most interesting things I've done
with JavaScript mostly involve DOM manipulation and some effects. I've never
needed to work with JavaScript prototypes and have just a little experience with
making an Object to encapsulate functionality. Still, this was an interesting
read.

Actually the thing that stood out the most here was the use of `try...finally`
in JavaScript - never knew you could do that! [Looked it up][js_docs] and this
clause works just like the `ensure` in Ruby's `begin...rescue` statements.

---

Klabnik [demonstrates how to implement HATEOAS][hateoas] in a Rails app using
the Draper gem for the Presenter Pattern.

---

Fellow Rocketeer [Josh Davey][josh] just [released turbux][turbux] and [wrote up
a post announcing it][announcement] - with a video and everything! We've been
using this for a while in the office and I really like this workflow. If you use
tmux this is a must-have.

---

Another Rocketeer [Adam Lowe][adam] reminded me about [watchr][watchr] and at
the same time [points out](/rotten.html#11) that its use would make doing the [Ruby
Koans][koans] much more pleasant. Good call.

---

Pan Thomakos [explores the uses of the single ampersand
operator](/rotten.html#12), divided into two categories: the Binary Ampersand
and the Unary Ampersand.

For the Binary Ampersand, most of the uses he reviews are weird and seem pretty
theoretical. Not sure where one would use most of them. But the second example
was pretty neat:

```ruby
[1, 2, 3, 4, 5] & [1, 2, 6] # => [1, 2]
```

So, this returns a collection of the common elements between the two
collections. Its just defined on `Array`, but I guess I never noticed it.

Then shit gets pretty real with the Unary Ampersand. He actually starts by
describing Blocks and Procs in a way that I found really easy to understand.
Again, some of this was pretty heady for me, but I did find something that I
though was really cool. If you have a thing that you're doing as a map you can
use a `Proc` with the Unary Ampersand to reduce duplication:

```ruby
# this
[1,2,3].map{ |x| x*2 }
[4,5,6].map{ |x| x*2 }

# can refactor to this
multiply = Proc.new{ |x| x*2 }
[1,2,3].map(&multiply)
[4,5,6].map(&multiply)
```

So that's pretty cool. You can also define `to_proc` on an object and then pass
that object.

[js_blocks]: http://yehudakatz.com/2012/01/10/javascript-needs-blocks
[js_docs]: https://developer.mozilla.org/en/JavaScript/Reference/Statements/try...catch
[hateoas]: http://blog.steveklabnik.com/posts/2012-01-06-implementing-hateoas-with-presenters
[josh]: https://twitter.com/joshuadavey
[turbux]: https://github.com/jgdavey/vim-turbux
[announcement]: https://joshuadavey.com/2012/01/10/faster-tdd-feedback-with-tmux-tslime-vim-and-turbux/
[adam]: https://twitter.com/adam_lowe
[watchr]: https://github.com/mynyml/watchr
[koans]: https://github.com/edgecase/ruby_koans
