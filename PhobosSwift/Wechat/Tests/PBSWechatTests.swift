//
//
//  PBSWechatTests.swift
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

@testable import PhobosSwiftWechat
import Nimble
import Quick

class PBSWechatSpec: QuickSpec {
  override func spec() {
    describe("Given 本模块PBSWechat") {
      let wechat = PBSWechat.shared
      let expectId = "testAppId"
      let expectUniversalLink = "testUniversalLink"
      context("When 调用confifure方法") {
        let result = wechat.configure(appId: expectId, universalLink: expectUniversalLink)

        it("Then 返回的结果为false") {
          expect(result).to(equal(false))
        }

        it("Then 返回的appId 为 expectId") {
          expect(wechat.appId).to(equal(expectId))
        }

        it("Then 返回的univeralLink 为 expectUniversalLink") {
          expect(wechat.universalLink).to(equal(expectUniversalLink))
        }
      }
    }
  }
}
