//
//
//  PhobosSwiftLocationTest.swift
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

class PhobosSwiftLocationTest: QuickSpec {
  override func spec() {
    testCrashs()
    testEqual()
    testZoomLevel()
    testCoordinate()
    testLocation()
    testDistance()
    testSubtracted()
    testSubtract()
    testAdd()
    testRemove()
    testAddBlockOperation()
    testFilled()
  }

  func testCrashs() {
    describe("Given PhobosSwiftLocation中的一些列属性") {
      context("When 调用各个属性") {
        _ = Bundle.bundle
        _ = "SETTINGS".localized
        var hasher = Hasher()
        CLLocationCoordinate2D(latitude: 31.30018852172415, longitude: 121.29127298178801).hash(into: &hasher)
        _ = OperationQueue.serial

        it("Then 不会闪退") {
          expect(true).to(beTrue())
        }
      }
    }
  }

  func testEqual() {
    describe("Given 给定两个坐标") {
      let location = CLLocationCoordinate2D(latitude: 31.30018852172415, longitude: 121.29127298178801)
      let location1 = CLLocationCoordinate2D(latitude: 31.40018852172415, longitude: 121.39127298178801)

      context("When 调用CLLocationCoordinate2D.==方法") {
        let shouldBeTrue = location == location
        let shouldBeFalse = location == location1
        it("Then shouldBeTrue为true，shouldBeFalse为false") {
          expect(shouldBeTrue).to(beTrue())
          expect(shouldBeFalse).toNot(beTrue())
        }
      }
    }
  }

  func testZoomLevel() {
    describe("Given double 10") {
      let number: Double = 10
      context("When 调用 double.zoomLevel") {
        let zoomLevel = number.zoomLevel
        it("Then 返回23") {
          expect(zoomLevel).to(equal(23))
        }
      }
    }
  }

  func testCoordinate() {
    describe("Given 给定一个坐标, 方位为30，距离为3000") {
      let location = CLLocationCoordinate2D(latitude: 31.30018852172415, longitude: 121.29127298178801)
      let expectLocation = CLLocationCoordinate2D(latitude: 31.30434522919643, longitude: 121.26008311661268)
      let bearing: Double = 30
      let distance: Double = 3000

      context("When 调用CLLocationCoordinate2D.coordinate方法") {
        let result = location.coordinate(onBearingInRadians: bearing, atDistanceInMeters: distance)
        it("Then 返回期望坐标") {
          expect(result).to(equal(expectLocation))
        }
      }
    }
  }

  func testLocation() {
    describe("Given 给定一个坐标") {
      let location = CLLocationCoordinate2D(latitude: 31.30018852172415, longitude: 121.29127298178801)

      context("When 调用CLLocationCoordinate2D.location方法") {
        let result = location.location
        it("Then 返回坐标经纬度与提供坐标相同") {
          expect(location.latitude).to(equal(result.coordinate.latitude))
          expect(location.longitude).to(equal(result.coordinate.longitude))
        }
      }
    }
  }

  func testDistance() {
    describe("Given 给定两个坐标") {
      let location = CLLocationCoordinate2D(latitude: 31.30018852172415, longitude: 121.29127298178801)
      let location1 = CLLocationCoordinate2D(latitude: 30.30018852172415, longitude: 120.29127298178801)
      context("When 调用CLLocationCoordinate2D.distance方法") {
        _ = Float(location.distance(from: location1))
        it("Then 不会闪退") {
          expect(true).to(beTrue())
        }
      }
    }
  }

