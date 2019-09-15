---
title: Wireless Debugging
date: 2018-08-01
tags:
desc:
---

When developing on android, you have the option to wireless connect to your computer. To do this you will need to do following setups.
<!--more-->

# Setup Wireless Debugging
First, connect your mobile device with an usb cable and make sure you have enable the developer option on your phone. Go to wireless settings, find the current IP address for the phone connecting the same network of your computer.

After you have the IP address, you run the following command.
```
./adb tcpip 5555
./adb connect 192.168.0.104:5555
```

After that you have enabled wireless debugging for that device. You can see that device when you hit run in android studio.
To turnoff wireless debugging by reboot the device or run
```
adb usb
```

## Where is ADB
If you cannot find your `adb` tool, you can find how to get `adb` here. Otherwise you can skip this section.

Open android studio and open preference by `cmd + ,` and search for `SDK`. The first option: `Android SDK` is where you want to go. You can see `Android SDK Location` here.

![](Pasted_Image_2018-08-01__2_58_PM.png)

Now go to that location in terminal. Android adb binary is located under `.../platform-tools/adb`

```
cd ~/Library/Android/sdk/platform-tools
./adb help
```

Now you can use `adb` as is.
