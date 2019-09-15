---
title: Xcode Keyboard Shortcut Cheatsheet
date: 2019-01-24
tags:
desc:
---

Here are list of keyboard shortcut I like to use to keep my hand always on keyboard.
<!--more-->

(I use extension [GitHub - XVimProject/XVim2: Vim key-bindings for Xcode 9](https://github.com/XVimProject/XVim2) for vim keybinding on editor, This blog shows some keyboard shortcut I usually use along with that plugin to speedup my workflow.)

::NOTE:: The highlight after the description is the command in key bindings settings. Anything with a highlight description may be the shortcut for my own. You will need to change your configuration if you want to use the same shortcut.

#  View Layout Navigation Related
List of shortcuts for changing Xcode layouts.

## Left Right Panel
1. `<CMD> 0`  Hide left panel
2. `<CMD,OPTION> 0` Hide right panel
3. `<CMD>1 -9` Show left panel and switch to corresponding section
4. `<CMD,OPTION> 1-9` Show right panel and switch to corresponding section

## Debugging
1. `<CMD,SHIFT,Y>` Toggle debugging console

## Assistant Editor
1. `<OPTION, RIGHT-CLICK-FILE>` Open file in assistant editor
2. `<OPTION, ENTER>` Open file in assistant editor
3. `<CMD, ENTER>` Dismiss Assistant Editor. ::Standard Editor > Show Standard Editor::

## Change Focus
1. `<CMD, SHIFT> C` Focus to debugging console
2. `<CTRL, BACKQUOTE>` Focus back to editor

## Quick Navigation
1. `<CMD, SHIFT> O` Quick open
2. `<CTRL> 6` Open object structure list (quick switch to function)
3. `<CMD, CTRL> 1` Open caller/callee menu ::Standard Editor > Show Related Items::
4. `<CMD, CTRL> j` Jump to definition ::Standard Editor > Jump to Definition::
5. `<CTRL> h` Go back ::Go Back::
6. `<CTRL> l` Go forward ::Go Forward::

## Refactor
1. `<CTRL, CMD> \` Refactor name ::Refactor > Extract Function::

# Debugging Related
List of shortcuts you can use when debugging your app.

## Debug Console
1. `<CMD,SHIFT,Y>` Toggle debugging console
2. `<CMD> k` Clear console

## Breakpoint Related
1. `<CMD, CTRL> Y` Play/Pause
