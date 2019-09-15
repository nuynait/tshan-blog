---
title: Dismiss Keyboard After Leaving Fragment
date: 2019-05-15
tags:
desc:
---

When switch / replace a fragment, the keyboard normally does not dismiss itself. Here is a quick way to ensure keyboard dismissed after the fragment replace (Leaving the fragment).
<!--more-->

# Utility Function
First, you will need a utility function to dismiss keyboard.

```kotlin
class KeyboardUtil {
    companion object {
        /**
         * Call this function to dismiss the keyboard.
         * @param activity: Pass in the current activity as context and get the current focus window.
         */
        fun dismiss(activity: Activity)  {
            val imm: InputMethodManager = activity.getSystemService(Context.INPUT_METHOD_SERVICE) as InputMethodManager
            activity.currentFocus?.let { focus ->
                imm.hideSoftInputFromWindow(focus.windowToken, 0)
            }
        }
    }
}
```

Now you can call this function anywhere and pass in the current activity to easily dismiss keyboard.

Question is where do you call this utility function?

# In Fragment
You want to call this utility function in fragment `onPause` life cycle.

```java
@Override
public void onPause() {
    super.onPause();
    assert getActivity() != null;
    KeyboardUtil.Companion.dismiss(getActivity());
}
```

Note that when you deactivate the app (moving to background), the keyboard will dismiss too. This is because the *onPause* is called when app into background as well.
