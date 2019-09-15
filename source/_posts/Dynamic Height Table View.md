---
title: Dynamic Height Table View
date: 2018-03-19
tags:
desc:
---

How to dynamically adjust table view height depending on its content? I got this perfect solution from [this stackoverflow post](https://stackoverflow.com/a/41688467/2581637). Below is the detail of the post.
<!--more-->

## Solution
Lots of the answers here don't honor changes of the table or are way too complicated. Using a subclass of `UITableView` that will properly set `intrinsicContentSize` is a far easier solution when using autolayout. No height constraints etc. needed.

```swift
class UIDynamicTableView: UITableView
{
    override var intrinsicContentSize: CGSize {
        self.layoutIfNeeded()
        return CGSize(width: UIViewNoIntrinsicMetric, height: self.contentSize.height)
    }

    override func reloadData() {
        super.reloadData()
        self.invalidateIntrinsicContentSize()
    }
}
```

Set the class of your TableView to `UIDynamicTableView` in the interface builder and watch the magic as this TableView will change it's size after a call to `reloadData()`.

- - - -

## Intrinsic Content Size
So what is Intrinsic Content Size?
