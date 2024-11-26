---
favorite: false
number: 63
title: "Week in Review: Week 25, 2021"
---

This week I was able to spend some time poking at Apache log files and learned a
lot more about how they work and what parts of the logged data I'm interested
in. What I have is a folder on S3 with daily log files. I pulled them down to my
local machine and then used a couple Ruby gems to inflate, parse and filter
them. There is a lot of noise in these files so the filtering part took the most
time - more time than I had anticipated for sure!

So that's where things stand - I've got a script that I used to slice and dice
down a file of data into what appears to be the signal from the noise. Where I
want to get to is a weekly email that shows me how my sites are doing.
Connecting pieces to achieve this goal would be the next step.

## Highlights

* worked 38:30, 1:30 of PTO

## Next Week

We're headed to visit family for the 4th of July so I probably won't have too
much time to work on things. I'm really looking forward to the break from normal
life; the haze of this last year of pandemic life is lifting more each time we
take a trip. I'm very grateful to be able to reconnect with people in person!

[gh-activity]: https://github.com/search?s=created&o=desc&q=author:jonallured+created:2021-06-20..2021-06-26
