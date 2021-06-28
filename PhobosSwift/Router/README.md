PhobosSwiftRouter
================
# Features
- URLNavigator
- URLMatcher
- PBSRouter


# Requirements
- iOS 10.0 or later
- Xcode 11.0 or later
- cocoapods 1.10.0 or later


# How To Use
- swift

```

import PhobosSwiftRouter

let router = PBSRouter.default
router.configure()
router.register("testURL/HelloViewController") { url, _, _ -> UIViewController? in
  print(url.urlStringValue == "testURL/HelloViewController")
  print(url.urlStringValue)
  return UIViewController()
}

```

# Installation
## Podfile

```
platform :ios, '10.0'
use_frameworks!
pod 'PhobosSwiftRouter', '~> 0.1.0'
```


# Author
[Restless Developer](https://github.com/restlesscode)



# Licenses
All source code is licensed under the [MIT License](../../LICENSE).
