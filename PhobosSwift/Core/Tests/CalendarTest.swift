//
//
//  Calendar+Test.swift
//  PhobosSwiftCore-Unit-Tests
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

@testable import PhobosSwiftCore
import Nimble
import Quick

class CalendarTest: QuickSpec {
  override func spec() {
    testDateComponents()
    testSecondDifferenceByDate()
    testSecondDifferenceByString()
    testDayDifferenceByDate()
    testDayDifferenceByString()
    testChangeDateStringToFormat()
    testDate()
    testLocalString()
    testToday()
  }

  func testDateComponents() {
    describe("Given 开始日期为2021/06/07, 结束日期为2021/07/12") {
      let startDate = Date(timeIntervalSince1970: TimeInterval(1_623_024_000))
      let endDate = Date(timeIntervalSince1970: TimeInterval(1_626_048_000))

      context("When 调用Calendar.pbs.dateComponents") {
        let dateComponents = Calendar.pbs.dateComponents(from: startDate, to: endDate)
        it("Then 返回dateComponents的day为35") {
          expect(dateComponents.day).to(equal(35))
        }
      }
    }
  }

  func testSecondDifferenceByDate() {
    describe("Given 开始日期为2021/06/07, 结束日期为2021/07/12") {
      let startDate = Date(timeIntervalSince1970: TimeInterval(1_623_024_000))
      let endDate = Date(timeIntervalSince1970: TimeInterval(1_626_048_000))

      context("When 调用Calendar.pbs.secondDifference") {
        let seconds = Calendar.pbs.secondDifference(from: startDate, to: endDate)
        it("Then 返回的seconds为3024000") {
          expect(seconds).to(equal(3_024_000))
        }
      }
    }
  }

  func testSecondDifferenceByString() {
    describe("Given 开始日期为2021/06/07, 结束日期为2021/07/12, 日期格式为 yyyy-MM-dd HH:mm:ss") {
      let dateFormat = "yyyy-MM-dd HH:mm:ss"
      let startDate = "2021-06-07 08:00:00"
      let endDate = "2021-07-12 08:00:59"

      context("When 调用Calendar.pbs.secondDifference") {
        let seconds = Calendar.pbs.secondDifference(from: startDate, to: endDate, dateFormat: dateFormat)
        it("Then 返回的seconds为3024059") {
          expect(seconds).to(equal(3_024_059))
        }
      }
    }
  }

  func testDayDifferenceByDate() {
    describe("Given 开始日期为2021/06/07, 结束日期为2021/07/12") {
      let startDate = Date(timeIntervalSince1970: TimeInterval(1_623_024_000))
      let endDate = Date(timeIntervalSince1970: TimeInterval(1_626_048_000))

      context("When 调用Calendar.pbs.dayDifference") {
        let days = Calendar.pbs.dayDifference(from: startDate, to: endDate)
        it("Then 返回的days为35") {
          expect(days).to(equal(35))
        }
      }
    }
  }

  func testDayDifferenceByString() {
    describe("Given 开始日期为2021/06/07, 结束日期为2021/07/12, 日期格式为 yyyy-MM-dd") {
      let dateFormat = "yyyy-MM-dd"
      let startDate = "2021-06-07"
      let endDate = "2021-07-12"

      context("When 调用Calendar.pbs.dayDifference") {
        let days = Calendar.pbs.dayDifference(from: startDate, to: endDate, dateFormat: dateFormat)
        it("Then 返回的days为35") {
          expect(days).to(equal(35))
        }
      }
    }
  }

  func testChangeDateStringToFormat() {
    describe("Given 要转换的日期为2021/06/07，日期格式为yyyy-MM-dd，目标格式为EE MMMM d, YYYY") {
      let srcDate = "2021-06-07"
      let srcDateFormat = "yyyy-MM-dd"
      let destDateFormat = "EE MMMM d, YYYY"

      context("When 调用Calendar.pbs.changeDateStringToFormat") {
        let date = Calendar.pbs.changeDateStringToFormat(srcDateStr: srcDate, srcDateFormat: srcDateFormat, destDateFormat: destDateFormat)
        it("Then 返回的date为Mon June 7, 2021") {
          expect(date).to(equal("Mon June 7, 2021"))
        }
      }
    }
  }

  func testDate() {
    describe("Given 日期字符串为2021-06-07，日期格式为yyyy-MM-dd") {
      let dateStr = "2021-06-07"
      let dateFormat = "yyyy-MM-dd"

      context("When 调用Calendar.pbs.date") {
        let date = Calendar.pbs.date(from: dateStr, dateFormat: dateFormat)
        it("Then 返回日期的时间戳为1622995200") {
          expect(date?.timeIntervalSince1970).to(equal(1_622_995_200))
        }
      }
    }
  }

  func testLocalString() {
    describe("Given 时间戳为1622995200, 目标日期格式为yyyy-MM-dd") {
      let timestamp = 1_622_995_200
      let dateFormat = "yyyy-MM-dd"

      context("When 调用Calendar.pbs.localString") {
        let dateStr = Calendar.pbs.localString(from: TimeInterval(timestamp), dateFormat: dateFormat)
        it("Then 返回日期字符串为：2021-06-07") {
          expect(dateStr).to(equal("2021-06-07"))
        }
      }
    }
  }

  func testToday() {
    describe("Given 目标日期格式为yyyy-MM-dd，时区默认") {
      let dateFormat = "yyyy-MM-dd"
      let timeZone: TimeZone? = nil

      context("When 调用Calendar.pbs.today") {
        let dateStr = Calendar.pbs.today(dateFormat: dateFormat, timeZone: timeZone)
        it("Then 返回的日期字符串为当天日期") {
          let todayStr = Calendar.pbs.localString(from: Date().timeIntervalSince1970)

          expect(dateStr).to(equal(todayStr))
        }
      }
    }
  }
}
