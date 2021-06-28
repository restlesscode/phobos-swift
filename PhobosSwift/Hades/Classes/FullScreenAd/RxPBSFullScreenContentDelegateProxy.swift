//
//
//  RxPBSFullScreenContentDelegateProxy.swift
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

class RxPBSFullScreenContentDelegateProxy: DelegateProxy<PBSFullScreenPresentingAd, PBSFullScreenContentDelegate>, DelegateProxyType {
  /// Typed parent object.
  public private(set) weak var fullScreenPresentingAd: PBSFullScreenPresentingAd?

  /// Parent object for delegate proxy.
  public init(fullScreenPresentingAd: PBSFullScreenPresentingAd) {
    self.fullScreenPresentingAd = fullScreenPresentingAd
    super.init(parentObject: fullScreenPresentingAd, delegateProxy: RxPBSFullScreenContentDelegateProxy.self)
  }

  public static func currentDelegate(for object: PBSFullScreenPresentingAd) -> PBSFullScreenContentDelegate? {
    object.fullScreenContentDelegate
  }

  public static func setCurrentDelegate(_ delegate: PBSFullScreenContentDelegate?, to object: PBSFullScreenPresentingAd) {
    object.fullScreenContentDelegate = delegate
  }

  public static func registerKnownImplementations() {
    register { RxPBSFullScreenContentDelegateProxy(fullScreenPresentingAd: $0) }
  }

  private(set) var didFailToPresentFullScreenContentWithErrorSubject = PublishSubject<(PBSFullScreenPresentingAd, Error)>()

  private(set) var didPresentFullScreenContentSubject = PublishSubject<PBSFullScreenPresentingAd>()

  private(set) var didDismissFullScreenContentSubject = PublishSubject<PBSFullScreenPresentingAd>()

  private(set) var didRecordImpressionSubject = PublishSubject<PBSFullScreenPresentingAd>()
}

// MARK: PBSFullScreenContentDelegate

extension RxPBSFullScreenContentDelegateProxy: PBSFullScreenContentDelegate {
  func ad(_ ad: PBSFullScreenPresentingAd, failedToPresentFullScreenContentWithError error: Error) {
    didFailToPresentFullScreenContentWithErrorSubject.onNext((ad, error))
    _forwardToDelegate?.ad(ad, failedToPresentFullScreenContentWithError: error)
  }

  func adDidPresentFullScreenContent(_ ad: PBSFullScreenPresentingAd) {
    didPresentFullScreenContentSubject.onNext(ad)
    _forwardToDelegate?.adDidPresentFullScreenContent(ad)
  }

  func adDidDismissFullScreenContent(_ ad: PBSFullScreenPresentingAd) {
    didDismissFullScreenContentSubject.onNext(ad)
    _forwardToDelegate?.adDidDismissFullScreenContent(ad)
  }

  func adDidRecordImpression(_ ad: PBSFullScreenPresentingAd) {
    didRecordImpressionSubject.onNext(ad)
    _forwardToDelegate?.adDidRecordImpression(ad)
  }
}
