---
title: Init Core Data For Framework Projects
date: 2017-11-12
tags:
desc:
---
How to init the core data `NSManagedObjectContext`?
<!--more-->

# Init Core Data
I learned this from [this stackoverflow post](https://stackoverflow.com/a/33460505/2581637). By default apple core data template suggests:

```swift
func initCoreData() {
  // This resource is the same name as your xcdatamodeld contained in your project.
  guard let modelURL = Bundle.main.url(forResource: "DataModelFileName", withExtension: "momd") else {
    fatalError("Error loading model from bundle")
  }

  // The managed object model for the application. It is a fatal error for
  // the application not to be able to find and load its model.
  guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
    fatalError("Error initializing mom from: \(modelURL)")
  }
  let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
  managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
  managedObjectContext.persistentStoreCoordinator = psc

  // If not using async, it might take too long for the app to load.
  // If it take too long for the app to load, iOS will terminate app launch.
  // If you have handle async yourself, remove async if needed.
  DispatchQueue.global().async {
    let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let docURL = urls[urls.endIndex-1]
    /* The directory the application uses to store the Core Data store file.
     This code uses a file named "DataModel.sqlite" in the application's documents directory.
     */
    let storeURL = docURL.appendingPathComponent("DataModel.sqlite")
    do {
      MNActivityManager.shared.update(title: "Preparing Database", subtitle: "Adding Presistant Storage")
      // This resource is the same name as your xcdatamodeld contained in your project.
      try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
    } catch {
      fatalError("Error migrating store: \(error)")
    }
  }
}
```

Now we need to change the part on where we get the `modelURL`. Instead of using `Bundle.main`, we need to get the framework bundle.

```swift
// assume project bundle id is "com.example.bundle"
guard let bundle = Bundle(identifier: "com.example.bundle"),
      let modelURL = bundle.url(forResource: "DataModelFileName", withExtension: "momd") else {
  fatalError("Error loading model from bundle")
}
```
