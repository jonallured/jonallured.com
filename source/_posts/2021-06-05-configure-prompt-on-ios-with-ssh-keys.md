---
number: 58
tags: article
title: "Configure Prompt on iOS With SSH Keys"
---

I got a fancy new iPad recently and bought a copy of [Prompt][] so that I could
SSH into my servers from the comfort of my couch. The process turned out to be
more tricky than I expected so here's my notes on how I did it.

## Generate the Keys

The first step was to generate the keys, I did this like so:

```
$ ssh-keygen -m PEM -t rsa -C "prompt@cypher" -f keys/prompt/cypher
```

## Add Public Key to Server

This won't work if you don't add the newly generated public key to the server so
let's do that next:

```
$ ssh-copy-id -i keys/prompt/cypher.pub domino -f
```

## Add Private Key to Prompt

This is the part that caused me some trouble. There's an interface in the Prompt
app to add keys by picking a file from your iCloud Drive but it didn't behave as
I expected. I had the keys there but they were greyed out and I couldn't pick
them.

{%
  include
  framed_image.html
  alt="SSH keys picker screenshot"
  caption="It would be nice if there were a little help here."
  src="/images/post-58/prompt-import-wtf.png"
%}

What I figured out was that they needed a file extension in order to work:

```
$ cp keys/prompt/cypher ~/Desktop/cypher-private.txt
```

Then I could find and pick that file as the key in Prompt and it would add it to
the list of known keys. Next was finishing the server settings in Prompt and
saving them so that it could be one-tap to connect. Behold:

{%
  include
  framed_image.html
  alt="SSH session screenshot"
  caption="Any bets on how often I actually use this??"
  src="/images/post-58/prompt-connected-to-domino.png"
%}

[Prompt]: https://panic.com/prompt/
