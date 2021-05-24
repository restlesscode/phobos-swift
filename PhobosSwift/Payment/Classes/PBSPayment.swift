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
    case alipay(PBSPayment.Alipay.Status)
    case wechatpay(Bool)
  }

  ///
  public enum ResultError: Error {
    case alipay(PBSPayment.Alipay.AlipayError)
    case wechatpay(PBSPayment.Wechatpay.WechatPayError)
  }
}

public class PBSPayment: NSObject {
  private let disposeBag = DisposeBag()

  public static let shared = PBSPayment()
  public let paymentResult = PublishSubject<Result<ResultStatus, ResultError>>()

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
      Wechatpay.shared.pay(wechatPayReq: model)
    case let .aliPay(orderString):
      Alipay.shared.pay(orderString: orderString)
    }
  }

  private func setupBindings() {
    Wechatpay.shared.didRecievePayReusltSubject.subscribe(onNext: { [weak self] result in
      guard let self = self else { return }
      switch result {
      case let .success(success):
        self.paymentResult.onNext(.success(.wechatpay(success)))
      case let .failure(error):
        self.paymentResult.onNext(.failure(.wechatpay(error)))
      }

    }).disposed(by: disposeBag)

    Alipay.shared.didRecievePayReusltSubject
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

  public static func handlePaymentOpen(url: URL) {
    Wechatpay.shared.handleOpen(url: url)
    Alipay.shared.handleOpenURL(url: url)
  }
}
