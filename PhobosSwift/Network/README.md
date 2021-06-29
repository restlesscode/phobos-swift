PhobosSwiftNetwork
================
# Features
- PBSNetwork: Api请求
- Extensions for CocoaMQTT: CocoaMQTT封装
- PBSCertificatePinner: SSL Pinning
- PBSNetwork.Reachability: 网络状态监听
- Session: 会话管理

# Requirements
- iOS 10.0 or later
- Xcode 11.0 or later
- cocoapods 1.10.0 or later


# How To Use
- swift

```
import PhobosSwiftNetwork

struct APIRequestResponse: Codable {
  let errorcode: String
  let errormsg: String
}

func request() {
  PBSNetwork.APIRequest.request("https://xxx.com", method: .get).then { (result: Result<APIRequestResponse, Error>) in
    switch result {
    case let .success(model):
      if model.errorcode == "0" {

      } else {

      }
    case let .failure(error):
      NSLog("request error: \(error.localizedDescription)")
    }
  }
}

```

# Installation
## Podfile

```
platform :ios, '10.0'
use_frameworks!
pod 'PhobosSwiftNetwork', '~> 0.1.0'
```


# Author
[Restless Developer](https://github.com/restlesscode)



# Licenses
All source code is licensed under the [MIT License](../../LICENSE).
