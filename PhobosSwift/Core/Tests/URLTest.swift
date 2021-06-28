//
//
//  URLTest.swift
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

class URLTest: QuickSpec {
  override func spec() {
    testQueryParametersIntDictionary()
    testAppendingQueryParameters()
    testParametersFromQueryString()
  }

  func testQueryParametersIntDictionary() {
    let dictionary = ["day": "Tuesday", "month": "January"]
    describe("Given 有一个字典为\(dictionary)") {
      let expectString = "day=Tuesday&month=January"

      context("When 调用字典的queryParameters") {
        let result = dictionary.queryParameters
        it("Then 返回\(expectString)") {
          expect(result.sorted()).to(equal(expectString.sorted()))
        }
      }
    }
  }

  func testAppendingQueryParameters() {
    describe("Given 有一个链接：http://xxxx.com，需要添加page=1,count = 10 ") {
      let url = URL(string: "http://xxxx.com")
      let parameters = ["page": "1", "count": "10"]
      let expectUrlString = "http://xxxx.com?page=1&count=10"

      context("When 调用url.pbs.appendingQueryParameters") {
        let resultUrl = url?.pbs.appendingQueryParameters(parameters)
        it("Then 返回\(expectUrlString)") {
          expect(resultUrl?.absoluteString.sorted()).to(equal(expectUrlString.sorted()))
        }
      }
    }
  }

  func testParametersFromQueryString() {
    describe("Given 有一个链接：http://xxxx.com?page=1&count=10") {
      let url = URL(string: "http://xxxx.com?page=1&count=10")
      let expectParameters = ["page": "1", "count": "10"]

      context("When 调用url.pbs.parametersFromQueryString") {
        let resultParameters = url?.pbs.parametersFromQueryString
        it("Then 返回\(expectParameters)") {
          expect(resultParameters).to(equal(expectParameters))
        }
      }
    }
  }
}
