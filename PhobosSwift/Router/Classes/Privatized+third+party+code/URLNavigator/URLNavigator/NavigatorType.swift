#if os(iOS) || os(tvOS)
import PhobosSwiftCore
import UIKit

#if !COCOAPODS
import URLMatcher
#endif

///
public typealias URLPattern = String
///
public typealias ViewControllerFactory = (_ url: URLConvertible, _ values: [String: Any], _ context: Any?) -> UIViewController?
///
public typealias URLOpenHandlerFactory = (_ url: URLConvertible, _ values: [String: Any], _ context: Any?) -> Bool
///
public typealias URLOpenHandler = () -> Bool

///
public protocol NavigatorType {
  ///
  var matcher: URLMatcher { get }
  ///
  var delegate: NavigatorDelegate? { get set }

  /// Registers a view controller factory to the URL pattern.
  func register(_ pattern: URLPattern, _ factory: @escaping ViewControllerFactory)

  /// Registers an URL open handler to the URL pattern.
  func handle(_ pattern: URLPattern, _ factory: @escaping URLOpenHandlerFactory)

  /// Returns a matching view controller from the specified URL.
  ///
  /// - parameter url: An URL to find view controllers.
  ///
  /// - returns: A match view controller or `nil` if not matched.
  func viewController(for url: URLConvertible, context: Any?) -> UIViewController?

  /// Returns a matching URL handler from the specified URL.
  ///
  /// - parameter url: An URL to find url handlers.
  ///
  /// - returns: A matching handler factory or `nil` if not matched.
  func handler(for url: URLConvertible, context: Any?) -> URLOpenHandler?

  /// Pushes a matching view controller to the navigation controller stack.
  ///
  /// - note: It is not a good idea to use this method directly because this method requires all
  ///         parameters. This method eventually gets called when pushing a view controller with
  ///         an URL, so it's recommended to implement this method only for mocking.

  @discardableResult
  func pushURL(_ url: URLConvertible, context: Any?, from: UINavigationControllerType?, animated: Bool) -> UIViewController?

  /// Pushes the view controller to the navigation controller stack.
  ///
  /// - note: It is not a good idea to use this method directly because this method requires all
  ///         parameters. This method eventually gets called when pushing a view controller, so
  ///         it's recommended to implement this method only for mocking.
  @discardableResult
  func pushViewController(_ viewController: UIViewController, from: UINavigationControllerType?, animated: Bool) -> UIViewController?

  /// Presents a matching view controller.
  ///
  /// - note: It is not a good idea to use this method directly because this method requires all
  ///         parameters. This method eventually gets called when presenting a view controller with
  ///         an URL, so it's recommended to implement this method only for mocking.
  @discardableResult
  func presentURL(_ url: URLConvertible,
                  context: Any?,
                  wrap: UINavigationController.Type?,
                  from: UIViewControllerType?,
                  animated: Bool,
                  completion: (() -> Void)?) -> UIViewController?

  /// Presents the view controller.
  ///
  /// - note: It is not a good idea to use this method directly because this method requires all
  ///         parameters. This method eventually gets called when presenting a view controller, so
  ///         it's recommended to implement this method only for mocking.
  @discardableResult
  func presentViewController(_ viewController: UIViewController,
                             wrap: UINavigationController.Type?,
                             from: UIViewControllerType?,
                             animated: Bool,
                             completion: (() -> Void)?) -> UIViewController?

  /// Executes an URL open handler.
  ///
  /// - note: It is not a good idea to use this method directly because this method requires all
  ///         parameters. This method eventually gets called when opening an url, so it's
  ///         recommended to implement this method only for mocking.
  @discardableResult
  func openURL(_ url: URLConvertible, context: Any?) -> Bool
}

// MARK: - Protocol Requirements

extension NavigatorType {
  ///
  public func viewController(for url: URLConvertible) -> UIViewController? {
    viewController(for: url, context: nil)
  }

  ///
  public func handler(for url: URLConvertible) -> URLOpenHandler? {
    handler(for: url, context: nil)
  }

  ///
  @discardableResult
  public func pushURL(_ url: URLConvertible, context: Any? = nil, from: UINavigationControllerType? = nil, animated: Bool = true) -> UIViewController? {
    guard let viewController = self.viewController(for: url, context: context) else { return nil }
    return pushViewController(viewController, from: from, animated: animated)
  }

  ///
  @discardableResult
  public func pushViewController(_ viewController: UIViewController, from: UINavigationControllerType?, animated: Bool) -> UIViewController? {
    guard (viewController is UINavigationController) == false else { return nil }
    guard let navigationController = from ?? UIViewController.topMost?.view.firstNavigationController else { return nil }
    guard delegate?.shouldPush(viewController: viewController, from: navigationController) != false else { return nil }
    navigationController.pushViewController(viewController, animated: animated)
    return viewController
  }

  ///
  @discardableResult
  public func showURL(_ url: URLConvertible,
                      context: Any? = nil,
                      from: UIViewControllerType? = nil) -> UIViewController? {
    guard let viewController = self.viewController(for: url, context: context) else { return nil }
    return showViewController(viewController, from: from)
  }

  ///
  @discardableResult
  public func showViewController(_ viewController: UIViewController,
                                 from: UIViewControllerType?) -> UIViewController? {
    guard let fromViewController = from ?? UIViewController.topMost else { return nil }

    let viewControllerToShow: UIViewController = viewController

    guard delegate?.shouldShow(viewController: viewController, from: fromViewController) != false else { return nil }

    fromViewController.show(viewControllerToShow, sender: fromViewController)
    return viewController
  }

