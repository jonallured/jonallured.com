---
favorite: false
number: 33
title: "Grimm on Recursion in Ruby"
---

Avdi Grimm had a post on the Code Benders site about [preventing recursion in
Ruby][avdi_post]. He starts by reviewing what recursion is and a typical
approach to dealing with it. Grimm has come up with a module that he's been
using to wrap a method with a Thread-level flag to know whether its been called
already.

He uses [`Module#instance_method`][doc1] in his module and that got me to
reading about the [`UnboundMethod`][doc2] class, which was interesting. You can
use `#instance_method` to create a new `UnboundMethod` instance and then
associate it with another object with its `bind` method.

Then the next thing that I wasn't very familiar with was the [`Thread`][doc3]
stuff. Looks like you can use `#[]` and `#[]=` as get/set on the thread and
return (or set) the values of any thread-local variables.

[avdi_post]: http://www.codebenders.com/code/preventing-recursion-in-ruby
[doc1]: http://ruby-doc.org/core-1.9.3/Module.html#method-i-instance_method
[doc2]: http://ruby-doc.org/core-1.9.3/UnboundMethod.html
[doc3]: http://ruby-doc.org/core-1.9.3/Thread.html
