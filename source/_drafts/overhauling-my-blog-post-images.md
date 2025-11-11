---
number: 81
tags: article
title: "Overhauling My Blog Post Images"
---

There were a few opportunities for taking a closer look and improving how I
handle images on my blog post so I spent some time overhauling things. I wanted
to reduce some duplication, have another look at more semantic markup options
and look into serving responsive image files. I also had a hunch that I could
write a helper script to make it easier to do these things.

## Extracting a Jekyll Include For Images

The first thing that I wanted to do was to extract a [Jekyll
Include][include-doc] file that would reduce the spread of image markup
throughout my blog posts. What I had been doing was copy/pasting image markup
from blog post to blog post. This was fine but since I wanted to make some
changes I knew it was time for an abstraction.

[include-doc]: https://jekyllrb.com/docs/includes/

Over on [Evaluating Apache Access Log Data][post-71] I had this markup:

[post-71]: https://www.jonallured.com/posts/2025/10/29/evaluating-apache-access-log-data.html

```
<div class="imageWrapper">
  <a href="/images/post-71/apache-directory-listing-screenshot.png">
    <img alt="Apache Directory Listing Screenshot" src="/images/post-71/apache-directory-listing-screenshot.png" width="700" />
  </a>
  <p><em>click for bigger</em></p>
</div>
```

Taking that structure and abstracting it looked like this:

```
<div class="imageWrapper">
  <a href="{{ include.src }}">
    <img alt="{{ include.alt }}" src="{{ include.src }}" width="700" />
  </a>
  <p><em>click for bigger</em></p>
</div>
```

Which means I can simplify the blog post file and insert the image into the blog
post much more easily:


{% raw %}
```
{%
  include
  wrapped_image.html
  alt="Screenshot of Apache Directory Listing."
  src="/images/post-71/apache-directory-listing-screenshot.png"
%}
```
{% endraw %}

I really like this because now in the actual blog post I'm thinking about how
the alt text reads and the link to the image and not all the boring details of
getting the markup correct.

## Use More Semantic Markup

If you checked out that Jekyll Include doc page then you might have noticed that
one of the examples they use is actually this very use-case - extracting an
include for images. In the include markup they used 2 elements that caught my
eye: `figure` and `figcaption`.

I looked up more info on MDN and found that their HTML images guide had [a
section for using these elements][fig-doc]. At this point it was easy to make a
change - simply update that include markup and it would update all the blog
posts with images. Here's what that include looks like with better markup:

[fig-doc]: https://developer.mozilla.org/en-US/docs/Learn_web_development/Core/Structuring_content/HTML_images#annotating_images_with_figures_and_figure_captions

```
<figure>
  <a href="{{ include.src }}">
    <img alt="{{ include.alt }}" src="{{ include.src }}" width="700" />
  </a>
  <figcaption>click for bigger</figcaption>
</figure>
```

I had to make some minor CSS changes but that was trivial but yeah then I
noticed another thing I wanted to improve. The caption saying "click for bigger"
is kinda lame. What I was really trying to do here was indicate that clicking on
the image would get you a bigger version. But a caption should really be
commenting on the image not a lame callout like this. A better way here is to
use `title` for the nudge to click for bigger and correctly populate the caption
with a meaningful sentence.

```
<figure>
  <a href="{{ include.src }}">
    <img alt="{{ include.alt }}" src="{{ include.src }}" title="click for bigger" width="700" />
  </a>
  <figcaption>{{ include.caption }}</figcaption>
</figure>
```

Which then means I can populate the caption over in the blog post file:

{% raw %}
```
{%
  include
  wrapped_image.html
  alt="Screenshot of Apache directory listing page"
  caption="Can you believe how awesome this page looks??"
  src="/images/post-71/apache-directory-listing-screenshot.png"
%}
```
{% endraw %}

That's nicer and again is putting the focus on the content rather than the
markup or structure of the image elements.
