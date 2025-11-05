---
number: 14
tags: article
title: "Rails 4.0 Will Drop Ruby 1.8.7; Croak Evaluates Decorators"
---

Rails will stop supporting Ruby 1.8.7 with [the 4.0 series][rails_post]. DHH
notes, however, that they intend to keep to a 2-year release cycle, thus don't
look for 4.0 any time soon.

---

I watched Jeff Casimir's [talk on Decorators][talk], then read about them a
couple more times, but I really enjoyed Dan Croak's [evaluation on the
topic][decorator_post].

He does a roundup of the four different types of Decorator implementations and
that was helpful for getting a clearer idea of what exactly we're talking about
when we refer to the "Decorator Pattern".

I also loved the places where Dan shares how he's thinking about this area of
Rails. In his conclusion he goes as far as outlining his plan for when to use
which types of Decorators. He also notes other questions he's still struggling
with, like if we're going to embrace Decorators, is there a use-case for classic
Rails view helpers anymore?

[rails_post]: http://weblog.rubyonrails.org/2011/12/20/rails-master-is-now-4-0-0-beta
[talk]: http://vimeo.com/27361482
[decorator_post]: http://robots.thoughtbot.com/post/14825364877/evaluating-alternative-decorator-implementations-in
