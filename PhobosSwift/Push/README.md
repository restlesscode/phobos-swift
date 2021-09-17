PhobosSwiftPush
================
# Features
- Nitifications: 注册、接收、推送


# Requirements
- iOS 10.0 or later
- Xcode 11.0 or later
- cocoapods 1.10.0 or later


# How To Use
- swift

```

import PhobosSwiftPush

PBSPush.shared.registerRemoteNotifications { status in
 
} onError: { error in

} onSuccess: { data in

}

```

# Installation
## Podfile

```
platform :ios, '10.0'
use_frameworks!
pod 'PhobosSwiftPush', '~> 0.1.0'
```


# Author
[Restless Developer](https://github.com/restlesscode)



# Licenses
All source code is licensed under the [MIT License](../../LICENSE).
