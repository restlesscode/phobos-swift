//
//
//  PBSAlipayPayment.swift
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
import MirrorAlipaySDK
import PhobosSwiftLog
import RxCocoa
import RxSwift

extension PBSPayment {
  public class Alipay: NSObject {
    public static let shared = Alipay()
    public private(set) var appScheme: String?
    public private(set) var didRecievePayReusltSubject = PublishSubject<Result<PBSPayment.Alipay.Status, PBSPayment.Alipay.AlipayError>>()

    override private init() {
      super.init()
    }

    public func configure(withAppScheme appScheme: String) {
      if appScheme.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
        fatalError("请设置正确的AppURLScheme")
      }
      self.appScheme = appScheme
    }

    public func pay(orderString: String) {
      guard let appScheme = appScheme else {
        fatalError("请在设置中，对AppURLScheme进行设置")
      }
      AlipaySDK.defaultService()?.payOrder(orderString, fromScheme: appScheme, callback: { [weak self] resultDict in
        guard let self = self else { return }
        PBSLogger.logger.debug(message: "AlipaySDK-H5ResultDic--\(String(describing: resultDict))", context: "Payment")
        self.processAlipaySDKCallBack(withPayResult: resultDict)
      })
    }

    public func handleOpen(url: URL) {
      AlipaySDK.defaultService()?.processOrder(withPaymentResult: url, standbyCallback: { resultDict in
        PBSLogger.logger.debug(message: "AlipaySDK-Mobile-ResultDic--\(String(describing: resultDict))", context: "Payment")
        self.processAlipaySDKCallBack(withPayResult: resultDict)
      })
    }

    private func processAlipaySDKCallBack(withPayResult result: [AnyHashable: Any]?) {
      let re = generateResult(withCallbackResult: result)
      didRecievePayReusltSubject.onNext(re)
    }

    func generateResult(withCallbackResult result: [AnyHashable: Any]?) -> Result<Alipay.Status, PBSPayment.Alipay.AlipayError> {
      guard let res: CallbackResult = result?.pbs_model(),
            let resultStatus = res.resultStatus,
            let status = Int(resultStatus) else {
        let error = Alipay.AlipayError.internaleFailed(reason: .alipayResultDecodeError)
        return .failure(error)
      }
      switch status {
      case 9000:
        return .success(.complete)
      case 8000:
        return .success(.processing)
      case 6004:
        return .success(.unknown)
      case 4000:
        return .failure(.alipayFailed(reason: .paymentProcessError))
      case 5000:
        return .failure(.alipayFailed(reason: .paymentRepeat))
      case 6001:
        return .failure(.alipayFailed(reason: .paymentCancel))
      case 6002:
        return .failure(.alipayFailed(reason: .paymentNetworkDown))
      default:
        return .failure(.alipayFailed(reason: .paymentError))
      }
    }
  }
}

extension PBSPayment.Alipay {
  public enum Status {
    case complete
    case processing
    case unknown
  }

  public enum AlipayError: Error, Equatable {
    public enum AlipayFailedReaseon {
      case paymentProcessError
      case paymentCancel
      case paymentError
      case paymentRepeat
      case paymentNetworkDown
    }

    public enum InternalFailedReaseon {
      case alipayResultDecodeError
    }

    case alipayFailed(reason: AlipayFailedReaseon)
    case internaleFailed(reason: InternalFailedReaseon)
  }

  /// alipay callback result
  struct CallbackResult: Codable {
    var memo: String?
    var result: String?
    var resultStatus: String?
  }
}
