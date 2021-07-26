//
//
//  PBSRouterProtocolTest.swift
//  PhobosSwiftCore-Unit-Tests
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

@testable import PhobosSwiftRouter
import Nimble
import Quick

class PBSRouterProtocolTest: QuickSpec {
  override func spec() {
    testRouter()
  }

  func testRouter() {
    describe("Given PBSTestRouter遵循PBSRouterProtocol协议, 并注册至Navigator中") {
      PBSTestRouter.regist()
      context("When 实例化PBSTestRouter") {
        let testRouter = PBSTestRouter.test
        let expectUrlPattern = "PBSTestRouter/test"
        let parameters = 898_989_898

        NSLog("testRouter.pattern = \(testRouter.urlPattern)")

        it("Then testRouter.urlPattern为\(expectUrlPattern)") {
          expect(testRouter.urlPattern).to(equal(expectUrlPattern))
        }

        it("Then 取出的Controller中values与输入一致") {
          guard let viewController = PBSRouter.default.viewController(for: testRouter.urlPattern, context: parameters) as? PBSTestViewControllerSpy else {
            expect(false).to(beTrue())
            return
          }

          expect(viewController.values).to(equal(parameters))
        }
      }
    }
  }
}

enum PBSTestRouter: String, PBSRouterProtocol {
  case test

  var controller: UIViewController? {
    switch self {
    case .test:
      return PBSTestViewControllerSpy()
    }
  }
}

class PBSTestViewControllerSpy: UIViewController, PBSRouterViewController {
  var values: Int = 0
  func setContext(_ context: Any?) {
    guard let values = context as? Int else { return }
    self.values = values
  }
}
