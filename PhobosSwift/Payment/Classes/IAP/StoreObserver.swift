//
//
//  StoreObserver.swift
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

import PhobosSwiftLog
import RxCocoa
import RxSwift
import StoreKit

extension PBSPayment.IAP {
  // MARK: delegate methods

  class StoreObserver: NSObject {
    static let shared = StoreObserver()

    let disposeBag = DisposeBag()

    // 在途restore的products
    private var ongoingRestoreProductIdentifiers: Set<String> = []
    var needReceiptVerification = true

    private var _purchaseTransactionSubject: PublishSubject<(SKPaymentTransaction, Result<PBSPayment.IAP.ReceiptResult, Error>?)>?
    private var _restoredTransactionSubject: PublishSubject<(SKPaymentTransaction, Result<PBSPayment.IAP.ReceiptResult, Error>?, Bool)>?
    private var _restoredOrderPlacedSubject: PublishSubject<([SKPaymentTransaction], error: Error?)>?

    internal var purchaseTransactionSubject: PublishSubject<(SKPaymentTransaction, Result<PBSPayment.IAP.ReceiptResult, Error>?)> {
      if let subject = _purchaseTransactionSubject {
        return subject
      }

      let subject = PublishSubject<(SKPaymentTransaction, Result<PBSPayment.IAP.ReceiptResult, Error>?)>()
      _purchaseTransactionSubject = subject

      return subject
    }

    internal var restoredTransactionSubject: PublishSubject<(SKPaymentTransaction, Result<PBSPayment.IAP.ReceiptResult, Error>?, Bool)> {
      if let subject = _restoredTransactionSubject {
        return subject
      }

      let subject = PublishSubject<(SKPaymentTransaction, Result<PBSPayment.IAP.ReceiptResult, Error>?, Bool)>()
      _restoredTransactionSubject = subject

      return subject
    }

    internal var restoredOrderPlacedSubject: PublishSubject<([SKPaymentTransaction], error: Error?)> {
      if let subject = _restoredOrderPlacedSubject {
        return subject
      }

      let subject = PublishSubject<([SKPaymentTransaction], error: Error?)>()
      _restoredOrderPlacedSubject = subject

      return subject
    }

    /// 购买：一次性消费的购买，或者非一次性消费的购买，不包括（自动续期/非自动续期的订阅）
    ///
    /// - parameter applicationUsername:
    /// 建议加入applicationUsername，可以是你当前的用户名，这样来帮助app store去初步查验出一些不合规的行为
    /// Apple原文建议如下: Use this property to help the store detect irregular activity. For example, in a game,
    /// it would be unusual for dozens of different iTunes Store accounts to make purchases on behalf of the same in-game character.
    /// The recommended implementation is to use a one-way hash of the user’s account name to calculate the value for this property.

    func purchase(product: SKProduct, applicationUsername: String?, simulatesAskToBuyInSandbox: Bool = false) {
      // Create a payment request.
      let payment = SKMutablePayment(product: product)
      payment.simulatesAskToBuyInSandbox = simulatesAskToBuyInSandbox
      payment.applicationUsername = applicationUsername

      // Submit the payment request to the payment queue.
      SKPaymentQueue.default().add(payment)
    }

    /// 恢复指定的非消费型商品购买
    /// 如果您调用该接口，确保您传入的商品必须是non-consumable（非消费型）商品
    func restorePurchases(applicationUsername: String? = nil) {
      ongoingRestoreProductIdentifiers.removeAll()
      // Restore Consumables and Non-Consumables from Apple
      SKPaymentQueue.default().restoreCompletedTransactions(withApplicationUsername: applicationUsername)
    }
  }
}

extension PBSPayment.IAP.StoreObserver: SKPaymentTransactionObserver {
  /// Called when there are transactions in the payment queue.
  public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
    ongoingRestoreProductIdentifiers = Set(transactions.filter {
      $0.transactionState == .restored && $0.original != nil
    }.compactMap {
      $0.original!.payment.productIdentifier
    })

