---
favorite: false
number: 41
title: Dealing With Rotten Links
---

In a perfect world hyperlinks would always work. We'd go through our lives
building this beautiful network of websites pointing at one another, enriching
the lives of ourselves and others as we went. The sites we make would forever
honor inbound links and the external links we setup would never go stale. The
reality is that links break all the time!

If you run a site long enough you will almost certainly break some inbound
traffic. You might not even notice it! Or maybe you decided against renewing a
domain and rendered links to that site fully and forever broken. On the other
side, you'll write external links that break and it's quite easy to miss these
broken links. This is called [link rot][link_rot] and it sucks.

So what can we do about link rot? Well, for external links on this site, my
approach is to identify them and then flag them for the reader. I created a page
for these [Rotten Links][rotten] and then link to that page rather than the
broken link. I run the un-hyperlinked URL on that page hoping that the reader
can find something useful from this context.

## Finding Rotten Links

In order to find these broken external links on this site, I use a Ruby Gem
called [HTMLProofer][htmlproofer] and have [a Rake task][rake_task] setup for
it:

```ruby
desc 'Check external links'
task :check_links do
  options = { assume_extension: true, checks_to_ignore: %w[ImageCheck ScriptCheck], external_only: true }
  HTMLProofer.check_directory('build', options).run
end
```

And I run it like this:

```
$ rake build
$ rake check_links
```

That first task will build the site to the `./build` folder so I'm sure I have
the freshest HTML to check and then the second one focuses HTMLProofer on
external links. It'll usually take 10 seconds or more and then spit back a list
of broken links and which page in the build folder contained the link.

## Fixing Rotten Links

When I have found a broken link, I start by visiting it in a browser to ensure
it's broken and to do some due diligence to see if I can find a replacement URL.
If I get lucky and find a suitable link, then I'll update it.

If I can't find a replacement, then I need to move this link to the Rotten Links
page and replace the link with an anchor to that plain text URL. You can see
[this PR for an example][pr].

## Automating Fixing Broken Links

There's a Rake task that I wrote to automate the above process, it takes the URL
that has gone stale:

```
$ rake fix_rot[http://www.example.com/path/to/page.html]
```

This task will:

* create a new entry in the `rotten_links.yml` file
* find the post where the rotten link exists
* update that post with a link/anchor to the Rotten Links page

I think this is the best I can do for people. I don't want broken links on my
website, but I also want to preserve some context. I wonder which link in this
very post will be the first to go stale and be replaced!

[link_rot]: https://en.wikipedia.org/wiki/Link_rot
[rotten]: /rotten.html
[htmlproofer]: https://github.com/gjtorikian/html-proofer
[rake_task]: https://github.com/jonallured/jonallured.com/blob/04157a179a6312d83f9e1c114b500218202795c5/Rakefile#L26-L30
[pr]: https://github.com/jonallured/jonallured.com/pull/20
