---
title: Troubleshooting For GraphQL
date: 2019-05-24
tags:
desc:
---

So I add in a graphQL query and when I build or clean, it gives me the following error message.
<!--more-->

```
Execution failed for task ':app:xxx'. Process 'command ./app/.gradle/nodejs/node-v6.7.0-linux-x64/bin/node'' finished with non-zero exit value 1
```

After did a couple search I found that `exit value 1` means: **Validation of GraphQL query document failed**.

I solve the problem by updating the `schema.json`.

Also according to a GitHub issue, it might be possible that the error is caused by using similar fragment names in my separate `.graphql` files, thus changing the name to assure they are different fixed my issue.
