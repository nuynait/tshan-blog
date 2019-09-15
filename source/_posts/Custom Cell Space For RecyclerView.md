---
title: Custom Cell Space For RecyclerView
date: 2019-05-03
tags:
desc:
---

Here is how we can have custom paddings in between cells for a `RecyclerView`.
<!--more-->

# Decoration
First create a custom *Decoration* object like this:
``` kotlin
/**
 * This is used for adapters that has custom cell spacings.
 * For example:
 * - The register choose business screen has 11dp in between the cell.
 * - The register choose account type single/group screen has 20dp in between the cell.
 */
class CustomSpacingDecoration
/**
 * Create a decoration to add space in between the cell.
 * @param middleSpaceInPixel The space in between the cell in pixel.
 */(middleSpaceInPixel: Int) : RecyclerView.ItemDecoration() {
    private val mMiddleSpaceInPixel: Int = middleSpaceInPixel

    override fun getItemOffsets(outRect: Rect, view: View, parent: RecyclerView, state: RecyclerView.State) {
        super.getItemOffsets(outRect, view, parent, state)
        // Do not add space for the last item in cell
        if (parent.getChildAdapterPosition(view) != (parent.adapter?.itemCount ?: 0) - 1) {
            outRect.bottom = mMiddleSpaceInPixel
        }
    }
}
```

The above class will take in a number when init and take that number as the space between the cell.

```kotlin
if (parent.getChildAdapterPosition(view) != (parent.adapter?.itemCount ?: 0) - 1)
```

This *if statement* make sure that we only add this space in between. Exclude the last element in *recycler view*.

## Apply Decoration
Now we have this custom decoration class, the next step is to create the decoration instance and assign to a *recycler view*.

```java
recyclerView.addItemDecoration(new CustomSpacingDecoration((int) getResources().getDimension(R.dimen.button_account_type_padding_in_between)));

LinearLayoutManager layoutManager = new LinearLayoutManager(getActivity().getApplicationContext());
```
