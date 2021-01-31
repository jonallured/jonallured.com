# jonallured.com [![CircleCI][badge]][circleci]

This is the source of [jonallured.com][site].

[badge]: https://circleci.com/gh/jonallured/jonallured.com.svg?style=svg
[circleci]: https://circleci.com/gh/jonallured/jonallured.com
[site]: https://www.jonallured.com

## Handy Scripts

I've got a number of handy scripts in the `bin` folder, check it:

* `new_article` - this one wraps the middleman article "title" command with some
  goodies.
* `publish_article` - this one finds drafts and publishes them including
  creating the PR!
* `server` - this one just boots middleman for local dev work on 3090.
* `update` - this is my pretty standard dependency update script complete with
  automerge behavior.
