---
number: 52
tags: article
title: "My Lab Notebook"
---

I keep a lab notebook with notes from doing my work, personal or professional.
This habit has evolved over time, but I'm still inspired by [a blog post Nelson
Elhage wrote][inspiration] where he proposes that Engineers should keep a lab
notebook. My lab notebook is built using [Middleman][] and a few tricks and I
want to tell you all about it!

[inspiration]: https://blog.nelhage.com/2010/05/software-and-lab-notebooks/
[Middleman]: https://middlemanapp.com/

## What Makes a Lab Notebook Different?

For me, keeping a lab notebook is a state of mind: what I'm working on is worth
documenting and you can never have too many notes. One never knows when or what
part of your notes you'll want to refer to later so make it easy on yourself and
write everything down and keep it all. I keep all kinds of notes - ones about
the commands I'm running to accomplish a task or even one where I'm
brainstorming the name of a class. Scraps of SQL litter my notebook along with
the occasional note about how I fixed a Rails upgrade.

## Making New Notes

Making a new note looks like this:

```
# create a new general note file
$ ./bin/new_note
source/notes/general/2021/04/twenty-four.html.md

# create a new general note file with custom title
$ ./bin/new_note "some great title"
source/notes/general/2021/04/some-great-title.html.md

# create a new general note file and copy the path to clipboard
$ ./bin/new_note | pbcopy
```

This script wraps the `middleman article "title goes here"` command with some
goodies:

* generate the next id number for the new note
* if a title is provided ensure the casing is correct
* if no title is provided convert the id number to words and use that for title
* spit back the path so that I can copy it and start editing

## General Notes vs Structured Notes

I've got a folder of general notes as described above but then I also have a
couple types of notes that I've broken out into their own folders: notes about
the current sprint I'm working on and notes for the one-on-one meetings I take.

### Sprint Notes

At Artsy we work in two-week long sprints and during that time we'll have
various meetings:

* daily standup
* weekly knowledge share meetings
* retro
* ticket grooming
* sprint planning

I use these recurring meetings to guide the organization of my sprint notes. In
my lab notebook I generate a skeleton of notes for each sprint that looks
something like this:

```
# create a new skeleton of notes file for the 7th sprint of 2021
$ ./bin/new_sprint 2021-07

# the resulting skeleton structure
source/notes/sprints/2021-07/
  grooming.html.md
  planning.html.md
  props.html.md
  retro.html.md
  week-1/
    1-monday.html.md
    2-tuesday.html.md
    3-wednesday.html.md
    4-thursday.html.md
    5-friday.html.md
    knowledge-share.html.md
  week-2/
    1-monday.html.md
    2-tuesday.html.md
    3-wednesday.html.md
    4-thursday.html.md
    5-friday.html.md
    knowledge-share.html.md
```

This gives me a notes file for each of the sprint meetings and I start it out
with just a `Prep` section and a spot for `Notes`. I can drop ideas ahead of
time in that `Prep` section and then when the meeting occurs I jot things down
under the `Notes` header.

Also generated is a folder for each week of the sprint with a file for each day
and this is where I put my standup notes.

I also keep a props file going so I can brag on my fabulous coworkers!

### One-on-one Notes

When I start my day I look at my calendar to see what meetings I have for the
day and I create a notes file for every one-on-one meeting:

```
# create a new one-on-one note file for Erik with today's date
$ ./bin/new_ooo erik-krietsch
```

Those notes files have a section for prep and another for notes. In the prep
section I can quickly record anything that I know I want to bring up with the
person. Then when we have the meeting I can record anything that comes up.

## The Repos

Ok let's get into the technical details. My lab notebook infrastructure is all
open source but the notes are not. I achieved this by separating the code of the
blog from the content. The code is available on GitHub in [my `lab_notebook`
repo][repo] but the note data is in an [encrypted repo hosted by Keybase][key].

[repo]: https://github.com/jonallured/lab_notebook
[key]: https://book.keybase.io/git

This separation means I can share my overall approach but not share the notes
themselves. I like this because it frees me to write whatever I want in that
notebook including sensitive tokens but also private thoughts.

## The Three Processes

