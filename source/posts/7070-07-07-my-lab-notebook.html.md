---
favorite: false
id: 52
title: "My Lab Notebook"
---

I keep a lab notebook with notes from doing my work, personal or professional.
This habit has evolved over time, but I'm still inspired by [a blog post Nelson
Elhage did][inspiration] to write things down and then save them to refer back
to later! My lab notebook is built using [Middleman][] and a few tricks.

[inspiration]: https://blog.nelhage.com/2010/05/software-and-lab-notebooks/
[Middleman]: https://middlemanapp.com/

## How is a Lab Notebook Different?

For me, keeping a lab notebook is a state of mind: whatever I'm working on is
worth documenting because you never know when you'll want to refer to notes
later. Everything from keeping some notes about the commands I'm running to
accomplish a task to notes where I'm listing candidates for a variable name.

## General Notes vs Structured Notes

One pattern I've landed on that has helped keep me organized is having a place
for general notes, but then also adding in some structure for a couple types of
notes. These structured notes come in two flavors: notes about the current
sprint I'm working on and notes for the One-on-one meetings I take.

## Sprint Notes

At Artsy we work in two-week long sprints and during that time we'll have
various meetings:

* daily standup
* weekly knowledge share meetings
* retro
* ticket grooming
* sprint planning

So in my lab notebook I generate a skelleton of notes for each sprint that looks
something like this:

```
source/notes/sprints/2021-07/
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
  grooming.html.md
  planning.html.md
  props.html.md
  retro.html.md
```

This gives me a notes file for each day of the sprint where I can add my standup
notes. Then I also have a spot for any notes resulting from our knowledge share
meetings or I can drop an idea there ahead of time.

Same goes for the grooming, planning and retro documents: I can use these files
to jot down things I want to bring up at these meetings and then also record any
notes that surface during the meetings.

Finally I keep a props file going so I can brag on my fabulous coworkers!

## One-on-one Notes

This one is simple - when I start by day I look at my calendar to see what
meetings I have for the day and I create a notes file for every One-on-one
meeting. Those notes files have a section for prep and another for notes. In the
prep section I can quickly record anything that I know I want to bring up with
the person. Then when we have the meeting I can record anything that comes up.

## The Scripts

I wrote a set of bash scripts to generate these files for me and then I run them
like this:

```
# create a new general note file
$ ./bin/new_note
# create a new One-on-one note file for Erik with today's date
$ ./bin/new_ooo erik-krietsch
# create a new skeleton of notes file for the 7th sprint of 2021
$ ./bin/new_sprint 2021-07
```

## The Repos

My lab notebook infrastructure is all open source but the notes are encrypted
and not public. I achieved this by separating the code of the blog from the
content. The code is available at https://github.com/jonallured/lab_notebook but
the notes themselves are in a separate repo hosted by Keybase at
keybase://private/jonallured/notebook-data.

## The Servers

So how do I actually look at my lab notebook? I'm glad you asked because I'm
pretty proud of the setup! First I'll tackle how I monitor the notes being added
and get them committed to the Keybase repo.

My approach here is to run a Guardfile that watches for files being added to
`/source/notes` and then run git commands to add files and changes as they
occur. This looks something like this:

```
watch(%r{^source/notes/.*$}) do
  message = 'Auto-adding this diff from Guard'
  command = "cd source/notes && git add . && git commit -m '#{message}'"
  system command
end
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
* 116b8b5 Auto-adding this diff from Guard
* fa6fa58 Auto-adding this diff from Guard
* 340208e Auto-adding this diff from Guard
* 9139f91 Auto-adding this diff from Guard
* 65f97e1 Auto-adding this diff from Guard
* 10f0056 Auto-adding this diff from Guard
* 5ffd8bc Auto-adding this diff from Guard
* 70c3be6 Auto-adding this diff from Guard
* 949a449 Auto-adding this diff from Guard
* 7bb18fd Auto-adding this diff from Guard
...
```

Just a fire-hose of commits that add/update the notes files being added to the
Keybase encrypted repo.
