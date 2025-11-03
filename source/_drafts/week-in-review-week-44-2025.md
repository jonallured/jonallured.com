---
favorite: false
number: 73
title: "Week in Review: Week 44, 2025"
---

It was a big relief to wrap up exploring the mountain of Apache Access Log data
I had accumulated over the years. The amount of junk traffic that my server
processes was pretty surprising. Also surprising was all the requests that
appeared to be looking for security vulnerabilities. Does a request with
`ADMIN_DEBUG=true` ever really work?? I mean I guess it must sometimes work or
else people wouldn't bother trying?

## Highlights

* worked 40:00, no PTO
* published [Evaluating Apache Access Log Data][post-71] on here
* published [Using Style Guides to Drive Website Design][post-72] on here

[post-71]: https://www.jonallured.com/posts/2025/10/29/evaluating-apache-access-log-data.html
[post-72]: https://www.jonallured.com/posts/2025/10/30/using-style-guides-to-drive-website-design.html

## Next Week

At this point I'm now working on creating an analytics section so I can look at
summaries of the data and page through months to see how things have changed
over time. I'll use that as my finish line. But I'll also have to re-think some
of my approaches. What I was doing locally on my laptop just isn't going to work
on a Heroku server. I'm starting to get a picture of an ETL pipeline in my head
so I'll need to connect that up with whatever pages I end up building. Should be
fun!
