---
title: Pass Type As Parameter
date: 2016-11-04
tags:
desc:
---

In short, add `<T>` after the function name, pass in a parameter with type `T.Type`, and when you need to use that parameter, usually you call the name of the parameter, but instead, you use the type `T`

<!--more-->

# Pass in Type as Parameter
Why do I need to pass in types as a parameter? One of the usage case is I want to dynamically cast some objects depending to what I passed in.

## How?
[Here](http://stackoverflow.com/questions/28116598/swift-pass-type-as-parameter) is a useful reference I found.

In short, add `<T>` after the function name, pass in a parameter with type `T.Type`, and when you need to use that parameter, usually you call the name of the parameter, but instead, you use the type `T`

## Call class method when pass in custom object
[Here](http://stackoverflow.com/a/29714287/2581637) is a useful reference I found.

In short, create a protocol with the method you want to call and adapt to the protocol in that custom object, then when you create a function that pass in the type T, assign the protocol to that type, then its good to go.

```swift
protocol MethodProtocol {
  func someMethod() -> ()
}

class customObject {
  // your class
}

extension customObject: MethodProtocol {
  func someMethod() -> () {
    print("Method I want to call")
  }
}

func passInType<T: MethodProtocol>(type: T.Type) {
  T.someMethod()
}
```
