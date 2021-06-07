//
//
//  PBSMessageBarViewController.swift
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

class PBSMessageBarViewController: UIViewController {
  let disposeBag = DisposeBag()

  public var style: PBSMessageBarStyle!

  private let imageView = UIImageView()
  private let titleLabel = UILabel(frame: .zero)
  private let messageLabel = UILabel(frame: .zero)
  private var buttonList: [UIButton] = []

  public var alertType: PBSMessageBarType = .info {
    didSet {
      adjustAccording(alertType: alertType)
    }
  }

  private var centerYMultipleList: [CGFloat] {
    [[1.0],
     [0.6, 1.4],
     [0.4, 1.0, 1.6]][buttonList.count - 1]
  }

  private var buttonHeight: CGFloat {
    [33, 33, 26][buttonList.count - 1]
  }

  convenience init(style: PBSMessageBarStyle,
                   title: String,
                   message: String,
                   alertType: PBSMessageBarType,
                   button1Text: String,
                   button1handler: (() -> Void)? = nil,
                   button2Text: String? = nil,
                   button2handler: (() -> Void)? = nil,
                   button3Text: String? = nil,
                   button3handler: (() -> Void)? = nil) {
    self.init()
    self.style = style
    self.alertType = alertType
    titleLabel.text = title
    messageLabel.text = message

    buttonList.append(UIButton(type: .system))

    buttonList.last?.setTitle(button1Text, for: .normal)
    buttonList.last?.rx.controlEvent(.touchUpInside).subscribe(onNext: { _ in
      button1handler?()
    }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)

    if button2Text != nil {
      buttonList.append(UIButton(type: .system))
      buttonList.last?.setTitle(button2Text, for: .normal)
      buttonList.last?.rx.controlEvent(.touchUpInside).subscribe(onNext: { _ in
        button2handler?()
      }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }
    if button3Text != nil {
      buttonList.append(UIButton(type: .system))
      buttonList.last?.setTitle(button3Text, for: .normal)
      buttonList.last?.rx.controlEvent(.touchUpInside).subscribe(onNext: { _ in
        button3handler?()
      }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    makeSubviews()
    makeStyles()
  }

  func adjustAccording(alertType: PBSMessageBarType) {
    switch alertType {
    case .success:
      imageView.image = style.successIcon
      imageView.tintColor = UIColor.pbs.color(R: 235, G: 235, B: 235)
      if style.enableGradientBackgroundColor {
        view.pbs.applyHorizontalGradientBackground(colorset: style.successGradientBackgroundColor)
      } else {
        view.backgroundColor = style.successBackgroundColor
      }
      buttonList.first?.tintColor = UIColor.pbs.color(hex: 0x229754)
    case .warning:
      imageView.image = style.warningIcon
      imageView.tintColor = UIColor.pbs.color(R: 235, G: 235, B: 235)
      if style.enableGradientBackgroundColor {
        view.pbs.applyHorizontalGradientBackground(colorset: style.warningGradientBackgroundColor)
      } else {
        view.backgroundColor = style.warningBackgroundColor
      }
      buttonList.first?.tintColor = UIColor.pbs.color(hex: 0xEC5857)
    case .info:
      imageView.image = style.infoIcon
      imageView.tintColor = UIColor.pbs.color(R: 235, G: 235, B: 235)
      if style.enableGradientBackgroundColor {
        view.pbs.applyHorizontalGradientBackground(colorset: style.infoGradientBackgroundColor)
      } else {
        view.backgroundColor = style.infoBackgroundColor
      }
      buttonList.first?.tintColor = UIColor.pbs.color(hex: 0x229754)
    case .error:
      imageView.image = style.infoIcon
      imageView.tintColor = UIColor.pbs.color(R: 235, G: 235, B: 235)
      if style.enableGradientBackgroundColor {
        view.pbs.applyHorizontalGradientBackground(colorset: style.infoGradientBackgroundColor)
      } else {
        view.backgroundColor = style.infoBackgroundColor
      }
      buttonList.first?.tintColor = UIColor.pbs.color(hex: 0x229754)
    }
  }

  func makeSubviews() {
    view.layer.cornerRadius = 12.0
    view.layer.masksToBounds = true

    view.addSubview(imageView)
    view.addSubview(titleLabel)
    view.addSubview(messageLabel)

    imageView.snp.makeConstraints {
      $0.top.equalTo(style.iconTopEdage)
      $0.left.equalTo(style.iconLeftEdage)
      $0.height.width.equalTo(style.iconDimension)
      $0.height.width.equalTo(style.iconDimension)
    }

    titleLabel.snp.makeConstraints {
      $0.top.equalTo(16.0)
      $0.left.equalTo(imageView.snp.right).offset(10)
      $0.height.equalTo(22)
    }

    messageLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(4)
      $0.left.equalTo(imageView.snp.right).offset(10)
      $0.right.equalTo(-82)
      $0.bottom.lessThanOrEqualTo(-12)
    }

    makeButtons()
  }

  func makeStyles() {
    adjustAccording(alertType: alertType)
    imageView.contentMode = .scaleAspectFill

    titleLabel.font = style.titleFont
    titleLabel.numberOfLines = 1
    titleLabel.textColor = .white

    messageLabel.font = style.messageFont
    messageLabel.numberOfLines = 0
    messageLabel.textColor = .white

    view.bringSubviewToFront(imageView)
    view.bringSubviewToFront(titleLabel)
    view.bringSubviewToFront(messageLabel)
    for button in buttonList {
      view.bringSubviewToFront(button)
    }
  }

  func makeButtons() {
    for (idx, button) in buttonList.enumerated() {
      view.addSubview(button)
      let centerYMultiple = centerYMultipleList[idx]
      button.snp.makeConstraints {
        $0.right.equalTo(-12)
        $0.centerY.equalTo(self.view).multipliedBy(centerYMultiple)
        $0.width.equalTo(68)
        $0.height.equalTo(self.buttonHeight)
      }

      if idx == 0 {
        button.backgroundColor = .white
        button.layer.borderWidth = 0
      } else {
        button.backgroundColor = .clear
        button.layer.borderWidth = 1
        button.tintColor = .white
      }

      button.layer.borderColor = UIColor.white.cgColor
      button.layer.cornerRadius = 4
      button.layer.masksToBounds = true
    }
  }
}
