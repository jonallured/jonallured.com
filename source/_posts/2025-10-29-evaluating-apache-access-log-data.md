---
date: 2025-10-29 15:29 -0500
number: 71
tags: article favorite
title: "Evaluating Apache Access Log Data"
---

Over on my [Capturing and Storing Apache Access Log Data][post-69] post I dove
into the configuration I'm using on a Digital Ocean machine that serves my
static websites. I set that up years ago and now I want to evaluate what that
data looks like.

[post-69]: https://www.jonallured.com/posts/2025/10/20/capturing-and-storing-apache-access-log-data.html

## Getting a Sense of the Data Size

A good place to start is getting a sense of how much data I have to work with.
Let's download it and then count the files and the lines. I have the [aws cli
tool][aws-cli] configured so that's an easy way to grab them:

[aws-cli]: https://formulae.brew.sh/formula/awscli

```
$ aws s3 cp s3://mli-data/domino/logs/ domino_logs/ --recursive --exclude "*" --include "access.log-*.gz" --region us-east-1
```

Now let's switch over to Ruby and count things:

```
> paths = Dir.glob("domino_logs/access.log-*.gz")
> paths.count
=> 1613
> counts = paths.map { |path| Zlib.gunzip(File.binread(path)).lines.count }
> counts.sum
=> 3586336
```

Those files are compressed so we start by reading the binary data and then
unzipping. Once we have the file contents we just count the number of lines.
Does that count of files make sense? Are there any gaps in those logs? Let's see
what we can find:

```
> paths.sort.first
=> "domino_logs/access.log-20210526.gz"
> paths.sort.last
=> "domino_logs/access.log-20251024.gz"
> (Date.new(2021, 5, 26)..Date.new(2025, 10, 24)).count
=> 1613
```

This look good to me. So there are 1,613 days worth of data and the total number
of requests we are working with is 3,586,336. Let's get this ingested into Rails
and see how else we can work with this data.

## Modeling Apache Access Log Lines

To work with this data locally on my machine I'll do the most naive thing I can
think of which is store each line of the data in a row in the database. I'll
grab the filename and line number plus the unparsed text and throw that into the
database. Then in a second pass I'll use a Regex to parse the line and "enhance"
the row with the rest of the data. If the Regex fails then I'll know to look at
the raw data and see what happened.

Here's the Rails migration I ended up with:

```
class CreateApacheLogItems < ActiveRecord::Migration[8.0]
  def change
    create_table :apache_log_items do |t|
      t.string :file_path, null: false
      t.integer :line_number, null: false
      t.string :raw, null: false
      t.boolean :enhanced, null: false

      t.string :website
      t.string :port
      t.string :remote_ip_address
      t.string :remote_logname
      t.string :remote_user
      t.datetime :requested_at
      t.string :request_method
      t.string :request_path
      t.string :request_params
      t.string :request_protocol
      t.string :response_status
      t.integer :response_size
      t.string :request_referrer
      t.string :request_user_agent

      t.timestamps

      t.index %i[file_path line_number], unique: true
    end
  end
end
```

With this in place I can create a job that takes a path and reads the data and
creates the individual items in the database. I'll use that same glob pattern to
enqueue the work:

```
> Dir.glob("domino_logs/access.log-*.gz").each { |path| ParseApacheAccessLogJob.perform_later(path) }
```

And it took about an hour with 6 workers to chew through this data. I had to
tinker with the Regex a bit - here's what ended up working well:

```
/^(\S+):(\d+) (\S+) (\S+) (\S+) \[([^\]]+)\] "((?:[^"]|\\")*)" (\d+) (\d+) "((?:[^"]|\\")*)" "((?:[^"]|\\")*)"/
```

I can't imagine anyone will read that but who knows. To be honest I didn't write
that myself - I worked with Claude to come up with it. Did we get all the data?
Let's see:

```
> ApacheLogItem.count
=> 3586336
> ApacheLogItem.where(enhanced: false).count
=> 0
```

Hell yeah counts match and zero records failed to match the Regex.

## Remove Other Websites

With all the data loaded into Rails we can start whittling down to just the data
we want to work with. Let's start by removing other websites:

```
> other_website_items = ApacheLogItem.where.not(website: "www.jonallured.com")
> other_website_items.count
=> 2228247
> other_website_items.delete_all
> ApacheLogItem.count
=> 1358089
```

