---
date: 2026-02-14 11:28 -0600
number: 95
tags: article
title: "Upgrading to Ruby 4.0"
---

Ruby 4.0 was released a couple months ago on Christmas and I had been meaning to
upgrade for a while. I noticed that version 4.0.1 came out too so that's always
a good sign that things are stable and ready for prime time.

## Reviewing Release Notes

I started by reviewing the [release post][release-post] on the official Ruby
blog. Nothing really stood out as all that controversial and so I figured it
would be a pretty straightforward upgrade. It was.

[release-post]: https://www.ruby-lang.org/en/news/2025/12/25/ruby-4-0-0-released/

But that isn't to say that as a fan of the Ruby language I'm not excited by what
was in those release notes - there are some cool things in Ruby 4! You should
search that page for "ErrorHighlight" and see what they did to improve the error
messages for `ArgumentError`.

## Installing

I still use [asdf][] as my Ruby version manager so next was installing:

[asdf]: https://asdf-vm.com

```
$ asdf plugin update --all
$ asdf install ruby 4.0.1
$ asdf list ruby
  3.3.10
 *3.4.8
  4.0.1
```

So the goal is to upgrade all my projects to Ruby 4.0.1 and then uninstall those
other versions.

## Setting Default Ruby

My dotfiles repo is where I set the default Ruby for my system so I made
[Upgrade default Ruby][dotfiles-246] to set this to `4.0.1`.

[dotfiles-246]: https://github.com/jonallured/dotfiles/pull/246

## Upgrade All the Projects

Now the toil - go to each project and do a PR that upgrades it to Ruby 4.0.1:

* [jay][jay-11]
* [jonallured.com][jonalluredcom-197]
* [mli][mli-18]
* [monolithium][monolithium-290]
* [shrt][shrt-28]

[jay-11]: https://github.com/jonallured/jay/pull/11
[jonalluredcom-197]: https://github.com/jonallured/jonallured.com/pull/197
[mli-18]: https://github.com/jonallured/mli/pull/18
[monolithium-290]: https://github.com/jonallured/monolithium/pull/290
[shrt-28]: https://github.com/jonallured/shrt/pull/28

Mostly the process was:

* edit the `.tool-versions` file to switch to 4.0.1
* run `bundle install` to install the project's gems
* run `bundle update --bundler` to get the newest bundler version
* run `bundle update --all` to upgrade the project's gems
* run `bundle exec rake` to see if anything broke

Oh and then if a project has a Ruby version matrix on CI then I'd also drop the
3.2 and add 4.0. I actually forgot this on jay so I opened [Update CI
matrix][jay-12] as a follow up.

[jay-12]: https://github.com/jonallured/jay/pull/12

Monolithium was the project that I assumed would be the most challenging to
upgrade but it Just Worked. I did notice that it needs a Rails upgrade and I
have been ignoring the Tailwind upgrade as well. Those are problems for Future
Jon!

## Cleaning Up

This was an easy upgrade and the final step was to clean up my older Ruby
installs:

```
$ asdf uninstall ruby 3.3.10
$ asdf uninstall ruby 3.4.8
$ asdf list ruby
 *4.0.1
```

I love boring software!
