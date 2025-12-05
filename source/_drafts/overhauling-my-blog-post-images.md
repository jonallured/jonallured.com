---
number: 83
tags: article
title: "Overhauling My Blog Post Images"
---

While working on [migrating this website back to Jekyll][post-67], I noticed a
few opportunities to improve how I handled images. Instead of adding to that
already huge migration task, I just let it go. Out of scope for now - I'll get
to it eventually, I told myself.

Then I recently wanted to take a picture and add it to a post I was working on.
As soon as that happened and I started looking a bit closer at image-related
things, I started falling down a rabbit hole. I was supposed to finish that post
but damn there _were_ a lot of ways I could improve the images on my blog posts.
Nerd sniped!

## Starting State

What I had been doing was copy/pasting a hunk of markup between blog post files.
It worked but was not something that would be easy to change and improve upon.
When code is duplicated then refactoring is more expensive.

In terms of the markup I was using, it was not terrible. What I was doing was
wrapping a `div` around an `a` and `p` then inside the `a` was the `img`. The
idea was to run the image with a caption and if you clicked you'd see the full
image. The wrapper added a light gray background to match my code blocks.

The image sizes were very inconsistent. I had taken screenshots over the years
with not much of a strategy about what I was doing. Some of them had drop
shadows from macOS and others did not. Some took up the entire container and
some were smaller. I _did_ provide alt text for them so that was nice but yeah
lots to improve!

Since we are discussing the starting state I should probably also mention that I
had a bug - when the browser was narrow then the images would bust out of their
container. So when I looked at a blog post on my phone then I would see the
image cut off.

I'm going to use [Evaluating Apache Access Log Data][post-71] as my example in
this post so here is the starting image code:

```
# source/_posts/2025-10-29-evaluating-apache-access-log-data.md

<div class="imageWrapper">
  <a href="/images/post-71/apache-directory-listing-screenshot.png">
    <img
      alt="Apache Directory Listing Screenshot"
      src="/images/post-71/apache-directory-listing-screenshot.png"
      width="700"
    />
  </a>
  <p><em>click for bigger</em></p>
</div>
```

## Extract Jekyll Include

The first step in this overhaul was to extract a [Jekyll Include][include-doc]
file which is the standard way of re-using a hunk of markup. I took that
existing image markup and tossed it into a file. Next I replaced actual values
with include attributes - here's how that would look:

{% raw %}
```
# source/_posts/2025-10-29-evaluating-apache-access-log-data.md

{%
  include
  framed_image.html
  alt="Apache Directory Listing Screenshot"
  src="/images/post-71/apache-directory-listing-screenshot.png"
%}

# source/_includes/framed_image.html

<div class="imageWrapper">
  <a href="{{ include.src }}">
    <img
      alt="{{ include.alt }}"
      src="{{ include.src }}"
      width="700"
    />
  </a>
  <p><em>click for bigger</em></p>
</div>
```
{% endraw %}

I could have stopped here but I told you I fell down a rabbit hole so buckle up!

## Use More Semantic Markup

If you checked out that doc page for Jekyll Includes then you might have noticed
one of the examples is actually this very use-case - extracting an include for
images. In the markup they used 2 elements that caught my eye: `figure` and
`figcaption`.

I looked up more info on MDN and found that their HTML images guide had [a
section for using these elements][fig-doc]. Here's what that include looks like
with better markup:

{% raw %}
```
# source/_includes/framed_image.html

<figure>
  <a href="{{ include.src }}">
    <img
      alt="{{ include.alt }}"
      src="{{ include.src }}"
      width="700"
    />
  </a>
  <figcaption>click for bigger</figcaption>
</figure>
```
{% endraw %}

I also made some CSS changes that actually fixed the bug I mentioned. Here's the
relevant section:

```
# source/css/default.css

img {
  height: auto;
  width: 100%;
}
```

The browser will get the `width` from the markup and then see that the styles
tell it to make the image as wide as the container allows. This keeps the image
as big as possible for desktop users and ensures that mobile users aren't seeing
an image breaking out of the container. I'll have more to say about image
dimensions later don't you worry!

## Improve Descriptive Text

The caption "click for bigger" is not really a caption at all. At this point I
took a step back and thought about how I wanted to use the descriptive text for
an image:

* `alt` - describe the image with a short phrase
* `title` - use this to nudge mouse users to click for bigger version
* `figcaption` - comment on the image with a sentence

With this new strategy in hand let's look at our example again:

