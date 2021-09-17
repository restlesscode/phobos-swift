//
//
//  Test.swift
//  PhobosSwiftTestKnight
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

@testable import PhobosSwiftTestKnight
import Nimble
import PhobosSwiftCore
import Quick

class PBSTestKnightSpec: QuickSpec {
  override func spec() {
    testPBSTestKnightInit()
    testPBSTestKnightConfigure()
  }

  func testPBSTestKnightInit() {
    describe("Given 已知本模块PBSTestKnight") {
      context("When 调用PBSTestKnight.shared 获取本模块") {
        let testKnight = PBSTestKnight.shared

        it("Then 返回的testKnight的configuration 为debug") {
          expect(testKnight.configuration).to(equal(.debug))
        }
      }
    }
  }

  func testPBSTestKnightConfigure() {
    describe("Given 已知PBSTestKnight") {
      let testKnight = PBSTestKnight.shared
      context("When 调用Configure方法") {
        let window = UIWindow()
        testKnight.configure(window: window) {
          it("Then 返回的window.rootViewController不能为空") {
            expect(window.rootViewController).notTo(beNil())
          }
        }
      }
    }
  }
}
