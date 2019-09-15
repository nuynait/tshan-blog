---
title: Convert Byte Array to Data and to Int
date: 2017-05-05
tags:
desc:
---

This is about converting Data into Integer in Swift.

<!--more-->

# Swift Code

```swift
let data = Data(buffer: UnsafeBufferPointer(start: &byteArray, count: xDataArray.count))
var val: Int32 = xData.withUnsafeBytes { $0.pointee }
val = Int32(bigEndian: xVal)
```

There's couple things we need to notice.

First `Int` is a 64-bit integer on 64-bit platforms, and if the input data has only 32-bit, we need to use `Int32`.

Second the swift `Int` uses little-endian representation on all current Swift platform. If the input is big-endian, we need to use `Int32(bigEndian: xx)`

# More to Read
I use `Data` object to convert `byteArray` and `Int32`. For more about converting between values with `Data` objects, take a look at [this stackoverflow answer](http://stackoverflow.com/a/38024025/2581637).
