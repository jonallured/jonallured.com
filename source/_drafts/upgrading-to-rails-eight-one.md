---
number: 100
tags: article
title: "Upgrading to Rails 8.1"
---

I have been a slacker on upgrading my Rails app [Monolithium] to version 8.1 so
today I decided it was time. The process was very boring and basically just
worked but I still wrote up some notes here for posterity.

## Bump Ruby to Latest Patch

I started the process but bumping Ruby to the latest patch version:

```
$ asdf plugin update --all
$ asdf set ruby 4.0.2
$ asdf install
$ bundle install
$ bundle update --bundler
```

[link]: http://www.example.com
