//
//
//  IAP+Receipt.swift
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

import Alamofire
import PhobosSwiftLog
import PhobosSwiftNetwork
import RxSwift
import StoreKit

// program mark - Receipt related
extension PBSPayment.IAP {
  /// 刷新凭证
  ///
  /// 会弹出iCloud账户输入框
  public func refreshReceipt() {
    let receiptRefreshRequest = SKReceiptRefreshRequest()

    receiptRefreshRequest.rx.request
      .subscribe(onError: { [weak self] error in
        guard let self = self else { return }
        self.receiptRequestSubject.onError(error)
      }, onCompleted: { [weak self] in
        guard let self = self else { return }
        self.receiptRequestSubject.onCompleted()
      }).disposed(by: disposeBag)

    receiptRefreshRequest.start()
  }

  /// 从设备中读取该App的Receipt
  ///
  var receiptData: Data? {
    guard let url = Bundle.main.appStoreReceiptURL else {
      return nil
    }

    do {
      let data = try Data(contentsOf: url)
      return data
    } catch {
      PBSLogger.logger.error(message: "Error loading receipt data: \(error.localizedDescription)", context: "Payment")
      return nil
    }
  }

  /// 从设备中读取该App的Receipt的base64 string
  ///
  public var receiptDataBase64: String? {
    receiptData?.base64EncodedString()
  }

  /// 访问 App Store 解析 receipt
  /// * 注意，Apple推荐 最好有服务器来做这些事，因为这样可以避免 “中间人”攻击
  /// * 如果您没有服务器做支持，那么由客户端进行验证可以是一个暂时的备选方案
  ///
  public func fetchReadableReceiptFromAppStore() -> Observable<PBSPayment.IAP.ReceiptResult> {
    // 获取票据，如果票据为空
    Observable<PBSPayment.IAP.ReceiptResult>.create { observer in
      guard let data = self.receiptData else {
        observer.onError(PBSPayment.IAP.ReceiptError(code: .receiptNotFound))
        return Disposables.create()
      }

      // Add Headers
      let headers = ["Content-Type": "application/json; charset=utf-8"]

      // JSON Body
      let body: [String: Any] = ["receipt-data": data.base64EncodedString(),
                                 "password": self.itunesConnectSharedSecret]

      // Fetch Request
      PBSNetwork.APIRequest.request(self.verifyReceiptURLString,
                                    method: .post,
                                    parameters: body,
                                    encoding: JSONEncoding.default,
                                    headers: headers)
        .then(onResolved: { (result: Result<PBSPayment.IAP.ReceiptResult, Error>) in
          switch result {
          case let .success(receiptResult):
            if receiptResult.isValidated {
              observer.onNext(receiptResult)
            } else {
              observer.onError(receiptResult.statusError)
            }
          case let .failure(error):
            PBSLogger.logger.error(message: "HTTP Request failed: \(error)", context: "Fetch Receipt")
            observer.onError(PBSPayment.IAP.ReceiptError(code: .receiptRequestFailed))
          }

        })
      return Disposables.create()
    }
  }

  /// 在购买过程中验证
  /// * 注意，1. 这个是通过App Store返回的解析进行验证的
  /// * 注意，2. 这个验证逻辑只有在购买时候有效，对4种商品类型都适用
  ///
  /// - parameter transaction:SKPaymentTransaction
  /// 当前购买的交易信息
  /// - parameter receiptResult:BBIReceiptResult
  /// 从App Store服务器返回的Receipt的解析类
  ///
  /// - return Bool:
  ///
  func verifyPurchase(transaction: SKPaymentTransaction, with receiptResult: PBSPayment.IAP.ReceiptResult) -> Bool {
    guard let receipt = receiptResult.receipt else {
      return false
    }

    let receiptInApp = receipt.in_app.filter {
      // 先判断transaction_id是不是正确
      let isTransactionIdCorrect = $0.transaction_id == transaction.transactionIdentifier ||
        $0.transaction_id == transaction.original?.transactionIdentifier ||
        $0.original_transaction_id == transaction.original?.transactionIdentifier // 如果是重复购买，则需要判断original transaction_id是不是正确

      // 同时，不能有取消日期
      let isNoCancellationDate = $0.cancellation_date == nil
      return isTransactionIdCorrect && isNoCancellationDate
    }

    return !receiptInApp.isEmpty
  }

