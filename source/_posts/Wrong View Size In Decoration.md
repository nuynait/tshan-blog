---
title: Wrong View Size In Decoration
date: 2019-05-15
tags:
desc:
---

If you follow [this](bear://x-callback-url/open-note?id=244D3DEE-2CCB-4B2D-AD67-9A993F476B86-41558-00008768B09928DC&header=Custom%20Cell%20Space%20For%20RecyclerView) note, you will learn that we can set the in cell space using decoration. If we want to dynamically change the space based on the view’s (cell) size, then we will need to get the `view.height` property from the * getItemOffsets* function. However, I sometimes get a `0` when I visit `view.height` .
<!--more-->

I saw the same problem in [stackoverflow](https://stackoverflow.com/a/53848159/2581637). So here is what I learned.

# Solution
Write a fix layout class. You can probably copy and paste this class into your decorator.

```kotlin
/**
 * This function gets from here
 * https://stackoverflow.com/a/53848159/2581637
 *
 * Reason: In `getItemOffsets:` the view do not have a correct
 * height for me to calculate the math. After search on web, I
 * found this solution. Calling before getting the height from
 * the view will fix the problem.
 *
 * @param view: View to calculate the size
 * @param parent: Parent for the view
 */
private fun fixLayoutSize(view: View, parent: ViewGroup) {
    if (view.layoutParams == null) {
        view.layoutParams = ViewGroup.LayoutParams(
                ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT
        )
    }
    val widthSpec = View.MeasureSpec.makeMeasureSpec(parent.width, View.MeasureSpec.EXACTLY)
    val heightSpec = View.MeasureSpec.makeMeasureSpec(parent.height, View.MeasureSpec.UNSPECIFIED)
    val childWidth = ViewGroup.getChildMeasureSpec(
            widthSpec, parent.paddingLeft + parent.paddingRight, view.layoutParams.width
    )
    val childHeight = ViewGroup.getChildMeasureSpec(
            heightSpec, parent.paddingTop + parent.paddingBottom, view.layoutParams.height
    )
    view.measure(childWidth, childHeight)
    view.layout(0, 0, view.measuredWidth, view.measuredHeight)
}
```

Now call this function once before you get the width/height from the view.

```kotlin
override fun getItemOffsets(outRect: Rect, view: View, parent: RecyclerView, state: RecyclerView.State) {
	fixLayoutSize(view, parent)
	print(view.height) // correct height
}
```

Note that if you don’t notice any number that is wrong, but just some times have a 0 on height, call `fixLayoutSize(view, parent)` under if `(view.height == 0)` to speed up process.

# More Readings
[How to: Android RecyclerView Item Decorations](https://yoda.entelect.co.za/view/9627/how-to-android-recyclerview-item-decorations). This could be a very decent reading to understanding this problem more.
