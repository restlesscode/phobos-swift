//
//
//  UNUserNotificationCenter+PhobosSwift.swift
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

import CoreLocation
import Foundation
import PhobosSwiftCore
import UserNotifications

// MARK: - local notificaiton push

extension UNUserNotificationCenter: PhobosSwiftCompatible {}

extension PhobosSwift where Base: UNUserNotificationCenter {
  /// 根据时间间隔推送
  public static func scheduleTimeIntervalNotificaiton(WithTitle title: String,
                                                      subTitle: String,
                                                      body: String,
                                                      userInfo: [String: Any],
                                                      timeInterval: TimeInterval,
                                                      repeats: Bool) {
    let content = UNMutableNotificationContent()
    content.title = title
    content.subtitle = subTitle
    content.body = body
    content.userInfo = userInfo

    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: repeats)

    scheduleNotification(trigger: trigger, content: content, sound: true, badge: "1")
  }

  /// 根据位置本地推送
  public static func scheduleLocationNotificaiton(withTitle title: String,
                                                  subTitle: String,
                                                  body: String,
                                                  userInfo: [String: Any],
                                                  identifier: String,
                                                  longitude: Double,
                                                  latitude: Double,
                                                  radius: Double,
                                                  notifyOnEntry: Bool,
                                                  notifyOnExit: Bool) {
    let content = UNMutableNotificationContent()
    content.title = title
    content.subtitle = subTitle
    content.body = body
    content.userInfo = userInfo

    let center = CLLocationCoordinate2DMake(latitude, longitude)
    let region = CLCircularRegion(center: center, radius: radius, identifier: identifier)
    region.notifyOnEntry = notifyOnEntry
    region.notifyOnExit = notifyOnExit
    let trigger = UNLocationNotificationTrigger(region: region, repeats: true)
    scheduleNotification(trigger: trigger, content: content, sound: true, badge: "1")
  }

  /// 根据时间点进行推送
  public static func timingPushNotification(withTitle title: String,
                                            subTitle: String,
                                            body: String,
                                            userInfo: [String: Any],
                                            identifier: String,
                                            dateComponents: DateComponents,
                                            repeat: Bool) {
    let content = UNMutableNotificationContent()
    content.title = title
    content.subtitle = subTitle
    content.body = body
    content.userInfo = userInfo

    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
    scheduleNotification(trigger: trigger, content: content, sound: true, badge: "1")
  }

  private static func scheduleNotification(trigger: UNNotificationTrigger, content: UNMutableNotificationContent, sound: Bool, badge: String?) {
    if sound {
      content.sound = UNNotificationSound.default
    }

    if let badge = badge, let number = Int(badge) {
      content.badge = NSNumber(value: number)
    }

    let identifier = UUID().uuidString
    let request = UNNotificationRequest(identifier: identifier,
                                        content: content,
                                        trigger: trigger)

    UNUserNotificationCenter.current().add(request) { error in
      if let error = error {
        DispatchQueue.main.async {
          let message = """
          Failed to schedule notification.
          \(error.localizedDescription)
          """
          print(message)
        }
      } else {
        DispatchQueue.main.async {}
      }
    }
  }
}

/// Request Notificaiton Settings
extension PhobosSwift where Base: UNUserNotificationCenter {
  /// Request Notification Settings
  /// - Parameter completionHandler: UNNotificationSettings
  public static func requestNotificationSettings(completionHandler: @escaping (UNNotificationSettings) -> Void) {
    UNUserNotificationCenter.current().getNotificationSettings { settings in
      completionHandler(settings)
    }
  }

  /// Request Notification Authorization Status
  /// - Parameter completionHandler: UNAuthorizationStatus
  public static func requestAuthorizationStatus(completionHandler: @escaping (UNAuthorizationStatus) -> Void) {
    requestNotificationSettings { settings in
      completionHandler(settings.authorizationStatus)
    }
  }
}
