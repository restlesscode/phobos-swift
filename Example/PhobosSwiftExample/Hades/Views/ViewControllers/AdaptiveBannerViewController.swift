//
//
//  AdaptiveBannerViewController.swift
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

import PhobosSwiftHades
import UIKit

class AdaptiveBannerViewController: UIViewController {
  let banner = PBSBannerAd()

  var bannerModel: BannerModel?

  override func viewDidLoad() {
    super.viewDidLoad()
    title = bannerModel?.title
    view.backgroundColor = .pbs.systemBackground
    makeSubviews()
  }

  func makeSubviews() {
    guard let bannerModel = bannerModel else {
      return
    }
    let bannerView = banner.createBannerView(bannerType: bannerModel.bannerType, rootViewController: self)
    banner.adUnitID = PhobosSwiftExample.Constants.kTestGADBannerViewAdUnitID
    view.addSubview(bannerView)

    bannerView.snp.makeConstraints {
      $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
      $0.centerX.equalToSuperview()
    }
  }

  func loadBannerAd() {
    // Here safe area is taken into account, hence the view frame is used after the
    // view has been laid out.
    let frame = { () -> CGRect in
      view.frame.inset(by: view.safeAreaInsets)
    }()
    let viewWidth = frame.size.width
    print("viewWidth is : \(viewWidth)")
    // Here the current interface orientation is used. If the ad is being preloaded
    // for a future orientation change or different orientation, the function for the
    // relevant orientation should be used.
    banner.adaptiveWithWidth = viewWidth
    banner.pbs_requestAd()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    // Note loadBannerAd is called in viewDidAppear as this is the first time that
    // the safe area is known. If safe area is not a concern (eg your app is locked
    // in portrait mode) the banner can be loaded in viewDidLoad.
    loadBannerAd()
  }

  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    coordinator.animate(alongsideTransition: { _ in
      self.loadBannerAd()
    })
  }
}
