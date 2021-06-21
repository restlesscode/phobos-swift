//
//
//  PBSClusterManagerTest.swift
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

class PBSClusterManagerTest: QuickSpec {
  let clusterManager = PBSClusterManager()
  let model = PBSClusterManagerTestModel()
  
  override func spec() {
    testAnnotations()
    testVisibleNestedAnnotations()
    testAddItem()
    testAddItems()
    testRemoveItem()
    testRemoveItems()
    testRemoveAll()
    testReload()
    testClusteredAnnotations()
    testClusteredAnnotationsWithTree()
    testDistributeAnnotations()
    testCoordinate()
    testMapRects()
    testDisplay()
    testCellSize()
  }
  
  func testAnnotations() {
    describe("Given PBSClusterManager初始化成功") {
      context("When 获取annotations") {
        _ = clusterManager.annotations
        it("Then 不会闪退") {
          expect(true).to(beTrue())
        }
      }
    }
  }
  
  func testVisibleNestedAnnotations() {
    describe("Given PBSClusterManager初始化成功") {
      context("When 获取visibleNestedAnnotations") {
        _ = clusterManager.visibleNestedAnnotations
        it("Then 不会闪退") {
          expect(true).to(beTrue())
        }
      }
    }
  }
  
  func testAddItem() {
    describe("Given 提供一个Annotation") {
      let annotion = model.annotion
      context("When 获取clusterManager.add") {
        clusterManager.add(annotion)
        it("Then 不会闪退") {
          expect(true).to(beTrue())
        }
      }
    }
  }
  
  func testAddItems() {
    describe("Given 提供多个Annotation") {
      let annotion = model.annotion
      let annotion1 = model.annotion1
      context("When 获取clusterManager.add") {
        clusterManager.add([annotion, annotion1])
        it("Then 不会闪退") {
          expect(true).to(beTrue())
        }
      }
    }
  }
  
  func testRemoveItem() {
    describe("Given 提供一个Annotation") {
      let annotion = model.annotion
      context("When 获取clusterManager.remove") {
        clusterManager.remove(annotion)
        it("Then 不会闪退") {
          expect(true).to(beTrue())
        }
      }
    }
  }
  
  func testRemoveItems() {
    describe("Given 提供多个Annotation") {
      let annotion = model.annotion
      let annotion1 = model.annotion1
      context("When 获取clusterManager.remove") {
        clusterManager.remove([annotion, annotion1])
        it("Then 不会闪退") {
          expect(true).to(beTrue())
        }
      }
    }
  }
  
  func testRemoveAll() {
    describe("Given 初始化成功") {
      context("When 获取clusterManager.removeAll") {
        clusterManager.removeAll()
        it("Then 不会闪退") {
          expect(true).to(beTrue())
        }
      }
    }
  }
  
  func testReload() {
    describe("Given 提供一个mapView") {
      let mapView = MKMapView.init(frame: .zero)
      context("When 获取clusterManager.reload") {
        clusterManager.reload(mapView: mapView, completion: { _ in })
        it("Then 不会闪退") {
          expect(true).to(beTrue())
        }
      }
    }
  }
  
  func testClusteredAnnotations() {
    describe("Given 提供zoomScale, visibleMapRect") {
      let zoomScale: Double = 1
      let visibleMapRect = MKMapRect(x: 0, y: 0, width: 100, height: 100)
      context("When 获取clusterManager.clusteredAnnotations") {
        _ = clusterManager.clusteredAnnotations(zoomScale: zoomScale, visibleMapRect: visibleMapRect)
        it("Then 不会闪退") {
          expect(true).to(beTrue())
        }
      }
    }
  }
  
  func testClusteredAnnotationsWithTree() {
    describe("Given 提供zoomScale, visibleMapRect") {
      let zoomScale: Double = 1
      let visibleMapRect = MKMapRect(x: 0, y: 0, width: 100, height: 100)
      context("When 获取clusterManager.clusteredAnnotations") {
        _ = clusterManager.clusteredAnnotations(tree: clusterManager.tree, mapRects: [visibleMapRect], zoomLevel: zoomScale)
        it("Then 不会闪退") {
          expect(true).to(beTrue())
        }
      }
    }
  }
  
  func testDistributeAnnotations() {
    describe("Given 提供tree, visibleMapRect") {
      let visibleMapRect = MKMapRect(x: 0, y: 0, width: 100, height: 100)
      context("When 获取clusterManager.distributeAnnotations") {
        clusterManager.distributeAnnotations(tree: clusterManager.tree, mapRect: visibleMapRect)
        it("Then 不会闪退") {
          expect(true).to(beTrue())
        }
      }
    }
  }
  
  func testCoordinate() {
    describe("Given 提供多个Annotation") {
      let annotion = model.annotion
      let annotion1 = model.annotion1
      let mapRect = MKMapRect(x: 0, y: 0, width: 100, height: 100)
      context("When 获取clusterManager.coordinate") {
        _ = clusterManager.coordinate(annotations: [annotion, annotion1], position: .center, mapRect: mapRect)
        it("Then 不会闪退") {
          expect(true).to(beTrue())
        }
      }
    }
  }
  
  func testMapRects() {
    describe("Given 提供zoomScale, visibleMapRect") {
      let zoomScale: Double = 1
      let visibleMapRect = MKMapRect(x: 0, y: 0, width: 100, height: 100)
      context("When 调用clusterManager.mapRects") {
        _ = clusterManager.mapRects(zoomScale: zoomScale, visibleMapRect: visibleMapRect)
        it("Then 不会闪退") {
          expect(true).to(beTrue())
        }
      }
    }
  }
  
  func testDisplay() {
    describe("Given 提供多个Annotation") {
      let annotion = model.annotion
      let annotion1 = model.annotion1
      let mapView = MKMapView.init(frame: .zero)
      context("When 调用clusterManager.display") {
        clusterManager.display(mapView: mapView, toAdd: [annotion], toRemove: [annotion1])
        it("Then 不会闪退") {
          expect(true).to(beTrue())
        }
      }
    }
  }
  
  func testCellSize() {
    describe("Given zoomLevel 14") {
      let zoomLevel: Double = 14
      context("When 调用clusterManager.cellSize") {
        let result = clusterManager.cellSize(for: zoomLevel)
        it("Then 返回64") {
          expect(result).to(equal(64))
        }
      }
    }
  }
}

struct PBSClusterManagerTestModel {
  let annotion = ClusterAnnotation.init(coordinate: CLLocationCoordinate2D(latitude: 31.30018852172415, longitude: 121.29127298178801))
  let annotion1 = ClusterAnnotation.init(coordinate: CLLocationCoordinate2D(latitude: 31.40018852172415, longitude: 121.49127298178801))
}
