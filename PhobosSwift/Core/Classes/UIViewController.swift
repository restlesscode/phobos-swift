//
//
//  UIViewController.swift
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

import RxCocoa
import RxGesture
import RxSwift
import UIKit

extension UIViewController: PhobosSwiftCompatible {}
/// Enhanced features of UIViewController class is implemented in this extension
extension PhobosSwift where Base: UIViewController {
  /// 设置让UIViewController点击任何区域后，force the first responder to resign（关闭键盘）
  ///
  public func UIViewControllercloseKeyboardByTouchingAnywhere() -> Disposable {
    base.view.rx.tapGesture().when(.recognized).subscribe(onNext: { [unowned base] _ in
      base.view.endEditing(true)
    })
  }

  /// StatusBar 和 NavigationBar的高度
  public var topbarHeight: CGFloat {
    statusBarHeight + navigationBarHeight
  }

  /// NavigationBar的高度
  public var navigationBarHeight: CGFloat {
    base.navigationController?.navigationBar.frame.height ?? 0.0
  }

  /// StatusBar的高度
  public var statusBarHeight: CGFloat {
    UIApplication.pbs_shared?.statusBarFrame.height ?? 0.0
  }

  /// 获取当前UIViewController 的 NavigationViewController 或者 TabViewController
  ///
  /// 注意：（当window的viewcontroller体系还没有创建完时调用会有bug）
  public var topMostWrapperController: UIViewController? {
    let topVC = UIViewController.pbs.topMost(of: base)
    if let navC = topVC?.navigationController {
      return navC
    }
    if let tabBarVC = topVC?.tabBarController {
      return tabBarVC
    }

    return topVC
  }

  /// 获取当前UIViewController最顶层的ViewController
  ///
  /// 注意：（当window的viewcontroller体系还没有创建完时调用会有bug）
  public var topMostController: UIViewController? {
    UIViewController.pbs.topMost(of: base)
  }

  /// Returns the current application's top most view controller.
  public static var topMost: UIViewController? {
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

  /// Returns the top most view controller from given view controller's stack.
  public static func topMost(of viewController: UIViewController?) -> UIViewController? {
    // presented view controller
    if let presentedViewController = viewController?.presentedViewController {
      return topMost(of: presentedViewController)
    }

    // UITabBarController
    if let tabBarController = viewController as? UITabBarController,
       let selectedViewController = tabBarController.selectedViewController {
      return topMost(of: selectedViewController)
    }

    // UINavigationController
    if let navigationController = viewController as? UINavigationController,
       let visibleViewController = navigationController.visibleViewController {
      return topMost(of: visibleViewController)
    }

    // UIPageController
    if let pageViewController = viewController as? UIPageViewController,
       pageViewController.viewControllers?.count == 1 {
      return topMost(of: pageViewController.viewControllers?.first)
    }

    // child view controller
    for subview in viewController?.view?.subviews ?? [] {
      if let childViewController = subview.next as? UIViewController {
        return topMost(of: childViewController)
      }
    }

    return viewController
  }
}
