---
title: Todo Tags In Xcode
date: 2019-03-03
tags:
desc:
---

In `Swift`, you can generate todo comments, like below:
<!--more-->

```swift
// TODO: a future todo
// FIXME: a future fix
```

After that, you will be able to see them in the class structure list. However that is not very obvious and will be easily ignored.

# Highlight Todos
Here is a script we can put in the `Run Script` section.

```bash
TAGS="TODO:|FIXME:"
ERRORTAG="ERROR:"
find "${SRCROOT}" \( -name "*.h" -or -name "*.m" -or -name "*.swift" \) -print0 | xargs -0 egrep --with-filename --line-number --only-matching "($TAGS).*\$|($ERRORTAG).*\$" | perl -p -e "s/($TAGS)/ warning: \$1/" | perl -p -e "s/($ERRORTAG)/ error: \$1/"
```

After that all the todos and fixme tag will generate a warning.