{% raw %}
```
# source/_posts/2025-10-29-evaluating-apache-access-log-data.md

{%
  include
  framed_image.html
  alt="Apache directory listing screenshot"
  caption="Wow could this page look any more basic??"
  src="/images/post-71/apache-directory-listing-screenshot.png"
%}

# source/_includes/framed_image.html

<figure>
  <a href="{{ include.src }}">
    <img
      alt="{{ include.alt }}"
      src="{{ include.src }}"
      title="click for bigger"
      width="700"
    />
  </a>
  <figcaption>{{ include.caption }}</figcaption>
</figure>
```
{% endraw %}

I've added a new `caption` attribute to the include and moved the nudge to the
`title` attribute of the `img` tag. This text shows on mouse hover so it's
perfect for what I was trying to do. Adding a proper caption let's me introduce
a bit of snark to the site and isn't that why we do anything?

## Image Tester Experiments

A reader of this blog post might be thinking wow what a neat, linear process
this is, Jon is so smart and sure of himself - not so! What actually happened is
that I tried a bunch of things that did not work in order to find things that
did work. One technique I used was to create a dummy page on my site that I
could use to test different approaches.

I deployed the [Image Tester][image-tester] page and then iterated a few times.
I would look at it on my various devices including my iPhone, an old Android
phone, and a Raspberry Pi running Ubuntu on an old 1x monitor. I wanted to try
out what I was reading about on the MDN docs site and see things in action for
myself. I learned a lot! Here's what I came away with:

* provide a set of images at standard sizes and then tell the browser about them
  using `srcset`
* use `sizes` to help browsers figure out image dimensions
* use `height/width` to help the browser figure out the aspect ratio of the
  image
* only mark some images as lazy loading

## Recreating Images

With these lessons learned the finish line started to come into focus. It was
time to switch over to [Pixelmator][] and recreate a bunch of image files. What
I aimed for was to take each existing image and create 4 new files. I used the
export for web features in Pixelmator to ensure the resulting images were
optimized. I would start with creating one as big as possible but no bigger than
2400 pixels wide. Then I would resize to 3 standard versions at these widths:
900/1200/1800. I would end up with a set looking like this:

```
apache-directory-list-900.png
apache-directory-list-1200.png
apache-directory-list-1800.png
apache-directory-list-full.png
```

As I went I would tinker with the part of the filename that I'm calling the
"slug". Many of them included the word "screenshot" which was not needed.

I should also call out that during this process I cropped many of the images to
remove any drop shadow. When possible I actually re-created screenshots that
were easy to do again to remove it from the start. I did this because I learned
that CSS is really good at adding this effect and it keeps the image file sizes
a bit smaller. Plus then I could ensure a consistent look. Here's what that CSS
looks like:

```
img {
  filter: drop-shadow(0 0 4px var(--gray));
  transform: translateZ(0);
}
```

The drop shadow is added with that `filter` - technically that's all that's
needed but I noticed rendering issues especially on Safari. After some research
I stumbled upon suggestions to add that `transform` line and sure enough that
made those rendering issues go away. The explanation for why this fixed things
wasn't totally clear to me. Something about how the `transform` line moves the
rendering to the GPU.

This makes me happy because I like it when CSS is inscrutable and there are
still tricks to make browsers do what you want.  That's the web I grew up with
and it's nice to know that however much things change and improve, my instinct
to see the browser as an adversary is still warranted.

## Setting Image Dimensions

Browsers do math now! That was another key takeaway from my research and
experiments. Here's my mental model on how browsers render images:

When a browser is rendering a webpage it starts by reading the HTML. It will hit
my blog post images and if I provide `height/width` attributes then it can
calculate the aspect ratio. With that aspect ratio in mind it can look at the
container for the image, the hints in the `sizes` attribute, and the CSS rule
for making the image as wide as possible and end up with dimensions. It can take
those dimensions, the density of the device (1x/2x/3x), and use the `srcset`
attribute to look up which of the provided image files it would need.  If I mark
the image as lazy loading then it can delay making the request for the image
file but either way it handles the work.

Phew - that's quite a sophisticated system! I guess I knew some of this but I
had not really internalized all of it. Getting back to our example let's update
it with all of these learnings:

