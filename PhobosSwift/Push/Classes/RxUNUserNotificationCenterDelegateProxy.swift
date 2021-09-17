//
//
//  RxUNUserNotificationCenterDelegateProxy.swift
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
import PhobosSwiftLog
import RxCocoa
import RxSwift

public class RxUNUserNotificationCenterDelegateProxy: DelegateProxy<UNUserNotificationCenter, UNUserNotificationCenterDelegate>, DelegateProxyType {
  /// Typed parent object.
  public private(set) weak var center: UNUserNotificationCenter?

  /// - parameter textview: Parent object for delegate proxy.
  public init(center: UNUserNotificationCenter) {
    self.center = center
    super.init(parentObject: center, delegateProxy: RxUNUserNotificationCenterDelegateProxy.self)
  }

  public static func currentDelegate(for object: UNUserNotificationCenter) -> UNUserNotificationCenterDelegate? {
    object.delegate
  }

  public static func setCurrentDelegate(_ delegate: UNUserNotificationCenterDelegate?, to object: UNUserNotificationCenter) {
    object.delegate = delegate
  }

  public static func registerKnownImplementations() {
    register { RxUNUserNotificationCenterDelegateProxy(center: $0) }
  }

  private(set) var willPresentNotificationPublishSubject = PublishSubject<RxUserNotificationCenterWillPresentNotification>()

  private(set) var didReceiveResponsePublishSubject = PublishSubject<RxUserNotificationCenterDidRecieveResponse>()

  private var _openSettingsForNotificationPublishSubject: Any?
  @available(iOS 12.0, *)
  var openSettingsForNotificationPublishSubject: PublishSubject<UNNotification?> {
    if _openSettingsForNotificationPublishSubject == nil {
      return PublishSubject<UNNotification?>()
    } else {
      return _openSettingsForNotificationPublishSubject as! PublishSubject<UNNotification?>
    }
  }
}

// MARK: UNUserNotificationCenterDelegate

extension RxUNUserNotificationCenterDelegateProxy: UNUserNotificationCenterDelegate {
  /// For more information take a look at `DelegateProxyType`.

  /// The method will be called on the delegate only if the application is in the foreground.
  /// If the method is not implemented or the handler is not called in a timely manner then the notification will not be presented.
  /// The application can choose to have the notification presented as a sound, badge, alert and/or in the notification list.
  /// This decision should be based on whether the information in the notification is otherwise visible to the user.
  public func userNotificationCenter(_ center: UNUserNotificationCenter,
                                     willPresent notification: UNNotification,
                                     withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    PBSLogger.logger.debug(message: "userNotificationCenter willPresent: \(notification)", context: "Push")

    let userNotificationCenterWillPresentNotification = (notification, completionHandler)
    willPresentNotificationPublishSubject.on(.next(userNotificationCenterWillPresentNotification))

    _forwardToDelegate?.userNotificationCenter(center, willPresent: notification, withCompletionHandler: completionHandler)
  }

  /// The method will be called on the delegate when the user responded to the notification by opening the application,
  /// dismissing the notification or choosing a UNNotificationAction. The delegate must be set before the application
  /// returns from application:didFinishLaunchingWithOptions:.
  public func userNotificationCenter(_ center: UNUserNotificationCenter,
                                     didReceive response: UNNotificationResponse,
                                     withCompletionHandler completionHandler: @escaping () -> Void) {
    PBSLogger.logger.debug(message: "userNotificationCenter didReceive: \(response)", context: "Push")

    let userNotificationCenterDidRecieveResponse = (response, completionHandler)
    didReceiveResponsePublishSubject.on(.next(userNotificationCenterDidRecieveResponse))

    _forwardToDelegate?.userNotificationCenter(center, didReceive: response, withCompletionHandler: completionHandler)
  }

  /// The method will be called on the delegate when the application is launched in response to the user's request to view in-app notification settings.
  /// Add UNAuthorizationOptionProvidesAppNotificationSettings as an option in requestAuthorizationWithOptions:completionHandler:
  /// to add a button to inline notification settings view and the notification settings view in Settings.
  /// The notification will be nil when opened from Settings.
  @available(iOS 12.0, *)
  public func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) {
    PBSLogger.logger.debug(message: "userNotificationCenter openSettingsFor: \(String(describing: notification))", context: "Push")

    openSettingsForNotificationPublishSubject.on(.next(notification))
    _forwardToDelegate?.userNotificationCenter(center, openSettingsFor: notification)
  }
}
