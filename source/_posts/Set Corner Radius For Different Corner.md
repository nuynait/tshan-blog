---
title: Set Corner Radius For Different Corner
date: 2018-03-18
tags:
desc:
---

How to set corner radius for different corner? For example, I want **top left**, **top right**, **bottom left** to have corner radius `5.0`, but **bottom right** to have `0.0`
<!--more-->

```swift
    let cornerRadius = UIBezierPath(roundedRect: quickSelectionView.bounds,
                                byRoundingCorners: [.topLeft, .topRight, .bottomLeft],
                                cornerRadii: CGSize(width: 5.0, height: 0.0))
    let maskLayer = CAShapeLayer()
    maskLayer.path = cornerRadius.cgPath
    quickSelectionView.layer.mask = maskLayer
```

### Reference
- Solution from [Stack Overflow](https://stackoverflow.com/questions/40498892/different-cornerradius-for-each-corner-swift-3-ios)
