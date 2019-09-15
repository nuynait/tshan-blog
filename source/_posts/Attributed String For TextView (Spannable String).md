---
title: Attributed String For TextView (Spannable String)
date: 2019-09-10
tags:
desc:
---

If you want to include different font and colour text into one TextView, which is the attributed text in iOS, you will have to use `SpannableString` in Android. This note

<!--more-->

# Example
For example,  for `TextView` below, you can see that we have a different colour for *”7 days”*. As well as its a different font type. The whole text view is mainly Typeface **Helvetica**. However, the red text is in **Helvetica-Bold** and colour code `#e13434`.


![](7F937648-9FF0-4894-AB49-98B9C1E61894.png)

Here is how I achieve this is using the `SpannableString`. This like the Attributed String in iOS.

In Strings.xml:
```xml
<string name="pending_deactivation_modal_code_expire_subtitle_part1">Your activation code will expire in </string>

<string name="pending_deactivation_modal_code_expire_subtitle_highlight">\ 7 days</string>

<string name="pending_deactivation_modal_code_expire_subtitle_part2">. Visit a participating store to activate your Contractor Rewards and start saving!</string>
```

```kotlin
// First get string from xml
val part1 = getString(R.string.pending_deactivation_modal_code_expire_subtitle_part1)
val highlight = getString(R.string.pending_deactivation_modal_code_expire_subtitle_highlight)
val part2 = getString(R.string.pending_deactivation_modal_code_expire_subtitle_part2)
val subtitle = "$part1$highlight$part2"

// Create spannable string
val spannable = SpannableString(subtitle)

context?.let {

// Set attribution for "7 days" a red color
    spannable.setSpan(ForegroundColorSpan(ContextCompat.getColor(it, R.color.expire_date_highlight)), part1.length, "$part1$highlight".length, Spannable.SPAN_EXCLUSIVE_EXCLUSIVE)

// Set attribution for "7 days" using Helvetica_bold
    spannable.setSpan(CustomTypeSpan(Typeface.create("helvetica_bold", BOLD)), part1.length, "$part1$highlight".length, Spannable.SPAN_INCLUSIVE_INCLUSIVE)
}

// Apply spannable string into TextView
tv_deactivation_modal_subtitle.setText(spannable, TextView.BufferType.SPANNABLE)
```

Also don’t forget to include the `CustomTypeSpan` into the project.

```kotlin
class CustomTypeSpan(val typeface: Typeface): MetricAffectingSpan() {
    override fun updateDrawState(tp: TextPaint?) {
        tp?.let {
            applyCustomTypeface(tp, typeface)
        }
    }

    override fun updateMeasureState(textPaint: TextPaint) {
        applyCustomTypeface(textPaint, typeface)
    }

    private fun applyCustomTypeface(paint: Paint, tf: Typeface) {
        paint.typeface = tf
    }
}
```
