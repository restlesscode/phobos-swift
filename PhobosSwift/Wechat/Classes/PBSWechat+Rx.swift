//
//
//  PBSWechat+Rx.swift
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

extension Reactive where Base: PBSWechat {
  /// DelegateProxy for PBSWechatDelegate
  public var delegate: DelegateProxy<PBSWechat, PBSWechatDelegate> {
    RxPBSWechatDelegateProxy.proxy(for: base)
  }

  /// Reactive wrapper for delegate method `didRecievePayResponse`
  public var didRecievePayResponse: ControlEvent<(PBSWechat, PayResp)> {
    let source = RxPBSWechatDelegateProxy.proxy(for: base).didReceivePayResponseSubject
    return ControlEvent(events: source)
  }

  /// Reactive wrapper for delegate method `didRecieveShowMessageRequest`
  public var didRecieveShowMessageRequest: ControlEvent<(PBSWechat, ShowMessageFromWXReq)> {
    let source = RxPBSWechatDelegateProxy.proxy(for: base).didRecieveShowMessageRequestSubject
    return ControlEvent(events: source)
  }

  /// Reactive wrapper for delegate method `didRecieveLaunchFromWXRequest`
  public var didRecieveLaunchFromWXRequest: ControlEvent<(PBSWechat, LaunchFromWXReq)> {
    let source = RxPBSWechatDelegateProxy.proxy(for: base).didRecieveLaunchFromWXRequestSubject
    return ControlEvent(events: source)
  }

  /// Reactive wrapper for delegate method `didRecieveMessageResponse`
  public var didRecieveMessageResponse: ControlEvent<(PBSWechat, SendMessageToWXResp)> {
    let source = RxPBSWechatDelegateProxy.proxy(for: base).didRecieveMessageResponseSubject
    return ControlEvent(events: source)
  }

  /// Reactive wrapper for delegate method `didRecieveAuthResponse`
  public var didRecvAuthResponse: ControlEvent<(PBSWechat, SendAuthResp)> {
    let source = RxPBSWechatDelegateProxy.proxy(for: base).didRecieveAuthResponseSubject
    return ControlEvent(events: source)
  }

  /// Reactive wrapper for delegate method `didRecieveAddCardResponse`
  public var didRecieveAddCardResponse: ControlEvent<(PBSWechat, AddCardToWXCardPackageResp)> {
    let source = RxPBSWechatDelegateProxy.proxy(for: base).didRecieveAddCardResponseSubject
    return ControlEvent(events: source)
  }

  /// Reactive wrapper for delegate method `didRecieveChooseCardResponse`
  public var didRecieveChooseCardResponse: ControlEvent<(PBSWechat, WXChooseCardResp)> {
    let source = RxPBSWechatDelegateProxy.proxy(for: base).didRecieveChooseCardResponseSubject
    return ControlEvent(events: source)
  }

  /// Reactive wrapper for delegate method `didRecieveChooseInvoiceResponse`
  public var didRecieveChooseInvoiceResponse: ControlEvent<(PBSWechat, WXChooseInvoiceResp)> {
    let source = RxPBSWechatDelegateProxy.proxy(for: base).didRecieveChooseInvoiceResponseSubject
    return ControlEvent(events: source)
  }

  /// Reactive wrapper for delegate method `didRecieveSubscribeMsgResponse`
  public var didRecieveSubscribeMsgResponse: ControlEvent<(PBSWechat, WXSubscribeMsgResp)> {
    let source = RxPBSWechatDelegateProxy.proxy(for: base).didRecieveSubscribeMsgResponseSubject
    return ControlEvent(events: source)
  }

  /// Reactive wrapper for delegate method `didRecieveLaunchMiniProgram`
  public var didRecieveLaunchMiniProgram: ControlEvent<(PBSWechat, WXLaunchMiniProgramResp)> {
    let source = RxPBSWechatDelegateProxy.proxy(for: base).didRecieveLaunchMiniProgramSubject
    return ControlEvent(events: source)
  }

  /// Reactive wrapper for delegate method `didRecieveInvoiceAuthInsertResponse`
  public var didRecieveInvoiceAuthInsertResponse: ControlEvent<(PBSWechat, WXInvoiceAuthInsertResp)> {
    let source = RxPBSWechatDelegateProxy.proxy(for: base).didRecieveInvoiceAuthInsertResponseSubject
    return ControlEvent(events: source)
  }

  /// Reactive wrapper for delegate method `didRecieveNonTaxpayResponse`
  public var didRecieveNonTaxpayResponse: ControlEvent<(PBSWechat, WXNontaxPayResp)> {
    let source = RxPBSWechatDelegateProxy.proxy(for: base).didRecieveNonTaxpayResponseSubject
    return ControlEvent(events: source)
  }

  /// Reactive wrapper for delegate method `didRecievePayInsuranceResponse`
  public var didRecievePayInsuranceResponse: ControlEvent<(PBSWechat, WXPayInsuranceResp)> {
    let source = RxPBSWechatDelegateProxy.proxy(for: base).didRecievePayInsuranceResponseSubject
    return ControlEvent(events: source)
  }

  /// Installs delegate as forwarding delegate on `delegate`.
  /// Delegate won't be retained.
  ///
  /// It enables using normal delegate mechanism with reactive delegate mechanism.
  ///
  /// - parameter delegate: Delegate object.
  /// - returns: Disposable object that can be used to unbind the delegate.
  public func setDelegate(_ delegate: PBSWechatDelegate)
    -> Disposable {
    RxPBSWechatDelegateProxy.installForwardDelegate(delegate, retainDelegate: false, onProxyForObject: base)
  }
}
