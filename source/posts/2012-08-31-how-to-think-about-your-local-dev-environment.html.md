---
favorite: false
id: 34
title: How to Think About Your Local Development Environment
---

I've found that a developer is much more likely to think about the production
and staging environments they deploy to than to think about their local
development environment, I know this was true for me. But I think there's
something to be gained by examining how we set up locally. Here's what I've come
up with as three guiding principles that I strive to keep in mind:

* Keep applications isolated so they don't interfere with each other
* Match production as much as possible
* If you're going to be working on the project with other people, document what
  it takes to get the app started

## Keep Things Isolated and Consistent

Before projects like [RVM][] and [Bundler][] having multiple applications on
different Ruby and Gem versions was a real pain, but now its pretty nice. I use
RVM to pick and stick with a particular version of Ruby, then create a
[Gemset][] that keeps my app's gems separated from the system Gems or the Gems
from another application. Then I have Bundler so that I can keep development and
production consistent.

## Match Production As Much As Possible

I've been bitten too many times by differences between my development and
production environments to allow significant differences between the two
environments. For example, if production is going to use Postgres, then I'm
going to use Postgres locally. Similarly, I want to match Ruby versions and Gem
versions so there aren't any surprises. Do your best to have what you run in
production installed and in use on your development machine.

## Document What It Takes to Get the App Started
---------------------------------------------

When you new up a Rails app, you are given a README file with some boilerplate
and many projects never even change this. I think this is a missed opportunity
to communicate with future team members or even just your future self. What I
want to achieve is a README so easy that a new team member (that might also be
new to Rails) can follow along and get the app running without having to bother
someone else.

I don't always do a great job of this, especially after I've been on a project
for a few months, but its something to work towards. When new things come up in
your project that would affect someone starting it up for the first time, try to
remember them and add something to the README to help another developer that
wouldn't know about it.

So, this is what I think about as I'm making an app--it keeps me organized
locally, less surprised when I push to production and new team members happy to
work on my projects.

[RVM]: https://rvm.io
[Bundler]: http://gembundler.com
[Gemset]: https://rvm.io/gemsets/basics
