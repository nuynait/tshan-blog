---
title: Firebase Cloud Messaging Setup
date: 2019-06-25
tags:
desc:
---

Everything about setting up Android project with Firebase Cloud Messaging.
<!--more-->

# Adding Firebase
If your project have not used firebase before, follow [Add Firebase to your Android project  |  Firebase](https://firebase.google.com/docs/android/setup) official documentation to add the firebase SDK.

In your project-root *build.gradle*:
```
// Top-level build file where you can add configuration options common to all sub-projects/modules.

buildscript {
    ext.kotlin_version = '1.3.21'
    repositories {
		  //...
        google()
    }
    dependencies {
		  //...
        classpath 'com.google.gms:google-services:4.2.0'
    }
}

allprojects {
    repositories {
		  //...
        google()
    }
}
```

**Trouble Shooting**
If you see error message of merge *android support library* with *androidx* failed, upgrade your android project with *androidx* using  [Migrating to AndroidX](https://developer.android.com/jetpack/androidx/migrate)

## Multiple Google Services Json
If you have multiple build variant / flavour, you probably want to use different `google-services.json` depends on different build variant. The answer is yes, you can. [Here](https://stackoverflow.com/a/42086133/2581637) is a stack-overflow answer that might help.

For detail, do something like following:
```
|-- Project
	|-- app
		|-- src
			|-- production
				|-- google-services.json
			|-- staging
				|-- google-services.json
			|-- debug
				|-- google-services.json
```

# Import Firebase Messaging Framework
In your app-level *build.gradle* file:
```
apply plugin: 'com.android.application'

android {
 // ...
}

apply plugin: 'com.google.gms.google-services'
dependencies {
    implementation 'com.google.firebase:firebase-core:17.0.0'
    implementation 'com.google.firebase:firebase-messaging:19.0.0'
}
```

After import the object, create a firebase messaging service by create an object in your codebase that extends *FirebaseMessagingService*. Here is an example in [Java](https://github.com/firebase/quickstart-android/blob/9d2c53324e6797eae93b2536110b80f3eed27850/messaging/app/src/main/java/com/google/firebase/quickstart/fcm/java/MyFirebaseMessagingService.java) or [Kotlin](https://github.com/firebase/quickstart-android/blob/master/messaging/app/src/main/java/com/google/firebase/quickstart/fcm/kotlin/MyFirebaseMessagingService.kt)

Here is an example I created in Kotlin:
```kotlin
package services

import android.util.Log
import com.google.firebase.messaging.FirebaseMessagingService
import com.google.firebase.messaging.RemoteMessage

class LowesFirebaseMessagingService: FirebaseMessagingService() {

    companion object {
        const val TAG = "LowesFirebaseMessaging"
    }

    /**
     * here are two types of messages data messages and notification messages. Data messages are handled
     * here in onMessageReceived whether the app is in the foreground or background. Data messages are the type
     * traditionally used with GCM. Notification messages are only received here in onMessageReceived when the app
     * is in the foreground. When the app is in the background an automatically generated notification is displayed.
     * When the user taps on the notification they are returned to the app. Messages containing both notification
     * and data payloads are treated as notification messages.
     *
     * @param p0: The remote push notification message received.
     */
    override fun onMessageReceived(p0: RemoteMessage?) {
        Log.d(TAG, "From: ${p0?.from}")
    }

    /**
     * Called if InstanceID token is updated. This may occur if the security of
     * the previous token had been compromised. Note that this is called when the InstanceID token
     * is initially generated so this is where you would retrieve the token.
     *
     * @param p0: The new token in string.
     */
    override fun onNewToken(p0: String?) {
        Log.d(TAG, "Refreshed token: $p0")

        // TODO: Send the new token to our backend server.
    }
}
```

After created the above class, head to the *AndroidManifest.xml*, add the following service in between the *<application>* tag:
```
<application
    android:name="presentation.application.myApplication"
    ....>
	  ...
    <service
      android:name="services.LowesFirebaseMessagingService"
      android:exported="false">
      <intent-filter>
          <action android:name="com.google.firebase.MESSAGING_EVENT" />
      </intent-filter>
    </service>
	  ...
</application
```

The *android:name* is the package path for the object created above.

## Get device token
Write the following code into your app to get the device token: (For *Java*/*Kotlin*)
```java
FirebaseInstanceId.getInstance().getInstanceId()
    .addOnCompleteListener(new OnCompleteListener<InstanceIdResult>() {
      @Override
      public void onComplete(@NonNull Task<InstanceIdResult> task) {
        if (!task.isSuccessful()) {
          Log.w(TAG, "getInstanceId failed", task.getException());
          return;
        }

        // Get new Instance ID token
        String token = task.getResult().getToken();
        Log.d(TAG, token);

		  // TODO: Send device token to our server
      }
    });
```

```kotlin
FirebaseInstanceId.getInstance().instanceId
    .addOnCompleteListener(OnCompleteListener { task ->
      if (!task.isSuccessful) {
        Log.w(TAG, "getInstanceId failed", task.exception)
        return@OnCompleteListener
      }

      // Get new Instance ID token
      val token = task.result?.token
      Log.d(TAG, token)

		// TODO: Send device token to our server
    })
```

**Note:** The token can get renewed or refreshed under certain conditions. Implement the callback `onNewToken` in the object extends *FirebaseMessagingService* to get noticed.

- - - -
🧪 Now you can try to **send a notification to your testing device** using the device token. The notification banner (Heads up notification) may not appear. However, you can still break or print from the method *onMessageReceived* to see the payload data or notification title.
- - - -

# Create Notification
So now if you send a notification to your testing device, it will vibrate and nothing more will happen. This is because in the *onMessageReceived* callback, currently you only log the notification received. You didn’t create the notification. Here is how to create a  [Heads-Up Notification](https://developer.android.com/guide/topics/ui/notifiers/notifications?hl=en#Heads-up)

(If you are sending a notification only type message you will be able to see the notification at this stage. See below for detail.)

Before create any heads-up notification, here is what you need to know. There are two type of notification in FCM (*Firebase Cloud Messaging*)

1. Notification messages.
2. Data messages.

See [About FCM messages  |  Firebase](https://firebase.google.com/docs/cloud-messaging/concept-options#notifications_and_data_messages) for detail.

## Notification Messages vs. Data Messages.
[If you want to know how to send different type of push notification via http-protocol (*Restful Api*), see the other notes: *Firebase Cloud Messaging Send Message Via HTTP Protocol*.]

For **Notification Messages**, android display the heads-up notification depends on the *JSON* you send. (title, subtitle, icon, etc.). Will simply launch app when click on the message. If you want specific behaviour after click on message, you can choose **Data Messages** or **Notification With Data Payloads**

For **Data Messages**, app will call *OnMessageReceived* to handle the message as soon as it gets received. The method will be fired even if the app not opened. You will need to create heads-up message yourself under function *OnMessageReceived*

You can also build a push notification with both *Notification Messages* and *Data Messages*. I call it **Notification With Data Payloads**. In this case, android first display the heads-up notification depends on *JSON* in the notification section: (title, subtitle, icon) etc. If you have specify the *”click_action”* in the notification section, it will launch the activity you specified there and put all the data payloads into the activity intent extras.

I would suggest to use **Data Messages** directly for more flexible. With **Data Message** you will be able to change layout, or even use custom layout. There’s no disadvantage because the *OnMessageReceived* gets called even when app gets killed.

## Notification Icons
There are two kinds of icons displayed in the *Notification Center*. A **small icon** and a **large icon**.

The **large icon** only used when you create the heads-up notification manually with *Data messages*.

The setup process for icon is different depends on different type of messages.  I found an image below from [this site](https://documentation.onesignal.com/docs/customize-notification-icons) , it shows how small icon and large icon displayed.
![](Screen%20Shot%202019-06-26%20at%201.49.57%20PM.png)

After my investigation of all different notification styles, there are two different style. The first one is the showing the status above and title / description below, the second one is showing an icon on the left and title / description on the right. For Api level > API_23, they use second style. For Api level <= API_23, they use the first style.

- - - -
I tested on Android 6 (Nexus 5), there is a problem. It will use a large icon with a small icon combo, and if there is a problem which I setup the icon properly but **it shows a white cube**. Why is that happening?

Because on old device the notification icon should be entirely white. (The outlines has to be white with transparent background). Try [Android Asset Studio](https://romannurik.github.io/AndroidAssetStudio/icons-notification.html#source.type=clipart&source.clipart=ac_unit&source.space.trim=1&source.space.pad=0&name=ic_stat_ac_unit) to generate a notification icon properly.

⚠️ Make sure your notification icon is 24dp * 24dp and is pure white with transparency. Here is an example sketch file for the notification icon I design.

<a href='lowes-notification-icon.sketch'>lowes-notification-icon.sketch</a>
- - - -
For *small icon*, if you use type *Notification Messages* or *Notification With Data Payloads*, you can specify what icon to use by passing *icon* property under *notification* section. The *icon* property is a String for drawable name. The *icon* property is optional. Add following code to your *AndroidManifest.xml* to avoid icon property.

```
<meta-data android:name="com.google.firebase.messaging.default_notification_icon"
android:resource="@drawable/ic_notification_launcher_original" />

<meta-data
android:name="com.google.firebase.messaging.default_notification_color"
android:resource="@color/color_accent" />
```
(Add between application tags)

## Create Notification Manually
So if you send a pure data message, the callback *onMessageReceived* will gets fired no matter what state app is in. It by default will not create any heads-up notification. Unless you implemented in that callback. Here is an example implementation.

Assume the following code locates in class *LowesFirebaseMessagingService : FirebaseMessagingService()*
```kotlin
companion object {
    const val TAG = "LowesFirebaseMessaging"
    const val CHANNEL_ID = "Lowes_Notification_Channel"
    const val CHANNEL_DESCRIPTION = "Lowes Notification"

    // Data Keys
    const val NOTIFICATION_DATA_KEY_TITLE = "title"
    const val NOTIFICATION_DATA_KEY_BODY = "body"
    const val NOTIFICATION_DATA_KEY_DEEP_LINK = "deep-link"
    const val NOTIFICATION_DATA_KEY_WEB_LINK = "http-link"
}

override fun onMessageReceived(p0: RemoteMessage?) {
    p0?.let { sendNotification(it) }
}

private fun sendNotification(p0: RemoteMessage) {
    val defaultSoundUri = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION)
    val notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

    // Since android Oreo notification channel is needed.
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
        val channel = NotificationChannel(CHANNEL_ID,
                CHANNEL_DESCRIPTION,
                NotificationManager.IMPORTANCE_HIGH)
        notificationManager.createNotificationChannel(channel)
    }

    val intent = Intent(this, LaunchActivity::class.java)
    intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)
    intent.putExtra(NOTIFICATION_DATA_KEY_DEEP_LINK, p0.data[NOTIFICATION_DATA_KEY_DEEP_LINK])
    intent.putExtra(NOTIFICATION_DATA_KEY_WEB_LINK, p0.data[NOTIFICATION_DATA_KEY_WEB_LINK])
    val pendingIntent = PendingIntent.getActivity(this, 0 /* Request code */, intent,
            PendingIntent.FLAG_ONE_SHOT)
    val notificationBuilder = NotificationCompat.Builder(this, CHANNEL_ID).run {
        setSmallIcon(R.drawable.ic_notification_small_logo)
        setLargeIcon(BitmapFactory.decodeResource(applicationContext.resources, R.mipmap.ic_launcher))
		  priority = NotificationCompat.PRIORITY_MAX
        setContentTitle(p0.data[NOTIFICATION_DATA_KEY_TITLE])
        setContentText(p0.data[NOTIFICATION_DATA_KEY_BODY])
        setAutoCancel(true)
        setSound(defaultSoundUri)
        setContentIntent(pendingIntent)
    }
    notificationManager.notify(0, notificationBuilder.build())
}
```

The intent for the *LaunchActivity* can pass in all kinds of data payloads as you need.

## Show Floating Window (Banner)
🧪 You probably noticed, when sending a message, it creates a message in notification centre. However, there’s not notification banner showing on top.  

If you want android to show a floating window (top floating banner) when received a notification, you will need to set the priority to high/max.

Remember that you have two places to setup. One is to setup the priority attribute for *NotificationBuilder* when build the notification. The other is the notification level for notification channel. I set to *NotificationManager.IMPORTANCE_HIGH* in constructor. Notification channel only used in system after *Build.VERSION_CODES.O*

⚠️ It is not recommend to use the priority contains in the *RemoteMessage*. First of all, the priority is 1 for high, 2 for normal. However, *IMPORTANCE_HIGH* is 4 and *PRIORITY_MAX* is 2. Also I don’t know why if you change the priority level for channel, you will need to reinstall the app for it to work. So I never make it work for dynamic priority.

**Trouble shooting:**
If you see the floating window in lower android version, but not higher android version, check if you have set priority high in notification channel. You will need to **uninstall & reinstall** the app to take affect.

## Notification Click Events
The other important part is how to handle notification when user click on it. For different type of notification, there are different ways to do it. Let’s discuss this one by one.

For type: **Notification Messages**, you cannot do anything other than redirect to a specific activity.

To redirect to a specific activity, you will need to add following to the activity you want to redirect.
```
<activity
    android:name="presentation.activities.LaunchActivity"
    android:theme="@style/LauncherTheme">

    <!-- For push notification, launch LaunchActivity after click on the notification. -->
    <intent-filter>
        <action android:name="example.notification.launch.activity" />
        <category android:name="android.intent.category.DEFAULT" />
    </intent-filter>

</activity>
```

The action name `example.notification.launch.activity` in above example can be customize to any String you want and will be used in the *”click_action* property when composing the notification *JSON*. See detail in another notes related to *send firebase cloud messaging via HTTP.*

If the app is in foreground, `onMessageReceived` is getting called and will handle notification manually. See detail in *Data Messages*.

For type: **Notification With Data Payloads**, you can redirect to any activity using the method states above, as well as passing the data payloads into the activity intent. You can get the payload data hash map by accessing `getIntents().getExtras()`

For type: **Data Messages**, you can specify which activity to launch while creating the heads-up notification. You can also input any data payloads into the intent extras.

So in order to handle everything properly after launching the activity, you can check the intent extras and do anything depends on different intents received.

My suggestion is you can implement the deep-linking for the app and re-use the deep-linking for push notification. For example, you want a notification to go to register screen, then you can implement a deep link to go to the register screen and reuse the logic there.

# Custom Notification
First only a data message accepts custom views, if you want custom layout, use a data type message.

If you don’t like the current notification style, you can also create a custom notification view. You can use *ImageView* in custom notification view so that you don’t need to show only the white/transparent icon.

Assume that you don’t like the large and small icon style for system under api-23, you want to use a square app icon instead:

From:
![](Screen%20Shot%202019-06-28%20at%2010.19.01%20AM.png)
To:
![](Screen%20Shot%202019-06-28%20at%2010.17.24%20AM.png)

You will need to first create a *layout.xml*. Here is an example for the above layout:
```xml
<?xml version="1.0" encoding="utf-8"?>
<RelativeLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="match_parent">

    <ImageView
        android:id="@+id/notification_icon"
        android:layout_width="40dp"
        android:layout_height="40dp"
        android:layout_alignParentStart="true"
        android:layout_centerVertical="true"
        android:layout_marginStart="11dp"
        android:layout_marginEnd="11dp"
        android:contentDescription="@string/app_notification_icon"
        android:src="@mipmap/ic_launcher" />

    <LinearLayout
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:layout_alignParentStart="true"
        android:layout_centerVertical="true"
        android:layout_marginStart="64dp"
        android:orientation="vertical">

        <TextView
            android:id="@+id/notification_title"
            style="@style/TextAppearance.Compat.Notification.Title"
            android:layout_width="wrap_content"
            android:layout_height="wrap_content"
            android:layout_marginBottom="3dp"
            android:lines="1" />

        <TextView
            android:id="@+id/notification_body"
            style="@style/TextAppearance.Compat.Notification.Info"
            android:layout_width="wrap_content"
            android:layout_height="wrap_content"
            android:lines="1" />
    </LinearLayout>

</RelativeLayout>
```
[File name: `view_headsup_notification_api_23.xml`]

Now after created the above xml, when build the notification in *NotificationBuilder*, specify the *setContentIntent* to a *Remote View*. See below code for details.

```kotlin
        val notificationBuilder = NotificationCompat.Builder(this, CHANNEL_ID).run {
            setDefaults(NotificationCompat.DEFAULT_ALL)
            setSmallIcon(R.drawable.ic_notification_small_logo)
			  // Only show customize view for build under api-23
            if (Build.VERSION.SDK_INT <= Build.VERSION_CODES.M) {
                val remoteView = RemoteViews(packageName, if (Build.VERSION.SDK_INT > Build.VERSION_CODES.M) R.layout.view_headsup_notification else R.layout.view_headsup_notification_api_23)
                remoteView.setTextViewText(R.id.notification_title, p0.data[NOTIFICATION_DATA_KEY_TITLE])
                remoteView.setTextViewText(R.id.notification_body, p0.data[NOTIFICATION_DATA_KEY_BODY])
                setCustomContentView(remoteView)
            }

            priority = NotificationCompat.PRIORITY_MAX
            setContentTitle(p0.data[NOTIFICATION_DATA_KEY_TITLE])
            setContentText(p0.data[NOTIFICATION_DATA_KEY_BODY])
 			  // Setup custom view
            setContentIntent(pendingIntent)
        }
```
