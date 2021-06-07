//
//
//  PBSMessageHud.swift
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
import RxSwift

///  MessageHud Style Setup
public struct PBSMessageHudStyle {
  /// 页面与上端的距离
  public var viewTopEdge: CGFloat = 140
  /// 标准高度
  public var standardHeight: CGFloat = 431
  /// 标准宽度
  public var standarWidth: CGFloat = 311
  /// 图片高度
  public var imageHeight: CGFloat = 175
  /// 动图size
  public var gifSize: CGFloat = 48
  /// Color of background
  public var backgroundColor = UIColor.black
  /// Font of title
  public var titleFont = UIFont.systemFont(ofSize: 18.0)
  /// Color of title
  public var titleColor = UIColor.white
  /// Font of message
  public var messageFont = UIFont.systemFont(ofSize: 14.0)
  /// Color of message
  public var messageColor = UIColor.white
  /// Cancel button title font
  public var buttonTitleFont = UIFont.systemFont(ofSize: 14)
  /// Cancel button title color
  public var buttonTitleColor = UIColor.red
  ///  Should add gesture for maskView to dismiss
  public var isMaskViewCanDismiss = false
  /// init method
  public init() {}
}

public class PBSMessageHud: NSObject {
  var alertViewCtrl: PBSMessageHudViewController?

  public static let `default` = PBSMessageHud()

  public var style = PBSMessageHudStyle()

  private let maskView = UIView()

  private var tap: UITapGestureRecognizer!

  private let disposeBag = DisposeBag()

  private var isAnimating = false

  public var isShowing: Bool {
    alertViewCtrl != nil
  }

  /// 在当前Window的topMostController上，显示UIMessageHud
  ///
  /// - parameter
  public func show(title: String,
                   message: String,
                   connectorImage: UIImage,
                   spinnerImage: UIImage,
                   buttonText: String?,
                   buttonhandler: (() -> Void)? = nil) {
    if alertViewCtrl != nil {
      alertViewCtrl?.updateUI(title: title, message: message, buttonText: buttonText, connectorImage: connectorImage, spinnerImage: spinnerImage)
    } else {
      let alertViewCtrl = PBSMessageHudViewController(style: style,
                                                      title: title,
                                                      message: message,
                                                      connectorGifImage: connectorImage,
                                                      spinnerGifImage: spinnerImage,
                                                      buttonText: buttonText,
                                                      buttonhandler: {
                                                        buttonhandler?()
                                                        self.dismiss(animated: true)
                                                      })

      self.alertViewCtrl = alertViewCtrl

      let alertView = alertViewCtrl.view!

      if style.isMaskViewCanDismiss {
        setUpGestureRecognizer()
      }

      if let viewCtrl = UIWindow.pbs.keyWindowTopMostController?.pbs.topMostWrapperController {
        maskView.frame = viewCtrl.view.frame
        maskView.backgroundColor = UIColor.pbs.color(R: 0, G: 0, B: 0, alpha: 0.7)
        viewCtrl.addChild(alertViewCtrl)
        viewCtrl.view.addSubview(maskView)
        viewCtrl.view.addSubview(alertView)
        alertView.snp.makeConstraints {
          $0.top.equalToSuperview().offset(style.viewTopEdge)
          $0.width.equalTo(style.standarWidth)
          $0.height.equalTo(style.standardHeight)
          $0.centerX.equalToSuperview()
        }

        alertView.frame = CGRect(x: alertView.frame.origin.x, y: -style.standardHeight, width: style.standarWidth, height: style.standardHeight)

        isAnimating = true
        UIView.animate(withDuration: 0.5, animations: {
          alertView.frame = CGRect(x: alertView.frame.origin.x, y: 0, width: self.style.standarWidth, height: self.style.standardHeight)

        }, completion: { [weak self] _ in
          guard let self = self else { return }
          self.isAnimating = false
          viewCtrl.view.layoutIfNeeded()
        })
      }
    }
  }

  /// 关闭当前的MessageHud
  ///
  public func dismiss(animated: Bool = true) {
    if !animated {
      let alertView = alertViewCtrl?.view
      alertView?.removeFromSuperview()
      maskView.removeFromSuperview()
      alertViewCtrl?.removeFromParent()
      alertViewCtrl = nil
    } else if let alertViewCtrl = self.alertViewCtrl {
      isAnimating = true
      let alertView = alertViewCtrl.view!
      UIView.animate(withDuration: animated ? 0.5 : 0, animations: {
        alertView.frame = CGRect(x: alertView.frame.origin.x, y: -alertView.frame.height, width: alertView.frame.width, height: alertView.frame.height)
      }, completion: { [weak self] _ in
        guard let self = self else { return }
        self.isAnimating = false
        alertView.removeFromSuperview()
        self.alertViewCtrl?.removeFromParent()
        self.maskView.removeFromSuperview()
        self.alertViewCtrl = nil
      })
    }
  }

  /// 更新当前MessageHud
  ///
  public func update(title: String?, message: String?, buttonText: String?, connectorImage: UIImage?, spinnerImage: UIImage?) {
    alertViewCtrl?.updateUI(title: title, message: message, buttonText: buttonText, connectorImage: connectorImage, spinnerImage: spinnerImage)
  }

  fileprivate func setUpGestureRecognizer() {
    tap = UITapGestureRecognizer(target: self, action: nil)
    maskView.addGestureRecognizer(tap)
    tap.rx.event.subscribe(onNext: { [weak self] _ in
      guard let self = self else { return }
      if self.isAnimating == false {
        self.dismiss()
      }
    }).disposed(by: disposeBag)
  }
}
