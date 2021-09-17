//
//
//  Date.swift
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

extension Date: PhobosSwiftCompatible {}

extension PhobosSwift where Base == Date {
  /// Covert Date to String format
  ///
  /// - parameter dateFormat: date format
  ///
  /// - returns: date string converted
  public func string(dateFormat: String = "yyyy-MM-dd") -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = dateFormat

    return dateFormatter.string(from: base)
  }

  /// The begining of a week for a given date
  ///
  public var beginDateOfWeek: Date {
    let gregorian = Calendar(identifier: Calendar.Identifier.gregorian)

    // Get the weekday component of the current date
    let weekdayComponents = gregorian.dateComponents([.weekday], from: base)

    /*
     Create a date components to represent the number of days to subtract from the current date.
     The weekday value for Sunday in the Gregorian calendar is 1,
     so subtract 1 from the number of days to subtract from the date in question.
     (If today is Sunday, subtract 0 days.)
     */
    var componentsToSubtract = DateComponents()
    componentsToSubtract.day = 0 - (weekdayComponents.weekday! - 1)

    var beginningOfWeek = gregorian.date(byAdding: componentsToSubtract, to: base)!

    /*
     Optional step:
     beginningOfWeek now has the same hour, minute, and second as the original date (today).
     To normalize to midnight, extract the year, month, and day components and create a new date from those components.
     */
    let components = gregorian.dateComponents([.year, .month, .day], from: beginningOfWeek)

    beginningOfWeek = gregorian.date(from: components)!

    return beginningOfWeek
  }

  /// The ending of a week for a given date
  ///
  public var endDateOfWeek: Date {
    let beginningOfWeek = beginDateOfWeek
    return beginningOfWeek.pbs.dateAfterDays(6)
  }

  /// The date after interval
  ///
  public func dateAfterDays(_ deltaDays: Int) -> Date {
    let gregorian = Calendar(identifier: Calendar.Identifier.gregorian)

    var dayComponent = DateComponents()
    dayComponent.day = deltaDays

    let newDate: Date = gregorian.date(byAdding: dayComponent, to: base)!

    return newDate
  }
}
