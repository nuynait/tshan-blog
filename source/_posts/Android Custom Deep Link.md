---
title: Android Custom Deep Link
date: 2019-06-13
tags:
desc:
---

How to setup android deep link with custom url scheme?
<!--more-->

# What is Deep Link
With deep link, you can redirect your app when you visit. I choose to use own custom url scheme.

For example: crp-lowes://tab/ can be a custom deep link. Click on the link would direct to the app.

`crp-lowes` is the *scheme*. `tab` is the *host*

## Deep Link vs App Link
The difference between deep link and app link is the domain url. If you use *http/https* url scheme, and it is your own domain and has verified with google, then its an app link. If it’s a custom url scheme such as *crp-lowes://tab/*, it is a deep link and cannot be domain verified.

The only user experience difference is for app link it will default switch to your app and for deep link, it will pop up a switch to dialog if needed.

This post will focus on creating custom deep link.

# Create Custom Deep Link
In `AndroidManifest.xml`, do things like following:

```xml
<activity
    android:name="presentation.activities.LaunchActivity"
    android:theme="@style/LauncherTheme">
    <intent-filter>
        <action android:name="android.intent.action.VIEW" />
        <category android:name="android.intent.category.DEFAULT" />
        <category android:name="android.intent.category.BROWSABLE" />
        <data android:scheme="crp-lowes"
            android:host="tab"
            android:path="/"/>
    </intent-filter>
</activity>
```

To make the link work on *Chrome*, the `android:path=“/"` is necessary.

## Testing With Adb Command Line
First, you can verify the link work or now using the command line `abd` tool. Using the following command:

```bash
./adb shell am start -W -a android.intent.action.VIEW -d "${LINK}" ${PACKAGE}
```

*${LINK}:* The custom app deep link.
*${PACKAGE}:* The app package name.

Use `context.getPackageName()` to fetch the package name. Please don’t rely on *applicationId* or *Application Name*

**EXAMPLE:**

```bash
./adb shell am start -W -a android.intent.action.VIEW -d "crp-lowes://tab/" com.lowes.contractorrewards.uat
```

**Trouble Shooting:** If it doesn’t work, first make sure the following command works:

```bash
./adb shell am start -n ./adb shell am start -n ${PACKAGE}/${ACTIVITY}
```

*${PACKAGE}:* The app package name.
*${ACTIVITY}:* The activity along with its package.

*EXAMPLE:*
```bash
./adb shell am start -n ./adb shell am start -n com.lowes.contractorrewards.uat/presentation.activities.MainActivity
```

If the above command doesn’t succeed, check the package name and activity package see if there’s any issue.

**Assume the above command works**, check the `/` after the url scheme. If you do not have `android:path`, do not add the trailing `/`. Vice versa

## Testing with Browser
In order to make the link work in chrome, please first make sure that you have `android:path=“/"` in *AndroidManifest.xml* when setting up the deep link.

**Below, This Doesn’t Work!**
```html
<a href="crp-lowes://tab/"> </a>
```

So, how to setup a link in browser to click and switch to our app?

To make it work in chrome, you cannot type it in chrome browser url  section. You will need to create a link using the `<a> </a>` tag. To create the link, please following rules: [Android Intents with Chrome - Google Chrome](https://developer.chrome.com/multidevice/android/intents)

**Rule:**
```html
<a href="intent://${HOST}/#Intent;scheme=${SCHEME};end"> </a>
```

*${HOST}:* The host for Url.
*${SCHEME}:* The scheme for Url.

Here is an **example**:
```html
<a href="intent://tab/#Intent;scheme=crp-lowes;end"> </a>
```

**NOTE:** Only activities that have the category filter, [android.intent.category.BROWSABLE](http://developer.android.com/reference/android/content/Intent.html#CATEGORY_BROWSABLE) are able to be invoked using this method as it indicates that the application is safe to open from the Browser.

# Handle Custom Deep Link
So what happen after user click a button on the web which redirects to your app? It will launch the activity correctly depends on *Scheme, Host, Path* you setup in **AndroidManifest.xml**.

After the activity launched, you can get all these information from the activity intent.
```java
// Inside the activity launched
getIntent().getData() // This is the intent data for deep link.
getIntent().getData().toString() // This is the full path. Ex: crp-lowes://tab/
getIntent().getData().getScheme() // This is scheme. Ex: crp-lowes
getIntent().getData().getHost() // This is the host. Ex: tab
getIntent().getData().getPath() // This is the path. Ex: /
```

You can set multiple *intent-filter* for an Activity and redirect to *(launch)* different activities by extracting different scheme host and path.
