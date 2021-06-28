PhobosSwiftWechat
================
# Features
- 基于微信SDK的封装（检查微信版本、是否安装、安装地址、调起微信、处理回调等）


# Requirements
- iOS 10.0 or later
- Xcode 11.0 or later
- cocoapods 1.10.0 or later


# How To Use
- swift

```

import PhobosSwiftWechat

let wechat = PBSWechat.shared
wechat.configure(appId: "", universalLink: "")

```

# Installation
## Podfile

```
platform :ios, '10.0'
use_frameworks!
pod 'PhobosSwiftWechat', '~> 0.1.0'
```


# Author
[Restless Developer](https://github.com/restlesscode)



# Licenses
All source code is licensed under the [MIT License](../../LICENSE).
