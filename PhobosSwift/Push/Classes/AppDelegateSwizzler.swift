//
//
//  AppDelegateSwizzler.swift
//  PhobosSwiftPush
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

class PBSPushAppDelegateSwizzler: NSObject {
  weak var defaultPush: PBSPush?
  var interceptorID: GULAppDelegateInterceptorID?

  func load(withDefaultPush defaultPush: PBSPush) {
    self.defaultPush = defaultPush
    PBSAppDelegateSwizzler.proxyOriginalDelegateIncludingAPNSMethods()
    interceptorID = PBSAppDelegateSwizzler.registerAppDelegateInterceptor(self)
  }

  func unload() {
    if let interceptorID = interceptorID {
      PBSAppDelegateSwizzler.unregisterAppDelegateInterceptor(withID: interceptorID)
    }
  }
}

// MARK: - UIApplicationDelegate Method

extension PBSPushAppDelegateSwizzler: UIApplicationDelegate {
  public func application(_ application: UIApplication,
                          didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    defaultPush?.onSuccess?(deviceToken)
    PBSLogger.logger.debug(message: deviceToken.deviceTokenString, context: "Push")
  }

  public func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    defaultPush?.onError?(error)
    PBSLogger.logger.error(message: error.localizedDescription, context: "Push")
  }
}
