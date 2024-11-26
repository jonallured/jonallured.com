---
favorite: false
number: 8
title: Bigg on Debugging; Shaughnessy on Rails Commits; OmniAuth 1.0; Videos From Windy City Rails 2011
---

Watched this great [screencast from Ryan Bigg on debugging][screencast]. He goes
through his steps to find the source of a `TypeError: wrong argument type Module
(expected Class)` error and I really enjoyed watching it.

The first thing I picked up was a reminder that a `Class` cannot inherit from a
`Module`, so this doesn't work:

```ruby
module Foo
end

class Bar < Foo
end
```

That exception mentioned above will get thrown. It was interesting watching Ryan
find this problem and I learned a little about how Rails works along the way.

Another cool thing I took away was that you can do `bundle show [gemname]` and
[Bundler][bundler] will spit back a path to that gem. This is a handy way to
open the source for a gem in your editor. Try something like this:

```
$ vim `bundle show fabrication`
```

And you can follow a stack trace or try messing with something in the gem,
whatever. Really easy.

---

Pay Shaughnessy takes us through some of his [favorite Rails
commits][fav_commits], trying to point out some things to keep in mind as you
work on projects. I found Jose's commit the most interesting, I really liked
seeing this peek at how he approaches deprecation.

Oh, and we see that DHH loves us and added Array.preprend and Array.append to
ActiveSupport, which is also cool.

---

[OmniAuth][omni] recently went 1.0 and Ryan Bates takes us on a tour of using
the [Identity strategy][strategy] for an app.  You'd support this strategy when
you want to provide users a way to log into your app separate from other
providers. Maybe you've got a user that doesn't have or doesn't want to use
their Twitter, Facebook or Google account with your app - this strategy allows
them to just create an account with your app.

It occurred to me while watching this screencast that when I see ERB view
templates now, they look really noisy and I actually have a hard time reading
them. HAML has completely spoiled me.

---

Went through a few of the [Windy City Rails 2011 talks][wcr_2011]. Watched a bit
of the presentation [Aaron][aaron] gave about Regex and saw that he did a good
job and was well received by the audience.

Then I watched most of Steve Klabnik's talk about Literate Code and pulled out
this quote:

> "It seems like every time I type 'git blame' the asshole that wrote that
> terrible function is me."

Thought that was funny. But I really did love his point that when we write
software we have four audiences:

* the computer
* ourselves
* the other (the person who will later maintain our code)
* the user

And the fact that we have these different audiences with different needs means
that we aren't free to focus on and optimize for just one of them.

As an aside, I liked the bit where he was talking about how a definition of
technical debit could be "screwing with future you". I have definitely cursed
"past-Jon" for some garbage he wrote that was in my way at the time.
"Present-Jon" tends to think "past-Jon" is a lazy asshole and too often he's
right.

I liked the part where he talked about how much people who make websites have to
know. He mentioned all the things we have to know as developers: HTML, CSS, JS,
Ruby, CoffeeScript, LESS. Validates my feelings that the web is just a really
interesting place to be working right now.

Another quote I liked was:

> If you're doing reg-green-refactor, you fail thousands of times a day.

He was talking about how terminology can trip you up. The example he gave was
working with some English Academics and their take vs a developer's take on code
being "broken". I've seen this while working in the Publishing industry as a
developer, but the thing I liked was how deftly he articulated something that's
interesting to consider: developers that test are used to failure and have, in
fact, embraced it as a means to write good code. There's something poetic about
that.

[screencast]: https://ryanbigg.com/2011/11/screencast-wrong-argument-type
[bundler]: http://gembundler.com/
[fav_commits]: http://patshaughnessy.net/2011/12/6/learning-from-the-masters-some-of-my-favorite-rails-commits
[omni]: https://github.com/omniauth/omniauth
[strategy]: http://railscasts.com/episodes/304-omniauth-identity
[wcr_2011]: http://vimeo.com/channels/wcr11
[aaron]: https://twitter.com/martinisoft
