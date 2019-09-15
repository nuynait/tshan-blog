---
title: Firebase Cloud Messaging Send Message Via HTTP Protocol
date: 2019-06-25
tags:
desc:
---

How do I send a message to device using Restful API?
<!--more-->

# Setup Post Method
The **Url**:
```
https://fcm.googleapis.com/fcm/send
```

The **Header**:
```
"Content-Type": "application/json",
"Authorization": "key=<API_KEY>"
```

Replace *<API_KEY>* to your api key on firebase.

The **BODY**:
Check [Http-Server-Ref](https://firebase.google.com/docs/cloud-messaging/http-server-ref) and [About FCM messages  |  Firebase](https://firebase.google.com/docs/cloud-messaging/concept-options#notifications_and_data_messages) official documentation for detail *JSON* object you can use.

There are three type of notifications.
1. Notification Messages
2. Data messages
3. Notification With Data Payloads.

For **Notification Messages**, android display the heads-up notification depends on the *JSON* you send. (title, subtitle, icon, etc.). Will simply launch app when click on the message. If you want specific behaviour after click on message, you can choose **Data Messages** or **Notification With Data Payloads**

For **Data Messages**, app will call *OnMessageReceived* to handle the message as soon as it gets received. The method will be fired even if the app not opened. You will need to create heads-up message yourself under function *OnMessageReceived*

You can also build a push notification with both *Notification Messages* and *Data Messages*. I call it **Notification With Data Payloads**. In this case, android first display the heads-up notification depends on *JSON* in the notification section: (title, subtitle, icon) etc. If you have specify the *”click_action”* in the notification section, it will launch the activity you specified there and put all the data payloads into the activity intent extras.

## Notification Messages
For **BODY** of *Notification Messages*:
```json
{
	"to": “<DEVICE_TOKEN>“,
	"notification": {
		"title": “This is the notification title“,
		"body": “This is the notification body.”,
		"click_action": "lowes.notification.launch.activity”,
		“icon”: “ic_notification_icon”
	}
}
```

*to*: Device token
*notification*: The notification object.
*title*: Title for notification.
*body*: Body for notification
*click_action*: The click action for notification. Usually be some kinds of activity to launch. (*OPTIONAL*)
*icon*: The small icon for notification. String for drawable resource. (*OPTIONAL*). With out icon, a default one will be used if meta data is implemented in android manifest file.

## Data Messages
For **BODY** of *Data Messages*:
```json
{
	"to": “<DEVICE_TOKEN>“,
	"data": {
		"title": "How was your recent purchase?",
		"body": "We hope you're enjoying your recent purchase.",
		"deep-link": "xxx://xxxx",
		"http-link": "http://xxxxx"
	}
}
```

*to*: Device token
“data”: Any self-defined data object.

The data object can be anything self-defined. Just make sure you implement the same key in the *onNotificationReceived* for your custom object extends *FirebaseMessagingService*

## Notification With Data Payloads
For **BODY** of *Notification With Data Payloads*
```json
{
	"to": “<DEVICE_TOKEN>“,
	"notification": {
		"title": "How was your recent purchase?",
		"body": "We hope you're enjoying your recent purchase.",
		"subtitle": "How was your recent purchase?",
		"click_action": "lowes.notification.launch.activity"
	},
	"data": {
		"rich-data": "testing rich-data"
	}
}
```

For detail of each field, visit [Notification Messages](bear://x-callback-url/open-note?id=0CD1A854-6756-4D64-9FA2-2B3924A30D90-77303-0000452D40E36C80&header=Notification%20Messages) and [Data Messages](bear://x-callback-url/open-note?id=0CD1A854-6756-4D64-9FA2-2B3924A30D90-77303-0000452D40E36C80&header=Data%20Messages). This is just a combination of the two.

However, please notice that the *“click_action”* here becomes required. Because you will need it to launch the activity to handle the data payload. After the activity launched, get the payload data hash map by accessing `getIntents().getExtras()`
