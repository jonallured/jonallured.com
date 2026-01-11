---
number: 88
tags: review
title: "Week in Review: Week 2, 2026"
---

The first week back to work after a couple weeks off is brutal. Everyone in my
house was tired and crabby. Luckily I found the time for a few naps - that
really helped. And really by the end of the week I was back in the swing of
things but geez.

Oh did you see that Bear's win over the Packers?? My heart was so full!

## Highlights

* worked 40:00, no PTO
* [Fixed bug in mli][mli-pull-7]
* Upgraded a bunch of projects to Ruby 3.4.8

For that bug: I have a couple Ruby gems that have an executable and they would
work great until I was in another project and then I couldn't use them. I would
get a mysterious error that mentioned Bundler. After a very frustrating
troubleshooting session with Claude I finally figured out that it was an easy
fix and totally my fault for copy/pasting some code.

[mli-pull-7]: https://github.com/jonallured/mli/pull/7

I made a list of my Ruby projects and then found each one's version number. Most
were pretty close to the latest 3.4 but I did a PR to get each of them all the
way there. Then I uninstalled all the Rubies on my system except one:

```
jon@mister-sinister:~% asdf list ruby
 *3.4.8
```

This made me so happy! I'll work on Ruby 4.0 next week perhaps.

## Pic of the Week

My pal [Steven Hicks][sjh] sent me a couple tshirts that he hand-printed! They
turned out so good. Here is me modeling one of them in my dirty bathroom mirror:

[sjh]: https://www.stevenhicks.me

{%
  include
  framed_image.html
  alt="Selfie with tshirt"
  caption="Why does my dog look so confused?"
  ext="jpg"
  loading="lazy"
  slug="max-value"
%}

He and I have always bonded over our shared interests and chief among them is
our love of capitalism. Working for the man brings us joy. I think it's fair to
say that we just love maximizing shareholder value!!

## Next Week

I mentioned Ruby 4.0 - I'd like to install it on my laptop and see if my
projects have any conflicts with it. Which reminds me that I'm overdue for a
Rails upgrade on Monolithium so that's also in the cards.

But what I should really do is wrap up my analytics project and get it shipped.
Why is it so hard to stay focused when working on personal projects??
