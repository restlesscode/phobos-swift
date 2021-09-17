#if os(iOS) || os(tvOS)
import UIKit

extension UIView {
  var firstNavigationController: UINavigationController? {
    if let vc = next as? UIViewController {
      if let navCtrl = vc.navigationController {
        return navCtrl
      }
    }

    for subview in subviews {
      return subview.firstNavigationController
    }

    return nil
  }
}

extension UIViewController {
  private class var sharedApplication: UIApplication? {
    let selector = NSSelectorFromString("sharedApplication")
    return UIApplication.perform(selector)?.takeUnretainedValue() as? UIApplication
  }

  /// Returns the current application's top most view controller.
  open class var topMost: UIViewController? {
    guard let currentWindows = self.sharedApplication?.windows else { return nil }
    var rootViewController: UIViewController?
    for window in currentWindows {
      if let windowRootViewController = window.rootViewController, window.isKeyWindow {
        rootViewController = windowRootViewController
        break
      }
    }

    return self.topMost(of: rootViewController)
  }

  /// Returns the top most view controller from given view controller's stack.
  open class func topMost(of viewController: UIViewController?) -> UIViewController? {
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
#endif
