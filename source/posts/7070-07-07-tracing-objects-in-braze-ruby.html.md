---
favorite: false
id: 66
title: "Tracing Objects in Braze Ruby"
---

The marketing team at [Artsy][] uses [Braze][] to send emails and a while ago I
took over the Ruby gem that wraps [their API][braze-api]. It's called
[braze_ruby][] or I also call it Braze Ruby because I'm not a robot and that's
more how people talk. I needed to add a few features so I did and then coworkers
also added some features. Then much time passed and I sorta forgot about the
gem.

The gem had existed for years before I ever got involved and my motivation for
working on it was mostly tied to what we needed it to do at work. I looked at
the code but didn't really make many substantial changes - most of my
contributions are actually more meta. Things like getting CI working or adding
[Standard Ruby][] or automating releases.

Recently, I got some notifications from GitHub that there was activity on the
project. I felt bad about ignoring the gem so I spent some time getting it back
into shape.

This week [a PR was opened][pr-66] that sent me down a rabbit hole and I wanted to
share what I found. The PR was very reasonable - the change was to allow Faraday
middleware to be passed into the gem. It was essentially a PR to improve the way
the gem is configured. But the PR caused me to follow up on some suspicions I
had about the design of the gem. Buckle up!

## Demo

Let's start with a quick demo of how you might use the gem:

```
api = BrazeRuby::API.new(api_key, api_url)
api.email_status
```

Like many gems that wrap REST APIs this gem uses a client instance that takes
credentials and provides methods that map to API endpoints. This demo is using a
method called `email_status` that ends up calling the [Change Email Status][]
endpoint at Braze. Any arguments to the method are converted into a payload that
works for the endpoint.

A slightly more complex usage might separate the configuration from generating
the client. In a lot of Rails apps the config happens in the
`config/initializers` folder. That might look more like this:

```
# config/initializers/braze_ruby.rb

BrazeRuby.configure do |config|
  config.rest_api_key = "valid-key-here"
  config.rest_url = "some-url-here"
  config.options = { retry: true }
end

# app/jobs/unsubscribe_user_job.rb

class UnsubscribeUserJob < ApplicationJob
  def perform(user_id)
    user = User.find(user_id)
    api = BrazeRuby::API.new
    api.email_status(email: user.email, subscription_state: :unsubscribed)
  end
end
```

In this demo we have an initialize block that gets things ready during the
booting of the application and then later in a background job a client is
created and that's where the API call happens.

Back to the gem design - client methods map to API endpoints and format their
arguments into payloads that are fired off. They return responses that the
caller can use to access data from Braze.

## My Suspicion

What I suspected was that the gem was making more instances of classes than it
needed to. I saw a trio of data that seemed to be all over the place and that
triggered my Spidey-sense. Here's a few class signatures for your consideration:

```
# lib/braze_ruby/api.rb

module BrazeRuby
  class API
    def initialize(api_key = nil, braze_url = nil, options = nil)
      # ...
    end
  end
end

# lib/braze_ruby/configuration.rb

module BrazeRuby
  class Configuration
    def initialize
      @rest_api_key = nil
      @rest_url = nil
      @options = nil
    end
  end
end

# lib/braze_ruby/http.rb

module BrazeRuby
  class HTTP
    def initialize(api_key, braze_url, options = {})
      # ...
    end
  end
end

# lib/braze_ruby/rest/base.rb

module BrazeRuby
  module REST
    class Base
      def initialize(api_key, braze_url, options)
        # ...
      end
    end
  end
end
```

Links to the full files for the curious:

