---
title: Timer On Background Thread
date: 2017-04-19
tags:
desc:
---

Sometimes when we schedule a timer we might want to schedule it on a background thread if the timer is updating in a short interval. Here is how I managed to do it.

<!--more-->

# NSTimer and RunLoop
Usually, when you schedule a timer, you call `scheduledTimer:withTimeInterval`. When this get called, it actually gets the main thread `RunLoop` and add into it. However, for background threads, you have to get the `RunLoop` and add `NSTimer` onto the `RunLoop` yourself.

## Codes
Here is the full block of codes

```swift
class RunTimer{
  let queue = DispatchQueue(label: "Timer", qos: .background, attributes: .concurrent)
  let timer: Timer?

  private func startTimer() {
    // schedule timer on background
    queue.async { [unowned self] in
      if let _ = self.timer {
        self.timer?.invalidate()
        self.timer = nil
      }

      let currentRunLoop = RunLoop.current
      self.timer = Timer(timeInterval: self.updateInterval, target: self, selector: #selector(self.timerTriggered), userInfo: nil, repeats: true)
      currentRunLoop.add(self.timer!, forMode: .commonModes)
      currentRunLoop.run()
    }
  }

  func timerTriggered() {
    // it will run under queue by default
    debug()
  }

  func debug() {
    // print out the name of current queue
    let name = __dispatch_queue_get_label(nil)
    print(String(cString: name, encoding: .utf8))
  }

  func stopTimer() {
    queue.sync { [unowned self] in
      guard let _ = self.timer else {
        // error, timer already stopped
        return
      }
      self.timer?.invalidate()
      self.timer = nil
    }
  }
}
```

## Create Queue
First, create a queue to make timer run on background and store that queue as a class property in order to reuse it for stop timer. I am not sure if we need to use the same queue for start and stop, the reason I did this is because I saw a warning message [here](https://developer.apple.com/reference/foundation/runloop).

> The RunLoop class is generally not considered to be thread-safe and its methods should only be called within the context of the current thread. You should never try to call the methods of an RunLoop object running in a different thread, as doing so might cause unexpected results.  

So I decided to store the queue and use the same queue for the timer to avoid synchronization issues.

Also create an empty timer and stored in the class variable as well. Make it optional so you can stop the timer and set it to `nil`.

```swift
class RunTimer{
  let queue = DispatchQueue(label: "Timer", qos: .background, attributes: .concurrent)
  let timer: Timer?
}
```

## Start Timer
To start timer, first call `async` from `DispatchQueue`. Then it is a good practice to first check if the timer has already started. If the `timer` variable is not `nil`, then `invalidate()` it and set it to `nil`.

The next step is to get the current `RunLoop`. Because we did this in the block of `queue` we created, it will get the `RunLoop` for the background queue we created before.

Create the timer. Here instead of using `scheduledTimer`, we just call the constructor of timer and pass in whatever property you want for the timer such as `timeInterval`, `target`, `selector`, etc.

Add the created timer to the `RunLoop`. Run it.

Here is a question about running the `RunLoop`. According to the documentation [here](https://developer.apple.com/reference/foundation/nsrunloop/1412430-run?language=objc), it says it effectively begins an infinite loop that processes data from the run loop\'s input sources and timers.

```swift
private func startTimer() {
  // schedule timer on background
  queue.async { [unowned self] in
    if let _ = self.timer {
      self.timer?.invalidate()
      self.timer = nil
    }

    let currentRunLoop = RunLoop.current
    self.timer = Timer(timeInterval: self.updateInterval, target: self, selector: #selector(self.timerTriggered), userInfo: nil, repeats: true)
    currentRunLoop.add(self.timer!, forMode: .commonModes)
    currentRunLoop.run()
  }
}
```

## Trigger Timer
Implement the function as normal. When that function gets called, it is called under the queue by default.

```swift
func timerTriggered() {
  // under queue by default
  debug()
}

func debug() {
  let name = __dispatch_queue_get_label(nil)
  print(String(cString: name, encoding: .utf8))
}
```

The `debug` function above is use to print out the name of the queue. If you ever worry if it has been running on the `queue`, you can call it to check.

## Stop Timer
Stop timer is easy, call `validate()` and set the timer variable stored inside class to nil.

Here I am running it under the `queue` again. Because of the warning [here](https://developer.apple.com/reference/foundation/runloop) I decided to run all the timer related code under the queue to avoid conflicts.

```swift
func stopTimer() {
  queue.sync { [unowned self] in
    guard let _ = self.timer else {
      // error, timer already stopped
      return
    }
    self.timer?.invalidate()
    self.timer = nil
  }
}
```

# Some Additional Questions
I am not fully understand this concepts. Here is some questions I have.

## Stop RunLoop
I am somehow a little bit confused on if we need to manually stop the `RunLoop` or not. According to the documentation [here](https://developer.apple.com/reference/foundation/runloop/1412430-run), it seems that when no timers attached to it, then it will exits immediately. So when we stop the timer, it should exists itself. However, at the end of that document, it also said that removing all known input sources and timers from the run loop is not a guarantee that the run loop will exit. macOS can install and remove additional input sources as needed to process requests targeted at the receiver's thread. Those sources could therefore prevent the run loop from exiting.

I tried the solution below which provide in the documentation for guarantee to terminate the loop. However the timer does not fired after I change `.run()` to the code below.

```swift
while (self.timer != nil && currentRunLoop.run(mode: .commonModes, before: Date.distantFuture)) {};
```

What I am thinking is that it might be safe for just using `.run()` on iOS. Because the documentation states that macOS is install and remove additional input sources as needed to process requests targeted at the receiver's thread. So iOS might be fine.

## RunLoop modes
When add timer onto `RunLoop`, we need to pass a variable for the mode. `Table 3-1` [here](https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/Multithreading/RunLoopManagement/RunLoopManagement.html) list all the modes available and their definition but I didn\'t understand them all.

My understanding right now is if it is a timer, it will use `.commonModes`.

I may update this part whenever I got time to look deep into this.

# Reference
Here are some useful links about running timer on background threads

-   [should NSTimer always added into runloop to execute - stackoverflow](http://stackoverflow.com/a/24017878/2581637)
