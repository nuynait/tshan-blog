---
title: Catch Tap Action In Motion Event
date: 2019-05-16
tags:
desc:
---

If I have an `MotionEvent` from *onTouchListener* or *dispatchTouchEvent*, how to I filter on tap? Say if I want to build an analytics only log when user click on the screen and all I can get is that `MotionEvent`, what should I do?
<!--more-->

```java
@Override
protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
	  // OTHER ACTIONS HERE ...

    // Tap detector used for analytics
    mTapDetector = new GestureDetector(this, new Clicked());
}

class Clicked extends GestureDetector.SimpleOnGestureListener {
    @Override
    public boolean onSingleTapConfirmed(MotionEvent e) {
        Log.d("TEST", "Single Tap");
        return super.onSingleTapConfirmed(e);
    }
}

private GestureDetector mTapDetector;

@Override
public boolean dispatchTouchEvent(MotionEvent ev) {
    mTapDetector.onTouchEvent(ev);
    return super.dispatchTouchEvent(ev);
}
```
