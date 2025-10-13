# jonallured.com [![CI Badge][badge]][action_page]

This is the source of [jonallured.com][site].

[badge]: https://github.com/jonallured/jonallured.com/actions/workflows/main.yml/badge.svg
[action_page]: https://github.com/jonallured/jonallured.com/actions/workflows/main.yml
[site]: https://www.jonallured.com

## Workflow

First boot a server with `bin/start` and point your browser at
http://localhost:3090 to see the site.

From there we can create a new post like so:

```bash
# for just any random post:
$ bin/new_post "very good post"

# for a Week In Review post:
$ bin/wir_post
```

This will create the draft and move to a new branch for that post. From here
it's time to actually write the blog post. Once that is done and you're ready to
publish then run this:

```bash
$ bin/publish_post source/_drafts/very-good-post.md
```

That will finalize the post file including generating the social image. It will
create a commit and push to GitHub and even create the PR. When that PR is
merged then the deploy process starts and when that's done then the post is
live.

## Deploying Locally

I should always prefer to deploy from CI via the process of opening and merging
a PR but if it ever comes up then deploying locally should be as easy as:

```bash
$ bundle exec rake deploy
```

This assumes that the `.env` file has the correct `DEPLOY_TARGET` so just make
sure that is in place.

## Rake Tasks

In addition to automating the posing process, I have a few Rake tasks that
automate routine things:

### Fixing Rotten Links

In order to update a rotten link first find the link and then fix like this:

```bash
$ bundle exec rake 'fix_rot[http://www.example.com/path/to/page.html]'
```

That will add an entry to the data file for rotten links and spit out the
`replace` command to run. Once that's all done then you can create a commit and
push.

### Updating Feeds I Read

Data for the Feeds I Read page comes from a [Settings page in
Feedbin][feedbin_page]. Download that OPML file and then:

[feedbin_page]: https://feedbin.com/settings/import_export

```bash
$ mv ~/Downloads/subscriptions.xml ./
$ bundle exec rake update_feeds
$ rm subscriptions.xml
```

### Updating Podcasts page

Similar to above the way to update the list of Podcasts I listen to starts with
downloading an OPML file from the [Account page on Overcast.fm][overcast_page].
Once that's downloaded then do this:

[overcast_page]: https://overcast.fm/account

```bash
$ mv ~/Downloads/overcast.opml ./
$ bundle exec rake update_podcasts
$ rm overcast.opml
```
