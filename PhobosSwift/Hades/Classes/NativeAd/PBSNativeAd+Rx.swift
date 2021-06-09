//
//
//  PBSNativeAd+Rx.swift
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

extension Reactive where Base: PBSNativeAd {
  ///
  public var delegate: DelegateProxy<PBSNativeAd, PBSNativeAdDelegate> {
    RxPBSNativeAdDelegateProxy.proxy(for: base)
  }

  /// Installs delegate as forwarding delegate on `delegate`.
  /// Delegate won't be retained.
  ///
  /// It enables using normal delegate mechanism with reactive delegate mechanism.
  ///
  /// - parameter delegate: Delegate object.
  /// - returns: Disposable object that can be used to unbind the delegate.
  public func setDelegate(_ delegate: PBSNativeAdDelegate)
    -> Disposable {
    RxPBSNativeAdDelegateProxy.installForwardDelegate(delegate, retainDelegate: false, onProxyForObject: base)
  }

  /// Reactive wrapper for delegate method `nativeAdDidRecordImpression`
  public var nativeAdDidRecordImpression: ControlEvent<PBSNativeAd> {
    let source = RxPBSNativeAdDelegateProxy.proxy(for: base).didRecordImpressionSubject
    return ControlEvent(events: source)
  }

  /// Reactive wrapper for delegate method `nativeAdDidRecordClick`
  public var nativeAdDidRecordClick: ControlEvent<PBSNativeAd> {
    let source = RxPBSNativeAdDelegateProxy.proxy(for: base).didRecordClickSubject
    return ControlEvent(events: source)
  }

  /// Reactive wrapper for delegate method `nativeAdWillPresentScreen`
  public var nativeAdWillPresentScreen: ControlEvent<PBSNativeAd> {
    let source = RxPBSNativeAdDelegateProxy.proxy(for: base).willPresentScreenSubject
    return ControlEvent(events: source)
  }

  /// Reactive wrapper for delegate method `nativeAdWillPresentScreen`
  public var nativeAdwillDismissScreen: ControlEvent<PBSNativeAd> {
    let source = RxPBSNativeAdDelegateProxy.proxy(for: base).willDismissScreenSubject
    return ControlEvent(events: source)
  }

  /// Reactive wrapper for delegate method `nativeAdDidDismissScreen`
  public var nativeAdDidDismissScreen: ControlEvent<PBSNativeAd> {
    let source = RxPBSNativeAdDelegateProxy.proxy(for: base).didDismissScreenSubject
    return ControlEvent(events: source)
  }

  /// Reactive wrapper for delegate method `nativeAdDidDismissScreen`
  public var nativeAdIsMuted: ControlEvent<PBSNativeAd> {
    let source = RxPBSNativeAdDelegateProxy.proxy(for: base).isMutedSubject
    return ControlEvent(events: source)
  }
}

extension Reactive where Base: PBSNativeAd {
  ///
  public var adLoaderdelegate: DelegateProxy<PBSNativeAd, PBSNativeAdLoaderDelegate> {
    RxPBSNativeAdLoaderDelegateProxy.proxy(for: base)
  }

  /// Installs delegate as forwarding delegate on `delegate`.
  /// Delegate won't be retained.
  ///
  /// It enables using normal delegate mechanism with reactive delegate mechanism.
  ///
  /// - parameter delegate: Delegate object.
  /// - returns: Disposable object that can be used to unbind the delegate.
  public func setAdLoaderDelegate(_ delegate: PBSNativeAdLoaderDelegate)
    -> Disposable {
    RxPBSNativeAdLoaderDelegateProxy.installForwardDelegate(delegate, retainDelegate: false, onProxyForObject: base)
  }

  /// Reactive wrapper for delegate method `adLoaderDidReceive`
  public var adLoaderDidReceive: ControlEvent<PBSNativeAd> {
    let source = RxPBSNativeAdLoaderDelegateProxy.proxy(for: base).didReceiveSubject
    return ControlEvent(events: source)
  }

  /// Reactive wrapper for delegate method `adLoaderDidFailToReceiveAdWithError`
  public var adLoaderDidFailToReceiveAdWithError: ControlEvent<Error> {
    let source = RxPBSNativeAdLoaderDelegateProxy.proxy(for: base).didFailToReceiveAdWithErrorSubject
    return ControlEvent(events: source)
  }

  /// Reactive wrapper for delegate method `adLoaderDidFinishLoading`
  public var adLoaderDidFinishLoading: ControlEvent<Void> {
    let source = RxPBSNativeAdLoaderDelegateProxy.proxy(for: base).didFinishLoadingSubject
    return ControlEvent(events: source)
  }
}
