PhobosSwiftAuth
================
# Features
- 常规权限获取(TouchId、FaceId..)


# Requirements
- iOS 10.0 or later
- Xcode 11.0 or later
- cocoapods 1.10.0 or later


# How To Use
- swift

```
import PhobosSwiftAuth

let isFaceIDAvailable = BioMetricAuthenticator.shared.isFaceIDAvailable
```

# Installation
## Podfile

```
platform :ios, '10.0'
use_frameworks!
pod 'PhobosSwiftAuth', '~> 0.1.0'
```


# Author
[Restless Developer](https://github.com/restlesscode)



# Licenses
All source code is licensed under the [MIT License](../../LICENSE).
