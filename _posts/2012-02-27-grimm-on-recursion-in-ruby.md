---
layout: post
title: Grimm on Recursion in Ruby
published_at: Monday, February 27, 2012
---

Avdi Grimm had a post on the Code Benders site about [preventing recursion in Ruby](http://www.codebenders.com/code/preventing-recursion-in-ruby/). He starts by reviewing what recursion is and a typical approach to dealing with it. Grimm has come up with a module that he's been using to wrap a method with a Thread-level flag to know whether its been called already.

He uses [`Module#instance_method`](http://ruby-doc.org/core-1.9.3/Module.html#method-i-instance_method) in his module and that got me to reading about the [`UnboundMethod`](http://ruby-doc.org/core-1.9.3/UnboundMethod.html) class, which was interesting. You can use `#instance_method` to create a new `UnboundMethod` instance and then associate it with another object with its `bind` method.

Then the next thing that I wasn't very familiar with was the [`Thread`](http://ruby-doc.org/core-1.9.3/Thread.html) stuff. Looks like you can use `#[]` and `#[]=` as get/set on the thread and return (or set) the values of any thread-local variables.