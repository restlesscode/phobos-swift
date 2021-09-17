//
//
//  PBSWechat.swift
//  PhobosSwiftWechat
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

import Foundation
import MirrorWechatSDK
import RxSwift

/// completion handler for wechat req/resp
public typealias CompletionHandler = ((Bool) -> Void)?

extension PBSWechat {
  /// 微信返回Error
  public enum Code: Int32 {
    case complete = 0
    case common = -1
    case userCancel = -2
    case sentFail = -3
    case authDeny = -4
    case unsupport = -5

    public var description: String {
      switch self {
      case .complete:
        return "微信回调:成功"
      case .common:
        return "微信回调:普通错误类型"
      case .userCancel:
        return "微信回调:用户点击取消并返回"
      case .sentFail:
        return "微信回调:发送失败"
      case .authDeny:
        return "微信回调:授权失败"
      case .unsupport:
        return "微信回调:微信不支持"
      }
    }
  }
}

extension SendAuthReq {
  convenience init(authScope: String, authState: String, authOpenID: String) {
    self.init()
    scope = authScope
    state = authState
    openID = authOpenID
  }
}

/// PBSWechat
public class PBSWechat: NSObject {
  public static let shared = PBSWechat()

  public weak var delegate: PBSWechatDelegate?

  override private init() {
    super.init()
  }

  public private(set) var appId: String = ""
  public private(set) var universalLink: String = ""

  /// WXApi的成员函数，向微信终端程序注册第三方应用。
  /// 需要在每次启动第三方应用程序时调用。
  /// @attention 请保证在主线程中调用此函数
  /// - Parameters:
  ///   - appid: 微信开发者ID
  ///   - appSecret: appSecret
  ///   - universalLink: 微信开发者Universal Link
  /// - Returns: 成功返回YES，失败返回NO。
  @discardableResult
  public func configure(appId: String, universalLink: String) -> Bool {
    self.appId = appId
    self.universalLink = universalLink
    return WXApi.registerApp(appId, universalLink: universalLink)
  }

  /// 发送请求到微信，等待微信返回onResp
  /// 函数调用后，会切换到微信的界面。第三方应用程序等待微信返回onResp。微信在异步处理完成后一定会调用onResp。支持以下类型 SendAuthReq、SendMessageToWXReq、PayReq等。
  /// - Parameters:
  ///   - requset: 具体的发送请求。
  ///   - completion: 调用结果回调block
  public func sendReq(requset: BaseReq, completion: CompletionHandler = nil) {
    WXApi.send(requset, completion: completion)
  }

  /// 收到微信onReq的请求，发送对应的应答给微信，并切换到微信界面
  /// 函数调用后，会切换到微信的界面。第三方应用程序收到微信onReq的请求，异步处理该请求，完成后必须调用该函数。可能发送的相应有 GetMessageFromWXResp、ShowMessageFromWXResp等。
  /// - Parameters:
  ///   - response: 具体的应答内容
  ///   - completion: 调用结果回调block
  public func sendResp(response: BaseResp, completion: CompletionHandler = nil) {
    WXApi.send(response, completion: completion)
  }

  /// 发送Auth请求到微信，支持用户没安装微信，等待微信返回onResp
  /// 函数调用后，会切换到微信的界面。第三方应用程序等待微信返回onResp。微信在异步处理完成后一定会调用onResp。支持SendAuthReq类型。
  /// - parameter request 具体的发送请求。
  /// - parameter viewController 当前界面对象。
  /// - parameter completion 调用结果回调closure，可以为空
  public func sendAuthReq(request: SendAuthReq, in viewController: UIViewController, completion: CompletionHandler = nil) {
    WXApi.sendAuthReq(request, viewController: viewController, delegate: self, completion: completion)
  }

  /// 处理旧版微信通过URL启动App时传递的数据
  /// 需要在 application:openURL:sourceApplication:annotation:或者application:handleOpenURL中调用。
  /// - Parameter url: 微信启动第三方应用时传递过来的URL
  /// - Returns: 成功返回YES，失败返回NO。
  @discardableResult
  public func handleOpen(url: URL) -> Bool {
    WXApi.handleOpen(url, delegate: self)
  }

  /// 处理微信通过Universal Link启动App时传递的数据
  /// 需要在 application:continueUserActivity:restorationHandler:中调用。
  /// - Parameter userActivity: 微信启动第三方应用时系统API传递过来的userActivity
  /// - Returns: 成功返回YES，失败返回NO。
  @discardableResult
  public func handleOpenUniversalLink(userActivity: NSUserActivity) -> Bool {
    WXApi.handleOpenUniversalLink(userActivity, delegate: self)
  }

  /// 检查微信是否已被用户安装
  public static var isWXAppInstalled: Bool {
    WXApi.isWXAppInstalled()
  }

  /// 判断当前微信的版本是否支持OpenApi
  public static var isWXAppSupportApi: Bool {
    WXApi.isWXAppSupport()
  }

  /// 获取微信的itunes安装地址
  public static var getWXAppInstallUrl: String {
    WXApi.getWXAppInstallUrl()
  }

  /// 获取当前微信SDK的版本号
  public static var getApiVersion: String {
    WXApi.getVersion()
  }

  /// 打开微信
  /// - Returns: 成功返回YES，失败返回NO。
  @discardableResult
  public func openWXApp() -> Bool {
    WXApi.openWXApp()
  }
}

// MARK: - WXApiDelegate

extension PBSWechat: WXApiDelegate {
  /// Wechat response
  /// - Parameter resp: response type
  public func onResp(_ resp: BaseResp) {
    if let response = resp as? PayResp {
      delegate?.wechat(self, didRecievePayResponse: response)
    } else if let response = resp as? SendMessageToWXResp {
      delegate?.wechat(self, didRecieveMessageResponse: response)
    } else if let response = resp as? SendAuthResp {
      delegate?.wechat(self, didRecieveAuthResponse: response)
    } else if let response = resp as? AddCardToWXCardPackageResp {
      delegate?.wechat(self, didRecieveAddCardResponse: response)
    } else if let response = resp as? WXChooseCardResp {
      delegate?.wechat(self, didRecieveChooseCardResponse: response)
    } else if let response = resp as? WXChooseInvoiceResp {
      delegate?.wechat(self, didRecieveChooseInvoiceResponse: response)
    } else if let response = resp as? WXSubscribeMsgResp {
      delegate?.wechat(self, didRecieveSubscribeMsgResponse: response)
    } else if let response = resp as? WXLaunchMiniProgramResp {
      delegate?.wechat(self, didRecieveLaunchMiniProgram: response)
    } else if let response = resp as? WXInvoiceAuthInsertResp {
      delegate?.wechat(self, didRecieveInvoiceAuthInsertResponse: response)
    } else if let response = resp as? WXNontaxPayResp {
      delegate?.wechat(self, didRecieveNonTaxpayResponse: response)
    } else if let response = resp as? WXPayInsuranceResp {
      delegate?.wechat(self, didRecievePayInsuranceResponse: response)
    }
  }

  /// Wechat request
  /// - Parameter req: request type
  public func onReq(_ req: BaseReq) {
    if let request = req as? ShowMessageFromWXReq {
      delegate?.wechat(self, didRecieveShowMessageRequest: request)
    } else if let request = req as? LaunchFromWXReq {
      delegate?.wechat(self, didRecieveLaunchFromWXRequest: request)
    }
  }
}
