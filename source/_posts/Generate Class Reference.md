---
title: Generate Class Reference
date: 2019-04-10
tags:
desc:
---

At Mapsted, we need to generate `html` class reference for the SDK. Have a detailed reference not only makes us look professional but also helps our client easier integrating our SDK.
<!--more-->

I choose `Jazzy` for generating the class reference in `iOS` platform.
[GitHub - realm/jazzy: Soulful docs for Swift & Objective-C](https://github.com/realm/jazzy)

# Installation
```bash
[sudo] gem install jazzy
```

# How to Generate
Generate doc under *Swift* mode:
```bash
jazzy \
  --clean \
  --author Mapsted \
  --author_url https://mapsted.com \
  --module-version 3.0 \
  --module ENTER_MODULE_NAME_HERE \
  --output docs/ \
  --theme apple
```

## Themes
1. `apple` example: [https://realm.io/docs/swift/latest/api/](https://realm.io/docs/swift/latest/api/)
2. `fullwidth` example: [https://reduxkit.github.io/ReduxKit/](https://reduxkit.github.io/ReduxKit/)
3. `jony` example: [https://harshilshah.github.io/IGListKit/](https://harshilshah.github.io/IGListKit/)

## Controlling What is Documented
In *Swift* mode, by default, documents only `public` and `open` declarations. To include declarations with a lower access level, set the `—min-acl` flag to `internal`, `fileprivate`, or `private`

In *Objective-C* mode, Jazzy documents all declarations found in the `—umbrella-header` header file and any other header files included by it. You can control exactly which declarations should be documented using `—exclude`, `—include` or `:nodoc:`.
