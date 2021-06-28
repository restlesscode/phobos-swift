//
//
//  PBSMessagePanel.swift
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
import SnapKit
import UIKit

/// PBSMessagePanelStyle
public struct PBSMessagePanelStyle {
  public enum IconType: Int {
    case success
    case fail
    case info
  }

  /// spaceToHorizontalEdge
  public var spaceToHorizontalEdge: CGFloat = 0.0

  /// icon type
  public var iconType: IconType = .info

  /// title font
  public var titleFont: UIFont = .boldSystemFont(ofSize: 14.0)
  /// title color
  public var titleColor: UIColor = .black
  /// message font
  public var messageFont: UIFont = .systemFont(ofSize: 12.0)
  /// message color
  public var messageColor: UIColor = .black
  /// default button font
  public var defaultButtonFont: UIFont = .boldSystemFont(ofSize: 14.0)
  /// default button title color
  public var defaultButtonTitleColor: UIColor = .black
  /// other button font
  public var otherButtonFont: UIFont = .systemFont(ofSize: 12.0)
  /// other button title color
  public var otherButtonTitleColor: UIColor = .black
}

///
public class PBSMessagePanel: NSObject {
  public static let `default` = PBSMessagePanel()

  private var panelVC: PBSMessagePanelViewController?

  private var selfWidth: CGFloat {
    UIScreen.main.bounds.size.width - 2 * style.spaceToHorizontalEdge
  }

  private var finalY: CGFloat {
    let topVC = UIWindow.pbs.keyWindowTopMostController?.pbs.topMostController

    if let nav = topVC?.navigationController {
      return UIApplication.pbs_shared?.statusBarFrame.height ?? 0 + nav.navigationBar.frame.height
    } else {
      if #available(iOS 13.0, *) {
        return 0.0
      } else {
        return UIApplication.pbs_shared?.statusBarFrame.height ?? 0.0
      }
    }
  }

  private var animDuration: TimeInterval = 1.0
  private var style = PBSMessagePanelStyle()
  private var titleText: String?
  private var messageText: String?
  private var defaultActionTitle: String?
  private var defaultActionHandler: (() -> Void)?
  private var otherActionTitle: String?
  private var otherActionHandler: (() -> Void)?

  private func addPanelToTopController() {
    panelVC = PBSMessagePanelViewController(style: style,
                                            title: titleText,
                                            message: messageText,
                                            defaultActionTitle: defaultActionTitle,
                                            defaultActionHandler: {
                                              self.defaultActionHandler?()
                                              self.hideAnimation()
                                            }, otherActionTitle: otherActionTitle, otherActionHandler: {
                                              self.otherActionHandler?()
                                              self.hideAnimation()
                                            })
    let panelView: UIView! = panelVC?.view

    let topVC = UIWindow.pbs.keyWindowTopMostController?.pbs.topMostController
    if let vc = topVC, let panelVC = self.panelVC {
      vc.addChild(panelVC)
      let parentView: UIView! = vc.view
      parentView.addSubview(panelView)

      panelView.snp.makeConstraints { make in
        make.left.equalTo(parentView).offset(style.spaceToHorizontalEdge)
        make.width.equalTo(selfWidth)
        make.bottom.equalTo(parentView.snp.top)
      }
      parentView.layoutIfNeeded()
    }
  }

  private func startAnimation() {
    let panelView: UIView! = panelVC?.view

    if let parentView = panelView.superview {
      panelView.snp.updateConstraints { make in
        make.bottom.equalTo(parentView.snp.top).offset(finalY + panelView.bounds.height)
      }

      UIView.animate(withDuration: animDuration, animations: {
        parentView.layoutIfNeeded()
      })
    }
  }

  private func hideAnimation(animated: Bool = true) {
    let panelView = panelVC?.view
    if !animated {
      panelView?.removeFromSuperview()
      panelVC?.removeFromParent()
      panelVC = nil
    } else {
      if let parentView = panelView?.superview {
        panelView?.snp.updateConstraints { make in
          make.bottom.equalTo(parentView.snp.top)
        }

        UIView.animate(withDuration: animDuration, animations: {
          parentView.layoutIfNeeded()
        }, completion: { _ in
          panelView?.removeFromSuperview()
          self.panelVC?.removeFromParent()
          self.panelVC = nil
        })
      }
    }
  }
}

///
extension PBSMessagePanel {
  ///
  public func animDuration(duration: TimeInterval) -> Self {
    animDuration = duration
    return self
  }

  ///
  public func style(style: PBSMessagePanelStyle) -> Self {
    self.style = style
    return self
  }

  ///
  public func title(title: String?) -> Self {
    titleText = title
    return self
  }

  ///
  public func message(message: String?) -> Self {
    messageText = message
    return self
  }

  ///
  public func defaultActionTitle(title: String?, handler: (() -> Void)? = nil) -> Self {
    defaultActionTitle = title
    defaultActionHandler = handler
    return self
  }

  ///
  public func otherActionTitle(title: String?, handler: (() -> Void)? = nil) -> Self {
    otherActionTitle = title
    otherActionHandler = handler
    return self
  }

  ///
  public func show() {
    hideAnimation(animated: false)
    addPanelToTopController()
    startAnimation()
  }
}
