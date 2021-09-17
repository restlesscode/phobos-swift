//
//
//  PaymentAppDelegateSwizzler.swift
//  PhobosSwiftPayment
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

class PaymentAppDelegateSwizzler: NSObject {
  var interceptorID: GULAppDelegateInterceptorID?

  func load() {
    PBSAppDelegateSwizzler.proxyOriginalDelegate()
    interceptorID = PBSAppDelegateSwizzler.registerAppDelegateInterceptor(self)
  }

  func unload() {
    if let interceptorID = self.interceptorID {
      PBSAppDelegateSwizzler.unregisterAppDelegateInterceptor(withID: interceptorID)
    }
  }
}

// MARK: - UIApplicationDelegate Method

extension PaymentAppDelegateSwizzler: UIApplicationDelegate {
  func application(_ app: UIApplication,
                   open url: URL,
                   options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
    #if canImport(PBSPayment)
    PBSPayment.Wechatpay.shared.handleOpen(url: url)
    #endif

    #if canImport(PBSPayment)
    PBSPayment.Alipay.shared.handleOpen(url: url)
    #endif
    return true
  }

  func application(_ application: UIApplication,
                   continue userActivity: NSUserActivity,
                   restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
    #if canImport(PBSPayment)
    return PBSPayment.Wechatpay.shared.handleOpenUniversalLink(userActivity: userActivity)
    #endif

    return true
  }

  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    PBSPayment.IAP.shared.applicationWillTerminateHandler()
  }
}
