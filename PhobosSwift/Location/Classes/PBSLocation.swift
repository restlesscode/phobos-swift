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
import PhobosSwiftCore
import PhobosSwiftLog
import RxSwift

/// PBSLocation 将CLLocationManager和CLGeocoder 常用的方法做了封装，让调用更简单
///
/// 整个App生命周期，取保只需要一个PBSLocation即可
open class PBSLocation {
  let disposeBag = DisposeBag()

  /// 如果用户没有授权，是否弹出默认的Alert提示
  public static var enableUnauthorizationAlert: Bool = true

  /// Location Manager
  public var locationManager: CLLocationManager

  public init(locationManager: CLLocationManager = CLLocationManager.pbs.default) {
    self.locationManager = locationManager
  }

  public func configure() {
    locationManager.rx.didChangeAuthorization.subscribe { [weak self] _, status in
      guard let self = self else { return }

      switch status {
      case .notDetermined:
        // Request when-in-use authorization initially
        self.locationManager.requestWhenInUseAuthorization()
      case .restricted, .denied:
        // Disable location features
        // disableLocationBasedFeatures()
        DispatchQueue.pbs.once {
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
        self.locationManager.pbs.updatingLocation(updating: true)
      // enableWhenInUseFeatures()
      case .authorizedAlways:
        // Enable any of your app's location features
        self.locationManager.pbs.updatingLocation(updating: true)
      // enableAlwaysFeatures()
      @unknown default:
        break
      }
    }.disposed(by: disposeBag)
  }

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

  /// lazy variable alertCtrl
  ///
  /// Should be initialized once
  static var locationAuthorizationAlertCtrl: UIAlertController = {
    PBSLocation.makeAlertCtrl(title: Constants.Text.kAllowLocationAccess, message: Constants.Text.kAllowLocationAccessMessage)
  }()
}
