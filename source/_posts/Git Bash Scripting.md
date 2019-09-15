---
title: Git Bash Scripting
date: 2019-01-17
tags:
desc:
---

Here are some useful git command for bash scripting
<!--more-->

*Uncommited Changes:*
```bash
if ! git diff-index --quiet HEAD --; then
	echo "There are uncommited changes on this repository."
	exit 1
fi
```

*Remote exists:*
```bash
    git remote -v | /usr/bin/awk '{print $1}' | /usr/bin/grep -w ${ORIGIN_REMOTE} >/dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo "Do not have remote: ${ORIGIN_REMOTE}\n"
        exit 1
    fi
```

*Local Branch Exists:*
```bash
git rev-parse -q --verify ${branch} >/dev/null 2>&1
if [ $? -ne 0 ]
then
    echo "Branch ${branch} exists"
fi
```
