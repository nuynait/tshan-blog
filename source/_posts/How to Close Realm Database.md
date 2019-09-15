---
title: How to Close Realm Database
date: 2019-06-10
tags:
desc:
---

According to [Official Documentation](https://realm.io/docs/java/latest/#closing-realms), always close the realm instance when you done with them.
<!--more-->

# Best Practise Close Instance
``` java
try {
 Realm realm = Realm.getDefaultInstance();
 //Use the realm instance
} catch(Exception e) {
  //handle exceptions
} finally {
    realm.close();
}
```

if you use**minSdkVersion >= 19**and**Java >= 7**, you won’t close it manually.

``` java
try (Realm realm = Realm.getDefaultInstance()) {
// No need to close the Realm instance manually
}
```

Getting the above answer from the [this stackoverflow answer](https://stackoverflow.com/a/48930294/2581637)

## Kotlin
The `try (Realm realm = Realm.getDefaultInstance())` in *Java* is called **try-with-resource**. This is how we do in Kotlin:

``` kotlin
Realm.getDefaultInstance().use {
  // no need to close realm with .use keyword
	it.where(...).equalTo(...).findAll()
}
```

Note: You have to use **minSdkVersion >= 19**and**Java >= 7** in order to not close it manually.
