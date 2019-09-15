---
title: iOS Multiple Firebase Apps For One Project
date: 2019-06-28
tags:
desc:
---

There are two ways to choose different `GoogleService-Info.plist`. One is recommended in the official documentation as *Run Time Configuration*. The other is what I use to replace configuration before compile using *Run Script*.
<!--more-->

Here is the official documentation: [Configure multiple projects  |  Firebase](https://firebase.google.com/docs/projects/multiprojects)

# Run Time Configuration
For run time configuration, navigate to [Configure multiple projects  |  Firebase](https://firebase.google.com/docs/projects/multiprojects#support_multiple_environments_in_your_ios_application) for official documentation.

# Compile Time Configuration
**This is what I choose to do and how I do it. You can choose to use this method or not by your own choice.**

First download all the *GoogleService-Info.plist* into your project. You can put it anywhere you want. Remember append something at the end of the file name. For example:
```
-- Main Project
| -- Project Folder
| -- AppDelegate.swift
	| -- Firebase
		|-- GoogleService-Info-uat.plist
		|-- GoogleService-Info-release.plist
```

When adding files into the project, choose the correct target file is corresponding to. (You can also choose all targets if you want).

Then in the *Target -> Build Phases*, create a *Run Script*, drag it above the *Copy Bundle Resources*, and write the following script:

```bash
PATH_TO_GOOGLE_PLISTS="${PROJECT_DIR}/<1>/Application/Firebase"
cp "$PATH_TO_GOOGLE_PLISTS/GoogleService-Info-<2>.plist" "${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app/GoogleService-Info.plist"
```

Replace: ::<1>:: with project folder name. ::<2>:: with the correct filename you appended.

The script will copy the *plist* file into the build binary root.

Why build binary root? You can of course copy to your project root before compile stage. However, it will then create a git difference. Copy to the binary file can direct avoid this problem.

> By default, `FirebaseApp.configure()` will load the `GoogleService-Info.plist` file bundled with the application.  

Therefore, this method works.

I use this method in Lowes Loyalty app when working for [Kinetic](https://kineticcommerce.com/).
