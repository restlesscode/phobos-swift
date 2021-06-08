//
//
//  RxPBSNativeAdDelegateProxy.swift
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

class RxPBSNativeAdDelegateProxy: DelegateProxy<PBSNativeAd, PBSNativeAdDelegate>, DelegateProxyType {
  /// Typed parent object.
  public private(set) weak var nativeAd: PBSNativeAd?

  /// Parent object for delegate proxy.
  public init(nativeAd: PBSNativeAd) {
    self.nativeAd = nativeAd
    super.init(parentObject: nativeAd, delegateProxy: RxPBSNativeAdDelegateProxy.self)
  }

  public static func currentDelegate(for object: PBSNativeAd) -> PBSNativeAdDelegate? {
    object.delegate
  }

  public static func setCurrentDelegate(_ delegate: PBSNativeAdDelegate?, to object: PBSNativeAd) {
    object.delegate = delegate
  }

  public static func registerKnownImplementations() {
    register { RxPBSNativeAdDelegateProxy(nativeAd: $0) }
  }

  private(set) var didRecordImpressionSubject = PublishSubject<PBSNativeAd>()

  private(set) var didRecordClickSubject = PublishSubject<PBSNativeAd>()

  private(set) var willPresentScreenSubject = PublishSubject<PBSNativeAd>()

  private(set) var willDismissScreenSubject = PublishSubject<PBSNativeAd>()

  private(set) var didDismissScreenSubject = PublishSubject<PBSNativeAd>()

  private(set) var isMutedSubject = PublishSubject<PBSNativeAd>()
}

// MARK: PBSNativeAdDelegate

extension RxPBSNativeAdDelegateProxy: PBSNativeAdDelegate {
  func nativeAdDidRecordImpression(_ nativeAd: PBSNativeAd) {
    didRecordImpressionSubject.onNext(nativeAd)
    _forwardToDelegate?.nativeAdDidRecordImpression(nativeAd)
  }

  func nativeAdDidRecordClick(_ nativeAd: PBSNativeAd) {
    didRecordClickSubject.onNext(nativeAd)
    _forwardToDelegate?.nativeAdDidRecordClick(nativeAd)
  }

  func nativeAdWillPresentScreen(_ nativeAd: PBSNativeAd) {
    willPresentScreenSubject.onNext(nativeAd)
    _forwardToDelegate?.nativeAdWillPresentScreen(nativeAd)
  }

  func nativeAdWillDismissScreen(_ nativeAd: PBSNativeAd) {
    willDismissScreenSubject.onNext(nativeAd)
    _forwardToDelegate?.nativeAdWillDismissScreen(nativeAd)
  }

  func nativeAdDidDismissScreen(_ nativeAd: PBSNativeAd) {
    didDismissScreenSubject.onNext(nativeAd)
    _forwardToDelegate?.nativeAdDidDismissScreen(nativeAd)
  }

  func nativeAdIsMuted(_ nativeAd: PBSNativeAd) {
    isMutedSubject.onNext(nativeAd)
    _forwardToDelegate?.nativeAdIsMuted(nativeAd)
  }
}
