---
title: Create Custom Delegate
date: 2019-04-19
tags:
desc:
---

First we need to create a *Protocol* object to define what kind of functions will exists in the delegate. Here is a template:
<!--more-->

```swift
public protocol CustomDelegate: class {
  func callback();
  optional func optionalCallback();
}
```

Use *optional* if the function is not required to implement for this protocol. If you want to use *optional*, you will need to expose the protocol to *Objective-C*. Add `@objc` in front of the *Protocol*.

If you do not want to use `@objc` for the *optional* keyword, you can remove the *optional* and provide a default implementation for the *protocol*.

```swift
protocol CustomDelegate: class {
  func callback();
  func optionalCallback();
}

extension CustomDelegate {
  func optionalCallback() {
    return
  }
}
```

Note: If you are making a framework and want to expose this *Protocol*, you will need to mark both *Protocol* and *Extension* `public`.

# Reference to Delegate
Assume you have an object hosting the delegate, like this:

```swift
open class Main {
  public weak var delegate: CustomDelegate?
}
```

Delegates will stored as optional variables inside a class. Remember to set it as *WEAK*. This is usually because your class has the ownership of the delegate.

To call the callback, use `delegate?.callback()`. Or `delegate?.optionalCallback?()` for optional functions.