* [lib/braze_ruby/api.rb](https://github.com/jonallured/braze_ruby/blob/d01d58a9433596157a6974479cfd3b88a2c9cded/lib/braze_ruby/api.rb)
* [lib/braze_ruby/configuration.rb](https://github.com/jonallured/braze_ruby/blob/d01d58a9433596157a6974479cfd3b88a2c9cded/lib/braze_ruby/configuration.rb)
* [lib/braze_ruby/http.rb](https://github.com/jonallured/braze_ruby/blob/d01d58a9433596157a6974479cfd3b88a2c9cded/lib/braze_ruby/http.rb)
* [lib/braze_ruby/rest/base.rb](https://github.com/jonallured/braze_ruby/blob/d01d58a9433596157a6974479cfd3b88a2c9cded/lib/braze_ruby/rest/base.rb)

Notice any patterns? Are you seeing anything that seems repetitive? How is your
Spidey-sense doing - do you feel an overwhelming desire to refactor??

These were the feelings I was having but I wanted some data. I wanted to pursue
some investigation that might demonstrate the ways the design of the gem leads
to inefficiencies. Rather than diving into a refactor, I took some time to trace
how the gem worked.

## Getting Setup to Trace

I knew that Ruby had ways of tracing objects but to be honest I had never really
used these types of tools. A quick search lead me to [a blog post][cb-post] that
ran through how to use a Ruby gem called [AllocationStats][].

I learned that I could setup tracing and then execute some code and print out
which and how many objects were being made as the gem was being used. This
pattern looks something like this:

```
stats = AllocationStats.new

stats.trace
api = BrazeRuby::API.new(api_key, api_url)
api.email_status
stats.stop

puts stats.allocations.to_text
```

Start by making an instance of an `AllocationStats` and then wrap the code you
want to observe with calls to `trace/stop`. Then in order to get the data out
you can call `allocations` and `to_text`. Got it - let's put this newfound
knowledge to work on this suspicion I have.

## Tracing Examples

I created [a branch][branch] where I could experiment with these ideas. I made
an `examples` folder and then wrote a bunch of files to demonstrate this
tracing. Let's look at [the first example][e-1] called
`all_allocations_to_text.rb` which just dumps out all the object allocations:

```
$ ruby examples/all_allocations_to_text.rb
# ... LOL SO MUCH TEXT!!
```

If you do this you will see an enormous amount of information. Like way too much
information. If you write that output to a file it's over 14MB.

Next up in [the second example][e-2] called `all_allocations_count_only.rb` I
just counted the allocations and printed that out:

```
$ ruby examples/all_allocations_count_only.rb
69618
```

Yes that's right the two lines of code that create the client class and make a
single API call generate nearly 70 thousand objects! I poked around at the
output and found the object allocations that were for `BrazeRuby` but it was a
real pain. After much trial and error I ended up creating [a little class][ot]
called `ObjectTracker`. It takes a regex pattern (or a string is fine) and only
keeps track of the object allocations whose class name matches that pattern. It
also prints out those matching objects. I used that in [the third example][e-3]
called `filtered_allocations_one_call.rb` and that really helped:

```
$ ruby examples/filtered_allocations_one_call.rb
BrazeRuby::Configuration
BrazeRuby::API
BrazeRuby::HTTP
BrazeRuby::REST::EmailStatus
4
```

Success! This output shows me that 4 `BrazeRuby` classes were created for those
two simple lines of code. Is my Spidey-sense correct? Are we making more objects
than we need to?

## More API Calls

Let's add more API calls to [the fourth example][e-4] called
`filtered_allocations_four_calls.rb` like this:

```
# ...
api.email_status
api.create_catalogs
api.subscription_status_get
api.trigger_campaign_send
# ...
```

When we run it we get this:

```
$ ruby examples/filtered_allocations_four_calls.rb
BrazeRuby::Configuration
BrazeRuby::API
BrazeRuby::HTTP
BrazeRuby::REST::EmailStatus
BrazeRuby::HTTP
BrazeRuby::REST::CreateCatalogs
BrazeRuby::HTTP
BrazeRuby::REST::SubscriptionStatusGet
BrazeRuby::HTTP
BrazeRuby::REST::TriggerCampaignSend
10
```

Huh, 10 objects this time. We started with 4 and then added 3 API calls and that
caused 6 new objects? That's not what I expected - what I expected was more like
this:

* 3 objects for creating the client and sending api calls
  * `BrazeRuby::Configuration`
  * `BrazeRuby::API`
  * `BrazeRuby::HTTP`
* 1 object per api call
  * `BrazeRuby::REST::Base` subclasses

So given this metal model I was expecting 7 objects. Spoiler: this mental model
is wrong. Let's dig into what these objects actually do.

## What Do These Objects Do?

At this point we should talk about what these objects do. Here's a rough
breakdown:

* `BrazeRuby::Configuration` => holds onto "global" config settings
* `BrazeRuby::API` => the actual client class with all the methods to send API
  calls to Braze
* `BrazeRuby::HTTP` => creates and caches a Faraday connection plus also has
  methods for sending requests
* `BrazeRuby::REST::Base` => base class that takes config from the client class
  and creates the http class

And if we return to our first simple example:

```
# this line:
api = BrazeRuby::API.new(api_key, api_url)

# makes these classes:
BrazeRuby::Configuration
BrazeRuby::API

# and then this line:
api.email_status

# makes these classes:
BrazeRuby::HTTP
BrazeRuby::REST::EmailStatus
```

We can begin to follow along with how these objects are being created. The line
that creates the `api` variable instantiates the `BrazeRuby::API` class but
that's not the first object that's allocated. That's because during the init of
`BrazeRuby::API` we create a `BrazeRuby::Configuration` instance.

The line with the `email_status` call creates instances of the `BrazeRuby::HTTP`
and `BrazeRuby::REST::EmailStatus` classes. That last class is a subclass of
`BrazeRuby::REST::Base`. The fact that these two are in this order surprises me
because I expected them in the reverse order. I did a little poking around and I
couldn't really figure it out. It's a bit of a mystery to me but I have to stay
focused or I'll never finish this blog post.

## Back To Four API Calls

Walking through the objects that are created with just 1 API call is good but
let's go back to see again the list of objects that were created with 4 API
calls:

```
# this line:
api = BrazeRuby::API.new(api_key, api_url)

# makes these classes:
BrazeRuby::Configuration
BrazeRuby::API

# and then these lines:
api.email_status
api.create_catalogs
api.subscription_status_get
api.trigger_campaign_send

# make these classes:
BrazeRuby::HTTP
BrazeRuby::REST::EmailStatus
BrazeRuby::HTTP
BrazeRuby::REST::CreateCatalogs
BrazeRuby::HTTP
BrazeRuby::REST::SubscriptionStatusGet
BrazeRuby::HTTP
BrazeRuby::REST::TriggerCampaignSend
```

Here's where I smile with satisfaction. This pattern of creating a
`BrazeRuby::HTTP` object and then creating a `BrazeRuby::REST::Base` object is
the proof that we are indeed creating more objects than we really should be. We
could debate the usefulness of the objects that inherit from
`BrazeRuby::REST::Base` but there's simply no need to keep creating these
`BrazeRuby::HTTP` objects. There's literally no differences between these
instances - there can't be!

## Caching Faraday Connections

The goal of the `BrazeRuby::HTTP` class is to take arguments that are used to
create a Faraday connection and then cache that connection. Then each time the
gem is used to send an API call to Braze the connection should be used. The fact
that 4 API calls result in 3 of these `BrazeRuby::HTTP` instances point to a
problem. How does this happen?

The way we create these `BrazeRuby::HTTP` instances is via a private method on
the `BrazeRuby::REST::Base` parent class. That means that each instance that
inherits from this class will have it's own `BrazeRuby::HTTP` instance and thus
it's own Faraday connection instance.

But why do we have all these instances? We saw earlier that four different
classes in the Braze Ruby gem all seem to keep track of a trio of data: api key,
api url and some options. A better design would encapsulate this trio, create
the connection once and use it for the life of the client. Instead of putting
this trio at the center of the gem, I would argue that putting the connection at
the center of the gem would vastly improve the design.

I would also argue that little is gained from wrapping the Faraday connection
with the `BrazeRuby::HTTP` instance nor do the subclasses of
`BrazeRuby::REST::Base` offer us much. I think there's a way to make this gem
way more simple.

[Artsy]: https://artsy.github.io
[Braze]: https://www.braze.com
[braze-api]: https://www.braze.com/docs/api/home
[braze_ruby]: https://github.com/jonallured/braze_ruby
[Standard Ruby]: https://github.com/standardrb/standard
[pr-66]: https://github.com/jonallured/braze_ruby/pull/66
[Change Email Status]: https://www.braze.com/docs/api/endpoints/email/post_email_subscription_status
[cb-post]: https://www.cloudbees.com/blog/tracking-object-allocations-in-ruby
[AllocationStats]: https://github.com/srawlins/allocation_stats
[branch]: https://github.com/jonallured/braze_ruby/tree/trace-braze-ruby-objects
[e-1]: https://github.com/jonallured/braze_ruby/blob/trace-braze-ruby-objects/examples/all_allocations_to_text.rb
[e-2]: https://github.com/jonallured/braze_ruby/blob/trace-braze-ruby-objects/examples/all_allocations_count_only.rb
[ot]: https://github.com/jonallured/braze_ruby/blob/trace-braze-ruby-objects/examples/object_tracker.rb
[e-3]: https://github.com/jonallured/braze_ruby/blob/trace-braze-ruby-objects/examples/filtered_allocations_one_call.rb
[e-4]: https://github.com/jonallured/braze_ruby/blob/trace-braze-ruby-objects/examples/filtered_allocations_four_calls.rb
