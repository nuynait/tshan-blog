---
title: Repeated Animation
date: 2017-05-19
tags:
desc:
---
Use the following code snippet to create a repeated animation
<!--more-->

# Create Repeated Animation
Use the following code snippet to create a repeated animation

```swift
// set original state
UIView.animate(withDuration: 0.4,
               delay: 0.0,
               options: [.repeat, .autoreverse],
               animations: { [unowned self] in
                 // set animated state
               }, completion: nil)
```

Note that we should define this animation in `viewWillAppear` instead of `viewDidLoad` if we want to reuse the view and keep animation display on screen. Because animation will stopped once view gets disappear.
