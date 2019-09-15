---
title: Upload Missing Required DSYMs
date: 2019-07-10
tags:
desc:
---

If you use firebase crashlytics and it says *Upload missing required dSYMs*, here is how you can upload it manually.
<!--more-->

# Upload DSYMs Manually
Here is a [All about Missing dSYMs — Fabric for Apple  documentation](https://docs.fabric.io/apple/crashlytics/missing-dsyms.html) usually link for uploading dSYMs for iOS.

First *archive* the project as normal, and click *Download dSYMs* button in Xcode’s Organizer.

![](Upload%20Missing%20Required%20DSYMs/xcode-download-dsyms.png)

Now open project files, you can find a folder called dSYMs. Zip the folder and upload manually to the console.

![](Upload%20Missing%20Required%20DSYMs/Screen_Shot_2019-07-10_at_4_23_13_PM.png)
