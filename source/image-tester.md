---
title: Image Tester
---
# Image Tester

This page helps me test various image scenarios and then I can view it on my
fleet of devices to see how each ends up rendering the page.

This one uses 5 densities in the `srcset`:

<figure>
  <a href="/images/tester/density-example@5x.png">
    <img
      alt="Example image with density label"
      height="675"
      src="/images/tester/density-example@1x.png"
      srcset="/images/tester/density-example@1x.png 1x, /images/tester/density-example@2x.png 2x, /images/tester/density-example@3x.png 3x, /images/tester/density-example@4x.png 4x, /images/tester/density-example@5x.png 5x"
      title="click for bigger"
      width="900"
    />
  </a>
  <figcaption>Such a creative example image - good job Jon!!</figcaption>
</figure>

This one uses 7 sizes in the `srcset` with smart breakpoints in the `sizes`:

<figure>
  <a href="/images/tester/size-example-4000.png">
    <img
      alt="Example image with size label"
      height="675"
      sizes="(max-width: 800px) calc(100vw - 80px), (max-width:1000px) calc(100vw - 280px), 760px"
      src="/images/tester/size-example-900.png"
      srcset="/images/tester/size-example-600.png 600w, /images/tester/size-example-900.png 900w, /images/tester/size-example-1200.png 1200w, /images/tester/size-example-1800.png 1800w, /images/tester/size-example-2400.png 2400w, /images/tester/size-example-3000.png 3000w, /images/tester/size-example-4000.png 4000w"
      title="click for bigger"
      width="900"
    />
  </a>
  <figcaption>There are so many options!</figcaption>
</figure>

This one uses 2 densities with a more realistic image:

<figure>
  <a href="/images/tester/homepage@full.png">
    <img
      alt="Screenshot of homepage"
      height="675"
      src="/images/tester/homepage@1x.png"
      srcset="/images/tester/homepage@1x.png 1x, /images/tester/homepage@2x.png 2x"
      title="click for bigger"
      width="900"
    />
  </a>
  <figcaption>I can't wait to ship a better homepage!</figcaption>
</figure>

This one uses 3 sizes with a more realistic image:

<figure>
  <a href="/images/tester/post-1800.png">
    <img
      alt="Screenshot of post page"
      height="675"
      sizes="(max-width: 800px) calc(100vw - 80px), (max-width:1000px) calc(100vw - 280px), 760px"
      src="/images/tester/post-900.png"
      srcset="/images/tester/post-900.png 900w, /images/tester/post-1200.png 1200w, /images/tester/post-1800.png 1800w"
      title="click for bigger"
      width="900"
    />
  </a>
  <figcaption>What great blog post content!</figcaption>
</figure>

In case the file details are interesting here's where things stand:

| Filename                        | Dimensions | Size |
| ------------------------------- | ---------- | ---- |
| [density-example@1x.png][de1]   | 900x675    | 9k   |
| [density-example@2x.png][de2]   | 1800x1350  | 32k  |
| [density-example@3x.png][de3]   | 2700x2025  | 55k  |
| [density-example@4x.png][de4]   | 3600x2700  | 64k  |
| [density-example@5x.png][de5]   | 4500x3375  | 93k  |
| [size-example-600.png][se600]   | 600x450    | 8k   |
| [size-example-900.png][se900]   | 900x675    | 12k  |
| [size-example-1200.png][se1200] | 1200x900   | 20k  |
| [size-example-1800.png][se1800] | 1800x1350  | 36k  |
| [size-example-2400.png][se2400] | 2400x1800  | 50k  |
| [size-example-3000.png][se3000] | 3000x2250  | 76k  |
| [size-example-4000.png][se4000] | 4000x3000  | 91k  |
| [homepage@1x.png][hp1]          | 900x675    | 151k |
| [homepage@2x.png][hp2]          | 1800x1350  | 354k |
| [homepage@full.png][hpfull]     | 2400x1800  | 262k |
| [post-900.png][pp900]           | 900x675    | 141k |
| [post-1200.png][pp1200]         | 1200x900   | 171k |
| [post-1800.png][pp1800]         | 1800x1350  | 293k |

[de1]: /images/tester/density-example@1x.png
[de2]: /images/tester/density-example@2x.png
[de3]: /images/tester/density-example@3x.png
[de4]: /images/tester/density-example@4x.png
[de5]: /images/tester/density-example@5x.png
[se600]: /images/tester/size-example-600.png
[se900]: /images/tester/size-example-900.png
[se1200]: /images/tester/size-example-1200.png
[se1800]: /images/tester/size-example-1800.png
[se2400]: /images/tester/size-example-2400.png
[se3000]: /images/tester/size-example-3000.png
[se4000]: /images/tester/size-example-4000.png
[hp1]: /images/tester/homepage@1x.png
[hp2]: /images/tester/homepage@2x.png
[hpfull]: /images/tester/homepage@full.png
[pp900]: /images/tester/post-900.png
[pp1200]: /images/tester/post-1200.png
[pp1800]: /images/tester/post-1800.png
