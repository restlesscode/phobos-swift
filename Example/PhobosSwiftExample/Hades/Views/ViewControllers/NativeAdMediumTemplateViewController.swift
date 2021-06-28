//
//
//  NativeAdMediumTemplateViewController.swift
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

import Foundation
import PhobosSwiftHades
import RxCocoa
import RxSwift

class NativeAdMediumTemplateViewController: UIViewController {
  private let disposeBag = DisposeBag()
  let nativeAd = PBSNativeAd(with: .google, adType: .mediumTemplate)

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Medium Template"
    view.backgroundColor = .pbs.systemBackground
    nativeAd.pbs_loadNativaAdWith(adUnitID: PhobosSwiftExample.Constants.kTestGADNativeAdUnitID, rootViewController: self)
    makeSubviews()
    setupBindings()
  }

  private func makeSubviews() {
    view.addSubview(nativeAd.nativeAdView)
    nativeAd.nativeAdView.backgroundColor = .white

    nativeAd.nativeAdView.snp.makeConstraints {
      $0.left.equalToSuperview().offset(16)
      $0.right.equalToSuperview().offset(-16)
      $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
    }
  }

  private func setupBindings() {
    nativeAd.rx.adLoaderDidReceive.subscribe(onNext: { [weak self] _ in
      guard let self = self else { return }
      self.adLoaderDidReceive()
    }).disposed(by: disposeBag)

    nativeAd.rx.adLoaderDidFailToReceiveAdWithError.subscribe(onNext: { error in
      print(error.localizedDescription)
    }).disposed(by: disposeBag)

    nativeAd.rx.adLoaderDidFinishLoading.subscribe(onNext: { _ in
      print("adLoaderDidFinishLoading")
    }).disposed(by: disposeBag)

    nativeAd.rx.nativeAdDidRecordImpression.subscribe(onNext: { _ in
      print("nativeAdDidRecordImpression")
    }).disposed(by: disposeBag)

    nativeAd.rx.nativeAdDidRecordClick.subscribe(onNext: { _ in
      print("nativeAdDidRecordClick")
    }).disposed(by: disposeBag)
  }

  private func adLoaderDidReceive() {}
}
