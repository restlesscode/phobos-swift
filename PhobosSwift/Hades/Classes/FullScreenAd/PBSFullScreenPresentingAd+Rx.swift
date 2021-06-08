//
//
//  PBSFullScreenPresentingAd+Rx.swift
//  PhobosSwiftHades
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
import RxCocoa
import RxSwift

extension Reactive where Base: PBSFullScreenPresentingAd {
  /// DelegateProxy for CodebaseWechatDelegate
  public var delegate: DelegateProxy<PBSFullScreenPresentingAd, PBSFullScreenContentDelegate> {
    RxPBSFullScreenContentDelegateProxy.proxy(for: base)
  }

  /// Installs delegate as forwarding delegate on `delegate`.
  /// Delegate won't be retained.
  ///
  /// It enables using normal delegate mechanism with reactive delegate mechanism.
  ///
  /// - parameter delegate: Delegate object.
  /// - returns: Disposable object that can be used to unbind the delegate.
  public func setDelegate(_ delegate: PBSFullScreenContentDelegate)
    -> Disposable {
    RxPBSFullScreenContentDelegateProxy.installForwardDelegate(delegate, retainDelegate: false, onProxyForObject: base)
  }

  /// Reactive wrapper for delegate method `adDidFailToPresentFullScreenContentWithError`
  public var adDidFailToPresentFullScreenContentWithError: ControlEvent<(PBSFullScreenPresentingAd, Error)> {
    let source = RxPBSFullScreenContentDelegateProxy.proxy(for: base).didFailToPresentFullScreenContentWithErrorSubject
    return ControlEvent(events: source)
  }

  /// Reactive wrapper for delegate method `adDidPresentFullScreenContent`
  public var adDidPresentFullScreenContent: ControlEvent<PBSFullScreenPresentingAd> {
    let source = RxPBSFullScreenContentDelegateProxy.proxy(for: base).didPresentFullScreenContentSubject
    return ControlEvent(events: source)
  }

  /// Reactive wrapper for delegate method `adDidDismissFullScreenContent`
  public var adDidDismissFullScreenContent: ControlEvent<PBSFullScreenPresentingAd> {
    let source = RxPBSFullScreenContentDelegateProxy.proxy(for: base).didDismissFullScreenContentSubject
    return ControlEvent(events: source)
  }

  /// Reactive wrapper for delegate method `adDidRecordImpression`
  public var adDidRecordImpression: ControlEvent<PBSFullScreenPresentingAd> {
    let source = RxPBSFullScreenContentDelegateProxy.proxy(for: base).didRecordImpressionSubject
    return ControlEvent(events: source)
  }

  ///
  public var event: ControlEvent<PBSAdEvent> {
    let source = base.adEventSubject
    return ControlEvent(events: source)
  }
}
