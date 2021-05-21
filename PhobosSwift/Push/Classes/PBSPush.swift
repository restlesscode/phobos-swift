//
//
//  PBSPush.swift
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
import RxSwift
import UserNotifications

public class PBSPush: NSObject {
  public static let shared = PBSPush()
  private let appDelegateSwizzler = PBSPushAppDelegateSwizzler()

  var onSuccess: ((Data) -> Void)?
  var onError: ((Error) -> Void)?
  var onUnauthorized: ((UNAuthorizationStatus) -> Void)?

  override private init() {
    super.init()
    appDelegateSwizzler.load(withDefaultPush: self)
  }

  public func registerRemoteNotifications(options: UNAuthorizationOptions = [.alert, .sound, .badge], onUnauthorized: @escaping (UNAuthorizationStatus) -> Void, onError: @escaping (Error) -> Void, onSuccess: @escaping (Data) -> Void) {
    self.onError = onError
    self.onSuccess = onSuccess
    self.onUnauthorized = onUnauthorized
    UNUserNotificationCenter.current().requestAuthorization(options: options) { granted, error in
      if let error = error {
        PBSLogger.logger.error(message: "Error requesting for authorization: \(error)", context: "Push")
        self.onError?(error)
      }

      guard granted else { return }

      UNUserNotificationCenter.current().getNotificationSettings { settings in
        guard settings.authorizationStatus == .authorized else {
          self.onUnauthorized?(settings.authorizationStatus)
          return
        }

        DispatchQueue.main.async {
          UIApplication.pbs_shared?.registerForRemoteNotifications()
        }
      }
    }
  }
}
