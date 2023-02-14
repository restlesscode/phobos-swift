//
//
//  PBSNativeAd.swift
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
import PhobosSwiftCore
import PhobosSwiftLog
import PhobosSwiftUIComponent
import SnapKit

/// PBSNativeAd
public class PBSNativeAd: NSObject {
  /// PBSNativeAdType
  public enum PBSNativeAdType {
    /// customized Ad
    case advanced
    /// small template
    case smallTemplate
    /// medium template
    case mediumTemplate
    /// native video Ad
    case video
  }

  weak var adLoaderDelegate: PBSNativeAdLoaderDelegate?

  weak var delegate: PBSNativeAdDelegate?

  var gADLoader: GADAdLoader?

  public lazy var adLabel = UIView()
  /// ad view's headline asset view.
  public lazy var headlineView = UIView()
  /// ad view's call to action asset view.
  public lazy var callToActionView = UIView()
  /// ad view's icon asset view.
  public lazy var iconView = UIView()
  /// ad view's body asset view.
  public lazy var bodyView = UIView()
  /// ad view's store asset view.
  public lazy var storeView = UIView()
  /// ad view's price asset view.
  public lazy var priceView = UIView()
  /// ad view's image asset view.
  public lazy var imageView = UIView()
  /// ad view's star rating asset view.
  public lazy var starRatingView = UIView()
  /// ad view's advertiser asset view.
  public lazy var advertiserView = UIView()
  /// ad view's media asset view.
  public lazy var mediaView = UIView()
  /// ad view's AdChoices view. Must set adChoicesView before setting
  /// nativeAd, otherwise AdChoices will be rendered according to the preferredAdChoicesPosition
  /// defined in GADNativeAdViewAdOptions.
  public lazy var adChoicesView = UIView()

  /// ad native view
  public lazy var nativeAdView = UIView()

  public var index: Int = 0

  lazy var gADNativeAdView: PBSADMobNativeAdView = .init(frame: .zero)

  /// PBSAdProvider
  public private(set) var adProvider: PBSHades.PBSAdProvider!

  /// PBSNativeAdType
  public private(set) var adType: PBSNativeAdType!

  public init(with adProvider: PBSHades.PBSAdProvider, adType: PBSNativeAdType? = .advanced) {
    self.adProvider = adProvider
    self.adType = adType
    super.init()

    switch adProvider {
    case .google:
      nativeAdView = gADNativeAdView
    default:
      nativeAdView = UIView()
    }
  }

  /// Load native ad
  /// - Parameters:
  ///   - adUnitID: adUnitID
  ///   - rootViewController: rootViewController for presentation
  public func pbs_loadNativaAdWith(adUnitID: String, rootViewController: UIViewController?) {
    switch adProvider {
    case .google:
      let videoOptions = GADVideoOptions()
      videoOptions.customControlsRequested = true

      if adType == .video {
        gADLoader = GADAdLoader(adUnitID: adUnitID, rootViewController: rootViewController, adTypes: [.native], options: [videoOptions])
      } else {
        gADLoader = GADAdLoader(adUnitID: adUnitID, rootViewController: rootViewController, adTypes: [.native], options: nil)
      }
      gADLoader?.delegate = self
      gADLoader?.load(GADRequest())
    default:
      break
    }
  }
}

extension PBSNativeAd: GADAdLoaderDelegate {
  public func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
    PBSLogger.logger.debug(message: "\(adLoader) failed with error: \(error.localizedDescription)")
    adLoaderDelegate?.adLoaderDidFailToReceiveAdWithError(error)
  }

  public func adLoaderDidFinishLoading(_ adLoader: GADAdLoader) {
    PBSLogger.logger.debug(message: "adLoader did finish loading.")
    adLoaderDelegate?.adLoaderDidFinishLoading?()
  }
}

