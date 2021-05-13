//
//
//  UIApplication.swift
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

import ObjectiveC
import UIKit

let kSharedApplication = "sharedApplication"
let kOpenURLSelectorName = "openURL:options:completionHandler:"

/// Enhanced features of Bundle class is implemented in this extension
extension UIApplication {
  /// to check if current running in an app extension or not
  public static var pbs_isAppExtension: Bool {
    #if TARGET_OS_IOS || TARGET_OS_TV
    // Documented by <a href="https://goo.gl/RRB2Up">Apple</a>
    let appExtension = Bundle.main.bundlePath.hasSuffix(".appex")
    return appExtension
    #elseif TARGET_OS_OSX
    return false
    #endif
    return false
  }

  /// 获取 shared application
  public static var pbs_shared: UIApplication? {
    let selector = NSSelectorFromString(kSharedApplication)
    return UIApplication.perform(selector)?.takeUnretainedValue() as? UIApplication
  }

  /// `keyWindow` 已经被Apple deprecated掉了，这里我们自己获取`keyWindow`
  public var pbs_keyWindow: UIWindow? {
    UIApplication.pbs_shared?.windows.filter {
      $0.isKeyWindow
    }.first
  }

  /// open
  public func pbs_open(_ url: URL, options: [UIApplication.OpenExternalURLOptionsKey: Any] = [:], completionHandler completion: ((Bool) -> Void)? = nil) {
    let selector = NSSelectorFromString(kOpenURLSelectorName)
    if let method = class_getInstanceMethod(UIApplication.self, selector) {
      let imp = method_getImplementation(method)

      typealias ClosureType = @convention(c) (AnyObject,
                                              Selector,
                                              URL, [UIApplication.OpenExternalURLOptionsKey: Any], ((Bool) -> Void)?) -> Void
      let openFunc: ClosureType = unsafeBitCast(imp, to: ClosureType.self)
      openFunc(self, selector, url, options, completion)
    }
  }
}
