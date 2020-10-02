---
favorite: false
id: 23
title: Helms on Imprecise Floats; Carroll on Services
---

I've heard about Floating point numbers being flaky and I knew there was a
perfectly logical reason for it, but I've never really groked it until reading
[Clemens Helms' write up](/rotten.html#22) on the topic. I really like how he
articulates this concept: Float numbers are a binary format, implemented right
on the processor of your computer, this is why they're so fast. When you use
this format with a decimal number, its going to be converted from base 10 to
base 2. This conversion can produce imprecise numbers in the same way that some
decimal numbers aren't precise.

And by precise numbers I'm talking about the difference between 1/3 and .3333 -
the former is a number that can't precisely be represented as a decimal, its an
infinitely repeating series of the number three, but we usually just round it to
some number of them, say four. So, to understand why Float isn't always precise,
you just have to remember that when some decimal numbers are converted to Float,
they result in an imprecise binary number that's going to get rounded.

Helm then goes on to give us a couple ideas about what to do when you need
precision, one way is to pick a delta you can live with and another is to use
[`BigDecimal`][big_decimal], another number format in Ruby's standard lib. I
took a look at BigDecimal and in the documentation there's a really easy way to
see how Float can break:

```ruby
(1.2 - 1.0) == 0.2 # => false
```

But this would return true if BigDecimal was used instead of Float.

---

[Jared Carroll explores][service_layer] services and a service layer in Rails.
He concludes that services can be helpful, but service layers are really only
necessary when you need to support clients other than HTTP. I had never heard
about these things, so I found the topic interesting, he starts out by reviewing
what he means by a service:

> \[A\] service is an action, not a thing. And instead of forcing the operation
> into an existing object, we should encapsulate it in a separate, stateless
> service.

There are three kinds of services, taken from what Eric Evans says in
[Domain-Driven Design](/rotten.html#21):

* Application Service: A service that provides non-infrastructure related
  operations that wouldn’t come up when discussing the domain model outside the
  context of software, i.e., in its natural environment.
* Domain Service: A domain service scripts a use-case involving multiple domain
  objects. Forcing this logic into a domain object is awkward because these
  use-cases often involve rules outside the responsibility of any single object.
* Infrastructure Service: An infrastructure service encapsulates access to an
  external system. Infrastructure services are often used by application and
  domain services.

Application Services are things like a report being generated - this code would
be properly extracted to a service object and I've just this. I always wondered
if there was a idiomatic way of doing this, what I've done is just call the
object something like "Exporter" or "Reporter" and then hang methods off of that
object that corresponded to the different exports or reports.

The Domain Service stood out to me as something that I've grappled with quite a
bit in my own work. There are those times when what you're working on involves
different objects and the action doesn't belong to any of these individual
objects. At times I've just picked one and stuck the stuff there anyway, but
more recently I've been creating a new object to deal with them and I guess
those were services.

The two examples Carroll gives for the Infrastructure Service are emailing and
message queueing, so had me thinking about [ActionMailer][action_mailer] and
[Delayed Job][dj]. This pattern type seems closest to a service layer, which is
where we go next:

> \[A\] service layer as an application's boundary and set of available
> operations from the perspective of interfacing client layers. In other words,
> it's your application's API.

Carroll points to HTTP and JSON as the standard ways of communicating and feels
that unless you need some other method of communication, you really don't need a
service layer. I know I was having a hard time thinking of a case where you'd
need another method, so I'm just going to believe him.

[big_decimal]: http://www.ruby-doc.org/stdlib-1.9.3/libdoc/bigdecimal/rdoc/BigDecimal.html
[service_layer]: http://blog.carbonfive.com/2012/01/10/does-my-rails-app-need-a-service-layer/
[action_mailer]: http://guides.rubyonrails.org/action_mailer_basics.html
[dj]: https://github.com/collectiveidea/delayed_job
