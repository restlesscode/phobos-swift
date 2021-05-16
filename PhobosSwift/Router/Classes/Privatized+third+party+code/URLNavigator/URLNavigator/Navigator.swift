#if os(iOS) || os(tvOS)
import UIKit

#if !COCOAPODS
import URLMatcher
#endif

open class Navigator: NavigatorType {
  public let matcher = URLMatcher()
  open weak var delegate: NavigatorDelegate?

  private var viewControllerFactories = [URLPattern: ViewControllerFactory]()
  private var handlerFactories = [URLPattern: URLOpenHandlerFactory]()

  public init() {
    // ⛵ I'm a Navigator!
  }

  /// 把URL注册到对应的路由中
  ///
  /// - parameter: pattern, {appurlscheme}://{pathpattern}中的pathpattern
  /// - parameter: factory, ViewController的工厂clousre，返回该路由地址中对应的ViewController的对象
  open func register(_ pattern: URLPattern, _ factory: @escaping ViewControllerFactory) {
    viewControllerFactories[pattern] = factory
  }

  /// 处理通过open url打开后，或者调用open之后的过程
  ///
  /// - parameter: pattern, {appurlscheme}://{pathpattern}中的pathpattern
  /// - parameter: factory, URLOpenHandler的工厂clousre
  open func handle(_ pattern: URLPattern, _ factory: @escaping URLOpenHandlerFactory) {
    handlerFactories[pattern] = factory
  }

  ///
  open func viewController(for url: URLConvertible, context: Any? = nil) -> UIViewController? {
    let urlPatterns = Array(viewControllerFactories.keys)
    guard let match = matcher.match(url, from: urlPatterns) else { return nil }
    guard let factory = viewControllerFactories[match.pattern] else { return nil }
    return factory(url, match.values, context)
  }

  ///
  open func handler(for url: URLConvertible, context: Any?) -> URLOpenHandler? {
    let urlPatterns = Array(handlerFactories.keys)
    guard let match = matcher.match(url, from: urlPatterns) else { return nil }
    guard let handler = handlerFactories[match.pattern] else { return nil }
    return { handler(url, match.values, context) }
  }
}
#endif
