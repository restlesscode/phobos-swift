//
//
//  Reachability.swift
//  PhobosSwiftNetwork
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

import Alamofire
import CoreTelephony
import Foundation
import PhobosSwiftCore
import PhobosSwiftLog

/// The enumeration of Network Status
///
/// 1. notReachable
/// 2. unknown
/// 3. wlan
/// 4. cellular
/// 5. restrictedByUser
extension PBSNetwork {
  public enum Status: Int {
    /// 网络不好
    case notReachable

    /// 未知状态
    case unknown

    /// WLAN网络
    case wlan

    /// 蜂窝网络
    case cellular

    /// 用户不给权限（国产iOS设备）
    case restrictedByUser
  }
}

extension PBSNetwork {
  public enum ConnectionType: String {
    case unknown = "未知"
    case unreachable = "无网"
    case G2 = "2G"
    case G3 = "3G"
    case G4 = "4G"
    case G5 = "5G"
    case WIFI
  }
}

extension PBSNetwork {
  public class Reachability: NSObject {
    private var reachMgr: NetworkReachabilityManager?
    var enableAlert: Bool = true
    public var isReachable: Bool { (reachMgr?.isReachableOnCellular ?? false) || (reachMgr?.isReachableOnEthernetOrWiFi ?? false) }

    deinit {
      self.reachMgr?.stopListening()
    }

    public var status: NetworkReachabilityManager.NetworkReachabilityStatus {
      reachMgr?.status ?? .unknown
    }

    /// 配置 Reachability
    ///
    /// 这里
    /// 允许自动弹出提示，引导用户打开网络权限
    public func configure() {
      configure(enableAlert: true)
    }

    /// 配置 Reachability
    ///
    /// - parameter enableAlert 是否开启自动弹出AlertView提示用户去打开网络授权（中国的iOS机型）
    ///
    public func configure(enableAlert: Bool = true) {
      reachMgr = NetworkReachabilityManager()
      self.enableAlert = enableAlert
    }

    /// Check the current connetivity
    ///
    /// - parameter handler 回调
    public func checkConnectivity(handler: ((Status) -> Void)? = nil) {
      /// 开启监听
      reachMgr?.startListening(onUpdatePerforming: { [unowned self] status in
        if self.reachMgr?.isReachable ?? false {
          switch status {
          case .unknown:
            PBSLogger.logger.debug(message: "It is unknown whether the network is reachable", context: "Network")
            handler?(.unknown)
          case .notReachable:
            PBSLogger.logger.debug(message: "The noework is not reachable", context: "Network")
            handler?(.notReachable)
          case .reachable(.ethernetOrWiFi):
            PBSLogger.logger.debug(message: "Reach via WiFi or ethernet", context: "Network")
            handler?(.wlan)
          case .reachable(.cellular):
            PBSLogger.logger.debug(message: "Reach via cellular network", context: "Network")
            handler?(.cellular)
          }
        } else {
          PBSLogger.logger.debug(message: "Network is unreachable", context: "Network")
          handler?(.restrictedByUser)

          DispatchQueue.pbs.once {
            if self.enableAlert {
              if self.alertCtrl.presentingViewController == nil && !self.alertCtrl.isBeingPresented {
                DispatchQueue.main.async {
                  UIApplication.pbs_shared?.keyWindow?.rootViewController?.present(self.alertCtrl,
                                                                                   animated: true,
                                                                                   completion: nil)
                }
              }
            }
          }
        }
      }
      )
    }

    /// lazy variable alertCtrl
    ///
    /// Should be initialized once
    lazy var alertCtrl: UIAlertController = {
      let _alertCtrl = UIAlertController(title: "NETWORK_CONNECTIVITY_RESTRICTED".localized,
                                         message: "NETWORK_CHECK_SETTINGS".localized,
                                         preferredStyle: .alert)

      _alertCtrl.addAction(UIAlertAction(title: "SETTING".localized, style: .default) { _ in
        _alertCtrl.dismiss(animated: true, completion: nil)

        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
          if UIApplication.pbs_shared?.canOpenURL(settingsURL) ?? false {
            UIApplication.pbs_shared?.pbs_open(settingsURL, options: [:], completionHandler: nil)
          }
        }
      })

      _alertCtrl.addAction(UIAlertAction(title: "CANCEL".localized, style: .cancel) { _ in
        _alertCtrl.dismiss(animated: true, completion: nil)
      })

      return _alertCtrl
    }()

    public var connectionType: ConnectionType {
      let nt = status
      var currentStatus = CTRadioAccessTechnologyLTE
      switch nt {
      case .unknown:
        return .unknown
      case .notReachable:
        return .unreachable
      case let .reachable(connectionType):
        switch connectionType {
        case .cellular:
          let info = CTTelephonyNetworkInfo()
          if #available(iOS 12.0, *) {
            guard let access = info.serviceCurrentRadioAccessTechnology,
                  !access.isEmpty,
                  let status = access.first?.value
            else {
              return .unknown
            }
            currentStatus = status
          } else {
            guard let status = info.currentRadioAccessTechnology else { return .unknown }
            currentStatus = status
          }
          if currentStatus == CTRadioAccessTechnologyGPRS || currentStatus == CTRadioAccessTechnologyEdge || currentStatus == CTRadioAccessTechnologyCDMA1x {
            return .G2
          } else if currentStatus == CTRadioAccessTechnologyWCDMA || currentStatus == CTRadioAccessTechnologyHSDPA || currentStatus == CTRadioAccessTechnologyHSUPA || currentStatus == CTRadioAccessTechnologyCDMAEVDORev0 || currentStatus == CTRadioAccessTechnologyCDMAEVDORevA || currentStatus == CTRadioAccessTechnologyCDMAEVDORevB {
            return .G3
          } else if currentStatus == CTRadioAccessTechnologyLTE {
            return .G4
          } else {
            if #available(iOS 14.1, *) {
              if currentStatus == CTRadioAccessTechnologyNRNSA || currentStatus == CTRadioAccessTechnologyNR {
                return .G5
              }
            }
            return .unknown
          }
        case .ethernetOrWiFi:
          return .WIFI
        }
      }
    }
  }
}
