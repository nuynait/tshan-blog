---
title: Fish Terminal Fuzzy Finding
date: 2019-07-09
tags:
desc:
---

*fzf* is a very important terminal tool that will adds a big help to your terminal. It is fuzzy find everything. A better companion to your fish terminal auto completion.
<!--more-->

[GitHub - junegunn/fzf: A command-line fuzzy finder](https://github.com/junegunn/fzf)

# Installation
```bash
brew install fzf
/usr/local/opt/fzf/install
```

Use first command to install from *brew* and second command to enable keyboard shortcut after installed.

**(Optional)**
Install `tac` if you want to use `bcd` or `rcd`. See *Advanced Usage* for details.

# Keyboard Shortcut
Use *Ctrl-R* to browse history.
Use *Ctrl-T* to open anything.

Some useful example would be:
```
cd <Ctrl-T>
vim <Ctrl-T>
```


```
Any Command + <Ctrl-R>
```

This will search history related to command you type first.

# Advanced Usage
Visit https://github.com/junegunn/fzf/wiki/Examples-(fish) for examples of fish functions.

## Replace Auto-Complete
Call `fzf_complete` to enable auto-complete using fzf (replace fish *tab* autocomplete) temporary just in this section.

This is not idea. You may not want to use this every time. One of the drawback is you can only press tab to work in the beginning of a word. No longer work on typing half the word and then *tab*.

## Cd Related
Call `bcd` to go *cd backwards*. Call `rcd` to *cd to one of the previously visited locations*.

## Git Related
Call `fco` to fuzzy find and check out to a branch. `fcoc` to fuzzy find and checkout a commit