## Sending HTTP to HTTPS

The next thing I zeroed in on was a huge amount of items that were nothing more
than sending HTTP traffic over to the HTTPS port. In fact when I reviewed the
traffic on port 80 I decided it was all garbage - we don't need this stuff:

```
> port_80_items = ApacheLogItem.where(port: "80")
> port_80_items.count
=> 327511
> port_80_items.delete_all
> ApacheLogItem.count
=> 1030578
```

While we are on the topic of HTTPS, I noticed some traffic from Let's Encrypt
that matches [their docs][lets_encrypt_doc] on sending challenges so let's get
rid of that stuff:

[lets_encrypt_doc]: https://letsencrypt.org/docs/challenge-types/

```
> lets_encrypt_items = ApacheLogItem.where("request_user_agent ILIKE ?", "%letsencrypt%")
> lets_encrypt_items.count
=> 868
> lets_encrypt_items.delete_all
> ApacheLogItem.count
=> 1029710
```

## Not OK Responses

My goal is to find real traffic from all this noisy data and so I looked through
responses that were not 200 - OK and decided I didn't need them. Let's get rid
of the other status codes:

```
> other_status_items = ApacheLogItem.where.not(response_status: "200")
> other_status_items.count
=> 298275
> other_status_items.delete_all
> ApacheLogItem.count
=> 731435
```

## Not GET Requests

Similar to response status where I only want 200s, I really only want requests
that use the GET method. These are static sites and so any other type of request
is junk:

```
> other_method_items = ApacheLogItem.where.not(request_method: "GET")
> other_method_items.count
=> 3199
> other_method_items.delete_all
> ApacheLogItem.count
=> 728236
```

## Bot Traffic

I started poking at how I might isolate the Bot Traffic so I could remove it but
quickly found that this is pretty complex. After some trial and error I decided
that it was worth looking for a gem and found [browser][]. Let's pull that in
and then use it to find and delete bot traffic:

[browser]: https://github.com/fnando/browser

```
> bot_items = ApacheLogItem.all.select { |item| Browser.new(item.request_user_agent).bot? }
> bot_items.count
=> 326233
> ApacheLogItem.where(id: bot_items.map(&:id)).delete_all
> ApacheLogItem.count
=> 402003
```

## Requests With Params

Looking at the data in the `request_params` column showed a lot of probing for
security vulnerabilities but it can't all be junk right? I spent a bit of time
spot checking and was not able to find _any_ examples where the params seems
legit so I'm actually just going to remove all of it!

```
> items_with_params = ApacheLogItem.where.not(request_params: nil)
> items_with_params.count
=> 1199
> items_with_params.delete_all
> ApacheLogItem.count
=> 400804
```

## Normalizing Some Oddities

During some sampling of the data I noticed a couple oddities in the request path
data:

* paths that start with double slashes
* paths that include the website

I chatted with Claude about this and we decided it was weird but fine and we
could just normalize it:

```
> double_slash_items = ApacheLogItem.where("request_path ~ ?", "^\/\/")
> double_slash_items.count
=> 16
> double_slash_items.each { |item| item.update(request_path: item.request_path.sub("//", "/")) }

> bonus_website_items = ApacheLogItem.where("request_path ~ ?", "^http")
> bonus_website_items.count
=> 21
> bonus_website_items.each { |item| item.update(request_path: item.request_path.sub("https://www.jonallured.com", "")) }
```

## Apache Directory Listings

Unbeknownst to me I have been serving Apache Directory Listing pages this whole
time - looks like this:

{%
  include
  framed_image.html
  alt="Screenshot of Apache Directory Listing."
  src="/images/post-71/apache-directory-listing-screenshot.png"
%}

There is [an Apache doc page][options-doc] that has the fix: `Options -Indexes`
which can be added to my server config. With this in place this traffic will end
up in the 403 category.  I actually SSHed into my server, made this change, and
confirmed that it's not working anymore. That does not help me here though
because I still need to find this traffic and filter it out.

[options-doc]: https://httpd.apache.org/docs/2.4/mod/core.html#options

What I want to remove are requests like these:

```
GET /posts
GET /posts/
GET /posts/2025
GET /posts/2025/
GET /posts/2025/10
GET /posts/2025/10/
GET /posts/2025/10/25
GET /posts/2025/10/25/
...
```

