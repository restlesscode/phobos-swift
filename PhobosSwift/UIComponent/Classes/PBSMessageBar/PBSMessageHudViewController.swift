//
//
//  PBSMessageHudViewController.swift
//  PhobosSwiftUIComponent
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

import PhobosSwiftCore
import RxCocoa
import RxSwift
import SnapKit
import UIKit

class PBSMessageHudViewController: UIViewController {
  let disposeBag = DisposeBag()

  public var style: PBSMessageHudStyle!

  private let connectorGifImageView = UIImageView()
  private let spinnerGifImageView = UIImageView()
  private let titleLabel = UILabel(frame: .zero)
  private let messageLabel = UILabel(frame: .zero)
  private let cancelButton = UIButton(type: .system)
  private var subViews: [UIView] = []

  convenience init(style: PBSMessageHudStyle,
                   title: String,
                   message: String,
                   connectorGifImage: UIImage,
                   spinnerGifImage: UIImage,
                   buttonText: String?,
                   buttonhandler: (() -> Void)? = nil) {
    self.init()
    self.style = style
    titleLabel.text = title
    messageLabel.text = message
    cancelButton.setTitle(buttonText, for: .normal)
    cancelButton.isHidden = (buttonText == nil)
    connectorGifImageView.image = connectorGifImage
    connectorGifImageView.contentMode = .scaleAspectFit
    spinnerGifImageView.image = spinnerGifImage
    cancelButton.rx.controlEvent(.touchUpInside).subscribe(onNext: { _ in
      buttonhandler?()
    }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)

    subViews = [titleLabel, connectorGifImageView, spinnerGifImageView, messageLabel, cancelButton]
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    makeSubviews()
    makeStyles()
  }

  fileprivate func makeSubviews() {
    view.layer.cornerRadius = 8.0
    view.layer.masksToBounds = true

    for subView in subViews {
      view.addSubview(subView)
    }

    titleLabel.snp.makeConstraints {
      $0.top.equalTo(20)
      $0.height.equalTo(25)
      $0.width.equalToSuperview()
    }

    connectorGifImageView.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(20)
      $0.height.equalTo(style.imageHeight)
      $0.width.equalToSuperview()
    }

    spinnerGifImageView.snp.makeConstraints {
      $0.top.equalTo(connectorGifImageView.snp.bottom).offset(27)
      $0.size.equalTo(style.gifSize)
      $0.centerX.equalToSuperview()
    }

    messageLabel.snp.makeConstraints {
      $0.top.equalTo(spinnerGifImageView.snp.bottom).offset(16)
      $0.height.greaterThanOrEqualTo(21)
      $0.width.equalTo(214)
      $0.centerX.equalToSuperview()
    }

    cancelButton.snp.makeConstraints {
      $0.bottom.equalTo(view).offset(-20)
      $0.height.equalTo(20)
      $0.width.equalTo(200)
      $0.centerX.equalToSuperview()
    }
  }

  func updateUI(title: String?, message: String?, buttonText: String?, connectorImage: UIImage?, spinnerImage: UIImage?) {
    titleLabel.text = title
    messageLabel.text = message
    cancelButton.setTitle(buttonText, for: .normal)
    cancelButton.isHidden = buttonText == nil
    connectorGifImageView.image = connectorImage
    spinnerGifImageView.image = spinnerImage
  }

  fileprivate func makeStyles() {
    view.backgroundColor = style.backgroundColor

    titleLabel.textColor = style.titleColor
    titleLabel.font = style.titleFont
    titleLabel.textAlignment = .center
    titleLabel.numberOfLines = 1

    messageLabel.textColor = style.messageColor
    messageLabel.font = style.messageFont
    messageLabel.textAlignment = .center
    messageLabel.numberOfLines = 2

    cancelButton.setTitleColor(style.buttonTitleColor, for: .normal)
    cancelButton.titleLabel?.font = style.buttonTitleFont

    for subView in subViews {
      view.bringSubviewToFront(subView)
    }
  }
}
