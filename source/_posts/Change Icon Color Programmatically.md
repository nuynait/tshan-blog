---
title: Change Icon Color Programmatically
date: 2017-02-03
tags:
desc:
---

When I was developing the iOS app, sometimes we need different color for an icon asset. For example, if its a button, the normal state or highlight state color is different.

<!--more-->

# What and Why?
When I was developing the iOS app, sometimes I need different color for an icon asset. For example, if its a button, the normal state or highlight state color is different. If it is selectable, the color is different depending on if you have select it or not. Before I know the color can be changed dynamically by code, I used to open sketch and make a new icon of the different color. It not only takes time and energy, but also makes your app bigger.

However, not all the icons can be changing colors. Usually those can change color are vectors that are symbol and do not close. If it has a circle then it sometimes will becomes a problem. Keep aware of that.

Also, please be aware that you can only change the icons color within a view. What you do is to render the image as a template to match to the `tintColor` of the view it belongs

# How?
First, of course, import your icon asset into the asset folder. For example, here I import an image called `example.png`. Its asset name is `example`.

When init that `UIImage`, call `withRenderingMode(.alwaysTemplate)` to make the image itself a template. Also, init and add to the view you want the icons locates. For example a `UIImageView`. Then you can change its color by setting the `tintColor` property for that view.

``` swift
let image = UIImage(named: "example").withRenderingMode(.alwaysTemplate)
let imageView = UIImageView()
// ... setup constraints and other properties for that image view

// make image red
imageView.image = image
imageView.tintColor = UIImage.red
```
