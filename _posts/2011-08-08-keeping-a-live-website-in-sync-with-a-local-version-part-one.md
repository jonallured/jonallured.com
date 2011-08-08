---
layout: post
title: Keeping a Live Website in Sync with a Local Version, Part One
---

{{ page.title }}
================

<p id="articleDate">published Monday, August 8, 2011</p>

*This part covers a project I worked on to keep a live website in sync with a local version from a business-level perspective, [the second part](/2011/08/08/keeping-a-live-website-in-sync-with-a-local-version-part-two.html) covers the technical aspects of the project.*

Each year Publishing companies produce something called a Media Kit (also called a Media Planner) - its an important tool salesreps use to help them sell advertising. Its a marketing piece that is responsible for:

* conveying the brand
* establishing credibility
* describing the audience reached
* laying out all the brand's products
* giving price information
* detailing some ad material requirements

A Media Kit's audience is both long-time customers and those that have never done business with the company. It should serve as a document that can be reviewed with a customer in person or mailed out to a prospect. It should be attractive and full of calls to action. Its one of the most important documents to come out of the Marketing Department and its typically quite expensive both to print and to mail.

[Allured Business Media](http://www.allured.com) wanted to take a different approach for their 2011 Media Kit - they wanted to take the content of the Media Kit and create a brochure-style website that reps could use just the same way they've used the physical Media Kit. They wanted to digitize their printed Media Kit.

The Hidden Requirement
----------------------

The digitizing process was started by deconstructing the piece and building an Information Architecture. We identified that good content always seems to get cut from the printed Media Kit due to size or money constraints and thought about what made sense to add back in now we no longer had these types of constraints.

A card sort helped us think about how different pieces of content were related and revealed what primary navigation to use. Wireframes were developed and final content was written, edited, and rewritten. What we ended up with was a great brochure site managed by our existing [CMS system](http://www.clickability.com). Easy.

But during the planning phase we discovered a hidden requirement: reps don't always have an internet connection when they need to show their Media Kit to customers. Take tradeshows as an example: wireless internet access is often expensive and flaky when its offered at all, especially internationally. But tradeshows are an excellent opportunity to interact with customers, so not having something to work with in this situation wasn't acceptable. It was imperative that whatever we ended up with was available without an internet connection.

Let's dig into this requirement a little, we needed this site to be:

* available when the internet isn't
* updated along with the live version
* as transparent as possible to both the salesrep who uses the site and the Marketing team who updates the content

What I came up with to solve this problem was really two things:

* a Ruby script that crawls the live version of the site and once the site is uploaded, continues to ping the live version looking for changes
* a shared DropBox folder that accepts these uploads using [their API](https://www.dropbox.com/developers)

A CAST System
-------------

I call this solution CAST - Compare and Sync Tool. It compares the live and local version of a site and keeps them in sync. To facilitate the comparing I came up with a type of file called a Castlist. A Castlist is just XML and is a list of the assets on a site with the last updated date of each. Consider the Castlist an external API from the CMS meant to be consumed by the Ruby script.

The Ruby script parses the Castlist from the live site and compares it to a Castlist that represents the current state of the local copy. When it detects that these lists are out of sync, it grabs the updates, posts them to the [shared Dropbox folder](http://www.dropbox.com/help/19) and updates the local Castlist. Then whenever any DropBox user that's included in that shared folder connects to the internet, these updates are automatically downloaded to their computer and their local copy of the site is updated as well.

A Seamless Experience
---------------------

The reps love the fact that when on the road they have access to this backup site. They don't always know what they are walking into when they arrive at a customer's office, but they know that even if they aren't going to be able to connect to the internet, they'll be able to go over their Media Kit website.

Its a very seamless experience for reps and those in Marketing and I haven't had a single compliant - it just works.

*If you're interested in more of the technical details, please read [Part Two](/2011/08/08/keeping-a-live-website-in-sync-with-a-local-version-part-two.html).*