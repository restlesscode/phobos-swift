//
//
//  PBSRouterAppDelegateSwizzler.swift
//  PhobosSwiftRouter
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
import PhobosSwiftLog

class PBSRouterAppDelegateSwizzler: NSObject, UIApplicationDelegate {
  private weak var router: PBSRouter?
  private var interceptorID: GULAppDelegateInterceptorID?

  func load(withRouter router: PBSRouter) {
    self.router = router

    PBSAppDelegateSwizzler.proxyOriginalDelegateIncludingAPNSMethods()
    interceptorID = PBSAppDelegateSwizzler.registerAppDelegateInterceptor(self)
  }

  func unload() {
    if let interceptorID = interceptorID {
      PBSAppDelegateSwizzler.unregisterAppDelegateInterceptor(withID: interceptorID)
    }
  }

  public func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
    if let router = router {
      // Try opening the URL first
      if router.open(url.host ?? "" + url.relativePath) == true {
        PBSLogger.logger.debug(message: "Open: \(url)", context: "Router")
        return true
      }

      // Try presenting the URL
      if router.present(url, wrap: UINavigationController.self) != nil {
        PBSLogger.logger.debug(message: "Present: \(url)", context: "Router")
        return true
      }
    }

    return false
  }
}
