---
title: Git Cheatsheet
date: 2018-12-04
tags:
desc:
---

My `git` cheatsheet
<!--more-->

# Remove Already Ignored Files
```bash
git rm -r --cached . # Remove already ignored files.
git add . # Add remove changes
git commit -m "..." # Commit changes
```

# Check Who Modified This Line
To see commits affecting line 40 of file foo:
`git blame -L 40,+1 foo`
The +1 means exactly one line. To see changes for lines 40-60, it’s:
`git blame -L 40,+21 foo`
From line to line. The second number can be an offset designated with a ‘+’, or a line number.  [git blame docs](https://git-scm.com/docs/git-blame)
`git blame -L 40,60 foo`

# Submodules
If you clone the repository, the submodule will not be cloned by default. If you want to clone all submodules while clone the repository, this is the command:

```bash
git clone —-recurse-submodules URL

# -j# will specify the number of submodules fetched at the same time.
git clone —-recurse-submodules -j8 URL
```

If you have **already cloned** your repository, you can run this command. Omit *<pathspec>* will  clone all the submodules in repository.

```bash
git submodule update --init --recursive <pathspec>
```
