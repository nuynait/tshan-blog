---
title: Upgrade Marketing Cloud SDK
date: 2019-07-11
tags:
desc:
---

I am working for Kinetic Commerce as Senior Mobile developer. We currently have a project called`ICMP`. It is an old project and this is my first time hands on the code. I am going to debug a problem where app crash when toggle the location service. After some time digging the code, I found that the project used an SDK:  [https://github.com/salesforce-marketingcloud/JB4A-SDK-Android](https://github.com/salesforce-marketingcloud/JB4A-SDK-Android)
<!--more-->

This is currently deprecated. The old documentation site for version 4.5.0: [Journey Builder for Apps Android SDK (v4.5.0) : OpenDirect](https://salesforce-marketingcloud.github.io/JB4A-SDK-Android-v4.5.0/features/opendirect.html)

Now we need to upgrade to a newer version, see upgrade notes: [MarketingCloudSdk Android : Home](http://salesforce-marketingcloud.github.io/JB4A-SDK-Android/). The new version is 6.3.3, the new documentation site for version 6.3.3 is: [MarketingCloudSDK Android : Home](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-Android/)

# Upgrade Android Repository
What I did:
1. Upgrade the maven repository address using the following:
```
allprojects {
	repositories {
		// ...
		maven { url "https://salesforce-marketingcloud.github.io/MarketingCloudSDK-Android/repository" }
		// ...
  }
}
```
The url used to be `http://salesforce-marketingcloud.github.io/JB4A-SDK-Android/repository/`

2. Upgrade sdk version import in build.gradle from `5.3.2` to `6.3.3`
```
// In coreconfig.gradle
exactTarget = '6.3.3'

// In build.gradle (app)
implementation("com.salesforce.marketingcloud:marketingcloudsdk:${exactTarget}") {
    exclude module: "${salesForceBeaconLib}"
}
```

Since in `build.gradle` app the version imports from the variable `{exactTarget}`, I change the `{exactTarget}` in `coreconfig.gradle` from *5.3.2* to *6.3.3*

3. After all the gradle change, I sync the project. The project sync succeed. Building the app and has many compile issues. Now I need to solve these compile issues. The first one is `com.salesforce.marketingcloud.registration.Attribute` **no longer exists** in the new SDK version. By reading the reference page: [Registration| Marketing Cloud SDK](https://salesforce-marketingcloud.github.io/JB4A-SDK-Android/javadocs/6.2/reference/com/salesforce/marketingcloud/registration/Registration.html#attributes), I found that attributes property now becomes type: `abstract Map<String, String>`. So I changed every place where it uses Attribute project in to using `String` directly. `List<Attribute>` now becomes `Map<String, String>`

In *MarketingCloudManager.java*
```java
public static Map<String, String> getRegistrationAttributes(){
	...
}
```

In *SettingsFragment.java*
```java
private void setSwitch(){
	...
}

private boolean isEnabled(Map.Entry<String, String> attr) {
	...
}
```

4. Next compile issue is that there are some initialization builder setter function missing. For this, because I don’t understand what they used to be, its hard for me to knowing how to properly change those functions.

In *KcpApplication.java*, In function *onCreate()*, under if statement `BuildConfig.PUSH`, there are lots of change under *MarketingCloudSdk.init*.

- Changed from `setGcmSenderId` into `setSenderId`.
- Changed from `.setOpenDirectRecipient` into customize notification style
- Changed from `setCloudPagesEnabled` into `setInboxEnabled`. According to [this 2018 release note.](https://help.salesforce.com/articleView?id=mc_rn_april_2018_mobilepush_sdk.htm&type=5) (Search for *setCloudPagesEnabled*), cloud page methods is deprecated.

For customize notification style: [MarketingCloudSDK Android : Customize Notification Handling](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-Android/notifications/customize-notifications.html). The [old](https://salesforce-marketingcloud.github.io/JB4A-SDK-Android-v4.5.0/features/opendirect.html) open direct url is outdated. Also moving channel name into customize notification handling as well.

In *KcpApplication.java*, in function *public void complete(InitializationStatus status)*, there it access to `status.locationPlayServicesStatus()` change to `status.playServicesStatus()`. [This](https://salesforce-marketingcloud.github.io/JB4A-SDK-Android/javadocs/6.2/reference/com/salesforce/marketingcloud/InitializationStatus.html) is the reference.
