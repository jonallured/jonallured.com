---
date: 2025-10-19 09:18 -0500
favorite: false
number: 68
title: "Week in Review: Week 42, 2025"
---

The main headline of this week is that I finished migrating the blog back to
Jekyll and wrote up some notes (see below) on my approach. With that done I'm
trying to get back to actually writing posts on this thing which includes these
weekly review posts.

## Highlights

* worked 16:00, 24:00 of PTO
* published [Migrating Back to Jekyll][post_67] on here
* finished reading [Your Brain Is a Time Machine][book_583]

It was a weird week with only 2 days in the office. Monday was a holiday and
then Thursday and Friday were no-school days so I had taken them off over the
summer. Monday was great because I was home by myself but didn't have to work
so that's when I focused on completing the blog migration and actually got it
done!

Finishing that book felt really good - I typically do not read that type of book
because I'm such a sucker for a fantasy novel but it was really fun! Thinking
about the nature of time through the lens of neuroscience and physics was such a
good idea for a book.

## Next Week

There's a loop I'm focused on where I publish a blog post, it gets posted to my
social media accounts and then I see it show up in my analytics with page views.
I've got the publishing in a good place with the migration complete and I'm
kinda skipping the social media step so I can focus on the analytics. I've been
sending daily Apache access logs to S3 from my server on Digital Ocean but there
they have sat.

What I've just started tinkering with is slurping down these access logs and
then producing some website analytic data. I've envisioning a system where
there's a daily job to pull down the access logs, parse them and then archive
the log file. Maybe I can come up with a way to surface the website analytics
for myself - possibly sending a daily email or just a webpage where I can view
it. I haven't decided yet.

[gh-activity]: https://github.com/search?s=created&o=desc&q=author:jonallured+created:2025-10-12..2025-10-18
[post_67]: https://www.jonallured.com/posts/2025/10/17/migrating-back-to-jekyll.html
[book_583]: https://wwnorton.com/books/Your-Brain-Is-a-Time-Machine/
