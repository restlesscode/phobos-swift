//
//
//  CLLocationCoordinate2DTest.swift
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
import CoreLocation
import Nimble
import Quick

class CLLocationCoordinate2DTest: QuickSpec {
  let model = CLLocationCoordinate2DTestModel()

  override func spec() {
    testGCJ02Offset()
    testWGS84ToGCJ02()
    testGCJ02ToWGS84()
    testGCJ02ToBD09()
    testBD09ToGCJ02()
    testDistance()
  }

  func testGCJ02Offset() {
    describe("Given 提供一个标准坐标\(model.WGSLocation)") {
      let location = model.WGSLocation
      let expectOffset = CLLocationCoordinate2D(latitude: -0.0019630359513466513, longitude: 0.004252246471772355)

      context("When 调用CLLocationCoordinate2D.pbs.GCJ02Offset") {
        let offset = location.pbs.GCJ02Offset
        it("Then 返回\(expectOffset)") {
          expect(offset).to(equal(expectOffset))
        }
      }
    }
  }

  func testWGS84ToGCJ02() {
    describe("Given 提供一个标准坐标\(model.WGSLocation)") {
      let location = model.WGSLocation

      context("When 调用CLLocationCoordinate2D.pbs.WGS84ToGCJ02") {
        let location = location.pbs.WGS84ToGCJ02
        it("Then 返回\(model.GCJLocation)") {
          expect(location).to(equal(self.model.GCJLocation))
        }
      }
    }
  }

  func testGCJ02ToWGS84() {
    describe("Given 提供一个火星坐标\(model.GCJLocation)") {
      let location = model.GCJLocation

      context("When 调用CLLocationCoordinate2D.pbs.GCJ02ToWGS84") {
        let location = location.pbs.GCJ02ToWGS84
        it("Then 返回\(model.GCJToWGSLocation)") {
          expect(location).to(equal(self.model.GCJToWGSLocation))
        }
      }
    }
  }

  func testGCJ02ToBD09() {
    describe("Given 提供一个火星坐标\(model.GCJLocation)") {
      let location = model.GCJLocation

      context("When 调用CLLocationCoordinate2D.pbs.GCJ02ToBD09") {
        let location = location.pbs.GCJ02ToBD09
        it("Then 返回\(model.BDLocation)") {
          expect(location).to(equal(self.model.BDLocation))
        }
      }
    }
  }

  func testBD09ToGCJ02() {
    describe("Given 提供一个百度坐标\(model.BDLocation)") {
      let location = model.BDLocation

      context("When 调用CLLocationCoordinate2D.pbs.BD09ToGCJ02") {
        let location = location.pbs.BD09ToGCJ02
        it("Then 返回\(model.BDToGCJLocation)") {
          expect(location).to(equal(self.model.BDToGCJLocation))
        }
      }
    }
  }

  func testDistance() {
    describe("Given 提供两个坐标\(model.BDLocation)，\(model.WGSLocation)") {
      let location = model.BDLocation
      let endLocation = model.WGSLocation

      context("When 调用CLLocationCoordinate2D.pbs.distance") {
        let distance = Float(location.pbs.distance(from: endLocation))
        it("Then 返回1111.1595") {
          expect(distance).to(equal(1111.1595))
        }
      }
    }
  }
}

struct CLLocationCoordinate2DTestModel {
  let WGSLocation = CLLocationCoordinate2D(latitude: 31.30018852172415, longitude: 121.29127298178801)
  let GCJLocation = CLLocationCoordinate2D(latitude: 31.298225485772804, longitude: 121.29552522825979)
  let GCJToWGSLocation = CLLocationCoordinate2D(latitude: 31.30018305828264, longitude: 121.29126576660241)
  let BDLocation = CLLocationCoordinate2D(latitude: 31.304003455135383, longitude: 121.30206587687063)
  let BDToGCJLocation = CLLocationCoordinate2D(latitude: 31.29822544649922, longitude: 121.29552522985625)
}
