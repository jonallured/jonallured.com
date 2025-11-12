---
title: Image Tester
---
# Image Tester

This page helps me test various image scenarios and then I can view it on my
fleet of devices to see how each ends up rendering the page.

<figure>
  <a href="/images/tester/example@5x.png">
    <img
      alt="Example image with density label"
      height="675"
      loading="lazy"
      src="/images/tester/example@1x.png"
      srcset="/images/tester/example@1x.png 1x, /images/tester/example@2x.png 2x, /images/tester/example@3x.png 3x, /images/tester/example@4x.png 4x, /images/tester/example@5x.png 5x"
      title="click for bigger"
      width="900"
    />
  </a>
  <figcaption>Such a creative example image - good job Jon!!</figcaption>
</figure>

Here I'm running a more simple experiment where I supply only 1x and 2x densities:

<figure>
  <a href="/images/tester/homepage@full.png">
    <img
      alt="Screenshot of homepage"
      height="675"
      loading="lazy"
      src="/images/tester/homepage@1x.png"
      srcset="/images/tester/homepage@1x.png 1x, /images/tester/homepage@2x.png 2x"
      title="click for bigger"
      width="900"
    />
  </a>
  <figcaption>I can't wait to ship a better homepage!</figcaption>
</figure>

In case the file details are interesting here's where things stand:

| Filename          | Dimensions | Size |
| ----------------- | ---------- | ---- |
| example@1x.png    | 900x675    | 9k   |
| example@2x.png    | 1800x1350  | 32k  |
| example@3x.png    | 2700x2025  | 55k  |
| example@4x.png    | 3600x2700  | 64k  |
| example@5x.png    | 4500x3375  | 93k  |
| homepage@1x.png   | 900x675    | 151k |
| homepage@2x.png   | 1800x1350  | 354k |
| homepage@full.png | 2400x1800  | 262k |
