//
//
//  InterstitialAdDemoViewController.swift
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

class InterstitialAdDemoViewController: UIViewController {
  private let disposeBag = DisposeBag()

  let interstitialAd = PBSInterstitialAd(with: .google, adUnitID: PhobosSwiftExample.Constants.kTestGADIntersitialAdUnitID)

  lazy var testButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Show Interstitial Ad", for: .normal)
    return button
  }()

  lazy var infoTextView: UITextView = {
    let textView = UITextView()
    textView.font = UIFont.systemFont(ofSize: 15)
    textView.textAlignment = .left
    textView.isEditable = false
    return textView
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Interstitial Ad"
    view.backgroundColor = UIColor.pbs.systemBackground

    makeSubviews()
    setupBindings()

    interstitialAd.pbs_loadInterstitialAd()
  }

  func makeSubviews() {
    view.addSubview(testButton)
    view.addSubview(infoTextView)

    testButton.snp.makeConstraints {
      $0.width.equalTo(200)
      $0.height.equalTo(50)
      $0.top.equalToSuperview().offset(80)
      $0.centerX.equalToSuperview()
    }

    infoTextView.snp.makeConstraints {
      $0.left.equalToSuperview().offset(30)
      $0.right.equalToSuperview().offset(-30)
      $0.top.equalTo(testButton.snp.bottom).offset(30)
      $0.bottom.equalToSuperview().offset(-30)
    }
  }

  private func setupBindings() {
    testButton.rx.tap.subscribe(onNext: { [weak self] in
      guard let self = self else { return }
      self.interstitialAd.pbs_showInterstitialAdWith(from: self)
    }).disposed(by: disposeBag)

    interstitialAd.rx.event.subscribe(onNext: { [weak self] event in
      guard let self = self else { return }
      switch event {
      case .loadSuccess:
        /// should do nothing
        self.infoTextView.text += "Load success\n"
      case let .loadFailedWith(error):
        /// load failed
        self.infoTextView.text += "Load failed: \(error.localizedDescription)\n"
      case .adNotReady:
        /// ads not ready
        self.infoTextView.text += "Ad is not ready\n"
      default:
        break
      }
    }).disposed(by: disposeBag)

    interstitialAd.rx.adDidFailToPresentFullScreenContentWithError.subscribe(onNext: { [weak self] ad, error in
      guard let self = self else { return }
      if ad is PBSInterstitialAd {
        self.infoTextView.text += "Ad did fail to present screen content with reason: \(error.localizedDescription)\n"
      }
    }).disposed(by: disposeBag)

    interstitialAd.rx.adDidPresentFullScreenContent.subscribe(onNext: { [weak self] ad in
      guard let self = self else { return }
      if ad is PBSInterstitialAd {
        self.infoTextView.text += "Ad did present full screen content\n"
      }
    }).disposed(by: disposeBag)

    interstitialAd.rx.adDidDismissFullScreenContent.subscribe(onNext: { [weak self] ad in
      guard let self = self else { return }
      if ad is PBSInterstitialAd {
        self.infoTextView.text += "Ad did dismiss full screen content\n"
        self.interstitialAd.pbs_loadInterstitialAd()
      }
    }).disposed(by: disposeBag)

    interstitialAd.rx.adDidRecordImpression.subscribe(onNext: { [weak self] ad in
      guard let self = self else { return }
      if let ad = ad as? PBSInterstitialAd {
        self.infoTextView.text += "Ad did record impression with adUnitID: " + ad.adUnitID + "\n"
      }
    }).disposed(by: disposeBag)
  }
}
