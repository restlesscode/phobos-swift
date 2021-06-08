//
//
//  PBSInterstitialAd.swift
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

///
public class PBSInterstitialAd: PBSFullScreenPresentingAd {
  internal var interstitialAd: GADInterstitialAd?
  internal var adProvider: PBSAdProvider!
  ///
  public private(set) var adUnitID: String!
  ///
  public init(with adProvider: PBSAdProvider, adUnitID: String) {
    self.adProvider = adProvider
    self.adUnitID = adUnitID
  }

  public func pbs_loadInterstitialAd() {
    switch adProvider {
    case .google:
      GADInterstitialAd.load(withAdUnitID: adUnitID, request: GADRequest()) { [weak self] interstitialAd, error in
        guard let self = self else { return }
        if let error = error {
          PBSLogger.logger.debug(message: "Failed to load interstitial ad with error: \(error.localizedDescription)")
          self.adEventSubject.onNext(.loadFailedWith(error))
          return
        }
        PBSLogger.logger.debug(message: "Rewarded ad loaded.")
        self.adEventSubject.onNext(.loadSuccess)
        self.interstitialAd = interstitialAd
        self.interstitialAd?.fullScreenContentDelegate = self
      }
    default:
      break
    }
  }

  ///
  public func pbs_showInterstitialAdWith(from rootViewController: UIViewController) {
    switch adProvider {
    case .google:
      DispatchQueue.main.async {
        if let interstitialAd = self.interstitialAd {
          interstitialAd.present(fromRootViewController: rootViewController)
        } else {
          PBSLogger.logger.debug(message: "Ad wasn't ready")
          self.adEventSubject.onNext(.adNotReady)
        }
      }
    default:
      break
    }
  }
}
