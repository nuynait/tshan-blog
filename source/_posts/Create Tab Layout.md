---
title: Create Tab Layout
date: 2019-05-23
tags:
desc:
---

Create a tab layout on Android
<!--more-->

# What is Tab Layout
I was working on a tabbed screen for saved offers. See below for screenshot.

![](device-2019-05-23-093111.png)

# Create The Layout
The entire offer screen is a *Fragment*. What I did is to include a *Tab Layout* in layout .xml file. Added the following code into the top of the fragment layout file.

```xml
<android.support.design.widget.TabLayout
    android:layout_width="match_parent"
    android:layout_height="@dimen/deal_list_tab_height">

	  <!-- Add items directly from XML -->
    <android.support.design.widget.TabItem
             android:text="@string/tab_text"/>

    <android.support.design.widget.TabItem
             android:icon="@drawable/ic_android"/>

</android.support.design.widget.TabLayout>
```

You can visit the  [TabLayout](https://developer.android.com/reference/android/support/design/widget/TabLayout)  page for more details.

## Add Tab Items Programmatically
You can either add tab items in *Layout* file or create tab items programatically.

To create tab items programatically, you will first need to assign an *ID* to *TabLayout* so that you can get the *TabLayout* in *Fragment*.

```java
final TabLayout tabLayout = view.findViewById(R.id.deal_tab_main);
TabLayout.Tab tab = tabLayout.newTab();
tab.setText(getContext().getText(R.string.tab_title_1));
tabLayout.addTab(tab);
```

## Tab Tapped
When user tap on a tab, there are two things you can do. One thing is to switch to a different fragment. The other is to reload data for the current fragment. For us, I choose to reload the offer list.

If you want to **switch to a different fragment**, check  [ViewPager](https://developer.android.com/reference/android/support/v4/view/ViewPager.html) .

If you want to reload data when select another tab, use the *OnTabSelectedListener*. See below for the actual code.

```java
tabLayout.addOnTabSelectedListener(new OnTabSelectedListener() {
    @Override
    public void onTabSelected(TabLayout.Tab tab) {
		  // Tab Selected
		  Log.d(getClass().getName(), "Selected Position: tab.getPosition()");
    }

    @Override
    public void onTabUnselected(TabLayout.Tab tab) {
        // Ignored ....
    }

    @Override
    public void onTabReselected(TabLayout.Tab tab) {
        // Ignored ....
    }
});
```

# Dynamically Create Tab Layout Using Enum
I end up using a enum for creating the tab. I add tab items programatically depending on items in an enum. So this is what I did.

First, put the enum somewhere:
```java
public enum DealsShowType {
    ALL, SAVED
}
```

Then, create the tab items dynamically depending on the *DealsShowType* enums:
```java
final TabLayout tabLayout = view.findViewById(R.id.deal_tab_main);
for (DealsListViewModel.DealsShowType type : DealsListViewModel.DealsShowType.values()) { // for loop enum
    TabLayout.Tab tab = tabLayout.newTab();
    switch (type) {
        case ALL:
            tab.setText(getContext().getText(R.string.deals_list_tab_show_all));
            break;
        case SAVED:
            tab.setText(getContext().getText(R.string.deals_list_tab_show_saved));
            break;
    }
    tabLayout.addTab(tab);
}
```

Last but not least, refresh data when tab gets pressed.
```java
tabLayout.addOnTabSelectedListener(new OnTabSelectedListener() {
    @Override
    public void onTabSelected(TabLayout.Tab tab) {
        showType = DealsListViewModel.DealsShowType.values()[tab.getPosition()]; // know which enum is currently selected
        modelsFetched();
		  // model fetched will access class variable showType to correctly fetch data depending on the current type.
    }

    @Override
    public void onTabUnselected(TabLayout.Tab tab) {
        // Ignored ....
    }

    @Override
    public void onTabReselected(TabLayout.Tab tab) {
        // Ignored ....
    }
});
```
