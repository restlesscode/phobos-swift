//
//
//  PBSNativeAdView.swift
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
import PhobosSwiftUIComponent
import SnapKit

///
public class PBSADMobNativeAdView: GADNativeAdView {
  public lazy var adLabel: UILabel = {
    let label = UILabel(frame: .zero)
    label.text = "Ad"
    label.backgroundColor = UIColor.pbs.color(R: 255, G: 204, B: 102, alpha: 1)
    label.textColor = UIColor.white
    label.font = UIFont.systemFont(ofSize: 11, weight: .semibold)
    return label
  }()

  let _headlineView = UILabel(frame: .zero)
  let _callToActionView = UIButton(frame: .zero)
  let _mediaView = GADMediaView(frame: .zero)
  let _iconView = UIImageView(frame: .zero)
  let _bodyView = UILabel(frame: .zero)
  let _storeView = UILabel(frame: .zero)
  let _priceView = UILabel(frame: .zero)
  let _imageView = UIImageView(frame: .zero)
  let _starRatingView = CosmosView(frame: .zero)
  let _advertiserView = UILabel(frame: .zero)
  let _adChoicesView = GADAdChoicesView(frame: .zero)

  override public init(frame: CGRect) {
    super.init(frame: frame)
    makeSubviews()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func makeSubviews() {
    addSubview(adLabel)

    _headlineView.isHidden = false
    headlineView = _headlineView
    addSubview(_headlineView)

    _callToActionView.isHidden = true
    callToActionView = _callToActionView
    addSubview(_callToActionView)

    _mediaView.isHidden = false
    mediaView = _mediaView
    addSubview(_mediaView)

    _iconView.isHidden = true
    iconView = _iconView
    addSubview(_iconView)

    _bodyView.isHidden = true
    bodyView = _bodyView
    addSubview(_bodyView)

    _storeView.isHidden = true
    storeView = _storeView
    addSubview(_storeView)

    _priceView.isHidden = true
    priceView = _priceView
    addSubview(_priceView)

    _imageView.isHidden = true
    imageView = _imageView
    addSubview(_imageView)

    _starRatingView.isHidden = true
    starRatingView = _starRatingView
    addSubview(_starRatingView)

    _advertiserView.isHidden = true
    advertiserView = _advertiserView
    addSubview(_advertiserView)

    _adChoicesView.isHidden = true
    adChoicesView = _adChoicesView
    addSubview(_adChoicesView)
  }
}

extension PBSADMobNativeAdView {
  func setupSmallTemplateUI() {
    layer.borderWidth = 1.0
    layer.borderColor = UIColor.pbs.color(R: 224, G: 224, B: 224).cgColor

    _headlineView.font = UIFont.systemFont(ofSize: 15, weight: .bold)

    adLabel.textColor = UIColor.pbs.color(R: 140, G: 164, B: 131)
    adLabel.textAlignment = .center
    adLabel.font = UIFont.systemFont(ofSize: 12)
    adLabel.backgroundColor = UIColor.white
    adLabel.layer.borderColor = UIColor.pbs.color(R: 140, G: 164, B: 131).cgColor
    adLabel.layer.borderWidth = 1.0
    adLabel.layer.cornerRadius = 3.0

    _advertiserView.font = UIFont.systemFont(ofSize: 12)
    _advertiserView.textColor = UIColor.lightGray

    _callToActionView.backgroundColor = UIColor.pbs.color(R: 54, G: 155, B: 254)
    _callToActionView.layer.cornerRadius = 3
    _callToActionView.layer.masksToBounds = true
    _callToActionView.titleLabel?.font = UIFont.systemFont(ofSize: 15)

    _mediaView.snp.makeConstraints {
      $0.left.centerY.equalToSuperview()
      $0.size.equalTo(100)
    }

    _headlineView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(10)
      $0.left.equalTo(_mediaView.snp.right).offset(10)
      $0.right.equalToSuperview().offset(-10)
      $0.height.equalTo(16)
    }

    adLabel.snp.makeConstraints {
      $0.top.equalTo(_headlineView.snp.bottom).offset(5)
      $0.left.equalTo(_headlineView)
      $0.size.equalTo(CGSize(width: 25, height: 19))
    }

    _advertiserView.snp.makeConstraints {
      $0.centerY.equalTo(adLabel)
      $0.left.equalTo(adLabel.snp.right).offset(5)
      $0.right.equalTo(_headlineView)
    }

    _callToActionView.snp.makeConstraints {
      $0.left.equalTo(_mediaView.snp.right).offset(10)
      $0.top.equalTo(adLabel.snp.bottom).offset(10)
      $0.right.bottom.equalToSuperview().offset(-10)
    }
  }

  func setupMediumTemplateUI() {
    layer.borderWidth = 1.0
    layer.borderColor = UIColor.pbs.color(R: 224, G: 224, B: 224).cgColor

    _headlineView.font = UIFont.systemFont(ofSize: 17, weight: .bold)

    adLabel.textColor = UIColor.pbs.color(R: 140, G: 164, B: 131)
    adLabel.textAlignment = .center
    adLabel.font = UIFont.systemFont(ofSize: 15)
    adLabel.backgroundColor = UIColor.white
    adLabel.layer.borderColor = UIColor.pbs.color(R: 140, G: 164, B: 131).cgColor
    adLabel.layer.borderWidth = 1.0
    adLabel.layer.cornerRadius = 3.0

    _advertiserView.textColor = UIColor.lightGray
    _advertiserView.font = UIFont.systemFont(ofSize: 15)

    _bodyView.font = UIFont.systemFont(ofSize: 14)
    _bodyView.textColor = UIColor.lightGray
    _bodyView.numberOfLines = 0

    _callToActionView.backgroundColor = UIColor.pbs.color(R: 54, G: 155, B: 254)
    _callToActionView.layer.cornerRadius = 5
    _callToActionView.layer.masksToBounds = true
    _callToActionView.titleLabel?.font = UIFont.systemFont(ofSize: 15)

    _mediaView.snp.makeConstraints {
      $0.top.left.right.equalToSuperview()
      $0.height.equalTo(_mediaView.snp.width).multipliedBy(9 / 16.0)
    }

    _iconView.snp.makeConstraints {
      $0.size.equalTo(50)
      $0.top.equalTo(_mediaView.snp.bottom)
      $0.left.equalTo(10)
    }

    _headlineView.snp.makeConstraints {
      $0.top.equalTo(_iconView)
      $0.left.equalTo(_iconView.snp.right).offset(10)
      $0.right.equalToSuperview().offset(-10)
      $0.height.equalTo(25)
    }

    adLabel.snp.makeConstraints {
      $0.top.equalTo(_headlineView.snp.bottom).offset(5)
      $0.left.equalTo(_headlineView)
      $0.size.equalTo(CGSize(width: 28, height: 20))
    }

    _advertiserView.snp.makeConstraints {
      $0.centerY.equalTo(adLabel)
      $0.left.equalTo(adLabel.snp.right).offset(5)
    }

    _bodyView.snp.makeConstraints {
      $0.top.equalTo(_iconView.snp.bottom).offset(10)
      $0.left.equalTo(_iconView)
      $0.right.equalTo(_headlineView)
      $0.height.greaterThanOrEqualTo(21)
    }

    _callToActionView.snp.makeConstraints {
      $0.left.equalTo(_iconView)
      $0.right.equalTo(_headlineView)
      $0.top.equalTo(_bodyView.snp.bottom).offset(10)
      $0.height.equalTo(40)
      $0.bottom.equalToSuperview().offset(-10)
    }
  }
}
