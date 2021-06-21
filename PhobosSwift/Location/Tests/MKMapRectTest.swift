//
//
//  MKMapRectTest.swift
//  PhobosSwiftLocation-Unit-Tests
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

@testable import PhobosSwiftLocation
import Nimble
import Quick
import MapKit

class MKMapRectTest: QuickSpec {
  override func spec() {
    testMakeMapRectWithMinX()
    testMakeMapRect()
    testContains()
  }
  
  func testMakeMapRectWithMinX() {
    describe("Given minX: 0, minY: 0, maxX: 100, maxY: 100") {
      let minX: Double = 0
      let minY: Double = 0
      let maxX: Double = 100
      let maxY: Double = 100
      let expectRect = MKMapRect(x: 0, y: 0, width: 100, height: 100)
      context("When 调用MKMapRect.pbs.makeMapRect") {
        let rect = MKMapRect.pbs.makeMapRect(minX: minX, minY: minY, maxX: maxX, maxY: maxY)
        it("Then 返回结果为\(expectRect)") {
          expect(self.equal(lhs: rect, rhs: expectRect)).to(beTrue())
        }
      }
    }
  }
  
  func testMakeMapRect() {
    describe("Given x: 0, y: 0, width: 100, height: 100") {
      let x: Double = 0
      let y: Double = 0
      let width: Double = 100
      let height: Double = 100
      let expectRect = MKMapRect(x: 0, y: 0, width: 100, height: 100)
      context("When 调用MKMapRect.pbs.makeMapRect") {
        let rect = MKMapRect.pbs.makeMapRect(x: x, y: y, width: width, height: height)
        it("Then 返回结果为\(expectRect)") {
          expect(self.equal(lhs: rect, rhs: expectRect)).to(beTrue())
        }
      }
    }
  }
  
  func testContains() {
    describe("Given Rect x: 0, y: 0, width: 100, height: 100, location: 31.30018852172415, 121.29127298178801") {
      let rect = MKMapRect(x: 0, y: 0, width: 100, height: 100)
      let coordinate = CLLocationCoordinate2DMake(31.30018852172415, 121.2912729817880)
      context("When 调用MKMapRect.pbs.contains") {
        let result = rect.pbs.contains(coordinate)
        it("Then 返回结果为true") {
          expect(result).toNot(beTrue())
        }
      }
    }
  }
  
  func equal(lhs: MKMapRect, rhs: MKMapRect) -> Bool {
    guard lhs.minX == rhs.minX,
          lhs.minY == rhs.minY,
          lhs.width == rhs.width,
          lhs.height == rhs.height else { return false }
    
    return true
  }
}