{% raw %}
```
# source/_posts/2025-10-29-evaluating-apache-access-log-data.md

{%
  include
  framed_image.html
  alt="Apache directory listing screenshot"
  caption="Wow could this page look any more basic??"
  slug="apache-directory-list"
%}

# source/_includes/framed_image.html

{%- capture small_src -%}
/images/post-{{ page.number }}/{{ include.slug }}-900.png
{%- endcapture -%}

{%- capture medium_src -%}
/images/post-{{ page.number }}/{{ include.slug }}-1200.png
{%- endcapture -%}

{%- capture large_src -%}
/images/post-{{ page.number }}/{{ include.slug }}-1800.png
{%- endcapture -%}

{%- capture full_src -%}
/images/post-{{ page.number }}/{{ include.slug }}-full.png
{%- endcapture -%}

<figure>
  <a href="{{ full_src }}">
    <img
      alt="{{ include.alt }}"
      height="570"
      loading="lazy"
      sizes="(max-width: 800px) calc(100vw - 80px), 760px"
      src="{{ full_src }}"
      srcset="{{ small_src }} 900w, {{ medium_src }} 1200w, {{ large_src }} 1800w"
      title="click for bigger"
      width="760"
    />
  </a>
  <figcaption>{{ include.caption }}</figcaption>
</figure>
```
{% endraw %}

The blog post where we call the include has gotten just a bit more simple by
switching from full image paths to just the slug. We then take that slug and use
the `capture` feature of [Liquid templates][liquid-capture] to come up with the
paths to our set of 4 images (900, 1200, 1800, and full). To make this easier to
read I'm cheating a bit and have removed some additional logic but this is
pretty close to what I'm using!

Note those `sizes` and `srcset` attributes - neat huh?! Here's how I read them:

```
sizes="(max-width: 800px) calc(100vw - 80px), 760px"
```

When the browser is 800 pixels wide or smaller then take the viewport width and
subtract 80 pixels to determine the size of the image element. If it is bigger
than 800 pixels wide then the width of the image is exactly 760 pixels no math
required.

{% raw %}
```
srcset="{{ small_src }} 900w, {{ medium_src }} 1200w, {{ large_src }} 1800w"
```
{% endraw %}

For this image there are 3 sizes available and this is the map for width to
image URL. Pick the URL that works best for this device. If none of these work
or you don't understand this attribute then fallback to the value of the `src`
attribute.

## Adding a Helper Script

With the include file set and my existing images lovingly massaged into
optimized versions, I started thinking about what I would do moving forward.
What I wanted to be able to do was take a screenshot, copy it into the folder
for my site, and then run a script on it to automate the rest of the process.
While I was at it, I might as well have this helper script return the include
snippet. Here's what I had in mind:

{% raw %}
```
$ bin/cut_images look-at-this.png 83
{%
  include
  framed_image.html
  alt="Short phrase"
  caption="This should be a sentence."
  slug="look-at-this"
%}
```
{% endraw %}

Call the script with the file to process and the number of the blog post. It
should do the work and then return on stdout the include lines that I could
copy/paste into the blog post I'm working on. Once it was working well I could
actually just pipe it to `pbcopy` and I'd already have it on my clipboard. So
how do I actually take an image and automate the resizing and exporting I was
manually doing in Pixelmator?

I worked with Claude and tinkered with an AppleScript to automate the loop of
resizing the original image and then exporting for web. For the sake of
simplicity here's the bones of what that looks like:

```
tell application "Pixelmator Pro"
  tell the front document
    # the targetWidth is injected in a loop
    resize image width targetWidth
    # the targetPath is also injected
    export for web to targetPath as PNG with properties {...}
  end tell
end tell
```

The idea is that I write a bash script that uses `osascript` to invoke this
AppleScript. Convoluted I know. When I run the bash script it will open the
original image file in Pixelmator, invoke the AppleScript for each size to
create the set of 4 images, and then echo back to me the include snippet so I
can paste it into the markdown file for the blog post.

## Conclusion

It was fun to explore the state of serving images on a website and wow did I
learn a lot. My experience with websites goes back decades and so a lot of this
stuff just did not exist when I was first learning about the topic. Then taking
that learning and applying it to my website in a way that I could automate so
that adding an image to the site is as simple as possible gave me a lot of
satisfaction. I hope to never think this hard about my blog post images again!

[Pixelmator]: https://www.pixelmator.com/pro/
[fig-doc]: https://developer.mozilla.org/en-US/docs/Learn_web_development/Core/Structuring_content/HTML_images#annotating_images_with_figures_and_figure_captions
[image-tester]: /image-tester.html
[include-doc]: https://jekyllrb.com/docs/includes/
[liquid-capture]: https://shopify.github.io/liquid/tags/variable/
[post-67]: /posts/2025/10/17/migrating-back-to-jekyll.html
[post-71]: /posts/2025/10/29/evaluating-apache-access-log-data.html
