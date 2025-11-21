---
number: 65
tags: article
title: "Decoding JWT Tokens"
---

While doing some troubleshooting today at work it occurred to me that I could
very easily create a page that decodes JWT tokens so I did it.

## What I Used to Do

For years I've used [https://jwt.io](https://jwt.io) for this - they have a very
convenient decoder right on the homepage. The problem is that by definition I'm
pasting something sensitive into a website on the Internet. This is really not a
very good idea.

## Making My Own Decoder

I knew that I would use my [Rails app Monolithium][monolithium] for this so how
would I do it?

My first thought was to use a form. I could have a page with a `textarea` that
POSTed to the server and then I could decode on the server and render the
response. After thinking that approach through I abandoned it. One thing I
wanted to avoid was any traces of the actual tokens. If I used a form that
POSTed then I'd want to redirect to a GET and...what - persist the token between
requests? Write the token to the session? A cookie?

## Use an API Endpoint

At this point I thought that a much better approach would be to create a GET
endpoint on my server and have the page I create hit that for the decoded
results. That way everything is stateless and nothing would be persisted.

I sketched out an endpoint like this:

```ruby
GET /api/v1/decode_jwt?token=eyJhbGciOiJub25lIn0.eyJmb28iOiJiYXIifQ.
```

With a response that looks like this:

```json
{
  "headers": { "alg": "none" },
  "payload": { "foo": "bar" },
  "token": "eyJhbGciOiJub25lIn0.eyJmb28iOiJiYXIifQ."
}
```

I whipped up some request specs for the invalid case and then implemented this
very basic endpoint.

## Use Stimulus for The Page

Now it was time to implement the page and connect it to this endpoint. I wanted
to use [Stimulus][] so I could get some more experience with it. The HTML I
envisioned went something like this:

```html
<section>
  <textarea></textarea>
  <pre>
    <code></code>
  </pre>
</section>
```

The `section` would be connected to the Stimulus controller. The `textarea`
would be a target whose value would be the actual token and the `code` element
would be where I rendered the results.

The docs were super helpful and I was able to connect all the pieces pretty
quickly.

## Finished Product

The [PR I opened][PR] has all the details but honestly there's not much there.
This was pretty easy to do and looks like this:

{%
  include
  framed_image.html
  alt="Decode JWT form screenshot"
  caption="It drives me nuts that the token doesn't fit on one line."
  src="/images/post-65/decode-jwt-screenshot.png"
%}

I don't expect I'll do much more here but now I can paste in JWT tokens to
decode without any guilt that I'm possibly doing something that's not secure.

[monolithium]: https://github.com/jonallured/monolithium
[Stimulus]: https://stimulus.hotwired.dev
[PR]: https://github.com/jonallured/monolithium/pull/209
