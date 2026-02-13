---
date: 2026-02-13 14:44 -0600
number: 94
tags: article
title: "Making Time for Boops"
---

A couple months back, just before the Christmas holiday break, I received a
[TIME smart clock][time] as a gift from Shopify. They gave everybody the choice
between a few different items from merchants on the platform. I thought it was
both a fun way to recognize employee effort and a cool way to dog food Shopify's
software. Plus merchants earned a little money off the project. Win-win-win.

[time]: https://lametric.com/en-US/time/overview

Setting it up was easy and fun and I instantly fell in love with the retro
look of the display. Those pixels are so chunky!

{%
  include
  framed_image.html
  alt="TIME clock on desk"
  caption="The default face is the calendar app and it is fine."
  ext="jpg"
  loading="eager"
  slug="time-on-desk"
%}

Before I headed out for the holidays I messed with the device a little. I
learned enough to kinda understand what was possible. Ideas bloomed but I didn't
get very far.

Then this was Hackathon week at Shopify and I decided to take one of those ideas
and run with it.

## The Idea

What I had in mind was something where I'd make a public page on my Rails app
where people could click a button and send a message to appear on the device. As
I pondered the idea over the couple months, a name for the idea came to me:
Boops. Once you have a good name how can you not build it right??

So yeah, people would create a Boop and send it to me. Fun!

## LaMetric Developer Account

As I sat down to start really digging into this concept and get something built
I first had to create a developer account with LaMetric, the company that
manufactures the TIME smart clock. It was just a free sign-up and I was in, no
big deal. But the screen you land on when creating your account presents you
with 3 choices of apps to create:

1. Indicator App
2. Button App
3. Notification App

I had no clue! Luckily there was a link to the [LaMetric Developer
Documentation][ldd] and there I spent quite a bit of time reading and tinkering
with things to figure out what I wanted to do.

[ldd]: https://lametric-documentation.readthedocs.io/en/latest/index.html

## Frames and Clicks

Ultimately I decided to build an Indicator App. What I needed to do was create 2
API endpoints - one for frames (what to display on the device) and one for
clicks (what to do when the button on top is pressed). The device sends GET
requests to these endpoints and will error unless it gets a 200 back. This is
what I sketched out:

```
GET /api/v1/time_clock/frames
GET /api/v1/time_clock/clicks
```

My Rails app Monolithium already had good patterns for adding API endpoints so
making [Add endpoints for time clock][monolithium-280] was not hard. At this
point the frames endpoint just returned a static default frame and the click
endpoint did nothing. But it was enough to complete the form in the developer
portal, get verified, publish the Indicator App, and install it on my device.

[monolithium-280]: https://github.com/jonallured/monolithium/pull/280

I tested it and it worked - I tailed my Heroku logs and saw the polling for
frame data and when I pushed the button I saw the click request come through.

## The Boop Lifecycle

At this point I started thinking about how I would create, show and then be done
with a `Boop` record. I was thinking of this as a queue. There would be a page
where a button would be clicked to create the `Boop` record. Then it would show
up in the frames API call and display on the device. Then I would press the top
button which would send a click API call which would dismiss the `Boop` and the
next one off the queue would show up. Wash, rinse and repeat.

## Look and Feel

This lead me to think about how the frames would look on the device. I was
picturing an icon on one side and the text on the other. I wasn't totally sure
about the text but I thought that it would be fun to pick some icons. LaMetric
provides icons for developers to use and has a [Gallery Page][gallery] so I went
hunting for some good options - here's what I picked:

[gallery]: https://developer.lametric.com/icons

{%
  include
  framed_image.html
  alt="Icon options for Boop"
  caption="There are a LOT of icons to choose from but these stood out as pretty nice."
  loading="lazy"
  slug="boop-icons"
%}

## The Boop Rails Model

Given the lifecycle I had in mind and the look and feel that was starting to
solidify in my mind, it was time to start modeling. What fields should be on a
`Boop` record? I jotted some notes and ended up with this migration:

```
class CreateBoops < ActiveRecord::Migration[8.0]
  def change
    create_table :boops do |t|
      t.string :display_type, null: false
      t.integer :number, null: false
      t.timestamp :dismissed_at
      t.timestamps
    end
  end
end
```

Putting it all together I made [Add basic boop lifecycle][monolithium-281] and
then [Different Boop frame approach][monolithium-282] quickly after playing with
the text. I didn't have a button to click on to create `Boop` records so I just
opened a Rails console and did it manually:

[monolithium-281]: https://github.com/jonallured/monolithium/pull/281
[monolithium-282]: https://github.com/jonallured/monolithium/pull/282

