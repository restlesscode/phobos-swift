//
//
//  PBSSlideViewDelegate.swift
//  PhobosSwiftSlideout
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

import UIKit

private struct AssociatedKeys {
  static var kSlideViewControllerKey = "PBSSlideViewDelegate.PBSSlideViewController"
}

/// Delegate for COBSlideViewController
///
@objc public protocol PBSSlideViewDelegate {
  /// 左侧即将划出
  @objc optional func leftPanelWillToggle(slideViewController: PBSSlideViewController)

  /// 左侧正在滑动
  @objc optional func leftPanelIsToggling(slideViewController: PBSSlideViewController, offset: CGFloat)

  /// 左侧完成划动
  @objc optional func leftPanelDidToggle(slideViewController: PBSSlideViewController)

  /// 右侧即将划出
  @objc optional func rightPanelWillToggle(slideViewController: PBSSlideViewController)

  /// 右侧正在滑动
  @objc optional func rightPanelIsToggling(slideViewController: PBSSlideViewController, offset: CGFloat)

  /// 右侧完成划动
  @objc optional func rightPanelDidToggle(slideViewController: PBSSlideViewController)
}

extension PBSSlideViewDelegate where Self: UIViewController {
  /// 学习Alamofire，为Extension增加属性变量
  /// COBSlideViewController 的对象
  public var slideViewController: PBSSlideViewController? {
    get {
      objc_getAssociatedObject(self, &AssociatedKeys.kSlideViewControllerKey) as? PBSSlideViewController
    }
    set(newValue) {
      objc_setAssociatedObject(self, &AssociatedKeys.kSlideViewControllerKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
  }

  /// 打开左侧Panel
  public func toggleLeftPanel(completion: ((Bool) -> Void)? = nil) {
    slideViewController?.toggleLeftPanel(completion: completion)
  }

  /// 打开右侧Panel
  public func toggleRightPanel(completion: ((Bool) -> Void)? = nil) {
    slideViewController?.toggleRightPanel(completion: completion)
  }

  /// 合上左侧/右侧Panel
  public func collapseSidePanels() {
    slideViewController?.collapseSidePanels()
  }
}
