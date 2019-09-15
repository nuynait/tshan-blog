---
title: Container View Controller
date: 2018-03-18
tags:
desc:
---

Introduce: Add / Remove Child View Controller
<!--more-->

# Add Child View Controllers
Before adding the child view controller into the container's hierarchy, we need to init the child view controller and save it as a property inside the container view controller.

Firstly, the container view controller call the `addChildViewController:` method. This method is basically saying now my container is managing the view of that child view controller.

Secondly, add child's root view to subview of any of your container's view. Remember to setup the constraints for your child's root view to match its super view after its being added.

Last, call `didMoveToParentViewController` method on child view and pass in the container view controller.
```swift
class ContainerViewController: UIViewController {
  let childViewController: ChildViewController = ChildViewController(nibName: nil, bundle: nil)

  // inside some function, we add it that child view controller
  private func addChildViewController() {
    addChildViewController(childViewController)
    view.addSubview(childViewController.view)
    childViewController.addParentsConstraints() // this is a method we implement later
    childViewController.didMove(toParentViewController: self)
  }
}

class ChildViewController: UIViewController {

  func addParentsConstraints() {
    // now the constraints will be full screen
    // you should add constraints depending on what you needed
    guard let superview = view.superview else {
      print("error, should call addParentsConstraints after adding this as subview to container")
      abort()
    }

    let viewDict = Dictionary(dictionaryLiteral: ("self", self.view))
    let horizontalLayout = NSLayoutConstraint.constraints(
      withVisualFormat: "|[self]|", options: NSLayoutFormatOptions.directionLeadingToTrailing, metrics: nil, views: viewDict)
    let verticalLayout = NSLayoutConstraint.constraints(
      withVisualFormat: "V:|[self]|", options: NSLayoutFormatOptions.directionLeadingToTrailing, metrics: nil, views: viewDict)
    superview.addConstraints(horizontalLayout)
    superview.addConstraints(verticalLayout)
  }
}
```

# Remove Child View Controllers
Firstly, call the `willMoveToParentViewController` method on child view controller and pass in `nil`. Secondly, remove the child view controller's root view from its superview. Lastly, call `removeFromParentViewController` on child view controller

```swift
class ContainerViewController: UIViewController {
  let childViewController: UIViewController = UIViewController(nibName: nil, bundle: nil)

  private func removeChildViewController() {
    childViewController.willMove(toParentViewController: nil)
    childViewController.view.removeFromSuperView()
    childViewController.removeFromParentViewController()
  }
}
```

# Memory Management
You don't need to remove child view controller to avoid retain cycles. Add as child will not create retain cycles at all. If you have a retain cycle, see if you have pass any parents function and stored as blocks in its child property.

If you are store parents function in child's property as a closure, you might notice that it does not let you add weak or unowned keywords on non-class reference. If you still store it as is, then it will create a retain cycle if you are reference to self in that function block. What you can do is instead store the function, pass the parent itself and give it an unowned property. When you want to call that function, just call from access parent.
