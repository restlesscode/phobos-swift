//
//
//  PBSLocation.swift
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
import Foundation
import MapKit
import PhobosSwiftCore
import PhobosSwiftLog
import RxSwift

/// CodebaseUILocation 将CLLocationManager和CLGeocoder 常用的方法做了封装，让调用更简单
///
/// 整个App生命周期，取保只需要一个CodebaseUILocation即可
open class PBSLocation {
  let disposeBag = DisposeBag()
  /// 当前位置，可能为空 , 此坐标为标准坐标系（非火星坐标系，不可直接用于Map和API接口调用）
  public var currentLocation: CLLocation?

  /// 如果用户没有授权，是否弹出默认的Alert提示
  public static var enableUnauthorizationAlert: Bool = true

  /// 获取最后一次的定位权限状态
  public var lastAuthorizationStatus: CLAuthorizationStatus?

  /// Location Manager
  public var locationManager: CLLocationManager

  open var isUpdatingLocation: Bool = false {
    didSet {
      if isUpdatingLocation {
        if locationManager.pbs_isLocationServicesEnabled {
          locationManager.startUpdatingLocation()
        } else {}
      } else {
        locationManager.stopUpdatingLocation()
      }
    }
  }

  public init(locationManager: CLLocationManager = CLLocationManager.default) {
    self.locationManager = locationManager

    self.locationManager.rx.didChangeAuthorization.subscribe { [weak self] _, status in
      guard let self = self else { return }

      self.lastAuthorizationStatus = status
      switch status {
      case .notDetermined:
        // Request when-in-use authorization initially
        locationManager.requestWhenInUseAuthorization()
      case .restricted, .denied:
        // Disable location features
        // disableLocationBasedFeatures()
        DispatchQueue.pbs_once {
          if PBSLocation.enableUnauthorizationAlert {
            if PBSLocation.locationAuthorizationAlertCtrl.presentingViewController == nil &&
              !PBSLocation.locationAuthorizationAlertCtrl.isBeingPresented {
              DispatchQueue.main.async {
                UIApplication.pbs_shared?.keyWindow?.rootViewController?.present(PBSLocation.locationAuthorizationAlertCtrl,
                                                                                 animated: true,
                                                                                 completion: nil)
              }
            }
          }
        }

      case .authorizedWhenInUse:
        // Enable basic location features
        self.isUpdatingLocation = true
      // enableWhenInUseFeatures()
      case .authorizedAlways:
        // Enable any of your app's location features
        self.isUpdatingLocation = true
      // enableAlwaysFeatures()
      @unknown default:
        break
      }
    }.disposed(by: disposeBag)

    // Invoked when new locations are available.  Required for delivery of
    // deferred locations.  If implemented, updates will
    // not be delivered to locationManager:didUpdateToLocation:fromLocation:
    //
    // locations is an array of CLLocation objects in chronological order.
    self.locationManager.rx.didUpdateLocations.subscribe { [weak self] _, locations in
      guard let self = self else { return }

      guard let currentLocation = locations.last else {
        return
      }

      self.currentLocation = currentLocation
    }.disposed(by: disposeBag)
  }

  /// lazy variable alertCtrl
  ///
  /// Should be initialized once
  static var locationAuthorizationAlertCtrl: UIAlertController = {
    PBSLocation.makeAlertCtrl(title: Constants.Text.kAllowLocationAccess, message: Constants.Text.kAllowLocationAccessMessage)
  }()

  private static func makeAlertCtrl(title: String, message: String) -> UIAlertController {
    let alertCtrl = UIAlertController(title: title, message: message, preferredStyle: .alert)

    alertCtrl.addAction(UIAlertAction(title: Constants.Text.kSettings, style: .default) { _ in
      alertCtrl.dismiss(animated: true, completion: nil)

      if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
        if UIApplication.pbs_shared?.canOpenURL(settingsURL) ?? false {
          UIApplication.pbs_shared?.pbs_open(settingsURL, options: [:], completionHandler: nil)
        }
      }
    })

    alertCtrl.addAction(UIAlertAction(title: Constants.Text.kCancel, style: .cancel) { _ in
      alertCtrl.dismiss(animated: true, completion: nil)
    })

    return alertCtrl
  }

  /// 在默认的地图中打开导航
  public static func showRouteInBuitinMap(sourceLocation: MKMapItem,
                                          destLocation: MKMapItem,
                                          directionsMode: DirectionsMode = .walk) {
    MKMapItem.openMaps(with: [sourceLocation, destLocation],
                       launchOptions: directionsMode.launchOptions)
  }

  /// 在默认的地图中打开导航
  public static func showRouteInBuitinMap(destLocation: MKMapItem,
                                          directionsMode: DirectionsMode = .walk) {
    let sourceLocation = MKMapItem.forCurrentLocation()
    PBSLocation.showRouteInBuitinMap(sourceLocation: sourceLocation,
                                     destLocation: destLocation,
                                     directionsMode: directionsMode)
  }
}