  /// 在恢复过程中验证
  /// * 注意，1. 这个是通过App Store返回的解析进行验证的
  /// * 注意，2. 这个验证逻辑只有在restore时候有效，对2种商品类型都适用（cosumable 和 non-auto renew subscription的产品不会在restore中出现）
  ///
  /// - parameter transaction: SKPaymentTransaction 当前购买的交易信息
  /// - parameter receiptResult: ReceiptResult 从App Store服务器返回的Receipt的解析类
  ///
  /// - returns: 是否通过验证
  internal func verifyRestore(transaction: SKPaymentTransaction, with receiptResult: PBSPayment.IAP.ReceiptResult) -> Bool {
    guard let receipt = receiptResult.receipt else {
      return false
    }

    let receiptInApp = receipt.in_app.filter {
      // product_id 需是transaction指定的product_id
      $0.product_id == transaction.payment.productIdentifier
    }.filter {
      // original_transaction_id 必须一致
      $0.original_transaction_id == transaction.transactionIdentifier
    }.filter {
      // 不能有取消日期
      $0.cancellation_date == nil
    }.filter {
      // 如果有 expires_date，则必须没有到期
      if let expiresDate = $0.expiresDate {
        return expiresDate >= Date()
      }
      return true
    }

    return !receiptInApp.isEmpty
  }

  /// 该用户对某个“自动续费”的商品的最后一次订阅的详细收据
  ///
  /// * 注意，1. 这个是通过App Store返回的解析进行验证的（我们建议如果交由您自己的服务器处理，也能返回相同的格式）
  /// * 注意，2. 这个只适用（auto renew subscription）的产品
  ///
  /// - parameter autoRenewingProductIdentifier:String 商品的productIdentifier，这个值必须和SKProduct或者SKPayment中的productIdentifier一致
  /// - parameter receiptResult: ReceiptResult 从App Store服务器返回的Receipt的解析类
  ///
  /// - returns: 该用户对该商品的订阅的最后一次票据
  public func lastReceipt(of autoRenewingProductIdentifier: String, with receiptResult: PBSPayment.IAP.ReceiptResult) -> ReceiptInApp? {
    guard let receipt = receiptResult.receipt else {
      return nil
    }

    let receiptInApp = receipt.in_app.filter {
      // product_id 需是productIdentifier
      $0.product_id == autoRenewingProductIdentifier
    }.filter {
      $0.expiresDate != nil
    }.sorted {
      $0.expiresDate! >= $1.expiresDate!
    }.first

    return receiptInApp
  }

  /// 该用户对“自动续费”的商品的订阅是否过期 是否过期
  ///
  /// * 注意，1. 这个是通过App Store返回的解析进行验证的
  /// * 注意，2. 这个只适用（auto renew subscription）的产品
  ///
  /// - parameter productIdentifier:String 商品的productIdentifier，这个值必须和SKProduct或者SKPayment中的productIdentifier一致
  /// - parameter receiptResult: ReceiptResult 从App Store服务器返回的Receipt的解析类
  ///
  /// - returns: 该用户对该商品的订阅是否过期
  public func isExpired(productIdentifier: String, with receiptResult: PBSPayment.IAP.ReceiptResult) -> Bool {
    if let receiptInApp = lastReceipt(of: productIdentifier, with: receiptResult) {
      return receiptInApp.expiresDate! < Date()
    }

    return true
  }

  /// 该用户对“非消费型商品”是否购买过
  ///
  /// * 注意，1. 这个是通过App Store返回的解析进行验证的
  /// * 注意，2. 这个只适用（non-consuming）的产品，如果传入的nonconsumingProductIdentifier不是“非消费型商品”的ID，那么返回的结果将是不可靠的
  ///
  /// - parameter nonconsumingProductIdentifier:String 商品的productIdentifier，这个值必须和SKProduct或者SKPayment中的productIdentifier一致
  /// - parameter receiptResult: ReceiptResult 从App Store服务器返回的Receipt的解析类
  ///
  /// - returns: 该用户对该商品的订阅是否过期
  public func isPurchased(nonconsumingProductIdentifier: String, with receiptResult: PBSPayment.IAP.ReceiptResult) -> Bool {
    guard let receipt = receiptResult.receipt else {
      return false
    }

    let receiptInApp = receipt.in_app.filter {
      // product_id 需是productIdentifier
      $0.product_id == nonconsumingProductIdentifier
    }.filter {
      $0.expiresDate == nil && $0.cancellation_date == nil
    }

    return !receiptInApp.isEmpty
  }
}
