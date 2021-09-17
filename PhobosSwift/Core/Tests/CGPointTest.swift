//
//
//  CGPointTest.swift
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

class CGPointTest: QuickSpec {
  override func spec() {
    testDistance()
    testOffset()
  }

  func testDistance() {
    describe("Given 当前点为(x: 100, y: 100), 目标点为(x: 120, y: 120)") {
      let nowPoint = CGPoint(x: 100, y: 100)
      let objPoint = CGPoint(x: 120, y: 120)

      context("When 调用CGPoint.pbs.distance") {
        let distance = nowPoint.pbs.distance(to: objPoint)
        it("Then 返回的距离为28.284271247461902") {
          expect(distance).to(equal(28.284271247461902))
        }
      }
    }
  }

  func testOffset() {
    describe("Given 当前点为(x: 100, y: 100), 偏移量为(x: 120, y: 120)") {
      let nowPoint = CGPoint(x: 100, y: 100)
      let offset = UIOffset(horizontal: 120, vertical: 120)

      context("When 调用CGPoint.pbs.offset") {
        let resultPoint = nowPoint.pbs.offset(x: offset.horizontal, y: offset.vertical)
        it("Then 返回的Point为(x: 220, y: 220)") {
          expect(resultPoint).to(equal(CGPoint(x: 220, y: 220)))
        }
      }
    }
  }
}
