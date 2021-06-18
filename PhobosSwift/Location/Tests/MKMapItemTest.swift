//
//
//  MKMapItemTest.swift
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

class MKMapItemTest: QuickSpec {
  override func spec() {
    testMakeMapItem()
  }
  
  func testMakeMapItem() {
    describe("Given 提供定位及名称") {
      let location = CLLocation(latitude: 31.30018852172415, longitude: 121.29127298178801)
      let name = "南翔"
      context("When 调用MKMapItem.pbs.makeMapItem") {
        let mapItem = MKMapItem.pbs.makeMapItem(location: location, name: name)
        it("Then 返回结果不能为空，同时坐标与名称与参数一致") {
          expect(mapItem).toNot(beNil())
          expect(mapItem.name).to(equal(name))
          expect(mapItem.placemark.location?.coordinate).to(equal(location.coordinate))
        }
      }
    }
  }
}
