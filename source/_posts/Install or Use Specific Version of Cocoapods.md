---
title: Install or Use Specific Version of Cocoapods
date: 2019-08-02
tags:
desc:
---

Sometimes you will need to use a specific version of *Cocoapods*, usually when you want to downgrade a cocoa pods. Here is what you need to do.
<!--more-->

**First** install the specific version.
```bash
sudo gem install cocoapods -v 1.6.1
```

**Second** uninstall the other version
```bash
sudo gem uninstall cocoapods
```
The above command will let you choose which version you want to uninstall if you have multiple version installed.

**Last But Not Least** check current version
```bash
pod --version
```
Now use the above command to check your current version.
