//
//
//  BannerViewController.swift
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
import RxCocoa
import RxSwift
import UIKit

class BannerViewController: UIViewController {
  private let disposeBag = DisposeBag()

  let banner = PBSBannerAd()

  var bannerModel: BannerModel?

  override func viewDidLoad() {
    super.viewDidLoad()
    title = bannerModel?.title
    view.backgroundColor = UIColor.pbs.systemBackground
    makeSubviews()
    setupBindings()
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
    banner.pbs_requestAd()
  }

  private func setupBindings() {
    banner.rx.bannerViewDidReceiveAd.subscribe(onNext: { [weak self] PBSBanner in
      guard let self = self else { return }
      self.adViewDidReceiveAd(PBSBanner)
      print("Did receive ad")
    }).disposed(by: disposeBag)

    banner.rx.bannerViewDidFailToReceiveAdWithReason.subscribe(onNext: { _, reason in
      print("Did fail to receive ad with reason: \(reason)")
    }).disposed(by: disposeBag)

    banner.rx.bannerViewWillPresentScreen.subscribe(onNext: { _ in
      print("Will present screen")
    }).disposed(by: disposeBag)

    banner.rx.bannerViewDidRecordImpression.subscribe(onNext: { _ in
      print("Did record impression")
    }).disposed(by: disposeBag)
  }

  private func adViewDidReceiveAd(_ banner: PBSBannerAd) {
    banner.bannerView.alpha = 0
    UIView.animate(withDuration: 1, animations: {
      banner.bannerView.alpha = 1
    })
  }
}
