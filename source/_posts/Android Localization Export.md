---
title: Android Localization Export
date: 2019-08-15
tags:
desc:
---

So implementing android localization is easy. First make sure everything (text) needs to be translated is in the `xml` file. Then we use the following tool to convert the `xml` file into `xliff` translation files.

<!--more-->

[Convert XLIFF language translation files](https://localise.biz/free/converter/tmx-to-xliff)

After the conversion, we can send `xliff` to any people to translate. [The fastest and most convenient way to translate interfaces — Poedit](https://poedit.net/) This can be a very nice `xliff` editor. Anyone (without any programming knowledge will be able to edit that file using *Poedit*)

After translation, using the above conversion tool to convert `xliff` file back to `.xml` file.

This is what I found when working for Kinetic Commerce for Lowes client. Their app needs to be translated into French and I will have to found a way to easy translation. For iOS, you can export and import `xliff` file directly. However, on Android, other than directly send `.xml` file, there is not an easy way found.

I tried using *csv* file, but copy from translation tools no longer works anymore in newer version of Android Studio.
