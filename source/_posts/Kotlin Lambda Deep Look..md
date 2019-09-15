---
title: Kotlin Lambda Deep Look
date: 2019-06-25
tags:
desc:
---

More detail, the usage of *let*, *also*, *apply*, *run*, *with*. When you first writing Kotlin, you must have questions on what is the difference between all these lambda functions and how to use them. This is a notes on how to properly use these lambda functions.

<!--more-->

# Let
*Let* accepts the object as a parameter and returns the result of the lambda.

```kotlin
val Height = Plant("Orange", 20).let { it.height * 2 }
```

*it* is *Plant*, *Height* is *Int* = 40

# Also
*Also* accepts the object as a parameter and returns the object itself.

```kotlin
val plant = Plant("Orange", 40)
val result = plant.also { it.age = 50 }
```

*it* is “Plant*, “result* is *Plant*. In this case, *plant* and *result* points to the same object.

# Apply
*Apply* is used for post-construction configuration. Object is not passed as a parameter, but rather as this. It return the object itself.

(An object passed in such way is called *receiver*. It is a *function literal with receiver*)
```kotlin
val plant = Plant().apply {
    setTitle("Orange")
    setHeight(40)
}
```

*setTitle* and *setHeight* are both functions for object *Plant*

# Run
*Run* is similar to *Apply* and is another *function literal with receiver*. Object is not passed as a parameter but rather as this. The difference is it it return the value of expression of the lambda function.

```kotlin
plant?.run {
    if (height < 20) SmallPlantView else TallPlantView
}.show()
```

(*height* is a property of *Plant*)

If you want to run a block and do not want to use the return value, use *Run*. Normally it is assumed that the return value of expression is not used. So it is perfectly use to safe unwrap optional variable.

```kotlin
plant.run {
    grow()
}
```

(*grow* is a function of *Plant*)

# With
*With* is similar to *Run*. The only difference is *With* do not accept optional variables.

(Assume *plant* is not optional variable)
```kotlin
with(plant) {
    height = 20
	  grow()
}

plant.run {
    height = 20
    grow()
}
```
(These are similar)

(Now, we assume *plant* is optional variable)
```kotlin
with(plant) {
    this?.height = 20
    this?.grow()
}

plant?.run {
    this?.height = 20
    this?.grow()
}
```

# Summary
Here is a table of summary.
- - - -
Parameter			| Same Object Return	| Different Object Return
- - - -
It					| also				| let
this					| apply				| run, with
