//
//
//  PBSBannerAd.swift
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
import SnapKit

/// PBSBannerType
public enum PBSBannerType {
  /// GADBanner
  case google(BannerSize)
  /// BaiduBanner
  case baidu(BannerSize)

  /// BannerSize
  public enum BannerSize {
    /// 自适应,推荐
    case adaptive
    /// 标准类型
    case normal
    /// 中等类型
    case medium
    /// 大型
    case large
    /// 适用于iPad
    case max
  }

  var size: CGSize {
    switch self {
    case .google(.normal):
      return CGSize(width: 320, height: 50)
    case .google(.medium):
      return CGSize(width: 320, height: 100)
    case .google(.large):
      return CGSize(width: 300, height: 250)
    case .google(.max):
      return CGSize(width: 468, height: 60)
    default:
      return .zero
    }
  }
}

/// PBSBannerAdProtocol
public protocol PBSBannerAdProtocol {
  /// 创建一个BannerView
  /// - Parameters:
  ///   - bannerType: banner广告的类型和大小
  ///   - rootViewController: The root view controller is most commonly the view
  /// controller displaying the banner, only for GADBannerView.
  func createBannerView(bannerType: PBSBannerType, rootViewController: UIViewController?) -> UIView
}

public class PBSBannerAd: NSObject, PBSBannerAdProtocol {
  lazy var gADBannerView: GADBannerView = {
    let bannerView = GADBannerView()
    return bannerView
  }()

  weak var delegate: PBSBannerAdDelegate?

  internal var bannerType: PBSBannerType = .google(.adaptive)

  public var bannerView = UIView()

  public var adUnitID: String? {
    didSet {
      switch bannerType {
      case .google:
        gADBannerView.adUnitID = adUnitID
      default:
        break
      }
    }
  }

  public var adaptiveWithWidth: CGFloat? {
    didSet {
      switch bannerType {
      case .google:
        gADBannerView.adSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(adaptiveWithWidth ?? ScreenWidth)
      default:
        break
      }
    }
  }

  public func pbs_requestAd() {
    switch bannerType {
    case .google:
      gADBannerView.load(GADRequest())
    default:
      break
    }
  }

  public func createBannerView(bannerType: PBSBannerType, rootViewController: UIViewController?) -> UIView {
    self.bannerType = bannerType

    switch bannerType {
    case .google(.adaptive):
      gADBannerView.rootViewController = rootViewController
      gADBannerView.delegate = self
      bannerView = gADBannerView
      return gADBannerView
    case .google:
      gADBannerView.rootViewController = rootViewController
      gADBannerView.translatesAutoresizingMaskIntoConstraints = false
      gADBannerView.adSize = GADAdSizeFromCGSize(bannerType.size)
      bannerView = gADBannerView
      gADBannerView.delegate = self
      return gADBannerView
    default:
      return UIView()
    }
  }
}

extension PBSBannerAd: GADBannerViewDelegate {
  /// Tells the delegate an ad request loaded an ad.
  public func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
    PBSLogger.logger.debug(message: "bannerViewDidReceiveAd")
    delegate?.bannerViewDidReceiveAd(self)
  }

  /// Tells the delegate an ad request failed.
  public func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
    PBSLogger.logger.debug(message: "adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    delegate?.bannerView(self, didFailToReceiveAdWithReason: error.localizedDescription)
  }

  /// Tells the delegate that a full-screen view will be presented in response
  /// to the user clicking on an ad.
  public func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {
    PBSLogger.logger.debug(message: "adViewWillPresentScreen")
    delegate?.bannerViewWillPresentScreen(self)
  }

  /// Tells the delegate that the full-screen view will be dismissed.
  public func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
    PBSLogger.logger.debug(message: "bannerViewWillDismissScreen")
    delegate?.bannerViewWillDismissScreen(self)
  }

  /// Tells the delegate that the full-screen view has been dismissed.
  public func bannerViewDidDismissScreen(_ bannerView: GADBannerView) {
    PBSLogger.logger.debug(message: "bannerViewDidDismissScreen")
    delegate?.bannerViewDidDismissScreen(self)
  }

  /// Tells the delegate that an impression has been recorded for an ad.
  public func bannerViewDidRecordImpression(_ bannerView: GADBannerView) {
    PBSLogger.logger.debug(message: "bannerViewDidRecordImpression")
    delegate?.bannerViewDidRecordImpression(self)
  }
}
