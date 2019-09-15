---
title: Get Current Device Language For iOS
date: 2019-09-03
tags:
desc:
---

If you want to know what current device language is for iOS, you can use `NSLocale.preferredLanguages.first`. This will give you the most preferred language user setup in system. Which is also the system language. This will gives you a string identifier.  [Here](https://gist.github.com/jacobbubu/1836273) is a list of string identifier for iOS.
<!--more-->

If you want to know if user system is French, using string comparison has a problem. Because there can be multiple result being French. Fro example: fr_CA, fr_FR. etc. So I use `preferredLanguage?.starts(with: “fr”)` to see if it is French.

Complete code:
```swift
	  DeviceLocaleType {
        case en
        case fr
        case other
    }

    static func deviceLocale() -> DeviceLocaleType {
        let preferredLanguage = NSLocale.preferredLanguages.first
        if preferredLanguage?.starts(with: "en") ?? false {
            return .en
        } else if preferredLanguage?.starts(with: "fr") ?? false {
            return .fr
        } else {
            return .other
        }
    }
```
