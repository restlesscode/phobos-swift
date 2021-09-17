//
//
//  PBSNetworkServiceTest.swift
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
import OHHTTPStubs
import PhobosSwiftCore
import Quick

class PBSNetworkServiceTest: QuickSpec {
  override func spec() {
    afterSuite {
      HTTPStubs.removeAllStubs()
      NSLog("Come in afterSuite")
    }

    testNetworkServiceRequest()
  }

  func testNetworkServiceRequest() {
    describe("Given 提供NetworkService及相应Endpoint") {
      let networkService = PBSNetworkServiceImpl()
      let parameters = Model.UrlParameters(page: 1, size: 10)
      let endPoint = EndPoint.test(parameters: parameters)

      context("When 调用Request") {
        let resultObservable: AnyPromisable<Model> = networkService.request(endPoint: endPoint)
        waitUntil(timeout: .seconds(30)) { done in
          resultObservable.then { result in
            switch result {
            case let .success(model):
              it("Then 调用接口成功") {
                expect(model).toNot(beNil())
              }
            case let .failure(error):
              NSLog("error = \(error.localizedDescription)")
              it("调用接口失败") {
                expect(false).to(beTrue())
              }
            }
            done()
          }
        }
      }
    }
  }

  enum Gateway: PBSGateway {
    case test

    var domain: String { "https://www.test.com" }

    var routePath: String { "/bff/v1" }

    var headers: PBSNetwork.APIRequest.Headers? { [:] }
  }

  enum EndPoint: PBSEndPoint {
    case test(parameters: Model.UrlParameters)

    var gateway: PBSGateway {
      Gateway.test
    }

    var path: String {
      switch self {
      case .test:
        return gateway.replaceVersion(old: "v1", new: "v2") + "/test"
      }
    }

    var parameters: PBSNetwork.APIRequest.Parameters? {
      switch self {
      case let .test(parameters):
        return parameters.pbs_dictionary
      }
    }
  }

  struct Model: Decodable {
    let errorcode: String
    let errormsg: String

    struct UrlParameters: Encodable {
      let page: Int
      let size: Int

      init(page: Int, size: Int) {
        self.page = page
        self.size = size
        interceptRequest()
      }

      func interceptRequest() {
        HTTPStubs.stubRequests { request -> Bool in
          request.url?.host == "www.test.com"
        } withStubResponse: { _ -> HTTPStubsResponse in
          HTTPStubsResponse(jsonObject: ["errorcode": "0", "errormsg": "success"], statusCode: 200, headers: nil)
        }
      }
    }

    struct RequestBody {}
  }
}
