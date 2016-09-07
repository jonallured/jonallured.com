---
title: Releases for Both Rspec and Rails
---

Rspec recently got [bumped to 2.8](/rotten.html#9), a minor version release with some
cool stuff.

`rspec-core` now has an option where you can run things in a random order:

```
$ rspec --order rand
```

This option "tells RSpec to run the groups in a random order, and then run the
examples within each group in random order".

We also get an init:

```
$ rspec -init
```

Which makes a `.rspec` file, a folder called "spec" and a helper file:
`spec/spec_helper.rb`, so that's neat.

Then the next day rspec-rails [got a patch](/rotten.html#10) for a bug in Rails
3.2.0.rc2.

---

Speaking of which, Rails 3.2.0.rc2 [was released][rails].

What caught my eye here was that Rails 2.3-style plugins are being depreciated
and will be removed from Rails 4.

[rails]: http://weblog.rubyonrails.org/2012/1/4/rails-3-2-0-rc2-has-been-released
