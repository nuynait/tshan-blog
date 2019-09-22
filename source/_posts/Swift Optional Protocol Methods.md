---
title: Swift Optional Protocol Methods
date: 2019-09-22
tags:
desc:
---

There are two ways to create optional protocol methods. One is with `@objc` tab, the other one uses the swift extension to provide a default method if not implemented. 

<!--more-->

I prefer using the second method. 

# Second Option (Preferred)
Using this way to create optional method in protocol, we are providing a default implementation for the protocol method.

``` swift
protocol somethingDataSourceDelegate {
    func getDataSourceSize() -> Int?
}

// provide default implementation for the protocol method
extension somethingDataSourceDelegate {
    func getDataSourceSize() -> Int? {
        return nil
    }
}
```

# First Option (Not Recommend)
For this option, we can create optional method in protocol using the old way by adding `@objc` attribute.
``` swift
@objc protocol somethingDataSourceDelegate {
    @objc func getDataSourceSize() -> Int
}
```
