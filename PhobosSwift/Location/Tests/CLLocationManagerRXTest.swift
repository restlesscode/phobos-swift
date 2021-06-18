//
//
//  CLLocationManagerRXTest.swift
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

class CLLocationManagerRXTest: QuickSpec {
  override func spec() {
    describe("Given CLLocationManager正常初始化") {
      let localtionManager = CLLocationManager.pbs.makeLocationManager()
      context("When 获取Reactive所有计算属性及函数") {
        _ = localtionManager.rx.delegate
        _ = localtionManager.rx.didUpdateLocations
        _ = localtionManager.rx.didUpdateHeading
        _ = localtionManager.rx.didDetermineState
        _ = localtionManager.rx.didRangeBeacons
        if #available(iOS 13.0, *) {
          _ = localtionManager.rx.didRangeBeaconsSatisfyingBeaconConstraint
          _ = localtionManager.rx.didFailRangingForBeaconConstraint
        } else {
          // Fallback on earlier versions
        }

        _ = localtionManager.rx.rangingBeaconsDidFailForBeaconRegion
        _ = localtionManager.rx.didEnterRegion
        _ = localtionManager.rx.didExitRegion
        _ = localtionManager.rx.didFailWithError
        _ = localtionManager.rx.monitoringDidFailForRegion
        _ = localtionManager.rx.didChangeAuthorization
        if #available(iOS 14.0, *) {
          _ = localtionManager.rx.locationManagerDidChangeAuthorization
        } else {
          // Fallback on earlier versions
        }
        _ = localtionManager.rx.didStartMonitoringForRegion
        _ = localtionManager.rx.locationManagerDidPauseLocationUpdates
        _ = localtionManager.rx.locationManagerDidResumeLocationUpdates
        _ = localtionManager.rx.didFinishDeferredUpdatesWithError
        _ = localtionManager.rx.didVisit
        _ = localtionManager.rx.setDelegate(CLLocationManagerDelegateStub())

        it("不会闪退") {
          expect(true).to(beTrue())
        }
      }
    }
  }
}

class CLLocationManagerDelegateStub: CLLocationManagerDelegate {
  func isEqual(_ object: Any?) -> Bool {
    true
  }

  var hash: Int = 0

  var superclass: AnyClass?

  func `self`() -> Self {
    CLLocationManagerDelegateStub() as! Self
  }

  func perform(_ aSelector: Selector!) -> Unmanaged<AnyObject>! {
    nil
  }

  func perform(_ aSelector: Selector!, with object: Any!) -> Unmanaged<AnyObject>! {
    nil
  }

  func perform(_ aSelector: Selector!, with object1: Any!, with object2: Any!) -> Unmanaged<AnyObject>! {
    nil
  }

  func isProxy() -> Bool {
    true
  }

  func isKind(of aClass: AnyClass) -> Bool {
    true
  }

  func isMember(of aClass: AnyClass) -> Bool {
    true
  }

  func conforms(to aProtocol: Protocol) -> Bool {
    true
  }

  func responds(to aSelector: Selector!) -> Bool {
    true
  }

  var description: String = ""
}
