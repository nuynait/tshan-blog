---
title: Android Multiple Firebase Apps For One Project
date: 2019-07-28
tags:
desc:
---

If you have multiple build variant / flavour, you probably want to use different `google-services.json` depends on different build variant. The answer is yes, you can. [Here](https://stackoverflow.com/a/42086133/2581637) is a stack-overflow answer that might help.

For detail, do something like following:
```
|-- Project
	|-- app
		|-- src
			|-- production
				|-- google-services.json
			|-- staging
				|-- google-services.json
			|-- debug
				|-- google-services.json
```
