//
//
//  PBSPayment.swift
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
import PhobosSwiftNetwork
import PhobosSwiftWechat
import RxCocoa
import RxSwift

extension PBSPayment {
  /// 支付方式
  public enum Channel {
    /// 支付宝
    case aliPay(String)
    /// 微信
    case wechatPay(WechatPayReq)
    /// 应用内购
    case inAppPurchase
    /// 苹果支付
    case applePay
  }

  /// Pay Result code
  public struct ResultCode {
    /// code
    public var code: Int
    /// description
    public var description: String
  }

  ///
  public enum ResultStatus {
    case alipay(PBSAlipayPayment.AlipayStatus)
    case wechatpay(Bool)
  }

  ///
  public enum ResultError: Error {
    case alipay(PBSAlipayPayment.AlipayError)
    case wechatpay(PBSPayment.WechatPay.WechatPayError)
  }
}

public class PBSPayment: NSObject {
  private let disposeBag = DisposeBag()

  public static let shared = PBSPayment()
  public let paymentResult = PublishSubject<Result<ResultStatus, ResultError>>()
  public let wechatPay = PBSPayment.WechatPay.shared
  public let aliPay = PBSAlipayPayment.shared

  private let appDelegateSwizzler = PaymentAppDelegateSwizzler()

  override private init() {
    super.init()
    appDelegateSwizzler.load()
  }

  deinit {
    appDelegateSwizzler.unload()
  }

  /// 开始付款
  public func startPay(method: Channel) {
    switch method {
    case let .wechatPay(model):
      wechatPay.pay(wechatPayReq: model)
    case let .aliPay(orderString):
      aliPay.pay(orderString: orderString)
    default:
      break
    }
  }

  private func setupBindings() {
    wechatPay.didRecievePayReusltSubject.subscribe(onNext: { [weak self] result in
      guard let self = self else { return }
      switch result {
      case let .success(success):
        self.paymentResult.onNext(.success(.wechatpay(success)))
      case let .failure(error):
        self.paymentResult.onNext(.failure(.wechatpay(error)))
      }

    }).disposed(by: disposeBag)

    aliPay.didRecievePayReusltSubject
      .subscribe(onNext: { [weak self] result in
        guard let self = self else { return }
        switch result {
        case let .success(success):
          self.paymentResult.onNext(.success(.alipay(success)))
        case let .failure(error):
          self.paymentResult.onNext(.failure(.alipay(error)))
        }
      })
      .disposed(by: disposeBag)
  }

  public static func handlePaymentOpenURL(url: URL) {
    PBSPayment.shared.handleWechatOpen(url: url)
    PBSPayment.shared.handleAlipayOpenURL(url: url)
  }
}

/// handle wechatPay/aliPay url
extension PBSPayment {
  /// 处理支付宝通过URL启动App时传递的数据
  func handleAlipayOpenURL(url: URL) {
    aliPay.handleAlipayOpenURL(url: url)
  }

  /// 处理旧版微信通过URL启动App时传递的数据
  @discardableResult
  func handleWechatOpen(url: URL) -> Bool {
    wechatPay.wechatSDK.handleOpen(url: url)
  }

  /// 处理微信通过Universal Link启动App时传递的数据
  @discardableResult
  func handleOpenWechatUniversalLink(userActivity: NSUserActivity) -> Bool {
    wechatPay.wechatSDK.handleOpenUniversalLink(userActivity: userActivity)
  }
}
