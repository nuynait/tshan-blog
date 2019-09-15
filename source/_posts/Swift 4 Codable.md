---
title: Swift 4 Codable
date: 2019-02-09
tags:
desc:
---

Swift4 makes JSON serialization easier than ever. If you want an object to be encodable, Adapt to `Encodable`  protocols. If you want an object to be decodable, adapt to `Decodable` protocols. `Codable` protocols is for objects that both encodable and decodable.
<!--more-->

# Automatic Encoding and Decoding
```swift
struct Employee: Codable {
    var name: String
    var id: Int
}
```

Now this class can be serialize or deserialize to JSON. Isn’t that convenient?  Also if you have an object as a property inside another object, conform to `Codable` too.

```swift
struct Employee: Codable {
    var name: String
    var id: Int
    var salary: Salary
}

struct Salary: Codable {
    var amount: int
    var tax: Int
}
```

The above class can also be serialize or deserialize to JSON.

# Encoder and Decoder
`Encoder` works to turn `Encodable` objects to JSON serialized string. `Decoder` works to turn JSON serialized string into `Decodable` objects.

**Here is how you encode:**
```swift
let jsonEncoder = JSONEncoder()
let jsonData = try jsonEncoder.encode(object)
let jsonString = String(data: jsonData, encoding: .utf8)
```

**Here is how you decode:**
```swift
let jsonDecoder = JSONDecoder()
let object = try jsonDecoder.decode(Object.self, from: object)
```

# Renaming Properties With CodingKeys
If you want to have different keys then your property name in your serialized string, you will have to implement a CodingKey enum. Note that you will need to include all properties in the enum even if you don’t plan to rename all of them.

```swift
struct Employee: Codable {
  var name: String
  var id: Int
  var salary: Salary

  enum CodingKeys: String, CodingKey {
    case id = "employeeId"
    case name
    case salary
  }
}
```

# Manual Encoding and Decoding
If in some case you want to alter the structure of the `JSON` not just rename the properties, you will need to write your own encoding and decoding logic.

For example, you don’t want to have the following  `JSON`:
```json
{
  "name": "Jerry"
  "employeeId": 763246
  "salary": {
    "amount": 85000
    "tax": 25000
}
```

Instead you want the following `JSON`:
```json
{
  "name": "Jerry"
  "employeeId": 763246
  "amount": 85000
  "tax": 25000
}
```

You will have to change the following in `CodingKeys`, the key enum case contains the key for the json. So you need to add `case amount` and `case tax` since they are both the key to the serialized string.
```swift
struct Employee: Codable {
  var name: String
  var id: Int
  var salary: Salary

  enum CodingKeys: String, CodingKey {
    case id = "employeeId"
    case name
    case amount
    case tax
  }
}
```

**For encode:**
```swift
extension Employee: Encodable {
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(name, forKey: .name)
    try container.encode(id, forKey: .id)
    try container.encode(salary.amount, forKey: .amount)
    try container.encode(salary.tax, forKey: .tax)
  }
}
```

**For decode**
```swift
extension Employee: Decodable {
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    name = try container.decode(String.self, forKey: .name)
    id = try container.decode(Int.self, forKey: .id)
    let amount = try container.decode(Int.self, forKey: .amount)
    let tax = try container.decode(Int.self, forKey: .tax)
    salary = Salary(amount: amount, tax: tax)
  }
}
```

## Inheritance of Encodable / Decodable
You have to override the `encode`  or `init:decoder` in your subclass and call super before the regular instructions.

For example of encode: [Code sample from Stack Overflow](https://stackoverflow.com/a/48255318/2581637)
```swift
class BasicData {
    let a: String
    let b: Int

    private enum CodingKeys: String, CodingKey {
        case a, b
    }

    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.a, forKey: .a)
        try container.encode(self.b, forKey: .b)
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        _a = try container.decode(String.self, forKey .a)
        _b = try container.decode(Int.self, forkey .b)
    }
}

// In its subclass, you will need to override both encode and init:from.
class AdditionalData: BasicData {
    let c: String
    let d: Int

    init(c: String, d: Int) {
        self.c = c
        self.d = d
    }

    private enum CodingKeys: String, CodingKey {
        case c, d
    }

    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.c, forKey: .c)
        try container.encode(self.d, forKey: .d)

        try super.encode(to: encoder)  // don't forget to call super
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        _c = try container.decode(String.self, forKey .c)
        _d = try container.decode(Int.self, forkey .d)

        try super.init(from: decoder)  //  don't forget to call super
    }
}
```

**NOTE:** When doing research, I found that there is some resource out there that passes `container.superEncoder` and `container.superDecoder` into the super class methods. For example: [swift4 - Using Decodable in Swift 4 with Inheritance - Stack Overflow](https://stackoverflow.com/a/44605696/2581637). However, when I try in my `QuestIt` project, I found that it will create a new subentry called `super: { ... }` in serialized JSON, but those are just redundant data because everything inside that super section is already exists in outside super. So that’s not a very good solution. I recommand to pass in `encoder` or `decoder` directly to super.
