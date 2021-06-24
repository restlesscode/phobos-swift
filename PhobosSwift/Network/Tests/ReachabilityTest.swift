//
//
//  ReachabilityTest.swift
//  PhobosSwiftNetwork-Unit-Tests
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


@testable import PhobosSwiftNetwork
import Nimble
import Quick

class ReachabilityTest: QuickSpec {
  override func spec() {
    testIsReachable()
    testStatus()
    testConfigure()
    testConfigureWithEnableAlert()
    testCheckConnectivity()
    testAlertCtrl()
    testConnectionType()
  }
  
  func testIsReachable() {
    describe("Given 在Mac上PBSNetwork.Reachability初始化成功") {
      let reachability = PBSNetwork.Reachability.init()
      context("When 调用reachability.isReachable") {
        let isReachable = reachability.isReachable
        it("Then 返回false") {
          expect(isReachable).toNot(beTrue())
        }
      }
    }
  }
  
  func testStatus() {
    describe("Given PBSNetwork.Reachability初始化成功") {
      let reachability = PBSNetwork.Reachability.init()
      context("When 调用reachability.status") {
        let status = reachability.status
        it("Then 返回unknown") {
          expect(status).to(equal(.unknown))
        }
      }
    }
  }
  
  func testConfigure() {
    describe("Given PBSNetwork.Reachability初始化成功") {
      let reachability = PBSNetwork.Reachability.init()
      context("When 调用reachability.configure") {
        reachability.configure()
        it("Then 不会闪退") {
          expect(true).to(beTrue())
        }
      }
    }
  }
  
  func testConfigureWithEnableAlert() {
    describe("Given PBSNetwork.Reachability初始化成功") {
      let reachability = PBSNetwork.Reachability.init()
      context("When 调用reachability.configure") {
        reachability.configure(enableAlert: false)
        it("Then 不会闪退") {
          expect(true).to(beTrue())
        }
      }
    }
  }
  
  func testCheckConnectivity() {
    describe("Given PBSNetwork.Reachability初始化成功") {
      let reachability = PBSNetwork.Reachability.init()
      context("When 调用reachability.checkConnectivity") {
        reachability.checkConnectivity()
        it("Then 不会闪退") {
          expect(true).to(beTrue())
        }
      }
    }
  }
  
  func testAlertCtrl() {
    describe("Given PBSNetwork.Reachability初始化成功") {
      let reachability = PBSNetwork.Reachability.init()
      context("When 调用reachability.alertCtrl") {
        _ = reachability.alertCtrl
        it("Then 不会闪退") {
          expect(true).to(beTrue())
        }
      }
    }
  }
  
  func testConnectionType() {
    describe("Given PBSNetwork.Reachability初始化成功") {
      let reachability = PBSNetwork.Reachability.init()
      context("When 调用reachability.connectionType") {
        _ = reachability.connectionType
        it("Then 不会闪退") {
          expect(true).to(beTrue())
        }
      }
    }
  }
}