After the notes are written, how do I actually look at my lab notebook? I'm glad
you asked because I'm pretty proud of the setup! I'm using three processes to
serve my lab notebook:

1. A Guard process that rebuilds the static HTML for the site
2. A Ruby process that boots a custom Rack app to serve this static HTML
3. Another Guard process that adds note data to the Keybase repo

You might be wondering why I'm not using the build-in Middleman server and it's
because it's too slow. I didn't want to pay the penalty of that process having
to be dynamic - I wanted something dumber!

### Rebuilding The Site As Things Change

My first goal was to write a Guard that would listen for changes and run
`middleman build` to rebuild the site locally. There was already a
[guard-middleman][] gem so I grabbed that and did some quick setup:

[guard-middleman]: https://github.com/matt-hh/guard-middleman

```ruby
group 'middleman' do
  guard 'middleman' do
    files = %w[config.rb]
    watch(/^(#{files.join("|")})$/)

    directories = %w[article_templates data helpers lib source]
    watch(%r{^(#{directories.join("|")})/.*$})
  end
end
```

And I can run this like so:

```
$ bundle exec guard --clear --group middleman
```

With this in place I have a process listening to a set of files and building the
static HTML as things change.

### Making A Static Server

Through a bunch of trial and error what I decided to do was create a small Rack
app that would serve the static HTML built by that Guard process. I wanted it to
support serving index.html files for directories but it's mostly a pass-through.

I did this by writing a class called `StaticApp` in a `config.ru` file. It uses
[`Rack::Directory`][rack-dir] and [`Rack::Static`][rack-static] to respond to
requests extremely quickly.

[rack-dir]: https://www.rubydoc.info/gems/rack/Rack/Directory
[rack-static]: https://www.rubydoc.info/gems/rack/Rack/Static

### Automating Adding Note Data to Keybase

Next up is how I automated the process of adding notes to the Keybase repo. My
approach was to run a Guard that watches for files being added to notes folder
and then runs a git command to add files and changes as they occur. It looks
something like this:

```
group 'watch_notes' do
  guard 'shell' do
    ignore(%r{^source/notes/\.git})

    watch(%r{^source/notes/.*$}) do
      message = 'Auto-adding this diff from Guard'
      command = "cd source/notes && git add . && git commit -m '#{message}'"
      system command
    end
  end
end
```

And I run it like so:

```
$ bundle exec guard --clear --group watch_notes
```

And that gives me a history on that Keybase repo that looks something like this:

```
jon@juggernaut:~/code/lab_notebook/source/notes(main)% git tree
* 5b8c369 (HEAD -> main) Auto-adding this diff from Guard
* 6701d89 Auto-adding this diff from Guard
* ca9518b Auto-adding this diff from Guard
* 736f6ce Auto-adding this diff from Guard
* f4851d6 Auto-adding this diff from Guard
* 51f4e03 Auto-adding this diff from Guard
* 1c33537 Auto-adding this diff from Guard
* a412607 Auto-adding this diff from Guard
* 0964f71 Auto-adding this diff from Guard
* 5ff953d Auto-adding this diff from Guard
...
```

Just a fire-hose of commits that add/update the notes files as I'm working.

## Customizing the URL

I wanted to be able to use a normal-looking URL to access my lab notebook so I
did some research and found [puma-dev][] which allows one to route local servers
using particular TLDs.

[puma-dev]: https://github.com/puma/puma-dev

I installed it with brew and then configured it to listen on `.notebook`. Then I
added an entry for `lab` and pointed it at my local static server. This allows
me to access my lab notebook with `https://lab.notebook` which is pretty cool
looking please agree with me!

{%
  include
  framed_image.html
  alt="Work in progress screenshot of my lab notebook."
  caption="Futura is such a cool font."
  height="553"
  loading="lazy"
  slug="lab-notebook"
%}

## Next Steps

I have lots of ideas about what I'd like to do next:

* add support for labeling notes with tags
* get a site search going to that finding notes is easier
* setup vim such that creating a new note can be done without leaving vim

And there are more! Still I'm using this setup right now and it's working great.
There's lots of little details here that work for me, but I hope you'll take
away the larger message that taking notes is good.
