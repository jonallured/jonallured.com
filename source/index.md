---
title: Home
---

# Hello Internet Traveler

I'm so glad you are here, you found the place ok? Great, great have a look
around there's plenty to see or might I suggest you take a look at my [Favorite
Posts][favs] page?

## Latest Post

{% assign latest_post = site.tags.article.first %}

## Latest Post: {{ latest_post.title }}

## Recent Posts

{% assign recent_article_posts = site.tags.article | slice: 1, 4 %}
{%
  include
  post_list.html
  posts=recent_article_posts
%}

## Weekly Reviews

{% assign recent_review_posts = site.tags.review | slice: 0, 4 %}
{%
  include
  post_list.html
  posts=recent_review_posts
%}

## Still Here?

Wow you made it pretty far - I'm impressed! If you're looking for something fun
to do, maybe you are the type of person that would love to [send me a
boop][boop]?

[boop]: https://app.jonallured.com/boops
[favs]: /favorite-posts.html
