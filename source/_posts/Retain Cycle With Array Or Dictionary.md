---
title: Retain Cycle With Array Or Dictionary
date: 2018-02-12
tags:
desc:
---

The question is will it create a retain cycle if we have an array  (dictionary) of objects where the object is owned elsewhere? A short answer is **YES** it will.
<!--more-->

# Experiments
I created a background project to test if the object in array / dictionary will create retain cycle.

## Array
```swift
class Retain {
  var a = "retain"

  deinit {
    print("deinit Retain")
  }
}

class TestArray {
  var arrayOfRetain: [Retain] = []

  func addToArray(retain: Retain) {
    arrayOfRetain.append(retain)
  }
}

var retain = Retain()
let testArray = TestArray()
testArray.addToArray(retain: retain)
retain = Retain()
```

For the above code, `"deist Retain"` should be printed if it does not create any retain cycle. Because `var retain` has been reassigned, and the original `Retain` should call `deinit` to free from the memory.  Result is array will create a retain cycle.

## Dictionary
```swift
class Retain {
  var a = "retain"

  deinit {
    print("deinit Retain")
  }
}

class TestDictionary {
  var dict: [Int: Retain] = [:]
  func addToDict(retain: Retain) {
    dict[0] = retain
  }
}

var retain = Retain()
let testDictionary = TestDictionary()
testDictionary.addToDict(retain: retain)
retain = Retain()
```

For the above code, `"deist Retain"` should be printed if it does not create any retain cycle. Because `var retain` has been reassigned, and the original `Retain` should call `deinit` to free from the memory.  Result is dictionary will create a retain cycle.

# Solution
You can use `NSHashTable`. You will need to init with `NSHashTable<AnyObject>.weakObjects()` . I found the solution from [How to avoid a retain cycle when using an array of delegates in Swift - Stack Overflow](https://stackoverflow.com/a/42460276/2581637) post.’

For dictionary, use `NSMapTable`.

**Other references:**
[NSHashTable & NSMapTable - NSHipster](https://nshipster.com/nshashtable-and-nsmaptable/)

## Array
```swift
class TestArraySolution() {
  private var array = NSHashTable<Retain>.weakObjects()

  func addToArray(item: Retain) {
    array.add(retain)
  }

  func getArray() -> [Retain] {
    array.allObjects as! [Retain]
  }

  func get(_ index: Int) -> Retain? {
    if let result = array.member(obj) as? Retain {
      return result
    }
    return nil
  }
}
```

## Dictionary
```swift
class TestDictionarySolution {
  private var dict: NSMapTable<NSNumber, Retain> = NSMapTable(keyOptions: .strongMemory, valueOptions: .weakMemory)

  func addToDict(key: Int, retain: Retain) {
    dict.setObject(retain, forKey: NSNumber(value: key))
  }

  func get(key: Int) -> Retain? {
    return dict.object(forKey: NSNumber(value: key))
  }
}
```

### Subscripting
The `NSMapTable` do not have subscripting like dictionary do. Here is how you can implement subscripting for `NSMapTable` using extension.

```swift
extension NSMapTable {
    subscript(key: AnyObject) -> AnyObject? {
        get {
            return objectForKey(key)
        }

        set {
            if newValue != nil {
                setObject(newValue, forKey: key)
            } else {
                removeObjectForKey(key)
            }
        }
    }
}
```
