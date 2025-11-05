---
date: 2025-10-17 10:17 -0500
number: 67
tags: article
title: "Migrating Back to Jekyll"
---

This week I finished a migration of the blog back to [Jekyll][] and wanted to
write up a few things about that process and the motivation.

## Back and Forth

The initial commit for this blog was in May of 2011. At that time I was building
the blog using Jekyll and it wasn't until a few years later that I learned of
the [Middleman][] project. I ended up deciding to migrate the blog over to
Middleman and away from Jekyll. That switch happened in March of 2014.

[Jekyll]: https://jekyllrb.com
[Middleman]: https://middlemanapp.com

I don't fully remember my reasons for switching to Middleman but I know that we
were using it at Hashrocket and it used [Haml][] and [Sass][] by default which
was my preference. Another very superficial thing was that I always thought the
underscore folders in Jekyll were really ugly and Middleman didn't do that.

[Haml]: https://haml.info
[Sass]: https://sass-lang.com

Quick aside here in case that doesn't mean anything to you: Jekyll uses a
convention that folders starting with an underscore are treated a bit
differently. All other folders are processed and built into the site. So these
underscore folders are where you put things like your layout files or include
snippets. I always thought that was dumb and that Middleman did a smarter thing
but pulling out those types of things into a different location in the project.

## Middleman Lost Momentum

Over the years I noticed issues with the health of the Middleman project. As far
as I could tell it seemed like there was really just one person keeping it going
and they were pretty overwhelmed. I just looked and there is still a `5.x`
branch that has been unreleased since around 2019.

I've pondered getting involved to help with Middleman but when I'm honest with
myself then I know that I would not actually have the time. So the project lacks
momentum and I can't be bothered to help which leads to the conclusion that I
should just move on to Jekyll which is better supported.

## Methodology

Great so there's some thoughts and feelings about how I got where I was and why
I wanted to migrate back to Jekyll. Now for the part you probably care about -
how did I approach it. Well honestly how I approached it was to have a bunch of
enthusiasm, make progress and then forget all about it for like 9 months. Then I
wanted to post something on the site, noticed with embarrassment how I had left
things and promised myself I would actually finish.

Oops more feelings came out! Back to the technical details.

### New Branch and Start Over Commit

The first thing I did was create a new branch and then do a commit that removed
everything from the repo except the `.git` folder. This made the repo empty and
allowed me to run the `jekyll new` command to get a skeleton landed. I messed
around with that a few times to get the new command just right and to figure out
what I wanted from the skeleton. At this point the project was literally 5
files.

I continued tinkering with the config file and reading through the docs until I
figured out sorta what I wanted. I actually ended up making the decision to drop
Sass and build the CSS from scratch.

### Getting Organized

Let's do a quick digression here so I can describe how I got myself organized to
switch between the old Middleman version of the site and the work-in-progress
Jekyll version. What I did was create a new folder called `blog-migration` and
then cloned the repo twice inside there to get a structure like this:

```
code/
  blog-migration/
    jekyll-jonallured.com/
    mm-jonallured.com/
```

And then the `jekyll-jonallured.com/` folder would be on the migration branch
while the `mm-jonallured.com` folder would be on main.

If I had this to do over again I would have used [git worktrees][worktrees]. I
didn't know much about them at the time but in our new world of AI coding agents
I have used them a bunch and this would have been a perfect use-case.

[worktrees]: https://git-scm.com/docs/git-worktree

### A Test of Correctness

In order to have confidence that I was correctly migrating sections of the site
over to the new Jekyll way of doing things I stumbled upon the idea of
installing [RSpec][] and writing a test for correctness.

[RSpec]: https://rspec.info

The idea was to use [fd][] on the `jekyll-jonallured.com` and
`mm-jonallured.com` folders and then compare the results. Something like this:

```ruby
it "builds the same number of files" do
  fd_command = "fd . build --type file"

  mm_output = `cd ../mm-jonallured.com/ && #{fd_command}`
  mm_matches = mm_output.split("\n")

  system "rm -rf build && bundle exec jekyll build"
  jekyll_output = `#{fd_command}`
  jekyll_matches = jekyll_output.split("\n")

  expect(jekyll_matches).to match_array mm_matches
