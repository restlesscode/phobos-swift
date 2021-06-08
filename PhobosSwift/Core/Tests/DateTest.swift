//
//
//  DateTest.swift
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

class DateTest: QuickSpec {
  override func spec() {
    testString()
    testBeginDateOfWeek()
    testEndDateOfWeek()
    testDateAfterDays()
  }

  func testString() {
    describe("Given 给定日期2021-06-08 08:00:00, 日期格式 yyyy-MM-dd HH:mm:ss") {
      let date = Date(timeIntervalSince1970: TimeInterval(1_623_110_400))
      let dateFormat = "yyyy-MM-dd HH:mm:ss"
      let expectDateStr = "2021-06-08 08:00:00"

      context("When 调用date.pbs.string") {
        let dateStr = date.pbs.string(dateFormat: dateFormat)
        it("Then 返回2021-06-08 08:00:00") {
          expect(dateStr).to(equal(expectDateStr))
        }
      }
    }
  }

  func testBeginDateOfWeek() {
    describe("Given 给定日期2021-06-08") {
      let date = Date(timeIntervalSince1970: TimeInterval(1_623_110_400))
      // 周日
      let expectDateStr = "2021-06-06"

      context("When 调用date.pbs.beginDateOfWeek") {
        let date = date.pbs.beginDateOfWeek
        it("Then 返回2021-06-06") {
          expect(date.pbs.string()).to(equal(expectDateStr))
        }
      }
    }
  }

  func testEndDateOfWeek() {
    describe("Given 给定日期2021-06-08") {
      let date = Date(timeIntervalSince1970: TimeInterval(1_623_110_400))
      // 周六
      let expectDateStr = "2021-06-12"

      context("When 调用date.pbs.endDateOfWeek") {
        let date = date.pbs.endDateOfWeek
        it("Then 返回2021-06-12") {
          expect(date.pbs.string()).to(equal(expectDateStr))
        }
      }
    }
  }

  func testDateAfterDays() {
    describe("Given 给定日期2021-06-08, 向后推6天") {
      let date = Date(timeIntervalSince1970: TimeInterval(1_623_110_400))
      let deltaDays = 6
      let expectDateStr = "2021-06-14"

      context("When 调用date.pbs.dateAfterDays") {
        let date = date.pbs.dateAfterDays(deltaDays)
        it("Then 返回2021-06-14") {
          expect(date.pbs.string()).to(equal(expectDateStr))
        }
      }
    }
  }
}
