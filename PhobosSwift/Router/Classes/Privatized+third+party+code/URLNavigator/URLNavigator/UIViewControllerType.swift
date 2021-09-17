#if os(iOS) || os(tvOS)
import UIKit

///
public protocol UINavigationControllerType {
  ///
  func pushViewController(_ viewController: UIViewController, animated: Bool)
}

///
public protocol UIViewControllerType {
  ///
  func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?)
  ///
  func show(_ vc: UIViewController, sender: Any?)
}

extension UINavigationController: UINavigationControllerType {}
extension UIViewController: UIViewControllerType {}
#endif
