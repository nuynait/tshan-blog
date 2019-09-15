---
title: Apple Bluetooth LE Peripheral
date: 2017-05-02
tags:
desc:
---

I personally has lots of experience with `CoreBluetooth`. I also did look at the `GATT` for sometime so I understand how service, characteristics, descriptor works. This note will focus mainly on implementation and how to make Android device work as peripheral and iOS as central to get data transfer from Android to iOS.

This blog will be updated in the future to finish all its contents.

<!--more-->


# Android Peripheral

Android peripheral is different a little bit from iOS. First its advertise and `GATT` service are separates. So let\'s take about advertise first.

## Advertise

We need a `BluetoothLeAdvertiser`, `AdvertiseCallback` to do the job. First, we need to check if the device supports Bluetooth Low Energy. Keep in mind that even if the device supports Bluetooth Low Energy, it can still don\'t support advertise or scan.

So first define class variables.

``` {.java}
private BluetoothLeAdvertiser mBLEAdvertiser;
private final AdvertiseCallback mAdvCallback = new AdvertiseCallback() {
  @Override
  public void onStartSuccess(AdvertiseSettings settingsInEffect) {
    super.onStartSuccess(settingsInEffect);
    Toast.makeText(mContext, "Advertise Start Successfully", Toast.LENGTH_SHORT).show();
    Log.d(LOG_TAG, "Advertise Start Successfully");
  }

  @Override
  public void onStartFailure(int errorCode) {
    super.onStartFailure(errorCode);
    Toast.makeText(mContext, "Advertise Start Error, Code " + String.valueOf(errorCode), Toast.LENGTH_SHORT).show();
    Log.e(LOG_TAG, "Advertise Start Error, Code " + String.valueOf(errorCode));
  }
};
```

Check if support Bluetooth Low Energy and initialize advertiser.

``` {.java}
public Boolean initializeBTLE() {
  boolean hasBLE = mContext.getPackageManager().hasSystemFeature(PackageManager.FEATURE_BLUETOOTH_LE);
  if (!hasBLE) {
    Toast.makeText(mContext, "Bluetooth Low Energy Not Supported On Phone", Toast.LENGTH_SHORT).show();
    Log.e(LOG_TAG, "Bluetooth Low Energy Not Supported On Phone.");
    return false;
  }

  mBLEAdvertiser = BluetoothAdapter.getDefaultAdapter().getBluetoothLeAdvertiser();
  if (mBLEAdvertiser == null) {
    Toast.makeText(mContext, "Cannot Initialize BTLE Advertiser", Toast.LENGTH_SHORT).show();
    Log.e(LOG_TAG, "Cannot Initialize BTLE Advertiser.");
    return false;
  }

  // this will mention later about how to create gatt server
  return createGattService();
}
```

Now write the advertise function. Initialize `advSetting` and `advData`. We need to pass in a `ParcelUuid` as service `UUID` for advertise. This service `UUID` is for advertise only and has no connection with `GATT` protocol. Call the `startAdvertise` and pass in the setting and data we just created and the advertise callback function we created before.

``` {.java}
public void startAdvertise() {
  AdvertiseSettings advSettings = new AdvertiseSettings.Builder()
    .setAdvertiseMode(AdvertiseSettings.ADVERTISE_MODE_LOW_LATENCY)
    .setTxPowerLevel(AdvertiseSettings.ADVERTISE_TX_POWER_HIGH)
    .setConnectable(true)
    .build();

  ParcelUuid deviceUUID = ParcelUuid.fromString(mContext.getString(R.string.ble_uuid));
  AdvertiseData advData = new AdvertiseData.Builder()
    .addServiceUuid(deviceUUID)
    .build();

  if (advSettings == null || advData == null) {
    Toast.makeText(mContext, "Cannot create AdvertiseSettings or AdvertiseData", Toast.LENGTH_SHORT).show();
    Log.e(LOG_TAG, "Cannot create AdvertiseSettings or AdvertiseData");
    return;
  }

  mBLEAdvertiser.startAdvertising(advSettings, advData, mAdvCallback);
}
```

If we ever need to stop the advertise process, this is what we do.

``` {.java}
public void stopAdvertise() {
  if (mBLEAdvertiser != null && mAdvCallback != null) {
    mBLEAdvertiser.stopAdvertising(mAdvCallback);
  }
}
```

## GATT Server

Now at this point, the iOS Central should be able to discover the Android Peripheral device. We need to continue setting up a `GATT` server to make iOS connectable.

So we need a `BluetoothManager`, a `BluetoothGattServer`, a `BluetoothGattCharacteristic`, a `BluetoothGattServerCallBack`.

For other objects such as `BluetoothGATTService` etc, we can have them locally in function. The reason that `BluetoothGattCharacteristic` needs to be a class property is because we need to set value for characteristic when notify the peripheral.

Here are the initializations.

``` {.java}
private BluetoothManager mManager;
private BluetoothGattServer mGattServer;
private BluetoothGattCharacteristic mCharacteristic;

private Boolean createGattService() {
  mManager = (BluetoothManager)mContext.getSystemService(Context.BLUETOOTH_SERVICE);
  if (mManager == null) {
    Toast.makeText(mContext, "Cannot Initialize Bluetooth Manager", Toast.LENGTH_SHORT).show();
    Log.e(LOG_TAG, "Cannot Initialize Bluetooth Manager.");
    return false;
  }

  mGattServer = mManager.openGattServer(mContext, mGattServerCallback);
  if (mGattServer == null) {
    Toast.makeText(mContext, "Cannot Create Gatt Server", Toast.LENGTH_SHORT).show();
    Log.e(LOG_TAG, "Cannot Create Gatt Server.");
    return false;
  }

  // Setup service and characteristic.
  addDeviceService();
  return true;
}
```

