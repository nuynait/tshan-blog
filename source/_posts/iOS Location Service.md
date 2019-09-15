---
title: iOS Location Service
date: 2016-11-02
tags:
desc:
---

This post talks about the basic for ios location service. How to setup the `CLLocationManager` to get user\'s current location? For Xcode 8.1, Swift 3.0

<!--more-->

# iOS Location Service
I created this notes when I am implementing the navigation app for Mapsted. In any case we should fetch as less as location data possible to avoid battery drain so avoid getting location data constantly if possible.

# Link Framework and Service Info Plist
First step is to link the necessary framework and editing the `info.plist` to indicate the location access of the app.

`CoreLocation.framework` link the framework and import the header file `#import <CoreLocation/CoreLocation.h>`. I will do it in a bridge header since I am using the swift.

For plist, first is the new privacy request message required by iOS 10.0 `Privacy - Location Always Usage Description` or `Privacy - Location When In Use Usage Description` you can choose for what you need depending on how you want to use the location service. Then I need to editing the `Required device capabilities` array. Include `location-services` string if I want location service in general, and `gps` string if I want to use the gps hardware to provides accuracy.

# Getting User's Location Data
Depending how you want to use the location data, you should always think how frequent are you going to get the data information. Try to make it as less as possible. There are two service available that gives you the user\'s current location. `standard location service` and `significant-change location`

> The standard location service is a configurable, general-purpose solution for getting location data and tracking location changes for the specified level of accuracy.  

> The significant-change location service delivers updates only when there has been a significant change in the device's location, such as 500 meters or more.  

# Is Location Service Available?
```c
/* This seems not correct??
 You can call ~CLLocationManager.locationServiceEnabled()~ if returns ~true~,
 it means user has enabled the location service. If it returns ~false~, which
 means user has deny the location access and you access to user's location data
 anyway, it will report error to delegate. However when user first opens the
 app, that method returns ~false~ as well and for the first time access,
 instead of return an error, it will ask user if they want to enable the
 location access.
*/
```

## Update
Here is an update on `CLLocationManager.locationServiceEnabled()`. The above commented text are taken from the apple documentation, but when I use `CLLocationManager.locationServiceEnabled()`, it always returns true, not matter I enabled the location service or not. Here is some questions with the same problem. [1](http://stackoverflow.com/questions/4034095/locationservicesenabled-always-return-yes)

So now the question becomes how do I check if user has enabled the location service or not? This is what I use. `CLLocationManager.authorizationStatus() == CLAuthorizationStatus.denied`.

Also, we should always handle errors catches in `locationManager:didFailWithError`

## How to request for permission?
First, remember to set the `info.plist` like *this*. Then request for permission depends on what you need. `self.locationManager.requestWhenInUseAuthorization`, `self.locationManager.requestAlwaysAuthorization`.

It seems that when we manually request permission for locations, the request only works for the first time. If user disabled the location service, we need to capture using `CLLocationManager.locationServiceEnabled()` and pop up the `alertView` ourselves

# Start Standard Location Change
First create a location manager and store it inside the class property. If the location manager is already created, then we can reuse it.

Assign a delegate to update the result when user changes its location.

Setup the `desiredAccuracy` and `distanceFilter` to increase or decrease the frequency to fire the location change notification.

After everything all set, call `locationManager.startUpdatingLocation()` to start monitoring the location change in the background.

Below is the code I use to start a location service:

```swift
let locationService = CLLocationManager()

private func enableLocationService() {
  // check if user disabled location service
  if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.denied {
    // popup alert view let user go to setting and enable it
  }
  locationService.requestAlwaysAuthorization()
  locationService.delegate = self
  locationService.desiredAccuracy = kCLLocationAccuracyBestForNavigation
  locationService.distanceFilter = 10
  locationService.startUpdatingLocation()
}
```

## Handle the response
Adapt self to `CLLocationManagerDelegate` and implement the following method. Note that sometimes location manager will cache the old value result, so you should check if this is a recent update. Only accept a result that is not cached by comparing the location service time stamp. See code blow for details.

```swift
func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
  print("ERROR: location update error. ERROR: \(error.localizedDescription)")
}

func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
  guard let lastLocation = locations.last else {
    // error and abort in debug build
    return
  }
  let eventDate = lastLocation.timestamp
  let howRecent = fabs(eventDate.timeIntervalSinceNow)

  // make sure its a recent item, not a cached one.
  guard howRecent < 15 else { // seconds
    // discard the cached item
    return
  }

  print("latitude: \(lastLocation.coordinate.latitude), longitude: \(lastLocation.coordinate.longitude)")
}
```

# Reference
1.  [apple\'s official documentation](https://developer.apple.com/library/content/documentation/UserExperience/Conceptual/LocationAwarenessPG/CoreLocation/CoreLocation.html)
