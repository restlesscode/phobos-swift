//
//
//  RxPBSNativeAdLoaderDelegateProxy.swift
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

class RxPBSNativeAdLoaderDelegateProxy: DelegateProxy<PBSNativeAd, PBSNativeAdLoaderDelegate>, DelegateProxyType {
  /// Typed parent object.
  public private(set) weak var nativeAd: PBSNativeAd?

  /// Parent object for delegate proxy.
  public init(nativeAd: PBSNativeAd) {
    self.nativeAd = nativeAd
    super.init(parentObject: nativeAd, delegateProxy: RxPBSNativeAdLoaderDelegateProxy.self)
  }

  public static func currentDelegate(for object: PBSNativeAd) -> PBSNativeAdLoaderDelegate? {
    object.adLoaderDelegate
  }

  public static func setCurrentDelegate(_ delegate: PBSNativeAdLoaderDelegate?, to object: PBSNativeAd) {
    object.adLoaderDelegate = delegate
  }

  public static func registerKnownImplementations() {
    register { RxPBSNativeAdLoaderDelegateProxy(nativeAd: $0) }
  }

  private(set) var didFailToReceiveAdWithErrorSubject = PublishSubject<Error>()

  private(set) var didFinishLoadingSubject = PublishSubject<Void>()

  private(set) var didReceiveSubject = PublishSubject<PBSNativeAd>()
}

// MARK: PBSNativeAdLoaderDelegate

extension RxPBSNativeAdLoaderDelegateProxy: PBSNativeAdLoaderDelegate {
  func adLoaderDidFailToReceiveAdWithError(_ error: Error) {
    didFailToReceiveAdWithErrorSubject.onNext(error)
    _forwardToDelegate?.adLoaderDidFailToReceiveAdWithError(error)
  }

  func adLoaderDidFinishLoading() {
    didFinishLoadingSubject.onNext(())
    _forwardToDelegate?.adLoaderDidFinishLoading()
  }

  func adLoaderDidReceive(_ nativeAd: PBSNativeAd) {
    didReceiveSubject.onNext(nativeAd)
    _forwardToDelegate?.adLoaderDidReceive(nativeAd)
  }
}
