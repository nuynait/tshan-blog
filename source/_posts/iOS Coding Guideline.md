---
title: iOS Coding Guideline
date: 2019-01-16
tags:
desc:
---

This is about iOS coding style convention.
<!--more-->

# Naming Convention
## Object Name
Object name starts with `MN` as `Mapsted Navigation`.

## Property Name
For private class property, starts with `_` followed by a lower camel case character. For example:

```swift
private var buildingData: MNBuildingData 	// [Not Preferred]
private var _buildingData: MNBuildingData 	// [Preferred]
```

## Enums
Enums should always use upper camel case.  Case for enum uses lower camel case. For example:

```swift
enum LayerType {
	case building, property
}
```

# Swift Coding Style
## Constants vs Variable
Constants are defined using `let` keyword. Always use `let` instead of `var` if the value will not change. *Tips:* A good technique is to define everything using let and only change it to `var` if the compiler complains.

## Optional
Only define optional variable where a `nil` value is acceptable. Don’t use `!` unless for `@IBOutlet`.  Avoid naming optional variables to something like `optionalValue` or `stringNilable`

## Spacing
Indent using 2 space rather than tabs to conserve space and help prevent line wrapping. Make sure to set this in Xcode.

For method `{}` brackets or `if`/`else`/`switch`/`while`, always open on the same line as the statement but close on a new line.

*Preferred:*
```swift
if bool {
  // do something
} else {
  // do something
}
```

*Not preferred:*
```swift
if bool
{
  // do something
} else
{
  // do something else
}
```

## Use of Self
Use `self.` only when required by the compiler. (In `@escaping` closures, or in initializers to disambiguate properties from arguments). In other words, if it compiles without `self` then omit it.

## Switch
Switch should cover all the cases if necessary, do not use default unless really needed.

## Access Control
Always using `private` if the function does not access from outside the class. Only using `fileprivate`, `open`, `public`, `internal` when you require a full access control specification. Always using an access control specifier before any function, class properties unless it’s a function coming from coca-touch or any third-party libraries. The access control specifier should always be the first one.

*Preferred:*
```swift
class A {
  private dynamic lazy var b = B()
  private func calc() {
    // do something
  }
}
```

*Not Preferred:*
```swift
class A {
  lazy dynamic private var b = B() // specifier order matters
  func calc() { // missing access control
    // do something
  }
}
```

# Objective-C Coding Style
For Objective-C coding convention, we mostly adapt to apple’s coding guidelines for cocoa and adding some our own changes. Apple’s coding guidelines can be found in [Introduction to Coding Guidelines for Cocoa](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/CodingGuidelines/CodingGuidelines.html#//apple_ref/doc/uid/10000146-SW1). Below will include anything important in that guideline as well.

## Defining Methods
[Naming Methods](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/CodingGuidelines/Articles/NamingMethods.html)

Here is how you want to define methods, please notice how I use space in this example.

```objc
- (type)doIt;
- (type)doItWithA:(type)a;
- (type)doItWithA:(type)a b:(type)b;
```

*Here is a list of rules for naming methods.*

1. Start the name with a lowercase letter and capitalize the first letter of embedded words.
2. For methods that represents actions an object takes, start the name with a verb:
```objc
- (void)invokeWithTarget:(id)target;
- (void)selectTabViewItem:(NSTabViewItem *)tabViewItem
```
3. If the method returns an attribute of the receiver, name the method after the attribute. The use of the “get” is unnecessary, unless one or more values are returned indirectly.
```objc
- (NSSize)cellSize 		//right
- (NSSize)calcCellSize 	//wrong
- (NSSize)getCellSize		//wrong
```
4. Use keywords before all arguments
```objc
- (void)sendAction:(SEL)aSelector toObject:(id)anObject forAllCells:(BOOL)flag;	//right
- (void)sendAction:(SEL)aSelector anObject:(id)anObject flag:(BOOL)flag; 		//not good
- (void)sendAction:(SEL)aSelector :(id)anObject :(BOOL)flag; 					//wrong
```
5. Make the word before the argument describe the argument
```objc
- (id)viewWithTag:(NSInteger)aTag; 	//right
- (id)taggedView:(int)aTag; 			//wrong
```

### Accessor Methods
Accessor methods are methods that set and return the value of a property of an object. They have certain recommended forms, depending on how the property is expressed.

1. If the property is expressed as a noun, the format is:
```objc
- (type)noun;
- (void)setNoun:(NSString *)aNoun;

// For example:
- (NSString *)title;
- (void)setTitle:(NSString *)aTitle;
```
2. If the property is expressed as an adjective, the format is:
```objc
- (BOOL)isAdjective;
- (void)setAdjective:(BOOL)flag;

// For example:
- (BOOL)isEditable;
- (void)setEditable:(BOOL)flag;
```
3. If the property is expressed as a verb, the format is:
```objc
- (BOOL)verbObject;
- (void)setVerbObject:(BOOL)flag;

// For example:
- (BOOL)showsAlpha;
- (void)setShowsAlpha:(BOOL)flag;
```
The verb should be in the simple present tense. You may use modal verbs (verbs preceded by “can”, “should”, “will” and so on) to clarify meaning, but don’t use “do” or “does”. For example:
```objc
- (void)setCanHide:(BOOL)flag; 				//right
- (BOOL)canHide; 								//right
- (void)setShouldCloseDocument:(BOOL)flag;	//right
- (BOOL)shouldCloseDocument;					//right
- (void)setDoesAcceptGlyphInfo:(BOOL)flag;	//wrong
- (BOOL)doesAcceptGlyphInfo;					//wrong
```
4. Use “get” only for methods that return objects and values indirectly. You should use this form for methods only when multiple items need to be returned. For example:
```objc
- (void)getLineDash:(float *)pattern count:(int *)count phase:(float *)phase;
```
