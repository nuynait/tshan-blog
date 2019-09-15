---
title: Date Formatter
date: 2019-07-10
tags:
desc:
---
A time formatter can format date / time string into a *Swift/Obj-c Date* object, vice-versa. It uses date format string to determine the format of the date / time string.
<!--more-->

# Date Format String
For detail of how to wrote the date format string, you can visit [NSDateFormatter.com - Easy Skeezy Date Formatting for Swift and Objective-C](https://nsdateformatter.com/), it is very helpful.

Below information comes from [DateFormatter - Foundation | Apple Developer Documentation](https://developer.apple.com/documentation/foundation/dateformatter) official document.

> When working with fixed format dates, such as RFC 3339, you set the **dateFormat** property to specify a format string. For most fixed formats, you should also set the **locale** property to a POSIX locale (`en_US_POSIX`), and set the **timeZone** property to UTC.  

```swift
let RFC3339DateFormatter = DateFormatter()
RFC3339DateFormatter.locale = Locale(identifier: "en_US_POSIX")
RFC3339DateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
RFC3339DateFormatter.timeZone = TimeZone(secondsFromGMT: 0)

/* 39 minutes and 57 seconds after the 16th hour of December 19th, 1996 with an offset of -08:00 from UTC (Pacific Standard Time) */
let string = "1996-12-19T16:39:57-08:00"
let date = RFC3339DateFormatter.date(from: string)
```

# Trouble Shooting
2019-06-10: When you are sure that the date format is correct, but it is return *nil* after format the date on some devices, please setup a locale.

```swift
let dateFormatter = DateFormatter()
dateFormatter.locale = Locale(identifier: "en_US_POSIX")
```

Without that, on some device, it will fail to format 24 hours format *HH*.
