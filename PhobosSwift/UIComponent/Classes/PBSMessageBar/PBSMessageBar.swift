//
//  PBSMessageBar.swift
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
import Foundation
import PhobosSwiftCore
import QuartzCore

public enum PBSMessageBarType: String {
  case success
  case warning
  case info
  case error

  var color: UIColor {
    switch self {
    case .success:
      return UIColor.pbs.color(hex: 0x5CC08C)
    case .warning:
      return UIColor.pbs.color(hex: 0xE2B236)
    case .info:
      return UIColor.pbs.color(hex: 0x007AD2)
    case .error:
      return UIColor.pbs.color(hex: 0xE9382C)
    }
  }

  var image: UIImage {
    switch self {
    case .success:
      return UIImage.image(named: "message_bar_info").withRenderingMode(.alwaysTemplate)
    case .warning:
      return UIImage.image(named: "message_bar_info").withRenderingMode(.alwaysTemplate)
    case .info:
      return UIImage.image(named: "message_bar_info").withRenderingMode(.alwaysTemplate)
    case .error:
      return UIImage.image(named: "message_bar_info").withRenderingMode(.alwaysTemplate)
    }
  }
}

/// MessageBar Style Setup
///
public struct PBSMessageBarStyle {
  /// Font of title
  public var titleFont = UIFont.systemFont(ofSize: 14.0)
  /// Font of message
  public var messageFont = UIFont.boldSystemFont(ofSize: 12.0)
  /// ????????????
  public var standardHeight: CGFloat = 88.0
  /// icon?????????
  public var iconDimension: CGFloat = 0
  /// icon?????????????????????
  public var iconLeftEdage: CGFloat = 0
  /// icon?????????????????????
  public var iconTopEdage: CGFloat = 0
  /// ???MessageBar???info????????? icon
  public var infoIcon = UIImage()
  /// ???MessageBar???success????????? icon
  public var successIcon = UIImage()
  /// ???MessageBar???warning????????? icon
  public var warningIcon = UIImage()
  /// ??????????????????????????????
  public var enableGradientBackgroundColor = false
  /// ???MessageBar???success???????????????????????????
  public var successGradientBackgroundColor: [UIColor] = []
  /// ???MessageBar???success??????????????????
  public var successBackgroundColor: UIColor = .black
  /// ???MessageBar???warning???????????????????????????
  public var warningGradientBackgroundColor: [UIColor] = []
  /// ???MessageBar???warning??????????????????
  public var warningBackgroundColor: UIColor = .black
  /// ???MessageBar???info???????????????????????????
  public var infoGradientBackgroundColor: [UIColor] = []
  /// ???MessageBar???info??????????????????
  public var infoBackgroundColor: UIColor = .black

  init() {
    reset()
  }

  /// Reset MessageBar Style
  public mutating func reset() {
    titleFont = UIFont.systemFont(ofSize: 14.0)
    messageFont = UIFont.boldSystemFont(ofSize: 12.0)
    standardHeight = 88.0
    iconDimension = 36.0
    iconLeftEdage = 12.0
    iconTopEdage = (standardHeight - iconDimension) / 2.0
    infoIcon = UIImage.image(named: "message_bar_info").withRenderingMode(.alwaysTemplate)
    successIcon = UIImage.image(named: "message_bar_success").withRenderingMode(.alwaysTemplate)
    warningIcon = UIImage.image(named: "message_bar_warning").withRenderingMode(.alwaysTemplate)
    enableGradientBackgroundColor = false
    successGradientBackgroundColor = [UIColor.pbs.color(hex: 0x6ECE96), UIColor.pbs.color(hex: 0x229754)]
    successBackgroundColor = UIColor.pbs.color(hex: 0x229754)
    warningGradientBackgroundColor = [UIColor.pbs.color(hex: 0xF3994B), UIColor.pbs.color(hex: 0xEC5757)]
    warningBackgroundColor = UIColor.pbs.color(hex: 0xEC5757)
    infoGradientBackgroundColor = [UIColor.pbs.color(hex: 0x05CBFF), UIColor.pbs.color(hex: 0x3F88FF)]
    infoBackgroundColor = UIColor.pbs.color(hex: 0x3F88FF)
  }
}

public class PBSMessageBar: NSObject {
  var alertViewCtrl: PBSMessageBarViewController?

  public static let `default` = PBSMessageBar()

  public var style = PBSMessageBarStyle()

  /// ?????????Window???topMostController????????????MessageBar
  ///
  public func show(title: String,
                   message: String,
                   alertType: PBSMessageBarType,
                   button1Text: String,
                   button1handler: (() -> Void)? = nil,
                   button2Text: String? = nil,
                   button2handler: (() -> Void)? = nil,
                   button3Text: String? = nil,
                   button3handler: (() -> Void)? = nil) {
    dismiss(animated: false)

    let alertViewCtrl = PBSMessageBarViewController(style: style,
                                                    title: title,
                                                    message: message,
                                                    alertType: alertType,
                                                    button1Text: button1Text,
                                                    button1handler: {
                                                      button1handler?()

                                                      self.dismiss(animated: true)
                                                    }, button2Text: button2Text, button2handler: {
                                                      self.dismiss(animated: true)
                                                      button2handler?()
                                                    }, button3Text: button3Text, button3handler: {
                                                      button3handler?()
                                                      self.dismiss(animated: true)
                                                    })

    let buttonCount = [button1Text, button2Text, button3Text].filter { $0 != nil }.count
    let adjustHeight = style.standardHeight + CGFloat(buttonCount - 1) * 11

    self.alertViewCtrl = alertViewCtrl

    let alertView = alertViewCtrl.view!

    if let viewCtrl = UIWindow.pbs.keyWindowTopMostController?.pbs.topMostWrapperController {
      viewCtrl.addChild(alertViewCtrl)
      viewCtrl.view.addSubview(alertView)
      let alertViewWidth: CGFloat = UIScreen.main.bounds.width - 12 * 2
      alertView.snp.makeConstraints {
        $0.top.equalTo(viewCtrl.topLayoutGuide.snp.bottom)
        $0.left.equalTo(12)
        $0.right.equalTo(-12)
        $0.height.equalTo(adjustHeight)
      }

      alertView.frame = CGRect(x: alertView.frame.origin.x, y: -style.standardHeight, width: alertViewWidth, height: style.standardHeight)

      UIView.animate(withDuration: 0.5, animations: {
        alertView.frame = CGRect(x: alertView.frame.origin.x, y: 0, width: alertViewWidth, height: self.style.standardHeight)

      }, completion: { _ in
        viewCtrl.view.layoutIfNeeded()
      })
    }
  }

  /// ???????????????MessageBar
  ///
  func dismiss(animated: Bool = true) {
    if !animated {
      let alertView = alertViewCtrl?.view
      alertView?.removeFromSuperview()
      alertViewCtrl?.removeFromParent()
      alertViewCtrl = nil
    } else if let alertViewCtrl = self.alertViewCtrl {
      let alertView = alertViewCtrl.view!
      UIView.animate(withDuration: animated ? 0.5 : 0, animations: {
        alertView.frame = CGRect(x: alertView.frame.origin.x, y: -alertView.frame.height, width: alertView.frame.width, height: alertView.frame.height)
      }, completion: { [weak self] _ in
        guard let self = self else { return }

        alertView.removeFromSuperview()
        self.alertViewCtrl?.removeFromParent()
        self.alertViewCtrl = nil
      })
    }
  }
}

public class PhobosSwiftMessageBar: NSObject {}
