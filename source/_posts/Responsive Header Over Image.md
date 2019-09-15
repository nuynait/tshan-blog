---
title: Responsive Header Over Image
date: 2018-02-17
tags:
desc:
---

A responsive cover image is a full width image that will adapt to any device screen. No matter what device you are using, it will always looks like full width and keeps its ratio.

So how to create this background image with a width 100% and height auto using pure css and html?

<!--more-->

# What is a responsive cover image?
![](20180217_015116_451665mW.png)

A responsive cover image is a full width image that will adapt to any device screen. No matter what device you are using, it will always looks like full width and keeps its ratio.

So how to create this background image with a width 100% and height auto?

## Code
For `CSS`:

```css
div.header-bg {
    height: 0;
    padding: 0;
    padding-bottom: 69%;
    background-image: url('../img/header-background.png');
    background-position: center center;
    background-size: 100%;
    background-repeat: no-repeat;
}
```

For `HTML`:

```html
<body>
  <div class="header-bg"></div>
</body>
```

## Calculating the ratio:
Note, when using above code, you need to change `padding-bottom` to adapt your own image ratio.

It is: `height / width * 100`. Note that it should be a landscape image which means height is always less than width.
