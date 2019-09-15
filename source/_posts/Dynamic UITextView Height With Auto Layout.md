---
title: Dynamic UITextView Heighgt With Auto Layout
date: 2018-07-20
tags:
desc:
---

If you are using pure auto layout to setup user interface, you might experience some issue when setup dynamic height for `UITextView` or `UITextField`.
<!--more-->

Here is how you can setup dynamic height using pure auto layout.

# Auto Layout Setup
First, make sure that you have disable the scrolling for the `UITextView` or `UITextField`
``` swift
textView.isScrollEnabled = false
```

Then create the constraints, and have a property which is the view’s height constraints. Now when you assign text, below is the code use to update the height constraint.
``` swift
    textView.text = text
    let sizeThatFitsTextView = textView.sizeThatFits(CGSize(width: TEXT_VIEW_WIDTH, height: CGFloat(MAXFLOAT)))
    textFieldHeightConstraints?.constant =  sizeThatFitsTextView.height
```
