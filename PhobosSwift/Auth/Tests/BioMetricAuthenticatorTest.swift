//
//
//  BioMetricAuthenticatorTest.swift
//  PhobosSwiftAuth-Unit-Tests
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

@testable import PhobosSwiftAuth
import Nimble
import Quick

class BioMetricAuthenticatorTest: QuickSpec {
  override func spec() {
    testAllowableReuseDuration()
    testCanAuthenticate()
    testAuthenticateWithBioMetrics()
    testAuthenticateWithPasscode()
    testIsFaceIDAvailable()
    testIsTouchIDAvailable()
  }
  
  func testAllowableReuseDuration() {
    describe("Given 给定allowableReuseDuration为10") {
      BioMetricAuthenticator.shared.allowableReuseDuration = 10
      context("When 获取BioMetricAuthenticator.shared.allowableReuseDuration") {
        let allowableReuseDuration = BioMetricAuthenticator.shared.allowableReuseDuration
        it("Then 返回10") {
          expect(Int(allowableReuseDuration ?? 0)).to(be(10))
        }
      }
    }
  }
  
  func testCanAuthenticate() {
    describe("Given BioMetricAuthenticator") {
      context("When 获取BioMetricAuthenticator.canAuthenticate") {
        let result = BioMetricAuthenticator.canAuthenticate
        it("Then 返回false") {
          expect(result).toNot(beTrue())
        }
      }
    }
  }
  
  func testAuthenticateWithBioMetrics() {
    describe("Given reason: 没有") {
      let reason = "没有"
      context("When 调用BioMetricAuthenticator.authenticateWithBioMetrics") {
        it("Then 不会闪退") {
          BioMetricAuthenticator.authenticateWithBioMetrics(reason: reason) { (_) in
            expect(true).to(beTrue())
          }
        }
      }
    }
  }
  
  func testAuthenticateWithPasscode() {
    describe("Given reason: 没有") {
      let reason = "没有"
      context("When 调用BioMetricAuthenticator.authenticateWithPasscode") {
        BioMetricAuthenticator.authenticateWithPasscode(reason: reason) { (_) in
          it("Then 不会闪退") {
            expect(true).to(beTrue())
          }
        }
      }
    }
  }
  
  func testIsFaceIDAvailable() {
    describe("Given 在mac环境下") {
      context("When 调用BioMetricAuthenticator.shared.isFaceIDAvailable") {
        let isFaceIDAvailable = BioMetricAuthenticator.shared.isFaceIDAvailable
        it("Then 返回false") {
          expect(isFaceIDAvailable).toNot(beTrue())
        }
      }
    }
  }
  
  func testIsTouchIDAvailable() {
    describe("Given 在mac环境下") {
      context("When 调用BioMetricAuthenticator.shared.isTouchIDAvailable") {
        let isTouchIDAvailable = BioMetricAuthenticator.shared.isTouchIDAvailable
        it("Then 返回false") {
          expect(isTouchIDAvailable).toNot(beTrue())
        }
      }
    }
  }
}