But this also applies to any of the folders on the site. So let's start by
finding all the requests that have a trailing slash. Then add to that list each
of those paths but with the trailing slash removed. Finally I can use that list
to delete all the traffic to folders:

```
> folders_with_slash = ApacheLogItem.where("request_path ~ ?", ".\/$").pluck(:request_path).uniq
> folders_without_slash = folders_with_slash.map { |path| path[..-2] }
> folder_paths = folders_with_slash + folders_without_slash
> folder_items = ApacheLogItem.where(request_path: folder_paths)
> folder_items.count
=> 6944
> folder_items.delete_all
> ApacheLogItem.count
=> 393860
```

## Automated Traffic

The next type of traffic to remove are automated requests. RSS readers will
request `/atom.xml` on a schedule. The [Keybase service][keybase] will make a
regular request to fetch my website proof. And for whatever reason I _still_
have some traffic to `/robots.txt` even after removing as much of that traffic
as I could using the User Agent. Let's get rid of all of this:

[keybase]: https://keybase.io

```
> automated_paths = %w[/atom.xml /keybase.txt /robots.txt]
> automated_items = ApacheLogItem.where(request_path: automated_paths)
> automated_items.count
=> 283320
> automated_items.delete_all
> ApacheLogItem.count
=> 110540
```

## Curating What's Left

At this point I'm looking through what's left and mostly I like what I see.
Here's a query to get the current month's data:

```
> ApacheLogItem.where(requested_at: Time.now.all_month).group(:request_path).count
```

But I see some things I want to curate:

* collapse `/index.html` to just `/`
* remove requests for css files
* remove requests for images
* remove requests for pdfs

Which are pretty easy to do:

```
> index_items = ApacheLogItem.where(request_path: "/index.html")
> index_items.count
=> 46
> index_items.update_all(request_path: "/")

> asset_items = ApacheLogItem.where("request_path ~ ?", "(css|png|pdf)$")
> asset_items.count
=> 28286
> asset_items.delete_all
> ApacheLogItem.count
=> 82254
```

## Good Enough

Starting with 3,586,336 requests and working it down to 82,254 is pretty good so
I'm calling this data exploration done. What I'll look into now is taking this
local work and figuring out how I want to do this on my production Heroku
deployment. I'll want to add some UI on top of this so I can poke around even
more in case there are other ways to filter out junk traffic.

As a treat for making it all the way to the end of this very long-winded post
here's the top ten pages on my site for the full month of September 2025:

```
> september_stats = ApacheLogItem.where(requested_at: (Time.now - 1.month).all_month).group(:request_path).count
> september_data = september_stats.map(&:to_csv).join
> File.write("september_pageviews.csv", september_data)
```

| Request Path                                                            | Count |
| ----------------------------------------------------------------------- | ----- |
| [/][root]                                                               | 1,113 |
| [/rotten.html][rotten-page]                                             | 265   |
| [/posts/2024/09/10/decoding-jwt-tokens.html][post-65]                   | 115   |
| [/favorite-posts.html][fav-page]                                        | 101   |
| [/all-posts.html][all-page]                                             | 99    |
| [/podcasts.html][podcast-page]                                          | 97    |
| [/feeds-i-read.html][feeds-page]                                        | 91    |
| [/posts/2021/06/05/configure-prompt-on-ios-with-ssh-keys.html][post-58] | 89    |
| [/posts/2021/06/05/updated-digitalocean-server-setup.html][post-59]     | 77    |
| [/posts/2016/09/06/commit-lint-for-danger.html][post-38]                | 71    |

[root]: https://www.jonallured.com
[rotten-page]: https://www.jonallured.com/rotten.html
[post-65]: https://www.jonallured.com/posts/2024/09/10/decoding-jwt-tokens.html
[fav-page]: https://www.jonallured.com/favorite-posts.html
[all-page]: https://www.jonallured.com/all-posts.html
[podcast-page]: https://www.jonallured.com/podcasts.html
[feeds-page]: https://www.jonallured.com/feeds-i-read.html
[post-58]: https://www.jonallured.com/posts/2021/06/05/configure-prompt-on-ios-with-ssh-keys.html
[post-59]: https://www.jonallured.com/posts/2021/06/05/updated-digitalocean-server-setup.html
[post-38]: https://www.jonallured.com/posts/2016/09/06/commit-lint-for-danger.html

These numbers seem high to me - I bet there's more to filter out but that's
something for Future Jon to figure out.
