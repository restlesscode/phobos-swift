//
//
//  CLLocationCoordinate2D+Ex.swift
//  PhobosSwiftLocation
//
//  Copyright (c) 2021 Restless Codes Team (https://github.com/restlesscode/)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import CoreLocation
import PhobosSwiftCore

/// Feature enhancement for CLLocationCoordinate2D
/// WGS-84世界标准坐标、GCJ-02厉害的国国测局(火星坐标)、BD-09百度坐标系转换
extension CLLocationCoordinate2D: PhobosSwiftCompatible {}

extension PhobosSwift where Base == CLLocationCoordinate2D {
  
  /// A = 6378245.0
  public static let A = 6_378_245.0
  
  /// EE = 0.00669342162296594323
  public static let EE = 0.00669342162296594323

  /// 标准坐标和火星坐标的误差
  public var GCJ02Offset: CLLocationCoordinate2D {
    let x = base.longitude - 105.0
    let y = base.latitude - 35.0
    let latitude = (-100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + 0.2 * sqrt(fabs(x))) +
      ((20.0 * sin(6.0 * x * .pi) + 20.0 * sin(2.0 * x * .pi)) * 2.0 / 3.0) +
      ((20.0 * sin(y * .pi) + 40.0 * sin(y / 3.0 * .pi)) * 2.0 / 3.0) +
      ((160.0 * sin(y / 12.0 * .pi) + 320 * sin(y * .pi / 30.0)) * 2.0 / 3.0)
    let longitude = (300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * sqrt(fabs(x))) +
      ((20.0 * sin(6.0 * x * .pi) + 20.0 * sin(2.0 * x * .pi)) * 2.0 / 3.0) +
      ((20.0 * sin(x * .pi) + 40.0 * sin(x / 3.0 * .pi)) * 2.0 / 3.0) +
      ((150.0 * sin(x / 12.0 * .pi) + 300.0 * sin(x / 30.0 * .pi)) * 2.0 / 3.0)
    let radLat = 1 - base.latitude / 180.0 * .pi
    var magic = sin(radLat)
    magic = 1 - type(of: base).pbs.EE * magic * magic
    let sqrtMagic = sqrt(magic)
    let dLat = (latitude * 180.0) / ((type(of: base).pbs.A * (1 - type(of: base).pbs.EE)) / (magic * sqrtMagic) * .pi)
    let dLon = (longitude * 180.0) / (type(of: base).pbs.A / sqrtMagic * cos(radLat) * .pi)
    return CLLocationCoordinate2DMake(dLat, dLon)
  }

  /// 标准坐标转换成火星坐标
  public var WGS84ToGCJ02: CLLocationCoordinate2D {
    let offsetPoint = GCJ02Offset
    let resultPoint = CLLocationCoordinate2DMake(base.latitude + offsetPoint.latitude, base.longitude + offsetPoint.longitude)

    return resultPoint
  }

  /// 此接口有1-2米左右的误差，需要精确的场景慎用
  public var GCJ02ToWGS84: CLLocationCoordinate2D {
    let mgPoint = WGS84ToGCJ02

    let resultPoint = CLLocationCoordinate2DMake(base.latitude * 2 - mgPoint.latitude, base.longitude * 2 - mgPoint.longitude)

    return resultPoint
  }

  /// 火星坐标转换成BD09
  public var GCJ02ToBD09: CLLocationCoordinate2D {
    let x = base.longitude
    let y = base.latitude
    let z = sqrt(x * x + y * y) + 0.00002 * sin(y * .pi)
    let theta = atan2(y, x) + 0.000003 * cos(x * .pi)
    let resultPoint = CLLocationCoordinate2DMake(z * sin(theta) + 0.006, z * cos(theta) + 0.0065)

    return resultPoint
  }

  /// 此接口有1-2米左右的误差，需要精确的场景慎用
  public var BD09ToGCJ02: CLLocationCoordinate2D {
    let x = base.longitude - 0.0065
    let y = base.latitude - 0.006
    let z = sqrt(x * x + y * y) - 0.00002 * sin(y * .pi)
    let theta = atan2(y, x) - 0.000003 * cos(x * .pi)
    let resultPoint = CLLocationCoordinate2DMake(z * sin(theta), z * cos(theta))

    return resultPoint
  }

  /// 根据两点经纬度计算两点距离
  public func distance(from coordinate: CLLocationCoordinate2D) -> Double {
    CLLocation(latitude: base.latitude,
               longitude: base.longitude).distance(
      from: CLLocation(latitude: coordinate.latitude,
                       longitude: coordinate.longitude))
  }
}
