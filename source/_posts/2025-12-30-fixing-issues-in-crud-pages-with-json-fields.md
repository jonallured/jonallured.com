---
date: 2025-12-30 12:03 -0600
number: 86
tags: article
title: "Fixing Issues in CRUD Pages With JSON Fields"
---

I have a section of my Rails app that is an admin interface to perform CRUD
actions on various models. They are fairly standard pages and honestly don't get
a ton of use. Recently I was poking around and happened to discover some issues
in these pages when the model had a JSON field.

Fixing these issues was kinda interesting - here's [the PR][pr] where I did it.
Have a look and I'm also sharing some notes here.

## Reproduce The Problem

Let's pick a model with JSON fields and demonstrate the issue. I made a Post Bin
on my Rails app and appropriately I have a `PostBinRequest` model. It takes the
body, headers and params of an authenticated request and stores them in the
database for me to look at. The body is just a string but the headers and params
are stored as `jsonb`.

To reproduce the issue we can create a `PostBinRequest` record with some dummy
data and then view it. Here's how that looks before the fixes:

{%
  include
  framed_image.html
  alt="Admin page showing rendering problem"
  caption="I expected those JSON fields to render with newlines and why are the quotes being escaped like that?"
  loading="eager"
  slug="show-page-before"
%}

These JSON fields are rendered inside a `pre` HTML tag. I use
`JSON.pretty_generate` to populate the tag with nicely formatted blobs of JSON.
This doesn't look right. Don't I have a system test for this?

## The Bad Green

There were indeed system tests for this and they were false positives. They made
2 mistakes:

* populating the JSON fields with a string instead of actual JSON
* using whitespace normalized Capybara nodes

Here's a simplified version of the test:

```
describe "Admin views post bin request" do
  scenario "viewing a record" do
    post_bin_request = FactoryBot.create(
      :post_bin_request,
      headers: {"param-name" => "param-value"}.to_json
    )

    visit "/crud/post_bin_requests/#{post_bin_request.id}"

    headers_pre_tag = page.all("pre").first
    expect(headers_pre_tag.text).to eq(
      JSON.pretty_generate(post_bin_request.headers)
    )
  end
end
```

I'm not sure what I was thinking with that `to_json` call when setting the
`headers` value on the `PostBinRequest` record. What that does is set the
attribute to a string. Then below where I'm doing my expectation I'm finding the
`pre` tag and just calling `text` on it but that is whitespace normalized!

Normalizing whitespace makes total sense for system tests because it is
generally not significant in HTML. One exception is the `pre` tag - significant
whitespace is kinda the whole point! Here's what that test should have looked
like:

```
describe "Admin views post bin request" do
  scenario "viewing a record" do
    post_bin_request = FactoryBot.create(
      :post_bin_request,
      headers: {"param-name" => "param-value"}
    )

    visit "/crud/post_bin_requests/#{post_bin_request.id}"

    headers_pre_tag = page.all("pre").first
    expect(headers_pre_tag.native.text).to eq(
      JSON.pretty_generate(post_bin_request.headers)
    )
  end
end
```

Now `headers` is correctly being set to JSON data and by calling `native` on the
default Capybara node we will get all the newline characters. We fixed the bad
green and now this test makes sense. It doesn't really solve the problem that we
reproduced - let's get at that another way.

## Parsing JSON Params

When I used the CRUD section to edit an existing `PostBinRequest` record I
noticed I was able to take the JSON data and "corrupt" it. I saw it go from JSON
data to a string. After some pondering it clicked - the controller was passing
the param as a string right to the model. What I needed to do was take the raw
string coming from the params and parse it as JSON so that it would be saved
correctly.

I am a devout [Decent Exposure][de_gem] user so for this case what I needed to
do was look at the private `post_bin_request_params` method and see how I might
change it to do this parsing. Here's a simplified version of what I found:

```
class Crud::PostBinRequestsController < ApplicationController
  expose(:post_bin_request)

  private

  def post_bin_request_params
    params.require(:post_bin_request).permit(PostBinRequest.permitted_params)
  end
end
```

Decent Exposure will create or update records by calling this params method so
this is where we need to make our change. What we want to do is pull out the
`headers` and `params` and parse them before returning. Here's what that might
look like:

```
class Crud::PostBinRequestsController < ApplicationController
  expose(:post_bin_request)

  private

  def post_bin_request_params
    permitted_params = params.require(:post_bin_request).permit(PostBinRequest.permitted_params)

    {
      body: permitted_params[:body],
      headers: JSON.parse(permitted_params[:headers]),
      params: JSON.parse(permitted_params[:params])
    }
  end
end
```

But there's a flaw here that tests caught - when you pass empty string to
`JSON.parse` it will raise `JSON::ParserError`. What I actually want is either
the parsed JSON or nil. The easiest way to do this is to rescue but the way this
params method works it's kinda annoying. I could extract a separate method to do
the parsing and rescuing but it's not really this controller's job and I knew I
would need it in another controller too.

## Extracting MaybeJson

Over the years I have made a method that either parses JSON or returns nil many
times but I never thought to extract a module for it. I had the idea to do that
here and to call it `MaybeJson`. It is very simple:

```
module MaybeJson
  def self.parse(source, opts = nil)
    JSON.parse(source.to_s, opts)
  rescue JSON::ParserError
    nil
  end
end
```

There are 2 things that `MaybeJson` adds to JSON parsing:

1. call `to_s` on whatever comes in as `source`
2. rescue `JSON::ParserError` and return nil

That's it! With this available to me I went back to the controller and swapped
out `JSON.parse` for `MaybeJson.parse` and was back to green.

## Populating Textareas With JSON

One more thing before I wrap this up - I had another mistake in the way I was
populating the value of the `textarea` tags on the edit page. I had just been
using the default Rails helper tags so that might look something like this:

```
= form_with model: [:crud, post_bin_request] do |form|
  = form.text_area :headers, placeholder: "headers"
  = form.text_area :params, placeholder: "params"
  = form.text_area :body, placeholder: "body"
  = form.button "update"
```

But that's not quite right! What this does is populate the value of those
`textarea` tags with `post_bin_request.headers.to_s` which is a Ruby Hash rather
than JSON. Here's what that looks like before fixing:

{%
  include
  framed_image.html
  alt="Admin page showing editing problem"
  caption="Wait those are Ruby hashes not JSON!"
  slug="edit-page-before"
%}

We can fix this by providing the `value` ourselves:

```
= form_with model: [:crud, post_bin_request] do |form|
  = form.text_area :headers, placeholder: "headers", value: post_bin_request.headers.to_json
  = form.text_area :params, placeholder: "params", value: post_bin_request.params.to_json
  = form.text_area :body, placeholder: "body"
  = form.button "update"
```

Now when we edit these values and submit the form we are sending the correct
type of data.

## Conclusion

My main takeaways from this experience were:

* JSON fields will happily accept a string - weird huh?
* Extracting MaybeJson was fun - maybe turn it into a gem for a little more fun?
* Don't forget about the `native` method in Capybara to drop down to a lower
  abstraction level.

I hope you liked riding along with this PR - I'll try doing more of these types
of write ups in the future.

[de_gem]: https://github.com/hashrocket/decent_exposure
[pr]: https://github.com/jonallured/monolithium/pull/261
