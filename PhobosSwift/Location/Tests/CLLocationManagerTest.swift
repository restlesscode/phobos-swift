//
//
//  CLLocationManagerTest.swift
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

class CLLocationManagerTest: QuickSpec {
  var locationManager: CLLocationManager!

  override func spec() {
    beforeEach {
      self.locationManager = CLLocationManager.pbs.makeLocationManager()
    }
    testMakeLocationManager()
    testEscalateLocationServiceAuthorization()
    testIsLocationServicesEnabled()
    testShouldDisplayHeadingCalibration()
    testAuthorizationStatus()
    testUpdatingLocation()
    testShowRouteInBuitinMap()
  }

  func testMakeLocationManager() {
    describe("Given 提供默认参数") {
      context("When 调用CLLocationManager.pbs.makeLocationManager") {
        locationManager = CLLocationManager.pbs.makeLocationManager()

        it("Then locationManager不为空") {
          expect(self.locationManager).toNot(beNil())
          expect(self.locationManager.pbs.shouldDisplayHeadingCalibration).to(beTrue())
        }
      }
    }
  }

  func testEscalateLocationServiceAuthorization() {
    describe("Given locationManager初始化成功") {
      context("When 调用 locationManager.pbs.escalateLocationServiceAuthorization") {
        locationManager.pbs.escalateLocationServiceAuthorization()
        it("Then 不会闪退") {
          expect(true).to(beTrue())
        }
      }
    }
  }

  func testIsLocationServicesEnabled() {
    describe("Given locationManager初始化成功") {
      context("When 调用 locationManager.pbs.isLocationServicesEnabled") {
        let enable = locationManager.pbs.isLocationServicesEnabled
        it("Then 返回true") {
          expect(enable).to(beTrue())
        }
      }
    }
  }

  func testShouldDisplayHeadingCalibration() {
    describe("Given locationManager初始化成功") {
      context("When 调用 locationManager.pbs.shouldDisplayHeadingCalibration") {
        let enable = locationManager.pbs.shouldDisplayHeadingCalibration
        it("Then 返回true") {
          expect(enable).to(beTrue())
        }
      }
    }
  }

  func testAuthorizationStatus() {
    describe("Given locationManager初始化成功") {
      context("When 调用 locationManager.pbs.authorizationStatus") {
        _ = locationManager.pbs.authorizationStatus
        it("Then 返回true") {
          expect(true).to(beTrue())
        }
      }
    }
  }

  func testUpdatingLocation() {
    describe("Given locationManager初始化成功") {
      context("When 调用 locationManager.pbs.updatingLocation") {
        locationManager.pbs.updatingLocation(updating: true)
        it("Then 不会闪退") {
          expect(true).to(beTrue())
        }
      }
    }
  }

  func testShowRouteInBuitinMap() {
    describe("Given 提供对应参数") {
      let location = CLLocationCoordinate2D(latitude: 31.29822544649922, longitude: 121.29552522985625)
      let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: location))

      context("When 调用 CLLocationManager.pbs.showRouteInBuitinMap") {
        CLLocationManager.pbs.showRouteInBuitinMap(destLocation: mapItem)
        it("Then 不会闪退") {
          expect(true).to(beTrue())
        }
      }
    }
  }
}
