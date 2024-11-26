---
favorite: false
number: 1
title: Finding the Mouse Position When an Event Fires
---

We recently had a project where we needed to find out where the mouse was (its
coordinates) when an event fired (hover). I wanted to create a little [example
page](/rotten.html#1) that I could play around with to see how this worked.

The markup is really simple and just creates four divs in red - on `over` their
background color is changed to green and then its changed back on `out`. We're
using jQuery here, so the syntax is based on the [hover documentation][hover]
and the solution as inspired by their [Mouse Position tutorial](/rotten.html#2).

The magic is really just the bit where you define the hover functions and then
the `pageX` and `pageY` attributes of `e`:

```javascript
$('div.block').hover(
  function (e) {
    ...
    var msg = 'ON! x=' + e.pageX + ', y=' + e.pageY;
    ...
  },
  function (e) {
    ...
    var msg = 'OFF! x=' + e.pageX + ', y=' + e.pageY;
    ...
  }
);
```

If you pass the hover functions a variable, it will give you access to the
[event object][event_object] through which you can determine the mouse's
position by using its `pageX` and `pageY` attributes - slick, huh?

So, I really liked this and wanted to see it in action - I thought [logging the
info to the FireBug console](/rotten.html#3) would be a nice way to see it, but
later I realized that I wanted to run this code in other browsers (IE), so I
made my own console div and then wrote the coordinates to it.

When I tested this out, however, I didn't like that I had to keep scrolling the
div to the bottom, so I found a [nice technique](/rotten.html#4) to keep it at
the bottom:

```javascript
function (e) {
  ...
  var consoleDiv = document.getElementById('console');
  consoleDiv.scrollTop = consoleDiv.scrollHeight;
}
```

The `div` element's `scrollTop` is set to its `scrollHeight` so that it will
remain scrolled to the bottom as its size grows. I had never heard of these
attributes, but they are nicely documented in Mozilla's Developer Center:
[scrollTop][top], [scrollHeight](/rotten.html#5).

[hover]: http://docs.jquery.com/Events/hover
[event_object]: http://docs.jquery.com/Events/jQuery.Event
[top]: https://developer.mozilla.org/en/DOM/element.scrollTop
