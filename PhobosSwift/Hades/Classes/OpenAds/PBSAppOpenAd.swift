//
//
//  PBSAppOpenAd.swift
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
public class PBSAppOpenAd: PBSFullScreenPresentingAd {
  internal var appOpenAd: GADAppOpenAd?
  internal var adProvider: PBSHades.PBSAdProvider!
  internal var lastLoadTime: Date?
  ///
  public private(set) var adUnitID: String!
  ///
  public init(with adProvider: PBSHades.PBSAdProvider, adUnitID: String) {
    self.adProvider = adProvider
    self.adUnitID = adUnitID
  }

  ///
  public func pbs_loadAppOpenAd(with orientation: UIInterfaceOrientation) {
    switch adProvider {
    case .google:
      appOpenAd = nil
      GADAppOpenAd.load(withAdUnitID: adUnitID, request: GADRequest(), orientation: orientation) { [weak self] appOpenAd, error in
        guard let self = self else { return }
        if let error = error {
          PBSLogger.logger.debug(message: "Failed to load app open ad with error: \(error.localizedDescription)")
          self.adEventSubject.onNext(.loadFailedWith(error))
          return
        }
        PBSLogger.logger.debug(message: "App open ad loaded.")
        self.adEventSubject.onNext(.loadSuccess)
        self.appOpenAd = appOpenAd
        self.appOpenAd?.fullScreenContentDelegate = self
        self.lastLoadTime = Date()
      }
    default:
      break
    }
  }

  ///
  public func pbs_showAppOpenAdWith(from rootViewController: UIViewController, timerInterval hours: Int) {
    switch adProvider {
    case .google:
      DispatchQueue.main.async {
        if let appOpenAd = self.appOpenAd, self.wasLoadTimeLessThanNHoursAgo(n: hours) {
          appOpenAd.present(fromRootViewController: rootViewController)
        } else {
          PBSLogger.logger.debug(message: "Ad wasn't ready")
          self.adEventSubject.onNext(.adNotReady)
        }
      }
    default:
      break
    }
  }

  private func wasLoadTimeLessThanNHoursAgo(n: Int) -> Bool {
    guard let lastLoadTime = lastLoadTime else {
      return true
    }
    let timeIntervalBetweenNowAndLoadTime: TimeInterval = Date().timeIntervalSince(lastLoadTime)
    let intervalInHours = timeIntervalBetweenNowAndLoadTime / (60 * 60)
    return Int(intervalInHours) < n
  }
}
