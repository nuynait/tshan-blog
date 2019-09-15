---
title: File Management in Swift
date: 2017-04-08
tags:
desc:
---

This note including everything I need to with file management on iOS. So it will have notes mostly on [File Manager](https://developer.apple.com/reference/foundation/filemanager) usage. Methods for permanent data storage with files are also included in this note.

<!--more-->

# Get File or Folder Path
## Get Document Directory
The iOS uses the sandbox system to protect users privacy. If you want to save your data into files on iOS, you have to do it in the document directory. Here is how to get the document directory `URL`.

```swift
func getDocumentDirURL() -> URL? {
  do {
    return try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
  } catch _ {
    // catch error
    return nil
  }
}
```

## Append File or Folder Path
In order to get the file, we need to append the url after the document directory. First we get document directory URL. Next we write the folder or file name in string and then use `appendingPathComponent` function to get the full url for the file or folder.

```swift
/* Usage Example:
 * let fileURL = getFileURL(filename: "example.json")
 */
func getFileURL(filename: String) -> URL? {
  if let docURL = getDocumentURL() {
    return docURL.appendingPathComponent(filename)
  }
  return nil
}
```

## Get file directly from the main bundle
Main bundle means the `workspace` folder. If we want to read a file in the development folder, we need to create a folder `Resources` and put files under `Resources`.

For example, we have `repo/proj/proj/Resources/data.csv` file that we want to get the path for the file.

```objc
NSString *filePath = [[NSBundle mainBundle] pathForResources:@"data" ofType:@"csv"];
```

# Get Contents From the File
First we get the url for that file. Then we get the content of that URL using different methods depending on the format I want.

## Get Data From The File
Create a `Data` object using the constructor `Data(contentsOf: url)`

```swift
func getDataFrom(url: URL) -> Data? {
  do {
    let data = try Data(contentsOf: url)
    return data
  } catch _ {
    // error handling
    return nil
  }
}
```

## Read String Line By Line From The File
Sometimes, we want to read from a file line by line. In this case we create the `string` using [constructor](https://developer.apple.com/reference/foundation/nsstring/1497269-stringwithcontentsoffile) `stringWithContentsOfFile`. First, we get a string for the whole file, then we separate the string with the newline character. As a result, we get an array of string separated by lines.

Note that `stringWithContentsOfFile` takes a string of path. So we can get it by accessing the `path` property of an `URL`.

```swift
func readLineByLine(url: URL) {
  do {
    let file: String = try String(contentsOfFile: url.path, encoding: .utf8)
    let allLines: String = data.components(separatedBy: .newlines)
    for line in allLines {
      // do whatever you want to each line
    }
  } catch _ {
    // error handling
    return
  }
}
```

# Objects Permanent Storage and JSON Files
People usually use `core data` to store app data permanently on disk. Sometimes, I choose to convert objects into `json` files manually. I found out that it will be easier if I want to support my app to the android platform in that case.

So there are several things needed in order to convert objects into `json` files and later to load these objects from the disk.

We need [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON) framework here for easier `json` parsing.

For easier description, we will use the following example. Assume we have an item object, which contain a number `id` and a string `data` and we want to save an `array of item` in to the disk to load later.

We want to load that `array of item` when app starts and save it to disk any time we add an `item` into the array.

```swift
class Item {
  let id: Int
  let data: String

  init(id: Int, data: String) {
    self.id = id
    self.data = data
  }

  init(json: JSON) {
    // ...
  }

  func toDict() -> Dictionary<String, Any> {
    // ...
  }
}

class ItemManager {
  let items: [Item] = [] // assume we create items and add to this array at app run time.

  func saveToDisk() {
    // ...
  }

  func loadFromDisk() {
    // ...
  }
}
```

## Changes to Item Class

First of all, we need two methods from the `Item`. One is to initialize the object from a `JSON`. The other one is to convert the object into a `dictionary`. The key for the dictionary is `string`, the value will be `any` because it can be `int`, `string`, `data`, etc.

So this is what we add into the `Item` class:

```swift
class Item {
  let id: Int
  let data: String

  init(id: Int, data: String) {
    self.id = id
    self.data = data
  }

  init(json: JSON) {
    self.id = json["id"].int ?? 0
    self.data = json["data"].string ?? 0
  }

  func toDict() -> Dictionary<String, Any> {
    let dict: [String: Any] = [
      "id"   : self.id,
      "data" : self.data
    ]

    return dict
  }
}
```

Here is what we need to be careful at.

When we get an item from the `JSON`, it will returns nil if the key does not exists or if the value type doesn't match. So in the constructor, we might want to handle the null case correctly maybe log an error message when we cannot find the value from the `JSON`.

The key in the constructor and the key used in `toDict()` has to be match. Otherwise it might get null when fetch items from the `JSON`.

## Changes to Manager Class
For manager, we need to implement two functions, one is `loadFromDisk()`, the other one is `saveToDisk()`. To make things easier, the `loadFromDisk()` load everything on disk into the item array, and `saveToDisk()` save everything in the item array onto the disk.

For `loadFromDisk()` we first get the `data` from the `url` and then create a `JSON` objects from the `data`. This function will be called when app launches.

For `saveToDisk()` we first convert the `array of Item` into `array of
   dictionary`. We get the dictionary for each item using the `toDict:` function we implemented. Then we convert dictionary into `JSON` and get the `raw data` from the `JSON` objects.

``` swift
class ItemManager {
  let items: [Item] = [] // assume we create items and add to this array at app run time.

  // call everytime item changes
  func saveToDisk(url: URL) {
    let dictArray: [[String: Any]] = items.map { x in return {x.toDict()} }
    do {
      let jsonData = try JSON(dictArray).rawData()
      try jsonData.write(to: url, options: .atomicWrite)
    } catch _ {
      // error handling
      return
    }
  }

  // call at app launches
  func loadFromDisk(url: URL) {
    do {
      let jsonData = try Data(contentsOf: url)
      let arrayJSON:[JSON] = JSON(data: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers, error: nil).arrayValue

      for itemJSON in arrayJSON {
        let item: Item = Item(json: itemJSON)
        items.append(item)
      }
    } catch _ {
      // error handling
      return
    }
  }
}
```

## Optimizations
Right now this method is easy to implement but it is not the most optimize way to do things. Obviously every time when I save to disk I rewrite the whole file again with every item in the array. We may easily optimize this by tracking which file is loaded from the disk and has been changed etc.

# Create Folder
First get the parent folder `url` and then append the folder name after the `url`. Remember that the folder name should end with \'*\'. An example of a folder name will be \"folder*\".

```swift
func createFolder(parentURL: URL, folderName: String) {
  try {
    // make sure folderName string ends with '/'
    guard let folderURL = getDocumentDirURL()?.appendingPathComponent(folderName) else {
      // error handling, appending folder path failed
      return
    }

    try FileManager.default.createDirectory(atPath: folderURL.path, withIntermediateDirectories: true, attributes: nil)
  } catch _ {
    // error handling
    return
  }
}
```

# Remove From Disk
First get the `url` of the file or folder you want to remove and then call `removeItem`.

```swift
func delete(path: URL) {
  do {
    try FileManager().removeItem(at: path)
  } catch _ {
    // error handling
    return
  }
}
```