  func testSubtracted() {
    describe("Given 给定两个Annotion数组") {
      let location = CLLocationCoordinate2D(latitude: 31.30018852172415, longitude: 121.29127298178801)
      let location1 = CLLocationCoordinate2D(latitude: 30.30018852172415, longitude: 120.29127298178801)
      let location2 = CLLocationCoordinate2D(latitude: 30.60018852172415, longitude: 120.69127298178801)

      let annotion = ClusterAnnotation(coordinate: location)
      let annotion1 = ClusterAnnotation(coordinate: location1)
      let annotion2 = ClusterAnnotation(coordinate: location2)

      let array = [annotion, annotion1]
      let array1 = [annotion1, annotion2]
      let expectArray2 = [annotion]

      context("When 调用array.subtracted") {
        let result = array.subtracted(array1)
        it("Then 返回annotion") {
          expect(result).to(equal(expectArray2))
        }
      }
    }
  }

  func testSubtract() {
    describe("Given 给定两个Annotion数组") {
      let location = CLLocationCoordinate2D(latitude: 31.30018852172415, longitude: 121.29127298178801)
      let location1 = CLLocationCoordinate2D(latitude: 30.30018852172415, longitude: 120.29127298178801)
      let location2 = CLLocationCoordinate2D(latitude: 30.60018852172415, longitude: 120.69127298178801)

      let annotion = ClusterAnnotation(coordinate: location)
      let annotion1 = ClusterAnnotation(coordinate: location1)
      let annotion2 = ClusterAnnotation(coordinate: location2)

      var array = [annotion, annotion1]
      let array1 = [annotion1, annotion2]
      let expectArray2 = [annotion]

      context("When 调用array.subtract") {
        array.subtract(array1)
        it("Then 返回annotion") {
          expect(array).to(equal(expectArray2))
        }
      }
    }
  }

  func testAdd() {
    describe("Given 给定1个Annotion数组") {
      let location = CLLocationCoordinate2D(latitude: 31.30018852172415, longitude: 121.29127298178801)
      let location1 = CLLocationCoordinate2D(latitude: 30.30018852172415, longitude: 120.29127298178801)
      let location2 = CLLocationCoordinate2D(latitude: 30.60018852172415, longitude: 120.69127298178801)

      let annotion = ClusterAnnotation(coordinate: location)
      let annotion1 = ClusterAnnotation(coordinate: location1)
      let annotion2 = ClusterAnnotation(coordinate: location2)

      var array = [annotion, annotion1]
      let expectArray2 = [annotion, annotion1, annotion2]

      context("When 调用array.add") {
        array.add([annotion2])
        it("Then 返回期望数组") {
          expect(array).to(equal(expectArray2))
        }
      }
    }
  }

  func testRemove() {
    describe("Given 给定1个Annotion数组") {
      let location = CLLocationCoordinate2D(latitude: 31.30018852172415, longitude: 121.29127298178801)
      let location1 = CLLocationCoordinate2D(latitude: 30.30018852172415, longitude: 120.29127298178801)
      let location2 = CLLocationCoordinate2D(latitude: 30.60018852172415, longitude: 120.69127298178801)

      let annotion = ClusterAnnotation(coordinate: location)
      let annotion1 = ClusterAnnotation(coordinate: location1)
      let annotion2 = ClusterAnnotation(coordinate: location2)

      var array = [annotion, annotion1, annotion2]
      let expectArray2 = [annotion, annotion1]

      context("When 调用array.remove") {
        array.remove(annotion2)
        it("Then 返回期望数组") {
          expect(array).to(equal(expectArray2))
        }
      }
    }
  }

  func testAddBlockOperation() {
    describe("Given 一个初始化完成的OperationQueue") {
      let quene = OperationQueue.serial
      context("When 调用quene.addBlockOperation") {
        let block: (BlockOperation) -> Void = { _ in }
        quene.addBlockOperation(block)
        it("Then 不会闪退") {
          expect(true).to(beTrue())
        }
      }
    }
  }

  func testFilled() {
    describe("Given 一个UIImage") {
      let image = UIImage()
      let color = UIColor.white
      context("When 调用UIImage.filled") {
        _ = image.filled(with: color)
        it("Then 不会闪退") {
          expect(true).to(beTrue())
        }
      }
    }
  }
}
