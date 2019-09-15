---
title: Multiple Dex Files Define Problem
date: 2019-06-20
tags:
desc:
---

A small issue about `Multiple dex files define Landroid/support/v4/os/ResultReceiver`
<!--more-->

# What Is The Problem?
I was upgrading the current android project to *AndroidX* then I encounter the following compile error:

```
Multiple dex files define Landroid/support/v4/os/ResultReceiver;
```

By doing some research I found that this problem is caused by having duplicate import of the library. For example, you have library *A*, *B*. You import *A* and *B* in the project. However, *B* import *A* as well.

# How To Fix?
First, you will need to find you what is the conflict of the library here. Usually this is because you import the android support library in the gradle and some third party library also import the android support library.

## Find Dependencies List
This [StackOverflow](https://stackoverflow.com/a/21100040/2581637) post helps me a lot. So you can *cd* into the project root directory and run the following command:

```bash
./gradlew -q dependencies
```

If you see java issue returned, that probably because you didn’t install java on your computer. I installed [Java SE Development Kit 8](https://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html)

If you see *No configurations*, use the following command instead:

```bash
./gradlew -q :app:dependencies
```

Try to find the issue. Here is a brief screenshot of my configuration:

```bash
+--- com.romandanylyk:pageindicatorview:0.2.0
|    +--- com.android.support:support-annotations:25.3.0
|    +--- com.android.support:support-compat:25.3.0
|    |    \--- com.android.support:support-annotations:25.3.0
|    \--- com.android.support:support-core-ui:25.3.0
|         +--- com.android.support:support-annotations:25.3.0
|         \--- com.android.support:support-compat:25.3.0 (*)
+--- com.loopj.android:android-async-http:1.4.9
|    \--- cz.msebera.android:httpclient:4.3.6
+--- com.nulab-inc:zxcvbn:1.2.5
```

Because I also import `implementation "androidx.appcompat:appcompat:1.0.2"`, it is causing the issue of duplicate *support-compat* module.

## Exclude Duplicates
Since I have already found the duplicates, the next step is easy. You can just exclude the duplicates like I did below:

```
implementation ('com.romandanylyk:pageindicatorview:0.2.0') {
    exclude module: 'support-compat'
}
```

Note that you can find the module name after the `:`. For example, for library: `com.android.support:support-compat:25.3.0`, its **group** name is *com.android.support*, its **module** name is *support-compact*.