extension PBSNativeAd: GADNativeAdLoaderDelegate {
  public func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADNativeAd) {
    // Set ourselves as the native ad delegate to be notified of native ad events.
    nativeAd.delegate = self

    adLabel = gADNativeAdView.adLabel

    // Populate the native ad view with the native ad assets.
    // The headline and mediaContent are guaranteed to be present in every native ad.
    (gADNativeAdView.headlineView as? UILabel)?.text = nativeAd.headline
    headlineView = gADNativeAdView.headlineView ?? UIView()

    gADNativeAdView.mediaView?.mediaContent = nativeAd.mediaContent
    mediaView = gADNativeAdView.mediaView ?? UIView()

    // Some native ads will include a video asset, while others do not. Apps can use the
    // GADVideoController's hasVideoContent property to determine if one is present, and adjust their
    // UI accordingly.
    let mediaContent = nativeAd.mediaContent
    if mediaContent.hasVideoContent {
      // By acting as the delegate to the GADVideoController, this ViewController receives messages
      // about events in the video lifecycle.
      mediaContent.videoController.delegate = self
    } else {
      gADNativeAdView.mediaView?.contentMode = .scaleToFill
    }

    // These assets are not guaranteed to be present. Check that they are before
    // showing or hiding them.
    (gADNativeAdView.bodyView as? UILabel)?.text = nativeAd.body
    gADNativeAdView.bodyView?.isHidden = nativeAd.body == nil
    bodyView = gADNativeAdView.bodyView ?? UIView()

    (gADNativeAdView.callToActionView as? UIButton)?.setTitle(nativeAd.callToAction, for: .normal)
    gADNativeAdView.callToActionView?.isHidden = nativeAd.callToAction == nil
    callToActionView = gADNativeAdView.callToActionView ?? UIView()

    // In order for the SDK to process touch events properly, user interaction should be disabled.
    gADNativeAdView.callToActionView?.isUserInteractionEnabled = false

    (gADNativeAdView.iconView as? UIImageView)?.image = nativeAd.icon?.image
    (gADNativeAdView.iconView as? UIImageView)?.contentMode = .scaleToFill
    gADNativeAdView.iconView?.isHidden = nativeAd.icon == nil
    iconView = gADNativeAdView.iconView ?? UIView()

    (gADNativeAdView.starRatingView as? CosmosView)?.rating = nativeAd.starRating?.doubleValue ?? 0
    gADNativeAdView.starRatingView?.isHidden = nativeAd.starRating == nil
    starRatingView = gADNativeAdView.starRatingView ?? UIView()

    (gADNativeAdView.storeView as? UILabel)?.text = nativeAd.store
    gADNativeAdView.storeView?.isHidden = nativeAd.store == nil
    storeView = gADNativeAdView.storeView ?? UIView()

    (gADNativeAdView.priceView as? UILabel)?.text = nativeAd.price
    gADNativeAdView.priceView?.isHidden = nativeAd.price == nil
    priceView = gADNativeAdView.priceView ?? UIView()

    (gADNativeAdView.advertiserView as? UILabel)?.text = nativeAd.advertiser
    gADNativeAdView.advertiserView?.isHidden = nativeAd.advertiser == nil
    advertiserView = gADNativeAdView.advertiserView ?? UIView()

    // Associate the native ad view with the native ad object. This is
    // required to make the ad clickable.
    // Note: this should always be done after populating the ad views.
    gADNativeAdView.nativeAd = nativeAd

    if adType == .smallTemplate {
      gADNativeAdView.setupSmallTemplateUI()
    } else if adType == .mediumTemplate {
      gADNativeAdView.setupMediumTemplateUI()
    }

    adLoaderDelegate?.adLoaderDidReceive(self)
  }
}

extension PBSNativeAd: GADNativeAdDelegate {
  public func nativeAdDidRecordImpression(_ nativeAd: GADNativeAd) {
    PBSLogger.logger.debug(message: "\(#function) called")
    delegate?.nativeAdDidRecordClick(self)
  }

  public func nativeAdDidRecordClick(_ nativeAd: GADNativeAd) {
    PBSLogger.logger.debug(message: "\(#function) called")
    delegate?.nativeAdDidRecordClick(self)
  }

  public func nativeAdWillPresentScreen(_ nativeAd: GADNativeAd) {
    PBSLogger.logger.debug(message: "\(#function) called")
    delegate?.nativeAdWillPresentScreen(self)
  }

  public func nativeAdWillDismissScreen(_ nativeAd: GADNativeAd) {
    PBSLogger.logger.debug(message: "\(#function) called")
    delegate?.nativeAdDidDismissScreen(self)
  }

  public func nativeAdDidDismissScreen(_ nativeAd: GADNativeAd) {
    PBSLogger.logger.debug(message: "\(#function) called")
    delegate?.nativeAdDidDismissScreen(self)
  }

  public func nativeAdIsMuted(_ nativeAd: GADNativeAd) {
    PBSLogger.logger.debug(message: "\(#function) called")
    delegate?.nativeAdIsMuted(self)
  }
}

extension PBSNativeAd: GADVideoControllerDelegate {
  // Implement this method to receive a notification when the video controller
  // begins playing the ad.
  public func videoControllerDidPlayVideo(_ videoController: GADVideoController) {
    PBSLogger.logger.debug(message: "\(#function) called")
  }

  // Implement this method to receive a notification when the video controller
  // pauses the ad.
  public func videoControllerDidPauseVideo(_ videoController: GADVideoController) {
    PBSLogger.logger.debug(message: "\(#function) called")
  }

  // Implement this method to receive a notification when the video controller
  // stops playing the ad.
  public func videoControllerDidEndVideoPlayback(_ videoController: GADVideoController) {
    PBSLogger.logger.debug(message: "\(#function) called")
  }

  // Implement this method to receive a notification when the video controller
  // mutes the ad.
  public func videoControllerDidMuteVideo(_ videoController: GADVideoController) {
    PBSLogger.logger.debug(message: "\(#function) called")
  }

  // Implement this method to receive a notification when the video controller
  // unmutes the ad.
  public func videoControllerDidUnmuteVideo(_ videoController: GADVideoController) {
    PBSLogger.logger.debug(message: "\(#function) called")
  }
}
