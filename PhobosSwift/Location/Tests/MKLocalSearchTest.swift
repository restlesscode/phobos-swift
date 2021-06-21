//
//
//  MKLocalSearchTest.swift
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
import MapKit
import Nimble
import Quick

class MKLocalSearchTest: QuickSpec {
  let location = CLLocationCoordinate2D(latitude: 31.30018852172415, longitude: 121.29127298178801)

  override func spec() {
    testMakeNaturalLanguageSearchWithRegion()
    testMakeNaturalLanguageSearchWithMeters()
  }

  func testMakeNaturalLanguageSearchWithRegion() {
    describe("Given 搜索关键字为超市，区域为附近10000米") {
      let keyword = "超市"
      let region = MKCoordinateRegion(center: location, latitudinalMeters: 10_000, longitudinalMeters: 10_000)

      context("When 调用MKLocalSearch.pbs.makeNaturalLanguageSearch") {
        let serach = MKLocalSearch.pbs.makeNaturalLanguageSearch(keyword: keyword, region: region)
        waitUntil(timeout: .seconds(5)) { done in
          serach.start { response, _ in
            it("Then 返回结果不为空") {
              expect(response).toNot(beNil())
            }
            done()
          }
        }
      }
    }
  }

  func testMakeNaturalLanguageSearchWithMeters() {
    describe("Given 搜索关键字为超市，区域为附近10000米") {
      let keyword = "超市"

      context("When 调用MKLocalSearch.pbs.makeNaturalLanguageSearch") {
        let serach = MKLocalSearch.pbs.makeNaturalLanguageSearch(keyword: keyword, center: location, latitudinalMeters: 10_000, longitudinalMeters: 10_000)
        waitUntil(timeout: .seconds(5)) { done in
          serach.start { response, _ in
            it("Then 返回结果不为空") {
              expect(response).toNot(beNil())
            }
            done()
          }
        }
      }
    }
  }
}
