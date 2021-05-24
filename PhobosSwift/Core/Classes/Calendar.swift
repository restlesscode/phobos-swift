//
//
//  Calendar.swift
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

import Foundation

extension Calendar: PhobosSwiftCompatible {}

extension PhobosSwift where Base == Calendar {
  public static func dateComponents(from start: Date, to end: Date) -> DateComponents {
    let gregorianCalendar = Calendar(identifier: Calendar.Identifier.gregorian)
    let dateComponents = gregorianCalendar.dateComponents([.day], from: start, to: end)
    return dateComponents
  }

  /// 计算两个时间点之间的「间隔秒数」
  ///
  /// - parameter datetimeStart: 开始时间Data对象
  /// - parameter datetimeEnd: 结束时间Data对象
  ///
  /// - returns: A second or count of seconds.
  public static func secondDifference(from start: Date, to end: Date) -> Int? {
    let gregorianCalendar = Calendar(identifier: Calendar.Identifier.gregorian)

    let dateComponents = gregorianCalendar.dateComponents([.second], from: start, to: end)

    return dateComponents.second
  }

  /// 计算两个时间点之间的「间隔秒数」
  ///
  /// - parameter datetimeStartStr: 开始时间Data对象
  /// - parameter datetimeEndStr: 结束时间Data对象
  ///
  /// - returns: A second or count of seconds.
  public static func secondDifference(from start: String, to end: String, dateFormat: String = "yyyy-MM-dd HH:mm:ss") -> Int? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = dateFormat

    guard let startDatetime = dateFormatter.date(from: start), let endDatetime = dateFormatter.date(from: end) else {
      return nil
    }

    return secondDifference(from: startDatetime, to: endDatetime)
  }

  /// 计算两个时间点之间的「间隔天数」
  ///
  /// - parameter dateStart: 开始时间String对象
  /// - parameter dateEnd: 结束时间String对象
  ///
  /// - returns: count of days.
  public static func dayDifference(from start: Date, to end: Date) -> Int? {
    let dateComponents = Calendar.pbs.dateComponents(from: start, to: end)
    return dateComponents.day
  }

  /// 计算两个时间点之间的「间隔天数」
  ///
  /// - parameter dateStartStr: 开始时间String对象
  /// - parameter dateEndStr: 结束时间String对象
  ///
  /// - returns: count of days.
  public static func dayDifference(from start: String, to end: String, dateFormat: String = "yyyy-MM-dd") -> Int? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = dateFormat
    guard let startDate = dateFormatter.date(from: start), let endDate = dateFormatter.date(from: end) else {
      return nil
    }

    return dayDifference(from: startDate, to: endDate)
  }

  /// Covert a date string from current format to another dateFormat
  ///
  /// - parameter srcDateStr: 要转换的Date String
  /// - parameter srcDateFormat: 要转换的Date String Format
  /// - parameter destDateFormat: 要转换后的Date String Format
  ///
  /// - returns: date string converted
  public static func changeDateStringToFormat(srcDateStr: String, srcDateFormat: String = "yyyy-MM-dd", destDateFormat: String = "EE MMMM d, YYYY") -> String? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = srcDateFormat
    let date = dateFormatter.date(from: srcDateStr)
    return date?.pbs.string(dateFormat: destDateFormat)
  }

  /// Covert Date String to Date
  ///
  /// - parameter dateStr: data string
  /// - parameter dateFormat: date format
  ///
  /// - returns: date converted
  public static func date(from dateStr: String, dateFormat: String = "yyyy-MM-dd") -> Date? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = dateFormat
    return dateFormatter.date(from: dateStr)
  }

  /// Covert Timestamp to String
  ///
  /// - parameter timestamp: 时间戳
  /// - parameter dateFormat: 需要的时间格式
  ///
  /// - returns: local date string converted
  public static func localString(from timestamp: TimeInterval, dateFormat: String = "yyyy-MM-dd") -> String {
    let date = Date(timeIntervalSince1970: timestamp)
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = NSTimeZone.local
    dateFormatter.dateFormat = dateFormat
    return dateFormatter.string(from: date)
  }

  /// today of string in a given date format
  public static func today(dateFormat: String = "yyyy-MM-dd", timeZone: TimeZone? = nil) -> String {
    let dateFormatter = DateFormatter()

    if timeZone != nil {
      dateFormatter.timeZone = timeZone
    }
    dateFormatter.dateFormat = dateFormat
    return dateFormatter.string(from: Date())
  }
}
