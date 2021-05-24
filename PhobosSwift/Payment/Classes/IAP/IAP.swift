//
//
//  IAP.swift
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

extension PBSPayment {
  public class IAP: NSObject {
    public static let shared = IAP()
    let disposeBag = DisposeBag()
    let storeObserver = StoreObserver.shared

    #if DEBUG
    let verifyReceiptURLString = "https://sandbox.itunes.apple.com/verifyReceipt"
    #else
    let verifyReceiptURLString = "https://buy.itunes.apple.com/verifyReceipt"
    #endif

    /// RAC 的 Subjects
    let productsRequestSubject = PublishSubject<SKProductsResponse>()
    let receiptRequestSubject = PublishSubject<Void>()

    public var isAuthorizedForPayments: Bool {
      SKPaymentQueue.canMakePayments()
    }

    /// itunesConnectSharedSecret
    /// 如果涉及到自动续约的内购，必须需要，可以在itunes connect中找到他
    var itunesConnectSharedSecret = ""

    // Initialize the store observer.
    override private init() {
      super.init()
      SKPaymentQueue.default().add(storeObserver)
    }

    /// 配置CodebaseIAP
    ///
    /// - parameter itunesConnectSharedSecret:
    /// 可选参数：itunesConnectSharedSecret 可以是"app-specific shared secret" 或 "master shared secret"
    /// 所谓“app-specific shared secret” 是一个唯一代码，比如“1e88d420308b44959050606fc8d32b95”，
    /// 如果你提供的内购是“auto-renewable subscriptions”这个类型，那么这个代码是用来做收据验证的，
    /// 每个App有且仅能配置一个“app-specific shared secret”
    /// "master shared secret"的用法和“app-specific shared secret”一致，
    /// 区别在于，当你一个itunesconnect账号下有多款App，那么这个"master shared secret"是可以通用的，
    /// 每个itunesconnect账号有且仅能配置一个“master shared secret”
    /// - parameter needReceiptVerification:
    /// needReceiptVerification 如果设置为false（推荐），则由您自己去处理票据的验证，SDK将不负责验证
    public func configure(with itunesConnectSharedSecret: String = "", needReceiptVerification: Bool = true) {
      self.itunesConnectSharedSecret = itunesConnectSharedSecret
      storeObserver.needReceiptVerification = needReceiptVerification
    }

    /// 购买：一次性消费的购买，或者非一次性消费的购买，不包括（自动续期/非自动续期的订阅）
    ///
    /// - parameter applicationUsername:
    /// 建议加入applicationUsername，可以是你当前的用户名，这样来帮助app store去初步查验出一些不合规的行为
    /// Apple原文建议如下: Use this property to help the store detect irregular activity. For example, in a game,
    /// it would be unusual for dozens of different iTunes Store accounts to make purchases on behalf of the same in-game character.
    /// The recommended implementation is to use a one-way hash of the user’s account name to calculate the value for this property.

    public func purchase(product: SKProduct, applicationUsername: String?, isAskToBuy: Bool = false) {
      storeObserver.purchase(product: product, applicationUsername: applicationUsername, isAskToBuy: isAskToBuy)
    }

    /// 恢复指定的非消费型商品购买
    /// 如果您调用该接口，确保您传入的商品必须是non-consumable（非消费型）商品
    public func restorePurchases(applicationUsername: String? = nil) {
      storeObserver.restorePurchases(applicationUsername: applicationUsername)
    }

    /// Fetch information about your products from the App Store.
    ///
    /// - parameter productIdentifiers:[String]
    /// 商品的productIdentifier列表
    /// * 知道每件商品的productIdentifier和商品类型是客户端的责任
    public func fetchProductsFromAppStore(productIdentifiers: [String]) {
      // Create a set for your product identifiers.
      let productIdentifiers = Set(productIdentifiers)
      // Initialize the product request with the above set.
      let productRequest = SKProductsRequest(productIdentifiers: productIdentifiers)

      productRequest.rx.productsRequest.subscribe(onNext: { [weak self] productResponse in
        guard let self = self else { return }
        self.productsRequestSubject.onNext(productResponse)
      }, onError: { [weak self] error in
        guard let self = self else { return }
        self.productsRequestSubject.onError(error)
      }).disposed(by: disposeBag)
      // Send the request to the App Store.
      productRequest.start()
    }

    /// remove Observer
    public func applicationWillTerminateHandler() {
      SKPaymentQueue.default().remove(storeObserver)
    }
  }
}
