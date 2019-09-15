---
title: Init View Controller For Framework Projects
date: 2017-11-12
tags:
desc:
---

How to init view controller from `.xib` file inside a framework project?
<!--more-->

# Init View Controller From Nib
Init `UIViewController` from the `.xib` file is a little bit different. `nibBundle` property is very important, need to get the bundle for framework and pass it in. Here is how you do it.

```swift
// Assume project bundle id is com.example.bundle
class ViewControllerFromNib: UIViewController {
  init() {
    if let bundle = Bundle(identifier: "com.example.bundle") {
      super.init(nibName: "ViewControllerFromNib", bundle: bundle)
    }
  }
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
}
```
