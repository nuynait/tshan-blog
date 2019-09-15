---
title: Kotlin Unwrap Optional Variable
date: 2019-06-25
tags:
desc:
---

Here is how you can unwrap optional variable in *Kotlin*
<!--more-->

# Let / Also
You can use a lambda function let / also to safe unwrap the optional variable.

(Assume *plant* is the optional variable)
```kotlin
plant?.let {
    it.height = 20
    displayGrowStage(it)
}
```

Use a different Parameter other than *it*
```kotlin
plant?.let { plant ->
    plant.height = 20
    displayGrowStage(plant)
}
```

# Return If Null
In **Swift**, you have *guard let xxx = xxx else* to unwrap the optional variable. So here is the similar thing I will do in **Kotlin**.

```kotlin
val plant = nullablePlant ?: return
plant.height = 20
displayGrowStage(plant)
```
