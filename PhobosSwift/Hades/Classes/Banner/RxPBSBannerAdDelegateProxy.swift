//
//
//  RxPBSBannerAdDelegateProxy.swift
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

class RxPBSBannerAdDelegateProxy: DelegateProxy<PBSBannerAd, PBSBannerAdDelegate>, DelegateProxyType {
  /// Typed parent object.
  public private(set) weak var banner: PBSBannerAd?

  /// Parent object for delegate proxy.
  public init(banner: PBSBannerAd) {
    self.banner = banner
    super.init(parentObject: banner, delegateProxy: RxPBSBannerAdDelegateProxy.self)
  }

  public static func currentDelegate(for object: PBSBannerAd) -> PBSBannerAdDelegate? {
    object.delegate
  }

  public static func setCurrentDelegate(_ delegate: PBSBannerAdDelegate?, to object: PBSBannerAd) {
    object.delegate = delegate
  }

  public static func registerKnownImplementations() {
    register { RxPBSBannerAdDelegateProxy(banner: $0) }
  }

  private(set) var didReceiveAdSubject = PublishSubject<PBSBannerAd>()

  private(set) var didFailToReceiveAdWithReasonSubject = PublishSubject<(PBSBannerAd, String)>()

  private(set) var willPresentScreenSubject = PublishSubject<PBSBannerAd>()

  private(set) var willDismissScreenSubject = PublishSubject<PBSBannerAd>()

  private(set) var didDismissScreenSubject = PublishSubject<PBSBannerAd>()

  private(set) var didRecordImpressionSubject = PublishSubject<PBSBannerAd>()
}

// MARK: PBSBannerAdDelegate

extension RxPBSBannerAdDelegateProxy: PBSBannerAdDelegate {
  func bannerViewDidReceiveAd(_ banner: PBSBannerAd) {
    didReceiveAdSubject.onNext(banner)
    _forwardToDelegate?.bannerViewDidReceiveAd(banner)
  }

  func bannerView(_ banner: PBSBannerAd, didFailToReceiveAdWithReason reason: String) {
    didFailToReceiveAdWithReasonSubject.onNext((banner, reason))
    _forwardToDelegate?.bannerView(banner, didFailToReceiveAdWithReason: reason)
  }

  func bannerViewWillPresentScreen(_ banner: PBSBannerAd) {
    willPresentScreenSubject.onNext(banner)
    _forwardToDelegate?.bannerViewWillPresentScreen(banner)
  }

  func bannerViewWillDismissScreen(_ banner: PBSBannerAd) {
    willDismissScreenSubject.onNext(banner)
    _forwardToDelegate?.bannerViewWillDismissScreen(banner)
  }

  func bannerViewDidDismissScreen(_ banner: PBSBannerAd) {
    didDismissScreenSubject.onNext(banner)
    _forwardToDelegate?.bannerViewWillDismissScreen(banner)
  }

  func bannerViewDidRecordImpression(_ banner: PBSBannerAd) {
    didRecordImpressionSubject.onNext(banner)
    _forwardToDelegate?.bannerViewDidRecordImpression(banner)
  }
}
