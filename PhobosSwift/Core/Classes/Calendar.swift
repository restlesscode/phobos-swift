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


/// Enhanced features of Calendar class is implemented in this extension
public extension Calendar {
    /// 通用时间格式
    static let timeStringFormat: String = "yyyy-MM-dd HH:mm:ss"
    /// 通用日期格式
    static let dateStringFormat: String = "yyyy-MM-dd"
    
    /// 计算两个时间点之间的「间隔秒数」
    ///
    /// - parameter datetimeStart: 开始时间Data对象
    /// - parameter datetimeEnd: 结束时间Data对象
    ///
    /// - returns: A second or count of seconds.
    static func pbs_secondDifference(_ datetimeStart:Date, datetimeEnd:Date) -> Int? {
        let gregorianCalendar:Calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        
        let dateComponents = gregorianCalendar.dateComponents([.second], from: datetimeStart, to: datetimeEnd)
        
        return dateComponents.second
    }
    
    /// 计算两个时间点之间的「间隔秒数」
    ///
    /// - parameter datetimeStartStr: 开始时间Data对象
    /// - parameter datetimeEndStr: 结束时间Data对象
    ///
    /// - returns: A second or count of seconds.
    static func pbs_secondDifference(_ datetimeStartStr:String, datetimeEndStr:String) -> Int? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        if let startDatetime = dateFormatter.date(from: datetimeStartStr) {
            if let endDatetime = dateFormatter.date(from: datetimeEndStr) {
                let gregorianCalendar:Calendar = Calendar(identifier: Calendar.Identifier.gregorian)
                let dateComponents = gregorianCalendar.dateComponents([.second], from: startDatetime, to: endDatetime)

                return dateComponents.second
            }
        }

        return nil
    }

    /// 计算两个时间点之间的「间隔天数」
    ///
    /// - parameter dateStartStr: 开始时间String对象
    /// - parameter dateEndStr: 结束时间String对象
    ///
    /// - returns: count of days.
    static func pbs_dayDifference(_ dateStartStr:String, dateEndStr:String) -> Int? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let startDate = dateFormatter.date(from: dateStartStr) {
            if let endDate = dateFormatter.date(from: dateEndStr) {
                let gregorianCalendar:Calendar = Calendar(identifier: Calendar.Identifier.gregorian)
                let dateComponents = gregorianCalendar.dateComponents([.day], from: startDate, to: endDate)

                return dateComponents.day
            }
        }

        return nil
    }
    
    /// Covert a date string from current format to another dateFormat
    ///
    /// - parameter srcDateStr: 要转换的Date String
    /// - parameter srcDateFormat: 要转换的Date String Format
    /// - parameter destDateFormat: 要转换后的Date String Format
    ///
    /// - returns: date string converted
    static func pbs_changeDateStringToFormat(_ srcDateStr: String, srcDateFormat:String = "yyyy-MM-dd", destDateFormat: String = "EE MMMM d, YYYY") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = srcDateFormat
        let date = dateFormatter.date(from: srcDateStr)
        return date!.pbs_string(dateFormat:destDateFormat)
    }
    
    /// Covert Date String to Date
    ///
    /// - parameter dateStr: data string
    /// - parameter dateFormat: date format
    ///
    /// - returns: date converted
    static func pbs_dateFromString(_ dateStr: String, dateFormat:String = "yyyy-MM-dd") -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.date(from: dateStr)!
    }
    
    /// Covert Timestamp to String
    ///
    /// - parameter timestamp: 时间戳
    /// - parameter dateFormat: 需要的时间格式
    ///
    /// - returns: local date string converted
    static func pbs_localStringFromTimestamp(_ timestamp: Double, dateFormat: String = "yyyy-MM-dd") -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.local
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: date)
    }

    /// today of string in a given date format
    static func pbs_today(_ dateFormat:String = "yyyy-MM-dd", timeZone:TimeZone? = nil) -> String {
        let dateFormatter = DateFormatter()
        
        if timeZone != nil {
            dateFormatter.timeZone = timeZone
        }
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: Date())
    }
}

/// Enhanced features of Date struct is implemented in this extension
public extension Date {
    /// Covert Date to String format
    ///
    /// - parameter dateFormat: date format
    ///
    /// - returns: date string converted
    func pbs_string(dateFormat:String = "yyyy-MM-dd") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        
        return dateFormatter.string(from: self)
    }
    
    /// The begining of a week for a given date
    ///
    var pbs_beginDateOfWeek:Date {
        
        let gregorian = Calendar(identifier: Calendar.Identifier.gregorian)
        
        // Get the weekday component of the current date
        let weekdayComponents = gregorian.dateComponents([.weekday], from: self)
        
        /*
         Create a date components to represent the number of days to subtract from the current date.
         The weekday value for Sunday in the Gregorian calendar is 1,
         so subtract 1 from the number of days to subtract from the date in question.
         (If today is Sunday, subtract 0 days.)
         */
        var componentsToSubtract = DateComponents()
        componentsToSubtract.day = 0 - (weekdayComponents.weekday!-1)
        
        var beginningOfWeek = gregorian.date(byAdding: componentsToSubtract, to: self)!
        
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
    var pbs_endDateOfWeek: Date {
        let beginningOfWeek = self.pbs_beginDateOfWeek
        return beginningOfWeek.pbs_dateAfterDays(6)
    }
    
    /// The date after interval
    ///
    func pbs_dateAfterDays(_ deltaDays:Int) -> Date {
        let gregorian = Calendar(identifier: Calendar.Identifier.gregorian)
        
        var dayComponent = DateComponents()
        dayComponent.day = deltaDays
        
        let newDate:Date = gregorian.date(byAdding: dayComponent, to: self)!
        
        return newDate
    }
}

/// Enhanced features of String class is implemented in this extension
public extension String {
    
    /// Convert UTC Date to Local Date
    ///
    /// - Parameter dateFormat: dateFormat String
    /// - Returns: Locat Data String
    func pbs_convertUTCDateToLocalDate(_ dateFormat:String = "yyyy-MM-dd") -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let localTimeZone = NSTimeZone.local
        dateFormatter.timeZone = localTimeZone
        let dateFormatted = dateFormatter.date(from: self)
        dateFormatter.dateFormat = dateFormat
        guard let date = dateFormatted else {
            return nil
        }
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
}
