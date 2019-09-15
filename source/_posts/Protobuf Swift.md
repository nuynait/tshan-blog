---
title: Protobuf Swift
date: 2016-11-07
tags:
desc:
---

`Protobuf-Swift` is a swift framework for protobuf. it contains a swift framework and a compiler you can use on macOS and Linux.

<!--more-->

# Installation
[This](https://github.com/alexeyxo/protobuf-swift#how-to-install-protobuf-compiler-on-linuxubuntu-1404) is the repository for `protobuf-swift`. First, install the protobuf compiler, it compiles the `.proto` files into swift class.

```sh
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew install automake
brew install libtool
brew install protobuf
git clone git@github.com:alexeyxo/protobuf-swift.git
../scripts/build.sh
```

You can also choose to install it from `Homebrew`. That is what I did at first place. However, I met *this problem*. It is usually caused by using an outdated compiler and framework, so I reinstalled the compiler using above method.

I am working with an existing `.proto` file so here I just go and compile the file first and use it to unserialize the data file.

## How to compile?
Go to the directory where you put the `.proto` file, use the following command to compile your file.

```sh
protoc  person.proto --swift_out="./"
```

After that you may get a `xxxxxx.proto.swift` file in your output directory. Add that into your existing project.

## Install Framework
Here I am using `cocoapod` to manage all my framework. Open your `podfile`, and the following into your podfile.

```ruby
pod 'ProtocolBuffers-Swift', :git => 'https://github.com/alexeyxo/protobuf-swift', :branch => 'master'
```

You can see that I am using the master branch source. Why? see *here*.

## Compile and Run?
After you did both, compile and run your project, if you did it successfully, then you will good to go.

## ERROR?
I compile the `.proto` file and put the `.proto.swift` generated class into my project. After compile the project, it has more than 30 error saying `Method does not override any method from its superclass`. After searching through all the issue, it seems all of this problems is because of using an out dated compiler or framework.

Here is what I did to solve the problem. First, I remove the compiler installed by `Homebrew`, then I installed using the method stated above. Than I update the framework to latest master branch using

```ruby
pod 'ProtocolBuffers-Swift', :git => 'https://github.com/alexeyxo/protobuf-swift', :branch => 'master'
```

After upgrading both to its latest version, I successfully solved the problem.
