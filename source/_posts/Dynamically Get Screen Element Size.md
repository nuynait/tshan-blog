---
title: Dynamically Get Screen Element Size
date: 2019-05-15
tags:
desc:
---

How to get size in pixel on device dynamically in code?
<!--more-->

## Screen
To get screen height:
```kotlin
/**
 * Get screen height in pixel
 * @param context Context used to calculate screen size
 * @return Screen height in pixel
 */
fun screenHeightInPx(context: Context): Int {
    return context.resources.displayMetrics.heightPixels
}
```

## Status Bar
To get status bar height:
```kotlin
/**
 * Get status bar height in pixel
 * @param context Context used to calculate status bar size
 * @return Status bar size in pixel
 */
fun statusBarHeightInPx(context: Context): Int {
    val resourceIdStatusBar = context.resources.getIdentifier("status_bar_height", "dimen", "android")
    return if (resourceIdStatusBar > 0) context.resources.getDimensionPixelSize(resourceIdStatusBar) else 0
}
```

## Tab Bar (Bottom Navigation)

![](Dynamically%20Get%20Screen%20Element%20Size/device-2019-05-15-093122.png)

This is the *Tab Bar* (in iOS). *Bottom Navigation* in Android. To get its height:

```kotlin
/**
 * Get navigation bar height in pixel
 * @param context Context used to calculate tab bar size
 * @return Navigation bar size in pixel
 */
fun tabBarHeightInPx(context: Context): Int {
    val resourceIdTabBar = context.resources.getIdentifier("navigation_bar_height", "dimen", "android")
    return if (resourceIdTabBar > 0) context.resources.getDimensionPixelSize(resourceIdTabBar) else 0
}
```
