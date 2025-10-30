---
date: 2025-10-30 12:35 -0500
favorite: false
number: 72
title: "Using Style Guides to Drive Website Design"
---

A practice I picked up from my days at Hashrocket is to add a style guide
section to website projects. I've been using this on my personal projects and
wanted to write up why I spend the time and how it has helped me drive the
design of these sites.

## Style Guide Sections

The idea is to add a section to website projects where we can produce the
intended design by using dummy pages. The style guide section can have one or
more pages where we lay out common website elements and ensure they visually
appear as designed.

Typically these are orphaned pages that are really only helpful while building
the project but I like to actually publish them so I can verify things on my
production site.

## My Style Guides

I have a style guide section on my Rails project [Monolithium][] that has separate
pages for:

[Monolithium]: https://github.com/jonallured/monolithium/

* [articles](https://app.jonallured.com/style/article)
* [color](https://app.jonallured.com/style/color)
* [flashes](https://app.jonallured.com/style/flashes)
* [form](https://app.jonallured.com/style/form)
* [table](https://app.jonallured.com/style/table)

For this blog I did something even more simple and just added a single [style
guide page](https://www.jonallured.com/style-guide.html) that gives me a good
enough set of elements to use.

## Driving Out Table Styles

As an example of how this practice can be useful I wanted to share how I drove
out the design of table styles for this site. At the end of the [Evaluating
Apache Access Log Data][post-71] post I did a table of data that initially
looked like this:

<div class="imageWrapper">
  <a href="/images/post-72/table-before-styling.png">
    <img alt="Table Before Styling Screenshot" src="/images/post-72/table-before-styling.png" width="700" />
  </a>
  <p><em>click for bigger</em></p>
</div>

I [logged an issue][issue-153] to come back to this because I didn't like how it
looked. That was a good excuse to add a table to the style guide page so I did
that and then iterated on the design until it looked like this:

<div class="imageWrapper">
  <a href="/images/post-72/table-after-styling.png">
    <img alt="Table After Styling Screenshot" src="/images/post-72/table-after-styling.png" width="700" />
  </a>
  <p><em>click for bigger</em></p>
</div>

Then I [opened a PR][pr-155] to close the issue and deployed that change pretty
quickly. You can take a look at the actual styles - there isn't a lot there just
some minor changes but I think they make the data look a lot nicer!

[post-71]: https://www.jonallured.com/posts/2025/10/29/evaluating-apache-access-log-data.html
[issue-153]: https://github.com/jonallured/jonallured.com/issues/153
[pr-155]: https://github.com/jonallured/jonallured.com/pull/155

## Why Bother?

I could have easily made this improvement to table styles without bothering with
a style guide but I think it is worth the effort. As the site evolves I might
find that I will have variations of tables that I want style slightly
differently. Now I have an easy place to do that and to document those
differences.