  ///
  @discardableResult
  public func presentURL(_ url: URLConvertible,
                         context: Any? = nil,
                         wrap: UINavigationController.Type? = nil,
                         from: UIViewControllerType? = nil,
                         animated: Bool = true,
                         completion: (() -> Void)? = nil) -> UIViewController? {
    guard let viewController = self.viewController(for: url, context: context) else { return nil }
    return presentViewController(viewController, wrap: wrap, from: from, animated: animated, completion: completion)
  }

  ///
  @discardableResult
  public func presentViewController(_ viewController: UIViewController,
                                    wrap: UINavigationController.Type?,
                                    from: UIViewControllerType?,
                                    animated: Bool,
                                    completion: (() -> Void)?) -> UIViewController? {
    guard let fromViewController = from ?? UIViewController.topMost else { return nil }

    let viewControllerToPresent: UIViewController
    if let navigationControllerClass = wrap, (viewController is UINavigationController) == false {
      viewControllerToPresent = navigationControllerClass.init(rootViewController: viewController)
    } else {
      viewControllerToPresent = viewController
    }

    guard delegate?.shouldPresent(viewController: viewController, from: fromViewController) != false else { return nil }
    fromViewController.present(viewControllerToPresent, animated: animated, completion: completion)
    return viewController
  }

  ///
  @discardableResult
  public func openURL(_ url: URLConvertible, context: Any?) -> Bool {
    guard let handler = self.handler(for: url, context: context) else { return false }
    return handler()
  }
}

// MARK: - Syntactic Sugars for Optional Parameters

extension NavigatorType {
  /// 通过路由进行Push
  ///
  /// - parameter: pattern, {appurlscheme}://{pathpattern}中的pathpattern
  /// - parameter: context，传入的对象参数，对象类型为Any，可以转成相应的对象
  /// - parameter: from, UINavigationControllerType
  /// - parameter: where enable animated
  /// - parameter: the completion closre will be execute when push is finished
  @available(*, deprecated, renamed: "show(_:context:wrap:from:completion:)")
  @discardableResult
  public func push(_ url: URLConvertible,
                   context: Any? = nil,
                   from: UINavigationControllerType? = nil,
                   animated: Bool = true,
                   completion: (() -> Void)? = nil) -> UIViewController? {
    print(#function, #line, url)

    CATransaction.begin()
    CATransaction.setCompletionBlock(completion) /// Push的动画完成后调用的clousre
    let ret = pushURL(url, context: context, from: from, animated: animated)
    CATransaction.commit()

    return ret
  }

  ///
  @discardableResult
  public func push(_ viewController: UIViewController, from: UINavigationControllerType? = nil, animated: Bool = true) -> UIViewController? {
    pushViewController(viewController, from: from, animated: animated)
  }

  ///
  @discardableResult
  public func present(_ url: URLConvertible,
                      context: Any? = nil,
                      wrap: UINavigationController.Type? = nil,
                      from: UIViewControllerType? = nil,
                      animated: Bool = true,
                      completion: (() -> Void)? = nil) -> UIViewController? {
    presentURL(url, context: context, wrap: wrap, from: from, animated: animated, completion: completion)
  }

  ///
  @discardableResult
  public func present(_ viewController: UIViewController,
                      wrap: UINavigationController.Type? = nil,
                      from: UIViewControllerType? = nil,
                      animated: Bool = true,
                      completion: (() -> Void)? = nil) -> UIViewController? {
    presentViewController(viewController, wrap: wrap, from: from, animated: animated, completion: completion)
  }

  /// 通过路由进行Show
  ///
  /// - parameter: pattern, {appurlscheme}://{pathpattern}中的pathpattern
  /// - parameter: context，传入的对象参数，对象类型为Any，可以转成相应的对象
  /// - parameter: from, UINavigationControllerType
  /// - parameter: the completion closre will be execute when present is finished
  @discardableResult
  public func show(_ url: URLConvertible,
                   context: Any? = nil,
                   from: UIViewControllerType? = nil,
                   completion: (() -> Void)? = nil) -> UIViewController? {
    print(#function, #line, url)

    CATransaction.begin()
    CATransaction.setCompletionBlock(completion) /// Show的动画完成后调用的clousre
    let ret = showURL(url, context: context, from: from)
    CATransaction.commit()
    return ret
  }

  /// 通过路由进行open
  ///
  /// - parameter: pattern, {appurlscheme}://{pathpattern}中的pathpattern
  /// - parameter: context，传入的对象参数，对象类型为Any，可以转成相应的对象
  /// - parameter: from, UINavigationControllerType
  /// - parameter: where enable animated
  /// - parameter: the completion closre will be execute when open is finished
  @discardableResult
  public func open(_ url: URLConvertible, context: Any? = nil, completion: (() -> Void)? = nil) -> Bool {
    CATransaction.begin()
    CATransaction.setCompletionBlock(completion)
    let ret = openURL(url, context: context)
    CATransaction.commit()
    return ret
  }

  /// 通过路由进行rootViewController替换
  @discardableResult
  public func turn(_ url: URLConvertible,
                   context: Any? = nil,
                   inWindow keyWindow: UIWindow? = nil,
                   transaction: CATransition? = CATransition.pbs.revealAnimation,
                   completion: (() -> Void)? = nil) -> Bool {
    if let window = keyWindow ?? UIApplication.pbs_shared?.windows.first(where: { $0.isKeyWindow }) {
      guard let viewController = self.viewController(for: url, context: context) else { return false }

      CATransaction.begin()
      CATransaction.setCompletionBlock(completion)

      window.rootViewController = viewController
      if let transaction = transaction {
        let transactionKey = [transaction.type.rawValue, transaction.subtype?.rawValue ?? ""].joined(separator: ".")

        window.layer.add(transaction, forKey: transactionKey)
      }

      CATransaction.commit()

      return true
    }

    return false
  }
}
#endif
