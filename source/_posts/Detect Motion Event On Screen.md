---
title: Detect Motion Event On Screen
date: 2019-05-06
tags:
desc:
---

When I was working on analytics for Kinetic, the click event in *setOnClickListener* never gets called. So I find out a secondary solution is to catch up the screen motion event in *Activity*.

<!--more-->

*Override* the following function:
```java
@Override
public boolean dispatchTouchEvent(MotionEvent ev) {
	  // Touch event catched.
    return super.dispatchTouchEvent(ev);
}
```

There is one problem with this touch event is that it will called on any kinds of motions. For example, you scroll the view. What if I only when user click on the screen?
