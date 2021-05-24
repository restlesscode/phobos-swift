//
//
//  PBSWechatPayment.swift
//  PhobosSwiftPayment
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
import PhobosSwiftLog
import PhobosSwiftWechat
import RxSwift

extension PBSPayment {
  public class Wechatpay: NSObject {
    private let disposeBag = DisposeBag()

    public static let shared = Wechatpay()
    public private(set) var didRecievePayReusltSubject = PublishSubject<Result<Bool, Wechatpay.WechatPayError>>()
    public private(set) var wechatSDK = PBSWechat.shared

    override private init() {
      super.init()
      setupBindings()
    }

    public func pay(wechatPayReq: WechatPayReq) {
      guard PBSWechat.isWXAppInstalled else {
        didRecievePayReusltSubject.onNext(.failure(.wechatNotInstalled))
        return
      }
      guard PBSWechat.isWXAppSupportApi else {
        didRecievePayReusltSubject.onNext(.failure(.wechatApiNotSupported))
        return
      }
      let payReq = PayReq()
      payReq.partnerId = wechatPayReq.partnerId
      payReq.prepayId = wechatPayReq.prepayId
      payReq.nonceStr = wechatPayReq.nonceStr
      payReq.timeStamp = UInt32(wechatPayReq.timeStamp) ?? 0
      payReq.package = wechatPayReq.package
      payReq.sign = wechatPayReq.sign
      wechatSDK.sendReq(requset: payReq, completion: nil)
    }

    private func setupBindings() {
      wechatSDK.rx.didRecievePayResponse.subscribe(onNext: { [weak self] _, response in
        guard let self = self, let errcode = PBSWechat.Code(rawValue: response.errCode) else { return }
        switch errcode {
        case .complete:
          self.didRecievePayReusltSubject.onNext(.success(true))
        default:
          self.didRecievePayReusltSubject.onNext(.failure(.wechatPayResultError(errcode)))
        }
      }).disposed(by: disposeBag)
    }

    public func configure(appId: String, universalLink: String) {
      wechatSDK.configure(appId: appId, universalLink: universalLink)
    }

    public func handleOpen(url: URL) {
      wechatSDK.handleOpen(url: url)
    }

    @discardableResult
    func handleOpenUniversalLink(userActivity: NSUserActivity) -> Bool {
      wechatSDK.handleOpenUniversalLink(userActivity: userActivity)
    }
  }
}

extension PBSPayment.Wechatpay {
  public enum WechatPayError: Error {
    case wechatNotInstalled
    case wechatApiNotSupported
    case wechatPayResultError(PBSWechat.Code)

    var description: String {
      switch self {
      case .wechatNotInstalled:
        PBSLogger.logger.debug(message: "用户手机未安装微信", context: "Payment")
        return "用户手机未安装微信"
      case .wechatApiNotSupported:
        PBSLogger.logger.debug(message: "用户手机不支持微信支付", context: "Payment")
        return "用户手机不支持微信支付"
      case let .wechatPayResultError(error):
        return error.description
      }
    }
  }
}

/// WechatPayRequest
public struct WechatPayReq: Codable {
  public var timeStamp: String
  public var nonceStr: String
  public var package: String
  public var partnerId: String
  public var prepayId: String
  public var sign: String

  enum CodingKeys: String, CodingKey {
    case timeStamp = "timestamp"
    case nonceStr = "noncestr"
    case package
    case partnerId = "partnerid"
    case prepayId = "prepayid"
    case sign
  }
}
