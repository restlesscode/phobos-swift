//
//
//  PBSCertificatePinnerTest.swift
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

class PBSCertificatePinnerTest: QuickSpec {
  override func spec() {
    testServerTrustEvaluator()
    testEvaluate()
  }

  func testServerTrustEvaluator() {
    describe("Given ServerTrustManager初始化完成, host: https://www.baidu.com") {
      let host = "https://www.baidu.com"
      let manager = PBSPinner.ServerTrustManager()
      context("When 调用serverTrustEvaluator") {
        _ = try? manager.serverTrustEvaluator(forHost: host)
        it("Then 不会闪退") {
          expect(true).to(beTrue())
        }
      }
    }
  }

  func testEvaluate() {
    describe("Given ServerTrustEvaluator初始化完成, host: https://www.baidu.com") {
      let host = "https://www.baidu.com"
      let manager = PBSPinner.ServerTrustManager()
      context("When 调用serverTrustEvaluator") {
        _ = try? manager.serverTrustEvaluator(forHost: host)
        it("Then 不会闪退") {
          expect(true).to(beTrue())
        }
      }
    }
  }
}
