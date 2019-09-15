---
title: Android Java Enum
date: 2018-08-07
tags:
desc:
---
Before taking about *Java Enum*, please note that  there is a performance issue with the android java enum object. For detail, please take a look at [this](https://android.jlelse.eu/android-performance-avoid-using-enum-on-android-326be0794dc3) blog post. 

If you still want to use a normal *Java Enum*, read below.
<!--more-->

# Java Enum
Here is how a normal *Java Enum* syntax is:

```java
public enum DealsShowType {
    ALL, SAVED
}
```

## Loop Though Enum

```java
for (DealsShowType type : DealsShowType.values()) {
    Log.d("TYPE", "type"); // loop though each type in DealsShowType
}
```

## Enum To Int (Ordinal)
There are several ways to get an Int from an Enum.
1. You can assign an Int to Enum.
2. You can get the ordinal int from Enum

For the first one, we will talk about how to create Int Enum and String Enum later. For now in this we keep our focus on ordinal value for an enum.

For example:
```java
public enum Persons {
    CHILD,
    PARENT,
    GRANDPARENT;
}
```

*CHILD* has ordinal value of 0, *PARENT* has ordinal value of 1, *GRANDPARENT* has ordinal value of 2. The order of this enum matters if you use the ordinal value of this enum.

I would suggest you avoid using the ordinal value, since making the order matters of the enum may create problem depending on where and when you use it. Other people may not know that this enum order matters. Use *Integer Enum* instead.

## Integer Enum
In this way, you can store any value to an *Enum*.  

```java
public enum Persons {
    CHILD(0),
    PARENT(1),
    GRANDPARENT(2);

    private Integer value;

    private Persons(final Integer value) {
        this.value = value;
    }

    public Integer getValue() {
        return value;
    }
}
```

NOTE: If you want a *String* *ENUM* you can just change the *Integer* to *String*.