```
> Boop.create(display_type: "smile", number: 16)
```


It worked and I started seeing them show up on the device! I pressed the button,
got a satisfying success sound, and then the next one showed up. Here's how one
looks:


{%
  include
  framed_image.html
  alt="Boop frames"
  caption="This is a Boop record with display_type of smile and number of 16."
  loading="lazy"
  slug="boop-16"
%}


There's an animation where one frame slides down on top of the other. It's Boop
time!!

## Adding a Public Boop Page

The next milestone was to create a public page where people could pick an icon
and send me a Boop. This is a silly project so I had some fun writing up some
copy and then adding some flair.

There did end up being an interesting technical challenge - the
`Boop.display_type` field is stored as a string but I wanted to run the icon
options on the page and have them be backed by a radio button group.

I tinkered with this for a while and ended up really liking how it came out.
What I did was wrap a `label` element around the `input` and `img` elements for
each option. Then I hid the `input` and used some fancy CSS to arrange things
nicely in a single rail with a bottom border. Because the icon images were
inside the `label` element when you click on the `img` then it selects that
`input` element.

Brief aside to mention a trick that I had not considered. Given this type of
markup structure:

```
<label>
  <input type="radio">
  <img>
</label>
```

How might we highlight the image of the checked option? Turns out it's easy!

```
:checked + img {
  border-color: pink;
}
```

That's not exactly what I ended up with but close enough. The trick is knowing
that the pseudo selector `:checked` applies here and if we use a plus sign then
the styles will apply to the next element not the checked one. CSS is maddening
to me but when you find the perfect way to do something it is so satisfying!!

Ok back to [the public Boop page][public] - here's what I ended up building:

[public]: https://app.jonallured.com/boops

{%
  include
  framed_image.html
  alt="Public page to send Boop"
  caption="There's more there - take a look to find out what's below the fold!"
  loading="lazy"
  slug="public-page"
%}

Some Boops are spooky - send me a Boop right now! Please also keep in mind that
I made [Add redirect to boop][shrt-27] so that you will have a memorable
shortcut: [jon.zone/boop][jz] so you can Boop anywhere, anytime.

[jz]: https://jon.zone/boop
[shrt-27]: https://github.com/jonallured/shrt/pull/27

## Quality of Life Improvements

My Rails app has a generator for CRUD pages so it is very easy to add an admin
section:

```
$ bin/rails generator crud:pages Boop
```

So I made [Add Boop CRUD pages][monolithium-285] and got that going. I want to
make a generator command for adding API endpoints but haven't gotten there yet
so I did it manually with [Add api endpoints for boop][monolithium-286]. I'm
glad I did these 2 PRs because it helped me see a couple areas for improvement
around Rails validations for the `Boop` model.

[monolithium-285]: https://github.com/jonallured/monolithium/pull/285
[monolithium-286]: https://github.com/jonallured/monolithium/pull/286

## Boop from the Terminal

With the API endpoints in place it was now possible to Boop right from my
terminal using [httpie][]:

[httpie]: https://httpie.io

```
$ http https://app.jonallured.com/api/v1/boops display_type=skull
```

So then I went to my Raspberry Pi and setup a cronjob to Boop me during work
hours on the 7s:

```
7 8-16 * * 1-5 http https://app.jonallured.com/api/v1/boops display_type=robot
```

Wait did you notice a new `display_type`?? Yep I made [Add more Boop display
types][monolithium-288] because I felt like an automated Boop should have a
robot icon. While looking for a good one I also found a fun monster one so I
added that too. I didn't add them to the public page so they are sorta Easter
eggs for you dear reader.

[monolithium-288]: https://github.com/jonallured/monolithium/pull/288

## Boop with a CLI

Don't you think it should be easier to Boop? No one should have to remember a
URL to create a Boop. I already had a solution - my CLI Ruby gem that wraps the
Monolithium API called [mli][]. What I wanted was this:

[mli]: https://github.com/jonallured/mli

```
$ mli boops create --display-type monster
```

I made [Add Boop command and resource][mli-17] and had that done. Installing
that project is done by cloning the repo and then running `rake install` so
there's a bit of friction but boy is it easy to Boop now!

[mli-17]: https://github.com/jonallured/mli/pull/17

## Conclusion

I want to thank Shopify for buying me this fun TIME smart clock and for
providing the Hackathon time to play with it. I had a blast stepping away from
my normal work to do something completely different. My work is so digital that
when I can do something with hardware that manifests itself in the real world I
just have to do it.

And I hope this project made you smile. Maybe feel some whimsy? Things are very
challenging in the real world right now so having some fun was a wonderful
distraction. Keep those Boops coming!
