---
title: ImageView Drawable Crash On Vector Source
date: 2019-05-13
tags:
desc:
---

I had a problem where the the vector assigned to an ImageView and it crashed on an odder device.
<!--more-->

# Problem
The problem is the vector is assigned to the *android:background* or *android:src*. Because the old system api level is not compatible with the vector source.

## Solution
Assign the vector drawable resource to *app:srcCompat*.

```xml
<ImageView
    android:layout_width="wrap_content"
    android:layout_height="wrap_content"
    android:layout_gravity="center_vertical|end"
    android:layout_marginEnd="20dp"
    app:srcCompat="@drawable/ic_arrow_right_black_24dp" />
```