    // Handle transaction states here.
    for transaction in transactions {
      switch transaction.transactionState {
      // Call the appropriate custom method for the transaction state.
      case .purchased:
        // Provide the purchased functionality
        handlePurchased(transaction)
      case .purchasing:
        // Update your UI to reflect the in-progress status, and wait to be called again.
        purchaseTransactionSubject.onNext((transaction, nil))
      case .failed:
        handleFailed(transaction)
      case .restored:
        // Restore the previously purchased functionality
        handleRestored(transaction)
      case .deferred:
        // Update your UI to reflect the deferred status, and wait to be called again.
        purchaseTransactionSubject.onNext((transaction, nil))
      @unknown default:
        fatalError("Unknown payment transaction case.")
      }
    }
  }

  /// Logs all transactions that have been removed from the payment queue.
  public func paymentQueue(_ queue: SKPaymentQueue, removedTransactions transactions: [SKPaymentTransaction]) {
    for transaction in transactions {
      PBSLogger.logger.debug(message: "\(transaction.payment.productIdentifier) was removed from the payment queue.", context: "Payment")
    }
  }

  /// Called when an error occur while restoring purchases. Notify the user about the error.
  public func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
    if let error = error as? SKError, error.code != .paymentCancelled {
      restoredOrderPlacedSubject.onNext((queue.transactions, error))
    }
  }

  /// Called when all restorable transactions have been processed by the payment queue.
  public func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
    if ongoingRestoreProductIdentifiers.isEmpty {
      restoredOrderPlacedSubject.onNext((queue.transactions, nil))
    }
  }

  private func handlePurchased(_ transaction: SKPaymentTransaction) {
    PBSLogger.logger.debug(message: "Deliver content for \(transaction.payment.productIdentifier).", context: "Payment")

    // 利用SDK，进行票据验证
    if needReceiptVerification {
      PBSPayment.IAP.shared.fetchReadableReceiptFromAppStore().subscribe(onNext: { [weak self] receiptResult in
        guard let self = self else { return }
        if PBSPayment.IAP.shared.verifyPurchase(transaction: transaction, with: receiptResult) {
          self.purchaseTransactionSubject.onNext((transaction, .success(receiptResult)))
          /// 这里成功后就finishTransaction是很不厚道的，因为还没in-app内容还没发放完成，不过，先收钱再说了
          SKPaymentQueue.default().finishTransaction(transaction)

        } else {
          self.receiptVerifyFailedInPurchase(with: PBSPayment.IAP.ReceiptError(code: .receiptVerifyFailed), in: transaction)
        }

      }, onError: { [weak self] error in
        guard let self = self, let error = error as? PBSPayment.IAP.ReceiptError else { return }
        self.receiptVerifyFailedInPurchase(with: error, in: transaction)
      }).disposed(by: disposeBag)
    }
    // 自行进行票据验证
    else {
      purchaseTransactionSubject.onNext((transaction, nil))
      SKPaymentQueue.default().finishTransaction(transaction)
    }
  }

  private func handleRestored(_ transaction: SKPaymentTransaction) {
    guard transaction.original?.payment.productIdentifier != nil else { return }

    // 如果需要sdk做票据验证
    if needReceiptVerification {
      PBSPayment.IAP.shared.fetchReadableReceiptFromAppStore().subscribe(onNext: { [weak self] receiptResult in
        guard let self = self else { return }
        if PBSPayment.IAP.shared.verifyRestore(transaction: transaction.original!, with: receiptResult) {
          // 删除在途的restore产品
          if self.ongoingRestoreProductIdentifiers.contains(transaction.payment.productIdentifier) {
            self.ongoingRestoreProductIdentifiers.remove(transaction.payment.productIdentifier)
            self.restoredTransactionSubject.onNext((transaction, .success(receiptResult), self.ongoingRestoreProductIdentifiers.isEmpty))
          }

          SKPaymentQueue.default().finishTransaction(transaction)
        } else {
          self.receiptVerifyFailedInRestore(with: PBSPayment.IAP.ReceiptError(code: .receiptVerifyFailed), in: transaction)
        }
      }, onError: { [weak self] error in
        guard let self = self, let error = error as? PBSPayment.IAP.ReceiptError else { return }
        self.receiptVerifyFailedInRestore(with: error, in: transaction)
      }).disposed(by: disposeBag)
    }
    // 如果不需要sdk做票据验证，自己handle验证
    else {
      // 删除在途的restore产品
      if ongoingRestoreProductIdentifiers.contains(transaction.payment.productIdentifier) {
        ongoingRestoreProductIdentifiers.remove(transaction.payment.productIdentifier)
        restoredTransactionSubject.onNext((transaction, nil, ongoingRestoreProductIdentifiers.isEmpty))
      }
      SKPaymentQueue.default().finishTransaction(transaction)
    }
  }

  private func handleFailed(_ transaction: SKPaymentTransaction) {
    // Use the value of the error property to present a message to the user. For a list of error constants, see SKErrorDomain
    let payment = transaction.payment
    let productIdentifier = payment.productIdentifier

    var iapError = PBSPayment.IAP.IAPError(code: .unknown)

    if let error = transaction.error as? SKError {
      switch error.code {
      case .unknown:
        iapError = PBSPayment.IAP.IAPError(code: .unknown)
      case .clientInvalid:
        iapError = PBSPayment.IAP.IAPError(code: .clientInvalid)
      case .cloudServiceRevoked:
        iapError = PBSPayment.IAP.IAPError(code: .cloudServiceRevoked)
      case .cloudServicePermissionDenied:
        iapError = PBSPayment.IAP.IAPError(code: .cloudServicePermissionDenied)
      case .paymentCancelled:
        iapError = PBSPayment.IAP.IAPError(code: .paymentCancelled)
      case .paymentInvalid:
        iapError = PBSPayment.IAP.IAPError(code: .paymentInvalid)
      case .paymentNotAllowed:
        iapError = PBSPayment.IAP.IAPError(code: .paymentNotAllowed)
      case .storeProductNotAvailable:
        iapError = PBSPayment.IAP.IAPError(code: .storeProductNotAvailable)
      case .cloudServiceNetworkConnectionFailed:
        iapError = PBSPayment.IAP.IAPError(code: .cloudServiceNetworkConnectionFailed)
      case .privacyAcknowledgementRequired:
        iapError = PBSPayment.IAP.IAPError(code: .privacyAcknowledgementRequired)
      case .unauthorizedRequestData:
        iapError = PBSPayment.IAP.IAPError(code: .unauthorizedRequestData)
      case .invalidOfferIdentifier:
        iapError = PBSPayment.IAP.IAPError(code: .invalidOfferIdentifier)
      case .invalidSignature:
        iapError = PBSPayment.IAP.IAPError(code: .invalidSignature)
      case .missingOfferParams:
        iapError = PBSPayment.IAP.IAPError(code: .missingOfferParams)
      case .invalidOfferPrice:
        iapError = PBSPayment.IAP.IAPError(code: .invalidOfferPrice)
      case .overlayCancelled:
        iapError = PBSPayment.IAP.IAPError(code: .overlayCancelled)
      case .overlayInvalidConfiguration:
        iapError = PBSPayment.IAP.IAPError(code: .overlayInvalidConfiguration)
      case .overlayTimeout:
        iapError = PBSPayment.IAP.IAPError(code: .overlayTimeout)
      case .ineligibleForOffer:
        iapError = PBSPayment.IAP.IAPError(code: .ineligibleForOffer)
      case .unsupportedPlatform:
        iapError = PBSPayment.IAP.IAPError(code: .unsupportedPlatform)
      case .overlayPresentedInBackgroundScene:
        iapError = PBSPayment.IAP.IAPError(code: .overlayPresentedInBackgroundScene)
      @unknown default:
        break
      }
      PBSLogger.logger.debug(message: "transaction failed with product \(productIdentifier) and error \(error)", context: "Payment")
    }

    /// 如果交易失败了，transaction.error一定有error，但是为了防止万一，如果失败了，
    /// transaction.error没有error，那么我们返回CodebaseIAPError.unknown
    purchaseTransactionSubject.onNext((transaction, .failure(iapError)))
    // ok，This transaction should be finished with failure
    SKPaymentQueue.default().finishTransaction(transaction)
  }

  private func receiptVerifyFailedInPurchase(with error: PBSPayment.IAP.ReceiptError, in transaction: SKPaymentTransaction) {
    // 票据没有通过验收，也许是网络不好，也许是票据校验不通过，error中有详细信息
    purchaseTransactionSubject.onNext((transaction, .failure(error)))
    SKPaymentQueue.default().finishTransaction(transaction)
  }

  private func receiptVerifyFailedInRestore(with error: PBSPayment.IAP.ReceiptError, in transaction: SKPaymentTransaction) {
    // 票据没有通过验收，也许是网络不好，也许是票据校验不通过，error中有详细信息
    // 删除在途的restore产品
    if ongoingRestoreProductIdentifiers.contains(transaction.payment.productIdentifier) {
      ongoingRestoreProductIdentifiers.remove(transaction.payment.productIdentifier)
      restoredTransactionSubject.onNext((transaction, .failure(error), ongoingRestoreProductIdentifiers.isEmpty))
    }
    // ok，This transaction should be finished with failure
    SKPaymentQueue.default().finishTransaction(transaction)
  }
}
