---
date: 2026-02-25 16:44 -0600
number: 97
tags: article
title: "Show Timestamps in Local Zone"
---

My Ruby on Rails application [Monolithium][] stores times in UTC and thus far
I've been content to show them without considering timezone. As an example, the
[Boops Page][boops] will show the `created_at` timestamp but it's just in UTC.
This annoyed me so I decided to look into what it would take to show them in a
user's local timezone.

## How Should I Do This?

The first questions I hit were around where I would do the conversion from UTC
to another timezone and which other timezone should I use. Should I do the
conversion client side or server side?  What if I just used my own timezone
since this is largely a personal app? Oh maybe I should only do this when I'm
signed in? Could I use a cookie to set the timezone and pass that into the
server side code?

## There's a Gem For This

While pondering these questions I did some searching and found that there was
already a gem for this! I found [local_time][] from [Basecamp][] which seemed
close enough to official that I should just use it. Plus it answered many of
these questions.

How it works is that it provides view helpers that write your timestamps into
`time` elements with data attributes. Then it also includes some Javascript that
runs client side and will process these `time` elements with logic that converts
the timestamp into the user's local timezone. Neat!

I decided to try it out and made [Localize times with local time
gem][monolithium-296] which demonstrates how to use it for my case. It wasn't
hard - I did end up making my own helper method that wraps the helper method
that the gem provides:

```
def in_tz(time)
  local_time(time, Time::DATE_FORMATS[:default])
end
```

I did this because I always wanted to use that format and it made the view code
much more simple:

```
%p= in_tz something.created_at
```

## Refused Bequest Like Crazy

At this point I noticed that the diff included a Javascript file in the vendor
folder and that got me thinking about what this gem was actually doing. I
started poking around and reading more of the README. The features of this gem
that I was not using started piling up:

* helpers for both times and dates
* adding a `title` attribute to the `time` element
* support for arbitrary formats
* integration with i18n
* timezone edge cases
* helpers for relative time that are updated every minute
* support for 24-hour vs 12-hour times

So yeah it wasn't long before it dawned on me that I was barely using any of the
functionality that this gem provided. [Refused Bequest][rb] like crazy. Isn't
there a better way?

## Making My Own Solution

I checked out a new branch and reversed the install of the gem. I left the
changes to the view files and set my sights on what it would take to arrive at
the same outcome but with much less code.

Here's what I had in mind:

* update the helper method to create a `time` tag kinda like the gem does
* add a data attribute to that tag that tracks if it has been converted yet
* add a Javascript event listener for when the page is loaded
* create a function to find all the `time` tags and convert them
* update the data attribute once done converting

Having the code of the gem to refer to made it actually pretty easy. I did this
and made [Localize times with intz][monolithium-297] which is a much more simple
and smaller change! By cutting out most of the features of the gem and finding
the smallest bit of functionality that I actually needed for my use case I
arrived at something I can understand and easily maintain.

It isn't tested though - don't tell anyone!

## Formatting Times in Javascript

Back to the code for a second - the function that converts the `time` elements
is pretty small and I think easy to understand:

```
const intz = () => {
  const timeElements = document.querySelectorAll("time[data-intz='false']")

  for (const timeElement of timeElements) {
    const datetime = timeElement.getAttribute("datetime")
    const localTime = new Date(Date.parse(datetime))
    const localText = formatTime(localTime)
    timeElement.innerText = localText
    timeElement.setAttribute("data-intz", "true")
  }
}
```

Find all the `time` elements and loop through them. For each element pull out
the timestamp in UTC, convert it to a local time that is formatted nicely,
update the text of the element, and then update the data attribute. Pass that
function to the event handler for `DOMContentLoaded` and boom, timestamps get
converted!

What ended up being the worst part of this was that `formatTime` function. Did
you know that formatting a `Date` object in Javascript sucks? It does if you
don't want to use a library! There is nothing like `strftime` and so I had to
build something myself. Pain points included:

* month is zero-indexed so you have to add 1
* you get the month with a function called `getMonth` but you get day with
  `getDate` - the `getDay` function returns the number of the day of the week??
* hour is 24-hour time so you have to convert it to 12-hour time yourself
* there is nothing to get the am/pm out
* you have to pad month, day, hour, minute, and second yourself

As someone that avoids Javascript as much as possible it was life-affirming to
see how stupid this all was. Feel free to have a look at my [formatTime][]
function if you'd like to see how I addressed this problem. I'm pretty sure it
works just fine.

## Assessing Trade-offs

A fair question might be "why build this yourself - why not just use the gem?"
and ultimately this is about trade-offs. In my mind I would rather build this
myself because I'm using so little of what the gem does and the code that I
added is not complex enough that I foresee problems maintaining it. That's the
calculation I'm making. I don't know, maybe you would make a different one!

I do wish I had a way to unit test those functions but oh well. I don't relish
the idea of spinning up an entire Javascript test suite just for one file.

[Basecamp]: https://basecamp.com
[Monolithium]: https://github.com/jonallured/monolithium/
[boops]: https://app.jonallured.com/boops
[formatTime]: https://github.com/jonallured/monolithium/blob/c893c526a8004385f8cf60d0ca8f0deaa89aa633/app/javascript/intz.js#L3
[local_time]: https://github.com/basecamp/local_time
[monolithium-296]: https://github.com/jonallured/monolithium/pull/296
[monolithium-297]: https://github.com/jonallured/monolithium/pull/297
[rb]: https://refactoring.guru/smells/refused-bequest
