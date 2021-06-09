//
//
//  Array+Test.swift
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

class ArrayTest: QuickSpec {
  override func spec() {
    testChunked()
  }

  func testChunked() {
    describe("Given 有一个长度为7的数组, 拆分size为3") {
      let array: [String] = ["Tom1", "Jack2", "Tom3", "Jack4", "Tom5", "Jack6", "Tom7"]
      let expectSize = 3
      let expectArray: [[String]] = [["Tom1", "Jack2", "Tom3"],
                                     ["Jack4", "Tom5", "Jack6"],
                                     ["Tom7"]]

      context("When 调用Array.pbs_chunked方法") {
        let chunkedArray = array.pbs_chunked(into: expectSize)

        it("Then 返回数组与期望数组一致") {
          expect(chunkedArray).to(equal(expectArray))
        }
      }
    }
  }
}
