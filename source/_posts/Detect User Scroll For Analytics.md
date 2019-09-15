---
title: Detect User Scroll For Analytics
date: 2019-05-16
tags:
desc:
---
I need to detect that user init a scroll for analytics. Assume you are working on a *ScrollView* or *RecyclerView*. Here is how.
<!--more-->

```java
mRecyclerView.addOnScrollListener(new RecyclerView.OnScrollListener() {
    @Override
    public void onScrollStateChanged(RecyclerView recyclerView, int newState) {
        super.onScrollStateChanged(recyclerView, newState);
		  if (newState == RecyclerView.SCROLL_STATE_SETTLING) {
            // Scroll detected. Log here.
        }
    }
});
```
