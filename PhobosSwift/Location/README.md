PhobosSwiftLocation
================
# Features
- Extensions 
```
CLLocationCoordinate2D(坐标系转换、距离计算)
CLLocationManager(定位、导航)
MKLocalSearch(关键字搜索)
MKMapItem、MKMapRect
PhobosSwiftLocation
```
- Utils

```
PBSClusterManager(管理地图标注、缩放level等)
PBSLocation(管理定位授权)
```


# Requirements
- iOS 10.0 or later
- Xcode 11.0 or later
- cocoapods 1.10.0 or later


# How To Use
- swift

```
import PhobosSwiftLocation

let WGSLocation = CLLocationCoordinate2D(latitude: 31.30018852172415, longitude: 121.29127298178801)
let location = WGSLocation.pbs.WGS84ToGCJ02
```

# Installation
## Podfile

```
platform :ios, '10.0'
use_frameworks!
pod 'PhobosSwiftLocation', '~> 0.1.0'
```


# Author
[Restless Developer](https://github.com/restlesscode)



# Licenses
All source code is licensed under the [MIT License](../../LICENSE).
