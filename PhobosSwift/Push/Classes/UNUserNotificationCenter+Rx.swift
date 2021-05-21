//
//
//  UNUserNotificationCenter+Rx.swift
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
import RxCocoa
import RxSwift

/// tuple类型:(UNNotification, (UNNotificationPresentationOptions) -> Void)
public typealias RxUserNotificationCenterWillPresentNotification = (notification: UNNotification, completionHandler: (UNNotificationPresentationOptions) -> Void)

/// tuple类型:(UNNotificationResponse, () -> Void)
public typealias RxUserNotificationCenterDidRecieveResponse = (response: UNNotificationResponse, completionHandler: () -> Void)

extension Reactive where Base: UNUserNotificationCenter {
  /// DelegateProxy for CocoaMQTTDelegate
  public var delegate: DelegateProxy<UNUserNotificationCenter, UNUserNotificationCenterDelegate> {
    RxUNUserNotificationCenterDelegateProxy.proxy(for: base)
  }

  /// Reactive wrapper for delegate method `userNotificationCenter(UNUserNotificationCenter:UNNotification:UNNotificationPresentationOptions)`
  public var willPresent: ControlEvent<RxUserNotificationCenterWillPresentNotification> {
    let source = RxUNUserNotificationCenterDelegateProxy.proxy(for: base).willPresentNotificationPublishSubject
    return ControlEvent(events: source)
  }

  /// Reactive wrapper for delegate method `userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void)`
  public var didReceive: ControlEvent<RxUserNotificationCenterDidRecieveResponse> {
    let source = RxUNUserNotificationCenterDelegateProxy.proxy(for: base).didReceiveResponsePublishSubject
    return ControlEvent(events: source)
  }

  /// Reactive wrapper for delegate method `userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?)`
  @available(iOS 12.0, *)
  public var openSettingsFor: ControlEvent<UNNotification?> {
    let source = RxUNUserNotificationCenterDelegateProxy.proxy(for: base).openSettingsForNotificationPublishSubject
    return ControlEvent(events: source)
  }

  /// Installs delegate as forwarding delegate on `delegate`.
  /// Delegate won't be retained.
  ///
  /// It enables using normal delegate mechanism with reactive delegate mechanism.
  ///
  /// - parameter delegate: Delegate object.
  /// - returns: Disposable object that can be used to unbind the delegate.
  public func setDelegate(_ delegate: UNUserNotificationCenterDelegate)
    -> Disposable {
    RxUNUserNotificationCenterDelegateProxy.installForwardDelegate(delegate, retainDelegate: false, onProxyForObject: base)
  }
}
