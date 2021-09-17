//
//
//  RxPBSWechatDelegateProxy.swift
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
import RxCocoa
import RxSwift

class RxPBSWechatDelegateProxy: DelegateProxy<PBSWechat, PBSWechatDelegate>, DelegateProxyType {
  /// Typed parent object.
  public private(set) weak var wechat: PBSWechat?

  /// - parameter textview: Parent object for delegate proxy.
  public init(wechat: PBSWechat) {
    self.wechat = wechat
    super.init(parentObject: wechat, delegateProxy: RxPBSWechatDelegateProxy.self)
  }

  public static func currentDelegate(for object: PBSWechat) -> PBSWechatDelegate? {
    object.delegate
  }

  public static func setCurrentDelegate(_ delegate: PBSWechatDelegate?, to object: PBSWechat) {
    object.delegate = delegate
  }

  public static func registerKnownImplementations() {
    register { RxPBSWechatDelegateProxy(wechat: $0) }
  }

  private(set) var didReceivePayResponseSubject = PublishSubject<(PBSWechat, PayResp)>()

  private(set) var didRecieveShowMessageRequestSubject = PublishSubject<(PBSWechat, ShowMessageFromWXReq)>()

  private(set) var didRecieveLaunchFromWXRequestSubject = PublishSubject<(PBSWechat, LaunchFromWXReq)>()

  private(set) var didRecieveMessageResponseSubject = PublishSubject<(PBSWechat, SendMessageToWXResp)>()

  private(set) var didRecieveAuthResponseSubject = PublishSubject<(PBSWechat, SendAuthResp)>()

  private(set) var didRecieveAddCardResponseSubject = PublishSubject<(PBSWechat, AddCardToWXCardPackageResp)>()

  private(set) var didRecieveChooseCardResponseSubject = PublishSubject<(PBSWechat, WXChooseCardResp)>()

  private(set) var didRecieveChooseInvoiceResponseSubject = PublishSubject<(PBSWechat, WXChooseInvoiceResp)>()

  private(set) var didRecieveSubscribeMsgResponseSubject = PublishSubject<(PBSWechat, WXSubscribeMsgResp)>()

  private(set) var didRecieveLaunchMiniProgramSubject = PublishSubject<(PBSWechat, WXLaunchMiniProgramResp)>()

  private(set) var didRecieveInvoiceAuthInsertResponseSubject = PublishSubject<(PBSWechat, WXInvoiceAuthInsertResp)>()

  private(set) var didRecieveNonTaxpayResponseSubject = PublishSubject<(PBSWechat, WXNontaxPayResp)>()

  private(set) var didRecievePayInsuranceResponseSubject = PublishSubject<(PBSWechat, WXPayInsuranceResp)>()
}

// MARK: PBSWechatDelegate

extension RxPBSWechatDelegateProxy: PBSWechatDelegate {
  /// For more information take a look at `DelegateProxyType`.
  func wechat(_ wechat: PBSWechat, didRecievePayResponse response: PayResp) {
    didReceivePayResponseSubject.onNext((wechat, response))
    _forwardToDelegate?.wechat(wechat, didRecievePayResponse: response)
  }

  func wechat(_ wechat: PBSWechat, didRecieveShowMessageRequest request: ShowMessageFromWXReq) {
    didRecieveShowMessageRequestSubject.onNext((wechat, request))
    _forwardToDelegate?.wechat(wechat, didRecieveShowMessageRequest: request)
  }

  func wechat(_ wechat: PBSWechat, didRecieveLaunchFromWXRequest request: LaunchFromWXReq) {
    didRecieveLaunchFromWXRequestSubject.onNext((wechat, request))
    _forwardToDelegate?.wechat(wechat, didRecieveLaunchFromWXRequest: request)
  }

  func wechat(_ wechat: PBSWechat, didRecieveMessageResponse response: SendMessageToWXResp) {
    didRecieveMessageResponseSubject.onNext((wechat, response))
    _forwardToDelegate?.wechat(wechat, didRecieveMessageResponse: response)
  }

  func wechat(_ wechat: PBSWechat, didRecieveAuthResponse response: SendAuthResp) {
    didRecieveAuthResponseSubject.onNext((wechat, response))
    _forwardToDelegate?.wechat(wechat, didRecieveAuthResponse: response)
  }

  func wechat(_ wechat: PBSWechat, didRecieveAddCardResponse response: AddCardToWXCardPackageResp) {
    didRecieveAddCardResponseSubject.onNext((wechat, response))
    _forwardToDelegate?.wechat(wechat, didRecieveAddCardResponse: response)
  }

  func wechat(_ wechat: PBSWechat, didRecieveChooseCardResponse response: WXChooseCardResp) {
    didRecieveChooseCardResponseSubject.onNext((wechat, response))
    _forwardToDelegate?.wechat(wechat, didRecieveChooseCardResponse: response)
  }

  func wechat(_ wechat: PBSWechat, didRecieveChooseInvoiceResponse response: WXChooseInvoiceResp) {
    didRecieveChooseInvoiceResponseSubject.onNext((wechat, response))
    _forwardToDelegate?.wechat(wechat, didRecieveChooseInvoiceResponse: response)
  }

  func wechat(_ wechat: PBSWechat, didRecieveSubscribeMsgResponse response: WXSubscribeMsgResp) {
    didRecieveSubscribeMsgResponseSubject.onNext((wechat, response))
    _forwardToDelegate?.wechat(wechat, didRecieveSubscribeMsgResponse: response)
  }

  func wechat(_ wechat: PBSWechat, didRecieveLaunchMiniProgram response: WXLaunchMiniProgramResp) {
    didRecieveLaunchMiniProgramSubject.onNext((wechat, response))
    _forwardToDelegate?.wechat(wechat, didRecieveLaunchMiniProgram: response)
  }

  func wechat(_ wechat: PBSWechat, didRecieveInvoiceAuthInsertResponse response: WXInvoiceAuthInsertResp) {
    didRecieveInvoiceAuthInsertResponseSubject.onNext((wechat, response))
    _forwardToDelegate?.wechat(wechat, didRecieveInvoiceAuthInsertResponse: response)
  }

  func wechat(_ wechat: PBSWechat, didRecieveNonTaxpayResponse response: WXNontaxPayResp) {
    didRecieveNonTaxpayResponseSubject.onNext((wechat, response))
    _forwardToDelegate?.wechat(wechat, didRecieveNonTaxpayResponse: response)
  }

  func wechat(_ wechat: PBSWechat, didRecievePayInsuranceResponse response: WXPayInsuranceResp) {
    didRecievePayInsuranceResponseSubject.onNext((wechat, response))
    _forwardToDelegate?.wechat(wechat, didRecievePayInsuranceResponse: response)
  }
}
