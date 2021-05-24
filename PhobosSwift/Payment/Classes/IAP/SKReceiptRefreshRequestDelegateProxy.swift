//
//
//  SKReceiptRefreshRequestDelegateProxy+Rx.swift
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

import RxCocoa
import RxSwift
import StoreKit

class SKReceiptRefreshRequestDelegateProxy: DelegateProxy<SKReceiptRefreshRequest, SKRequestDelegate>,
  DelegateProxyType,
  SKRequestDelegate {
  init(parentObject: SKReceiptRefreshRequest) {
    super.init(parentObject: parentObject, delegateProxy: SKReceiptRefreshRequestDelegateProxy.self)
  }

  static func registerKnownImplementations() {
    register { SKReceiptRefreshRequestDelegateProxy(parentObject: $0) }
  }

  static func currentDelegate(for object: SKReceiptRefreshRequest) -> SKRequestDelegate? {
    object.delegate
  }

  static func setCurrentDelegate(_ delegate: SKRequestDelegate?, to object: SKReceiptRefreshRequest) {
    object.delegate = delegate
  }

  let responseSubject = PublishSubject<SKProductsResponse>()

  func requestDidFinish(_ request: SKRequest) {
    _forwardToDelegate?.requestDidFinish?(request)
    responseSubject.onCompleted()
  }

  func request(_ request: SKRequest, didFailWithError error: Error) {
    _forwardToDelegate?.request?(request, didFailWithError: error)
    responseSubject.onError(error)
  }

  deinit {
    responseSubject.on(.completed)
  }
}
