//
//
//  SceneDelegate.swift
//  PhobosSwiftExample
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

import AdSupport
import AppTrackingTransparency
import PhobosSwiftHades
import RxCocoa
import RxSwift
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?
  let disposeBag = DisposeBag()
  var appOpenAd = PBSAppOpenAd(with: .google, adUnitID: PhobosSwiftExample.Constants.kTestGADAppOpenAdUnitID)

  func scene(_ scene: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) {
    // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
    // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
    // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
    guard let _ = (scene as? UIWindowScene) else { return }
    PBSHades.configuration(adProviders: [.google])
    if #available(iOS 14, *) {
      ATTrackingManager.requestTrackingAuthorization { status in
        switch status {
        case .authorized:
          let idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
          print("IDFA: \(idfa)")
        default:
          print("请在设置-隐私-跟踪中允许App请求跟踪")
        }
      }
    } else {
      if ASIdentifierManager.shared().isAdvertisingTrackingEnabled {
        let idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        print("IDFA: \(idfa)")
      } else {
        print("请在设置-隐私-广告中打开广告跟踪功能")
      }
    }
    setupBindings()
    window?.rootViewController = UINavigationController(rootViewController: MainViewController())
  }

  func sceneDidDisconnect(_: UIScene) {
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
  }

  func sceneDidBecomeActive(_: UIScene) {
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
  }

  func sceneWillResignActive(_: UIScene) {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
  }

  func sceneWillEnterForeground(_: UIScene) {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
  }

  func sceneDidEnterBackground(_: UIScene) {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
  }

  private func setupBindings() {
    appOpenAd.rx.event.subscribe(onNext: { [weak self] event in
      guard let self = self else { return }
      switch event {
      case .loadSuccess:
        /// should do nothing
        break
      case .loadFailedWith:
        /// load failed
        break
      case .adNotReady:
        self.appOpenAd.pbs_loadAppOpenAd(with: .portrait)
      default:
        break
      }
    }).disposed(by: disposeBag)

    appOpenAd.rx.adDidFailToPresentFullScreenContentWithError.subscribe(onNext: { [weak self] ad, error in
      guard let self = self else { return }
      if ad is PBSAppOpenAd {
        print("Ad did fail to present screen content with reason: \(error.localizedDescription)")
        self.appOpenAd.pbs_loadAppOpenAd(with: .portrait)
      }
    }).disposed(by: disposeBag)

    appOpenAd.rx.adDidPresentFullScreenContent.subscribe(onNext: { ad in
      if ad is PBSAppOpenAd {
        print("Ad did present full screen content")
      }
    }).disposed(by: disposeBag)

    appOpenAd.rx.adDidDismissFullScreenContent.subscribe(onNext: { [weak self] ad in
      guard let self = self else { return }
      if ad is PBSAppOpenAd {
        print("Ad did dismiss full screen content")
        self.appOpenAd.pbs_loadAppOpenAd(with: .portrait)
      }
    }).disposed(by: disposeBag)

    appOpenAd.rx.adDidRecordImpression.subscribe(onNext: { ad in
      if let ad = ad as? PBSAppOpenAd {
        print("Ad did record impression with adUnitID: " + ad.adUnitID)
      }
    }).disposed(by: disposeBag)
  }
}
