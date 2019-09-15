---
title: Protected Property in Objective-C
date: 2017-04-21
tags:
desc:
---

Objective-C do not have protected property. The `ivars` are protected by default, but you still have to declare them in interface file in order to expose those variables. However, that is not what I can use. Because in the case that my private variables are `cpp` class but I can only expose `.h` to the header to `Swift`.

<!--more-->

# Protected Property
Objective-C do not have protected property. The `ivars` are protected by default, but you still have to declare them in interface file in order to expose those variables. However, that is not what I can use. Because in the case that my private variables are `cpp` class but I can only expose `.h` to the header to `Swift`.

So Another work around to expose the parent private methods to child classes are using a second header file.

# Solution
In `Parent.h`

``` objc
@interface Parent : NSObject
// Public Property and Methods
// ...
@end
```

In `Parent.mm`

``` objc
#import "Parent.h"
@interface Parent()
// property goes here becomes private
// ...
@end

@implementation Parent

@end
```

In `Child.h`

``` objc
#import "Parent.h"

@interface Child : Parent
// Public Property and Methods

@end
```

In `Child.mm`

``` objc
#import "Child.h"

@interface Child()
// private property for child only
// ...
@end

@implementation Child

@end
```

Above is an example I am going to use. Assume we have some property for `Parent` that I want to expose to `Child` only which are `protected` properties. Here is a step by step solution on how to achieve this.

## Create a Second Header For Parent
First step is to create a second Header file for parent.

In `Parent_Protected.h`

``` objc
#import "Parent.h"
@interface Parent()
@property NSInteger protectedInt;
@end
```

## Import into Parent
Import the second header file in `Parent.mm`

In `Parent.mm`

``` objc
#import "Parent.h"
#import "Parent_Protected.h"

@interface Parent()
// property goes here becomes private
// ...
- (NSInteger)getProtectedInt;
@end

@implementation Parent
- (NSInteger)getProtectedInt {
  return _protectedInt;
}
@end
```

## Import into Child
Import the second header file in `Child.mm`

In `Child.mm`

```objc
#import "Child.h"
#import "Parent_Protected.h"

@interface Child()
// private property for child only
// ...
- (NSInteger)getParentInt;
@end

@implementation Child
- (NSInteger)getParentInt {
  return [super protectedInt];
}
@end
```

Note that you need to use `[super xxx]` to access the property. If you use `_xxx` it may end up complain `Use of undeclared identifier`.
