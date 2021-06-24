//
//
//  AuthenticatorTest.swift
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
import RxSwift

class AuthenticatorTest: QuickSpec {
  let disposeBag = DisposeBag()
  override func spec() {
    testValidToken()
    testRefreshToken()
    testPerformAuthenticateRequest()
    testPerformRequest()
  }

  func testValidToken() {
    describe("Given PBSNetwork.Authenticator初始化成功") {
      context("When 调用PBSNetwork.Authenticator.shared.validToken") {
        let token = PBSNetwork.Authenticator.shared.validToken()
        waitUntil(timeout: .seconds(10)) { done in
          token.skip(1).subscribe { _ in
            it("不会闪退") {
              expect(true).to(beTrue())
            }
            done()
          }.disposed(by: self.disposeBag)
        }
      }
    }
  }

  func testRefreshToken() {
    describe("Given PBSNetwork.Authenticator初始化成功") {
      context("When 调用PBSNetwork.Authenticator.shared.refreshToken") {
        let token = PBSNetwork.Authenticator.shared.refreshToken()
        waitUntil(timeout: .seconds(10)) { done in
          token.skip(1).subscribe { _ in
            it("不会闪退") {
              expect(true).to(beTrue())
            }
            done()
          }.disposed(by: self.disposeBag)
        }
      }
    }
  }

  func testPerformAuthenticateRequest() {
    describe("Given 提供调用同花顺的网址及对应参数") {
      let model = APIRequestModel()
      context("When 调用PBSNetwork.NetworkManager.shared.performAuthenticateRequest") {
        let response: Observable<PBSNetwork.APIRequest.Response> = PBSNetwork.NetworkManager.shared.performAuthenticateRequest(method: model.method, url: model.url as! String, body: model.parameters, encoding: model.encoding, headers: model.headers)

        waitUntil(timeout: .seconds(30)) { done in
          response.skip(1).subscribe { _ in
            it("不会闪退") {
              expect(true).to(beTrue())
            }
            done()
          }.disposed(by: self.disposeBag)
        }
      }
    }
  }

  func testPerformRequest() {
    describe("Given 提供调用同花顺的网址及对应参数") {
      let model = APIRequestModel()
      context("When 调用PBSNetwork.APIRequest.performRequest") {
        let response: Observable<PBSNetwork.APIRequest.Response> = PBSNetwork.APIRequest.performRequest(method: model.method, url: model.url as! String, body: model.parameters, encoding: model.encoding, headers: model.headers)

        waitUntil(timeout: .seconds(30)) { done in
          response.skip(1).subscribe { _ in
            it("不会闪退") {
              expect(true).to(beTrue())
            }
            done()
          }.disposed(by: self.disposeBag)
        }
      }
    }
  }
}
