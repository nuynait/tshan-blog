---
title: Apple Bluetooth LE Central
date: 2017-05-02
tags:
desc:
---

I personally has lots of experience with `CoreBluetooth`. I also did look at the `GATT` for sometime so I understand how service, characteristics, descriptor works. This note will focus mainly on implementation and how to make Android device work as peripheral and iOS as central to get data transfer from Android to iOS.

This blog will be updated in the future to finish all its contents.

<!--more-->

# iOS Central

[This](https://developer.apple.com/library/content/samplecode/BTLE_Transfer/Introduction/Intro.html#//apple_ref/doc/uid/DTS40012927-Intro-DontLinkElementID_2) code example worth a million words. It provide an example of a `Peripheral` role and a `Central` role.

Here is a brief explanation. For **Central**, it is responsible for scanning the device, connect, search for the specific peripheral and set notify to the characteristics. When anything updates, it receives the data comes every 20 bytes and combine them all at the end when finished.

So here are the steps in sequential.

## Check Bluetooth State

First, use `centralManagerDidUpdateState` to check the state of the Bluetooth. Handle all 5 states. `.poweredOn`, `.poweredOff`, `.resetting`, `.unauthorized`, `unknown`, `unsupported`. If the state is `.poweredOn`, scan for peripherals.

``` {.swift}
func centralManagerDidUpdateState(_ central: CBCentralManager) {
  switch central.state {
  case .poweredOn:
    scan()
  case .poweredOff:
    print("bluetooth is powered off.")
  case .resetting:
    print("bluetooth is resetting.")
  case .unauthorized:
    print("bluetooth is unauthorized.")
  case .unknown:
    print("bluetooth is unknown.")
  case .unsupported:
    print("bluetooth is unsupported.")
  }
}
```

## Scan

Provide a `uuid` to scan.

``` {.swift}
func scan() {
  centralManager.scanForPeripherals(withServices: [CBUUID(string: UUIDString)],
                                    options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])
  print("scan started")
}
```

## Discover

When a device with our specific `uuid` approach, the discover callback will get called. Check the `RSSI` if you want to filter distance for too far away. Then check if that device is already discovered. Finally, connect to the peripheral.

``` {.swift}
func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
  // Reject any where the value is above reasonable range
  if (RSSI.intValue > -15) {
    return
  }

  // Reject if the signal strength is too low to be close enough (Close is around -22dB)
  if (RSSI.intValue < -35) {
    return
  }

  print("Discovered \(String(describing: peripheral.name)) at \(RSSI)")

  // Have we already seen this device?
  if (self.discoveredPeripheral != peripheral) {

    // save a local copy of the peripheral, so CoreBluetooth doesn't get rid of it
    self.discoveredPeripheral = peripheral

    // And connect
    print("Connecting to peripheral \(peripheral)")
    centralManager.connect(peripheral, options: nil)
  }
}
```

## Connected

Now implement `didConnect` and `didFailToConnect` to see if `BLE` peripheral has connected successfully. If it connects, we can stop the scan, and assign `self` to `peripheral.delegate` and call `discoverService` with service `UUID`.

``` {.swift}
/** If the connection fails for whatever reason, we need to deal with it.
 */
func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
  print("Failed to connect to \(peripheral). \(String(describing: error?.localizedDescription))")

}

/** We've connected to the peripheral, now we need to discover the services and characteristics to find the 'transfer' characteristic.
 */
func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
  print("Peripheral Connected")

  // stop scanning
  centralManager.stopScan()

  print("Scanning Stopped")

  // clear the data that we may already have
  dataReceived = nil

  // make sure we get the discovery callbacks
  peripheral.delegate = self

  // search only for services that match our UUID
  peripheral.discoverServices([CBUUID(string: serviceUUIDString)])
}
```

## Did Discover Services

Service has been discovered successfully. Now we want to discover the characteristics inside the service.

``` {.swift}
func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
  if let e = error {
    print("error discovering services \(e)")
    cleanup()
    return
  }

  // Discover the characteristic we want

  // Loop through the newly filled peripheral.services array, just in case there's more than one.
  guard let services = peripheral.services else {
    return
  }
  for service in services {
    peripheral.discoverCharacteristics([CBUUID(string: characteristicUUIDString)], for: service)
  }
}
```

## Did Discover Characteristics

Now we have discover the characteristic we want. So set notify of that characteristic in order to subscribe to it.

``` {.swift}
/** The Transfer characteristic was discovered.
 *  Once this has been found, we want to subscribe to it, which lets the peripheral know we want the data it contains
 */
func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
  if let e = error {
    print("error discovering services \(e)")
    cleanup()
    return
  }
  print("Did discover characteristics")
  // Again, we loop through the array, just in case
  guard let characteristics = service.characteristics else {
    return
  }

  for characteristic in characteristics {
    if characteristic.uuid.isEqual(CBUUID(string: characteristicUUIDString)) {
      peripheral.setNotifyValue(true, for: characteristic)
    }
  }

  // once this is complete we just need to wait for the data to come in
}
```

## Get Notified

When central is updating the value, it will notify you that characteristic has changed. Then you get the `value` from the characteristic and append everything together if its one large data separates before send.

After received all data, we can choose to disconnects or keep the connection and waiting for new batch of data. Its all up to you.

``` {.swift}
/** This callback lets us know more data has arrived via notification on the characteristic
 */
func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
  if let e = error {
    print("Error discovering characteristics \(e)", e.localizedDescription)
    return
  }

  guard let value = characteristic.value else {
    return
  }

  let stringFromData = String(data: value, encoding: String.Encoding.utf8)

  // If we need to stop subscription after receive all data
  if (stringFromData == "EOM") {
    // data all sent

    // cancel our subscription to the characteristic
    peripheral.setNotifyValue(false, for: characteristic)

    // and disconnect from the peripheral
    centralManager.cancelPeripheralConnection(peripheral)
  }

  // Otherwise, just add the data on to what we already have
  dataReceived?.append(value)

  // Log it
  print("Received: \(String(describing: stringFromData))")
}
```

## Handle Connection Loss

We need to implement `didUpdateNotificationStateFor` as well to handle when we lost connection with the central. If we are no longer notify the central, call `cancelPeripheralConnection` to disconnect.

``` {.swift}
/** The peripheral letting us know whether our subscribe/unsubscribe happened or not
 */
func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
  if let e = error {print("Error changing notification state \(e.localizedDescription)")
  }

  // Exit if it's not the transfer characteristic
  if (!characteristic.uuid.isEqual(CBUUID(string: characteristicUUIDString))) {
    return
  }

  // Notification has started
  if (characteristic.isNotifying) {
    print("notification began on \(characteristic)")
  }

  // Notification has stopped
  else {
    // so disconnect from the peripheral
    print("Notification stopped on \(characteristic). Disconnecting")
    centralManager.cancelPeripheralConnection(peripheral)
  }
}
```

## After Disconnect Peripheral

When we successfully connects to peripheral, `didDisconnectPeripheral` will get called and you can handle anything there to clean things up. In the example below, it just clear out the peripheral it previously stored.

``` {.swift}
/** Once the disconnection happens, we need to clean up our local copy of the peripheral
 */
func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
  print("Peripheral Disconnected")
  discoveredPeripheral = nil
  scan()
}
```

## Manually Disconnect

This can happen on various case. For example, you just don\'t need to monitoring the device anymore. Or something went wrong and you want to clean everything up.

So the following code cancels any subscription if there are any, or straight disconnects if not.

``` {.swift}
/** Call this when things either go wrong, or you're done with the connection.
 *  This cancels any subscriptions if there are any, or straight disconnects if not.
 *  (didUpdateNotificationStateForCharacteristic will cancel the connection if a subscription is involved)
 */
func cleanup() {
  // don't do anything if we're not connected
  guard let peripheral = discoveredPeripheral, peripheral.state == .connected else {
    return
  }

  // see if we are subscribed to a characteristic on the peripheral
  if let services = self.discoveredPeripheral?.services {
    for service in services {
      if let characteristics = service.characteristics {
        for characteristic in characteristics {
          if characteristic.uuid == CBUUID(string: characteristicUUIDString) {
            if characteristic.isNotifying {
              // It is notifying, so unsubscribe
              discoveredPeripheral?.setNotifyValue(false, for: characteristic)

              // And we're done
              return
            }}}}}}

  // If we've got this far, we're connected, but we're not subsctibed, so we just disconnect
  centralManager.cancelPeripheralConnection(peripheral)
}
```
