PhobosSwiftAnimation
================
# Features
- 转场动画封装



# Requirements
- iOS 10.0 or later
- Xcode 11.0 or later
- cocoapods 1.10.0 or later


# How To Use
- swift

```

import PhobosSwiftAnimation

let transition = PBSDraggableInteractiveTransition(cardView: UIView,
pushFromViewCtrl: UIViewController,
pushToViewCtrl: UIViewController,
navigationController: UINavigationController,
style: PBSDraggableInteractiveTransitionStyle)

```

# Installation
## Podfile

```
platform :ios, '10.0'
use_frameworks!
pod 'PhobosSwiftAnimation', '~> 0.1.0'
```


# Author
[Restless Developer](https://github.com/restlesscode)



# Licenses
All source code is licensed under the [MIT License](../../LICENSE).
