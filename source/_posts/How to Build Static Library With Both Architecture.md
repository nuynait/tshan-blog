---
title: How to Build Static Libaray With Both Architecture
date: 2019-01-15
tags:
desc:
---

When building static library in XCode (`.a`), the architecture you selected in build target does affect the result. For example, if you select a simulator and build the static library, then the library will contain only architecture for simulator use. If you select a real device / generic iOS device, then the library will only contain architecture for a real device.
<!--more-->

This means that either you can run the app (includes the static library) on a simulator or real device. It cannot be both. You will have to switch the library `.a` binary.

Below we will introduce a method to create a `.a` binary for both architecture. The benefit is to provide ability to run the app (includes the static library) in both simulator and real device.

# Create Library With Both Architecture
First, build the library using simulator and rename the `.a` file to `xxx_sim.a`. Then build the library using real device and rename the `.a` file to `xxx_device.a`

Now using the bash utility `lipo` to merge them together.

```bash
lipo -create xxx_device.a xxx_sim.a -output xxx.a
```

👆 xxx is the name of the static library.

# Run Script
If you want to automate the process with `Run Script` section in Xcode, there’s some useful post:

- [iphone - Build fat static library (device + simulator) using Xcode and SDK 4+ - Stack Overflow](https://stackoverflow.com/questions/3520977/build-fat-static-library-device-simulator-using-xcode-and-sdk-4)
- [Binding iOS Libraries - Xamarin | Microsoft Docs](https://docs.microsoft.com/en-us/xamarin/ios/platform/binding-objective-c/)
👆The video inside talks about how to generate fat static library.
