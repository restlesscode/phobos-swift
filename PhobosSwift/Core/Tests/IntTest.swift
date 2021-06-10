//
//
//  IntTest.swift
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

class IntTest: QuickSpec {
  override func spec() {
    testTextualString()
    testCN()
    testRandom()
  }

  func testTextualString() {
    describe("Given 数字12") {
      let number: Int = 12
      let expectResult = "twelve"
      context("When 调用int.pbs.textualString") {
        let result = number.pbs.textualString
        it("Then 返回twelve") {
          expect(result).to(equal(expectResult))
        }
      }
    }
  }

  func testCN() {
    describe("Given 数字12") {
      let number: Int = 12
      let expectResult = "十二"
      context("When 调用int.pbs.cn") {
        let result = number.pbs.cn
        it("Then 返回十二") {
          expect(result).to(equal(expectResult))
        }
      }
    }
  }

  func testRandom() {
    describe("Given 数字12，求12-30之间的随机数") {
      let number: Int = 12
      let maxNumber: Int = 30
      context("When 调用Int.pbs.random") {
        let result = Int.pbs.random(between: number, and: maxNumber)
        it("Then 返回数值在12-30之间") {
          expect(result) > number
          expect(result) < maxNumber
        }
      }
    }
  }
}
