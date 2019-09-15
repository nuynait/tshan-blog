---
title: Import Third-Party Objective-C Framework into Swift Framework Project
date: 2017-11-09
tags:
desc:
---

How to import objective-c framework into a swift framework project?

<!--more-->

# Import Obj-C Framework To Swift Framework
Recently manager asked me to export some of my apps functions into a dynamic framework instead of keep them a whole app. So I was fighting on extracting the code into a framework project. When I extract the map, I met some issue. The map sdk we are using is written in `objc`. If I am importing `objc` framework into a `swift` project, normally I would create a bridge header and boom, I can use it in Swift. However, bridge header is now how things works when creating a dynamic framework.

# How to
So how to import `Obj-C` framework into `Swift` framework?

## Import Framework
First import the framework. Download the `.framework` file, put in under the `$(PROJ_DIR)/lib`. Open Xcode, Switch to `Build Phases -> Link Binary With Libraries` and add downloaded framework.

You can also use `Cocoa-Pods` to import the framework.

## Create Framework Module Map File
Go to the folder where the framework is added. For example, if you install the framework using `cocoa-pods`, then it should be located at:

```sh
"$(SRCROOT)/Pods/FrameworkName/"
```

Inside that folder, there should be a file called `FrameworkName.framework`. Create a file called `module.modulemap` at the same level. Inside `module.modulemap`: (second header include is optional). Include anything that you need.

```sh
module Framework {
    header "Framework.framework/Versions/A/Headers/Framework.h"
    header "Framework.framework/Versions/A/Headers/OtherFrameworkHeader.h"

    export *
}
```

## Create Private Module Map File
Now go to `$(SRCROOT)` directory, create `target.private.modulemap` file. Inside file, write:

```sh
module TargetPrivate {
    export Framework
}
```

The module name can be target name + private. When export, write the framework module name.

## Project Settings
After creating all the map module file, go to the `target -> Build Settings`, search `module`, find `Private Module Map File`, enter the path for the `target.private.modulemap` file. It is usually be:

```sh
$(SRCROOT)/target.private.modulemap
```

Now search for \"import\" find `Import Paths` under `Swift Compiler - Search
   Paths`, enter the root directory for private module map. It is usually be:

```sh
$(SRCROOT)
```

## Import In Code
Now in code, wherever you need to use the library, you can use `#import framework`. I know its an objective-c framework, because you setup the module map, you can import them directly in `.swift` now. After import the file that expose is those you have headers inside module framework file.

You can also import that in umbrella header using `#import <Framework/Framework.h>`. If you did that inside umbrella header then no need to import for individual swift files anymore.

# My Research
Here is a list of research I did. It took me some time try different things.

## Understand Modular Framework
In order to understand how to solve the problem, we need to understand what the modular framework is. There are many awesome blog posts exists on that topic. Here is a list that helped me understanding.

1.  [Modular Framework Creating And Using Them](http://nsomar.com/modular-framework-creating-and-using-them/)
2.  [Accessing Private & Public Headers in Swift & Obj-C Framework](http://nsomar.com/project-and-private-headers-in-a-swift-and-objective-c-framework/)

## Understand Allow Non-Modular Includes
If you ever see error message of `non-modular header inside framework module`, try to understand [this answer.](https://stackoverflow.com/a/37072619/2581637)

## [Optional] More Research Resources
Here is a list of links that related to this issue. Not all of them are helpful, but I decided to bookmark all of them just in case.

1.  [Github - Sample Code Mix Swift Objc For Framework](https://github.com/danieleggert/mixed-swift-objc-framework)
2.  [Import Objective-C framework into Swift framework Project](https://stackoverflow.com/questions/33797212/import-objective-c-framework-into-swift-framework-project)
3.  [Objective-C Headers In Swift Framework Custom Build Configuration](http://ilya.puchka.me/objective-c-headers-in-swift-framework-custom-build-configurations/)

## Update
Here is an update. Previously my understanding is wrong. My previous understanding is only partial and the solution does not help to solve the issue.

So now here is some add-on that may help me understand modular well. This [modular framework creating and using them](http://nsomar.com/modular-framework-creating-and-using-them/) is mentioned before. Read it again carefully will understand the basic knowledge of modular file.

[Here is clang documentation](http://clang.llvm.org/docs/Modules.html#private-module-map-files) on private modular files.

[This github project](https://github.com/danieleggert/mixed-swift-objc-framework) gives an example on how to include objective-c framework inside a swift framework project. It is very useful and gives a lot of hints.
