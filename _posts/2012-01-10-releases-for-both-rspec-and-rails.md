---
layout: post
title: Releases for Both Rspec and Rails
published_at: Tuesday, January 10, 2012
---

Rspec recently got [bumped to 2.8](http://blog.davidchelimsky.net/2012/01/04/rspec-28-is-released/), a minor version release with some cool stuff.

`rspec-core` now has an option where you can run things in a random order:

	$ rspec --order rand

This option "tells RSpec to run the groups in a random order, and then run the examples within each group in random order".

We also get an init:

	$ rspec -init

Which makes a `.rspec` file, a folder called "spec" and a helper file: "spec/spec_helper.rb", so that's neat.

Then the next day rspec-rails [got a patch](http://blog.davidchelimsky.net/2012/01/05/rspec-rails-281-is-released/) for a bug in Rails 3.2.0.rc2.

---

Speaking of which, Rails 3.2.0.rc2 [was released](http://weblog.rubyonrails.org/2012/1/4/rails-3-2-0-rc2-has-been-released).

What caught my eye here was that Rails 2.3-style plugins are being depreciated and will be removed from Rails 4.