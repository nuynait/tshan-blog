---
title: Wait Until Async Finishes
date: 2018-12-05
tags:
desc:
---

If I have to run a block of codes in background thread, how to make a function return the value after async blocks?
<!--more-->

For example,

```
func myFunction() {
    var a: Int?

    DispatchQueue.main.async {
        var b: Int = 3
        a = b
    }

    // wait until the task finishes, then print

    print(a) // - this will contain nil, of course, because it
             // will execute before the code above

}
```

## Solution:
Use `DispatchGroup`s to achieve this. You can either get notified when the group's `enter()` and `leave()` calls are balanced:

```
    func myFunction() {
        var a: Int?

        let group = DispatchGroup()
        group.enter()

        DispatchQueue.main.async {
            a = 1
            group.leave()
        }

        // does not wait. But the code in notify() gets run
        // after enter() and leave() calls are balanced

        group.notify(queue: .main) {
            print(a)
        }
    }
```

or you can wait (and return):

```
    func myFunction() -> Int? {
        var a: Int?

        let group = DispatchGroup()
        group.enter()

        // avoid deadlocks by not using .main queue here
        DispatchQueue.global(attributes: .qosDefault).async {
            a = 1
            group.leave()
        }

        // wait ...
        group.wait()

        // ... and return as soon as "a" has a value
        return a
    }
```

*Note*: `group.wait()` blocks the current queue (probably the main queue in your case), so you have to dispatch.async on another queue (like in the above sample code) to avoid a *deadlock*.
