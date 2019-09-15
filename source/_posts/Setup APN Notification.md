---
title: Setup Apple Push Notification
date: 2019-06-28
tags:
desc:
---

Basic about setting up push notification (2019)
<!--more-->

# Enable Push Notification
The first step is to enable push notification under *Target -> Capabilities*.  See screenshot below.

![](Screen%20Shot%202019-06-28%20at%2012.56.53%20PM.png)

Then you will need to create an authentication key file for push notification under your developer team account. Note that you will need an account with admin privilege to do this. Note that this has been changed a little bit compare to the old time. It has become much simpler.


![](Screen%20Shot%202019-06-28%20at%201.02.36%20PM.png)

*Create a key:*
![](Screen%20Shot%202019-06-28%20at%201.03.03%20PM.png)

# Remote Notification Registration
So you have finished all the preparation, now its time to implement the APN in your project. The first thing you will need to do is to ask for notification permission. Then you will need to register device for the remote notification after user gives the permission. Waiting for callback to extract the device token.

For all these, here is a sample code written in `AppDelegate.swift`:
```swift
    func registerForPushNotifications() {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge]) {
                [weak self] granted, error in
                print("TEST_PUSH: Permission granted: \(granted)")
                guard granted else { return }
                self?.getNotificationSettings()
        }
    }

    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            print("TEST_PUSH: Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("TEST_PUSH: Device Token: \(token)")
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("TEST_PUSH: Failed to register push notification: \(error)")
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        registerForPushNotifications()
        return true
    }
```

For the above code:
1. Call *registerForPushNotification* in *didFinishLaunchingWithOptions*
2. Call *getNotificationSettings* to get current notification setting and if its *.authorized*, *registerForRemoteNotification*
3. Get device token in *didRegisterForRemoteNotificationWithDeviceToken* and upload to your own server if needed. (Upload to my server is not include in above sample code)
4.
- - - -
🧪 At this stage, you will be able to send a APN to your testing device using the device token and able to see the push notification popup.
- - - -

# Testing
Now you can test to see if your implementation works.

## Testing Utility Tool
[GitHub - onmyway133/PushNotifications: 🐉 A macOS, Linux, Windows app to test push notifications on iOS and Android](https://github.com/onmyway133/PushNotifications)

This is a very useful tool to test your push notification to make sure it works.

For sending an APN, you will need following information:
1. Team ID
2. Key ID
3. Key File (created above)
4. Device Token

You can get the team id by login to your development account and select **Membership** on the left panel. You can get the key id when you create the key file.

## Send APN Via HTTP Protocol (Restful Api)
[Sending Notification Requests to APNs | Apple Developer Documentation](https://developer.apple.com/documentation/usernotifications/setting_up_a_remote_notification_server/sending_notification_requests_to_apns)

See above official documentation to construct a notification post request. Note that you will need to encrypt your key file into *Authentication* header value. See below for detail for encryption.

[Establishing a Token-Based Connection to APNs | Apple Developer Documentation](https://developer.apple.com/documentation/usernotifications/setting_up_a_remote_notification_server/establishing_a_token-based_connection_to_apns)
