---
favorite: false
number: 15
title: "Preston-Werner at RubyConf 2011 on GitHub Flavored Ruby"
---

I just watched the video of Tom Preston-Werner at [RubyConf
2011][rubyconf_videos]. His video was called "GitHub Flavored Ruby" and it was
broken down into five parts that I took notes on individually.

## Relentless Modularization

Here Tom's talking about keeping your software small and the benefits this
provides. One benefit that stood out was smaller software is cheaper to change.
This is something that I've been struggling with on the project I'm currently
on, so I enjoyed thinking about how this could resolve some of the things
causing pain on that project.

When you sense that a component of your system might make an interesting open
source library, extract it. Even if you have no intention of open-sourcing the
library. This is de-coupling.

## Readme Driven Development

Cowboy coding: the answer to Waterfall! Both approaches can produce software
that doesn't solve the problems they were created to solve.

Tom's middle-ground for this is writing the README first, [Readme Driven
Development][rdd]. What this technique does is force you to think about the end
user of your library before you write any code so that you can make good
decisions about its design. You'll find yourself thinking about how it will work
in code first, then you write that code.

So as to not confuse anyone, one thing you can do is to pick a point where your
Readme.md looks pretty fleshed out and then move its contents to Spec.md. Then,
as you actually code portions of the project, you can move content from the Spec
file to the Readme file. This helps the person who comes to your
half-implemented project see what's done and what's still left to do. Very
interesting ideas. I had read Tom's initial post on this linked above, but I
enjoyed hearing him talk about what he likes about this approach.

## RakeGem

A dependency-free template for making gems. Gives you some rake tasks that solve
common needs of gem authors. What's nice is that its just code in your repo, so
you can change whatever you want about it.

## TomDoc

He talks about the four levels of documentation:

* line
* code (methods and classes)
* API
* book

A distinction is made between documentation at the code level and at the API
level. The audiences of each are different; the former is aimed at those in your
code and latter is aimed at those trying to use this project.

TomDoc is code-level documentation.

Things to document:

* what params does this method expected and what type are they
* what does this method return
* examples

I like these ideas, but I wish TomDoc was called something else...

## Semantic Versioning

The goal of [Semantic Versioning][semver] is for the three numbers
representing each release of your software to communicate something about what
was changed. For example, say you have version 1.2.3, then each number is:

* 1: Major
* 2: Minor
* 3: Patch

When you look at what you have to release, use this guide to decide how to
increment your version number:

* Major: backwards incompatible, big changes
* Minor: backwards compatible, new functionality, big internal changes, may contain bug fixes
* Patch: backwards compatible, bug fixes only

He called `~>` the "spermy operator", then clarified how it works, so if you
have this:

```
gem fabrication ~> '1.2'
```

Then you're saying that you require version 1.2 and any version up to but NOT
including 2.0. If gem authors stuck to Semantic Versioning, then you'd know that
your code wouldn't break because any minor change should be backwards compatible
and not change the methods you rely on. Those types of changes would be major
and thus require a bump that your Gemfile wouldn't allow.

[rubyconf_videos]: https://confreaks.tv/events/rubyconf2011
[rdd]: http://tom.preston-werner.com/2010/08/23/readme-driven-development.html
[semver]: http://semver.org
