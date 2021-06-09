//
//
//  PBSFullScreenPresentingAd.swift
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

import GoogleMobileAds
import PhobosSwiftLog
import RxCocoa
import RxSwift

/// Ad load event
public enum PBSAdEvent {
  ///
  case loadFailedWith(_ error: Error)
  ///
  case loadSuccess
  ///
  case adNotReady
  ///
  case didEarnRewarded
}

public class PBSFullScreenPresentingAd: NSObject {
  let disposeBag = DisposeBag()

  let adEventSubject = PublishSubject<PBSAdEvent>()
  ///
  weak var fullScreenContentDelegate: PBSFullScreenContentDelegate?
}

// MARK: GADFullScreenContentDelegate

extension PBSFullScreenPresentingAd: GADFullScreenContentDelegate {
  public func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
    PBSLogger.logger.debug(message: "Ad did fail to present full screen content, the reason is: \(error.localizedDescription)")
    fullScreenContentDelegate?.ad(self, failedToPresentFullScreenContentWithError: error)
  }

  public func adDidPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
    PBSLogger.logger.debug(message: "Ad did present full screen content.")
    fullScreenContentDelegate?.adDidPresentFullScreenContent(self)
  }

  public func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
    PBSLogger.logger.debug(message: "Ad did dismiss full screen content.")
    fullScreenContentDelegate?.adDidDismissFullScreenContent(self)
  }

  public func adDidRecordImpression(_ ad: GADFullScreenPresentingAd) {
    PBSLogger.logger.debug(message: "Ad did record Impression")
    fullScreenContentDelegate?.adDidRecordImpression(self)
  }
}
