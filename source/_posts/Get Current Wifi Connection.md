---
title: Get Current Wifi Connection
date: 2017-04-21
tags:
desc:
---
From *<2017-04-21 Fri>* it is possible to get the current wifi information from the Captive Network. In the past, apple actually disabled this `api` for a while, but they seems to [re-enabled](http://stackoverflow.com/questions/31555640/how-to-get-wifi-ssid-in-ios9-after-captivenetwork-is-deprecated-and-calls-for-wi) it due to strong request. It is also possible that they decide to close this `api` in the future.

<!--more-->

# Captive Network
The information we can get is `BSSID`, `SSID`, `SSIDDATA`. `BSSID` is the unique address for wifi, `SSID` is the current wifi name, `SSIDDATA` is the hex representation for the `SSID`.

## Swift
Updated at *<2017-04-21 Fri>* for `Swift 3.1`, `XCode 8.3`

```swift
func printCurrentWifiInfo() {
  if let interface = CNCopySupportedInterfaces() {
    for i in 0..<CFArrayGetCount(interface) {
      let interfaceName: UnsafeRawPointer = CFArrayGetValueAtIndex(interface, i)
      let rec = unsafeBitCast(interfaceName, to: AnyObject.self)
      if let unsafeInterfaceData = CNCopyCurrentNetworkInfo("\(rec)" as CFString), let interfaceData = unsafeInterfaceData as? [String : AnyObject] {
        // connected wifi
        print("BSSID: \(interfaceData["BSSID"]), SSID: \(interfaceData["SSID"]), SSIDDATA: \(interfaceData["SSIDDATA"])")
      } else {
        // not connected wifi
      }
    }
  }
}
```

## Objective-C
Updated at *<2017-04-21 Fri>* for `clang-802.0.38`, `XCode 8.3`

```objc
NSArray *interFaceNames = (__bridge_transfer id)CNCopySupportedInterfaces();

for (NSString *name in interFaceNames) {
  NSDictionary *info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)name);

  NSLog[@"wifi info: bssid: %@, ssid:%@, ssidData: %@", info[@"BSSID"], info[@"SSID"], info[@"SSIDDATA"]];
 }
```
