---
title: Network Reachability With Alamofire
date: 2018-04-02
tags:
desc:
---
When I was implementing the Mapsted Navigation app, one thing I need is to know if device is connected to network. The ideal case for me is to have a function to call `isConnected()` and will return `true` if connected, `false` if not.
<!--more-->

I found that the easiest implementation for this is using the `Alamofire` framework, since I am using this for all the RESTful api calls. There is a `NetworkReachabilityManager` will listen to a particular host server. If it changes between reachable and unreachable, it will fire a closure.

Here is the implementation. It is a singleton class. You can change it to adapt to your app. Call `MNNetworkUtils.main.isConnected()` to get the reachability result.

``` swift
import Alamofire

class MNNetworkUtils {
  static let main = MNNetworkUtils()
  init() {
    manager = NetworkReachabilityManager(host: "google.com")
    listenForReachability()
  }

  private let manager: NetworkReachabilityManager?
  private var reachable: Bool = false
  private func listenForReachability() {
    self.manager?.listener = { [unowned self] status in
      switch status {
      case .notReachable:
        self.reachable = false
      case .reachable(_), .unknown:
        self.reachable = true
      }
    }
    self.manager?.startListening()
  }

  func isConnected() -> Bool {
    return reachable
  }
}
```