Now for creating service and characteristic, we need to have two more individual uuid for service and characteristic. It should be different from the device uuid we used before for advertise.

If we need peripheral to subscribe characteristic, we need to implement a Descriptor with a specific uuid `00002902-0000-1000-8000-00805F9B34FB`.

This uuid is found in [Bluetooth SIG](https://www.bluetooth.com/specifications/gatt/descriptors) as Client Characteristic Configuration. From the Doc, the Assigned Number for that is `0x2902` add base UUID to convert it from 16 bit to 128 bit. [Here](http://stackoverflow.com/questions/36212020/how-can-i-convert-a-bluetooth-16-bit-service-uuid-into-a-128-bit-uuid) is the introduction on how to convert.

Moreover we need to give it a write permission and implement the `onDescriptorWriteRequest` for `BluetoothGATTServerCallBack`

``` {.java}
private void addDeviceService() {
    // Remove previous Service
    BluetoothGattService previousService = mGattServer.getService(UUID.fromString(mContext.getString(R.string.service_uuid)));
    if (previousService != null) {
        mGattServer.removeService(previousService);
    }

    // Create new service and characteristics
    mCharacteristic = new BluetoothGattCharacteristic(
                                                      UUID.fromString(mContext.getString(R.string.characteristic_uuid)),
                                                      BluetoothGattCharacteristic.PROPERTY_NOTIFY,
                                                      BluetoothGattCharacteristic.PERMISSION_READ);

    BluetoothGattDescriptor myDescriptor = new BluetoothGattDescriptor(
                                                                       UUID.fromString(mContext.getString(R.string.notify_descriptor_uuid)),
                                                                       BluetoothGattDescriptor.PERMISSION_WRITE | BluetoothGattDescriptor.PERMISSION_READ);
    mCharacteristic.addDescriptor(myDescriptor);

    mService = new BluetoothGattService(
                                        UUID.fromString(mContext.getString(R.string.service_uuid)),
                                        BluetoothGattService.SERVICE_TYPE_PRIMARY);

    mService.addCharacteristic(mCharacteristic);
    mGattServer.addService(mService);
}
```

Now we need to implement the `BluetoothGattServerCallback`. There are couple callbacks we need to handle in order to make it works. First is `onDescriptorWriteRequest`. We need to call `mGattServer.sendResponse(...)`. That callback gets called when peripheral asked to notify a characteristics and `sendResponse` tells peripheral that notify success.

``` {.java}
private final BluetoothGattServerCallback mGattServerCallback = new BluetoothGattServerCallback() {
        @Override
        public void onDescriptorWriteRequest(BluetoothDevice device, int requestId, BluetoothGattDescriptor descriptor, boolean preparedWrite, boolean responseNeeded, int offset, byte[] value) {
            super.onDescriptorWriteRequest(device, requestId, descriptor, preparedWrite, responseNeeded, offset, value);
            mGattServer.sendResponse(device, requestId, BluetoothGatt.GATT_SUCCESS, offset, value);
        }
    };
```

Now the peripheral is able to notify the characteristics and we can send data whatever and whenever we want.

## Send Data

When sending data, every time we set value in characteristic and then notify the client. For each notify, we can only put maximum 20 bytes of data into the characteristic. So if we want to send data more than 20 bytes, this is what we do.

We notify it several times and send an \"EOF\" string to indicate that data has been all sent and on peripheral we can then combine all received data together.

So first I wrote a `DataSendManager` class. Calling the constructor to pass-in the total data we want to send. And each time we set data in characteristics, we call `getNextData()` to get the chunk of the data we need to send. If `getNextData()` returns null, then all data including the \"EOF\" string has been sent.

Here is the `DataSendManager` class.

``` {.java}
class DataSendManager {
    private final String LOG_TAG = "Data Sender";
    private final int MAX_DATA_LENGTH = 20; // bytes
    private final byte[] EOF = "EOF".getBytes(Charset.forName("UTF-8"));

    private byte[] data;
    private int startIndex;
    private boolean isFinished;

    DataSendManager(String stringToSend) {
        data = stringToSend.getBytes(Charset.forName("UTF-8"));
        initializeManager();
    }

    DataSendManager(byte[] data) {
        this.data = data;
        initializeManager();
    }

    private void initializeManager() {
        startIndex = 0;
        isFinished = false;
    }

    public byte[] getNextData() {
        if (isFinished) {
            return null;
        }

        if (startIndex == data.length - 1) {
            Log.d(LOG_TAG, "All data has been sent. Send EOF");
            isFinished = true;
            return EOF;
        }

        int endIndex = startIndex + MAX_DATA_LENGTH >= data.length ? data.length : startIndex + MAX_DATA_LENGTH;
        byte[] dataToSend = Arrays.copyOfRange(data, startIndex, endIndex);
        startIndex = endIndex - 1;
        return dataToSend;
    }
}
```

Here is an example for sending the data.

``` {.java}
public void sendLocTo(byte[] data) {
    DataSendManager mDataSendManager = new DataSendManager(data);
    byte[] dataToSend = mDataSendManager.getNextData();
    while (dataToSend != null) {
        mCharacteristic.setValue(dataToSend);
        for (BluetoothDevice subscribedDevice : mSubscribedDevices) {
            mGattServer.notifyCharacteristicChanged(subscribedDevice, mCharacteristic, false);
        }
        dataToSend = mDataSendManager.getNextData();
    }
}
```
