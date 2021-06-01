//
//
//  UIWindow.swift
//  PhobosSwiftCore
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

/// Enhanced features of UIApplication class is implemented in this extension
extension PhobosSwift where Base: UIApplication {
  /// Returns the current application's top most view controller.
  public static var topMostViewController: UIViewController? {
    guard let currentWindows = UIApplication.pbs_shared?.windows else { return nil }
    var rootViewController: UIViewController?
    for window in currentWindows {
      if let windowRootViewController = window.rootViewController, window.isKeyWindow {
        rootViewController = windowRootViewController
        break
      }
    }

    return UIViewController.pbs.topMost(of: rootViewController)
  }
}

/// Enhanced features of UIWindow class is implemented in this extension
extension PhobosSwift where Base: UIWindow {
  /// 获取当前Window最顶层的ViewController
  ///
  /// 注意：（当window的viewcontroller体系还没有创建完时调用会有bug）
  public static var keyWindowTopMostController: UIViewController? {
    UIApplication.pbs_shared?.keyWindow?.pbs.topMostController
  }

  ///
  public var topMostController: UIViewController? {
    UIViewController.pbs.topMost(of: base.rootViewController)
  }

  /// 当前Key Window下，如果是Navigation图层，是否包含类型为viewCtrlType的UIViewController
  ///
  public static func keyWindowNavigationContains(child viewCtrlType: UIViewController.Type) -> Bool {
    UIApplication.pbs_shared?.keyWindow?.pbs.navigationContains(child: viewCtrlType) ?? false
  }

  ///
  public func navigationContains(child viewCtrlType: UIViewController.Type) -> Bool {
    guard let topViewCtrl = topMostController else {
      return false
    }

    // 当前VC是源于UINavigationController
    if let navCtrl = topViewCtrl as? UINavigationController {
      return !navCtrl.children.filter { $0.isMember(of: viewCtrlType) }.isEmpty
    }

    return false
  }
}