end
```

[fd]: https://github.com/sharkdp/fd

The idea is to formulate an `fd` command that I run twice and use RSpec's array
matcher to compare what comes back. I ran this over and over while tinkering
with various configurations and could use the RSpec failure output to drive
towards green and a correctly migrated site in terms of files on disk.

### Matching Visual Style

Having the right number of files and the right filenames was a nice milestone to
hit but when I started a Jekyll server and looked at the site it was garbage. As
I mentioned, I had the idea that I should drop Sass and just re-write the style
of the site by hand. When I looked at the Sass code what I saw was that I was
using 2 main features:

* variables for colors and fonts
* nested styles

But it turns out modern CSS includes both of these things and browser support is
there! Here's some docs:

* [CSS custom properties][css_vars]
* [CSS nesting][css_nest]

[css_vars]: https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_cascading_variables/Using_CSS_custom_properties
[css_nest]: https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_nesting/Using_CSS_nesting

So I had my Jekyll server running in watch mode, my Sass version of the styles
as a reference and I just got to work authoring plain old CSS. It was not hard.

### Comparing Generated HTML

As I was making progress on the migration I had the idea that I should actually
compare the generated HTML from both sites to get a sense of how closely I was
matching there. I went back to my RSpec file and added one for just the
`index.html` page. Something like this:

```ruby
it "has the same index content" do
  script = <<-SHELL
    bundle exec jekyll build
    rm -rf diff
    mkdir diff
    cp build/index.html diff/jekyll-index.html
    cp ../mm-jonallured.com/build/index.html diff/mm-index.html
    npx prettier diff --write
  SHELL

  script.split("\n").compact.each do |command|
    system(command)
  end

  diff_brief = `diff diff/jekyll-index.html diff/mm-index.html --brief`
  expect(diff_brief).to eq "foo"
end
```

What this does is build the Jekyll site, copy over the index file, grab the
index file from the Middleman version and then run [Prettier][] on them to iron
out any formatting inconsistencies. Then I diff the 2 files and see what comes
up. In this version of the test I was passing the `brief` flag to `diff` which
causes it to just print a message when the files differ rather than the actually
differences. I played with this command while comparing the 2 and sometimes
wrote the diff to stdout or to a file depending on what I wanted to investigate.

[Prettier]: https://prettier.io

Ultimately the differences were trivial and this was mostly just an exercise in
making me feel like I didn't miss anything. It did help me tweak my [Kramdown][]
config a bit since that translation wasn't quite doing what I wanted. For
instance I don't like curly quotes on a technical website so I turned that all
off.

[Kramdown]: https://kramdown.gettalong.org

I thought that I might do this comparison on all the pages of the site but it
was such a pain in the butt that I ended up deciding that this was good enough
and I should stop stalling and move on.

### Migrating Ruby Code

At this point the content of the site was migrated. What I had left was a bunch
of Ruby code that I had written over the years to automate various things. I had
scripts to generate a new blog post or create a social image for sharing on
social media sites. There were scripts with code for generating my list of the
RSS feeds I read and the Podcasts I listen to.

I confess I fell down a rabbit hole here. It would have been fine to create some
follow up issues on GitHub for this stuff and complete the migration without
this stuff. But my scripts!

Instead what I did was move this code over and refactor it a bunch. I wrote
snapshot-style tests for the scripts and code that generate new posts and just
way over-engineered it. It was fun but slowed me down.

### Stop Stalling

I literally wrote "STOP STALLING" on my whiteboard and then made a list of what
was needed to actually ship this migration. Anything that could be a follow up I
added as a GitHub issue and ignored. I got the site to deploy locally and then
opened [the PR][pr] to merge the migration to main. It was done!

[pr]: https://github.com/jonallured/jonallured.com/pull/133

## Ahh Now I Can Write

At this point I have the site deploying main automatically via CI and all that's
left on my list are nice-to-haves. This write-up captures the process and now I
can finally just get to actually using this blog to publish some posts. At least
that's what I tell myself!
