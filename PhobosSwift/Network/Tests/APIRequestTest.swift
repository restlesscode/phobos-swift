//
//
//  APIRequestTest.swift
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
import Alamofire
import Nimble
import OHHTTPStubs
import PhobosSwiftCore
import Quick

class APIRequestTest: QuickSpec {
  override func spec() {
//    beforeSuite {
//      self.interceptRequest()
//    }
    afterSuite {
      HTTPStubs.removeAllStubs()
      NSLog("Come in afterSuite")
    }

    testRequest()
    testGet()
    testPost()
    testPut()
    testDownloadRequest()
    testDownloadDataRequest()
  }

  func testRequest() {
    describe("Given 提供调用同花顺的网址及对应参数") {
      var model = APIRequestModel()
      model.encoding = URLEncoding.default
      context("When 调用PBSNetwork.APIRequest.request") {
        let promisable: PBSPromisable<Result<APIRequestResponse, Error>> = PBSNetwork.APIRequest.request(model.url, method: model.method, parameters: model.parameters, encoding: model.encoding, headers: model.headers, session: model.session)

        waitUntil(timeout: .seconds(30)) { done in
          promisable.then { (result: Result<APIRequestResponse, Error>) in
            self.checkResponese(result: result)
            done()
          }
        }
      }
    }

    describe("Given 提供调用同花顺的网址及对应参数-ModelResponse") {
      var model = APIRequestModel()
      model.encoding = URLEncoding.default
      typealias ModelResponse = PBSNetwork.APIRequest.ModelResponse
      context("When 调用PBSNetwork.APIRequest.request") {
        let promisable: PBSPromisable<Result<ModelResponse<APIRequestResponse>, Error>> = PBSNetwork.APIRequest.request(model.url, method: model.method, parameters: model.parameters, encoding: model.encoding, headers: model.headers, session: model.session)

        waitUntil(timeout: .seconds(30)) { done in
          promisable.then { (result: Result<ModelResponse<APIRequestResponse>, Error>) in
            var expectResult: Result<APIRequestResponse, Error>
            switch result {
            case let .success(response):
              expectResult = .success(response.model)
            case let .failure(error):
              expectResult = .failure(error)
            }
            self.checkResponese(result: expectResult)
            done()
          }
        }
      }
    }

    describe("Given 提供调用同花顺的网址及对应参数") {
      var model = APIRequestModel()
      model.encoding = URLEncoding.default
      context("When 调用PBSNetwork.APIRequest.request") {
        let promisable: PBSPromisable<Result<AFDataResponse<Data>, Error>> = PBSNetwork.APIRequest.request(model.url, method: model.method, parameters: model.parameters, encoding: model.encoding, headers: model.headers, session: model.session)

        waitUntil(timeout: .seconds(30)) { done in
          promisable.then { (result: Result<AFDataResponse<Data>, Error>) in
            switch result {
            case let .success(response):
              it("Then 调用接口成功") {
                expect(response).toNot(beNil())
              }
            case let .failure(error):
              it("Then 调用接口失败\(error.localizedDescription)") {
                expect(false).to(beTrue())
              }
            }
            done()
          }
        }
      }
    }

    describe("Given 提供调用同花顺的网址及对应参数") {
      var model = APIRequestModel()
      model.encoding = URLEncoding.default

      context("When 调用PBSNetwork.APIRequest.request") {
        let promisable: PBSPromisable<Result<PBSNetwork.APIRequest.Response, Error>> = PBSNetwork.APIRequest.request(model.url, method: model.method, parameters: model.parameters, encoding: model.encoding, headers: model.headers, session: model.session)

        waitUntil(timeout: .seconds(30)) { done in
          promisable.then { (result: Result<PBSNetwork.APIRequest.Response, Error>) in
            switch result {
            case let .success(response):
              it("Then 调用接口成功") {
                expect(response).toNot(beNil())
              }
            case let .failure(error):
              it("Then 调用接口失败\(error.localizedDescription)") {
                expect(false).to(beTrue())
              }
            }
            done()
          }
        }
      }
    }
  }

  func testGet() {
    describe("Given 提供调用同花顺的网址及对应参数") {
      var model = APIRequestModel()
      model.encoding = URLEncoding.default
      context("When 调用PBSNetwork.APIRequest.get") {
        let promisable: PBSPromisable<Result<APIRequestResponse, Error>> = PBSNetwork.APIRequest.get(model.url, parameters: model.parameters, encoding: model.encoding, headers: model.headers, session: model.session)

        waitUntil(timeout: .seconds(30)) { done in
          promisable.then { (result: Result<APIRequestResponse, Error>) in
            self.checkResponese(result: result)
            done()
          }
        }
      }
    }
  }

  func testPost() {
    describe("Given 提供调用同花顺的网址及对应参数") {
      let model = APIRequestModel()
      context("When 调用PBSNetwork.APIRequest.post") {
        let promisable: PBSPromisable<Result<APIRequestResponse, Error>> = PBSNetwork.APIRequest.post(model.url, parameters: model.parameters, encoding: model.encoding, headers: model.headers, session: model.session)

        waitUntil(timeout: .seconds(30)) { done in
          promisable.then { (result: Result<APIRequestResponse, Error>) in
            self.checkResponese(result: result)
            done()
          }
        }
      }
    }
  }

  func testPut() {
    describe("Given 提供调用同花顺的网址及对应参数") {
      let model = APIRequestModel()
      context("When 调用PBSNetwork.APIRequest.put") {
        let promisable: PBSPromisable<Result<APIRequestResponse, Error>> = PBSNetwork.APIRequest.put(model.url, parameters: model.parameters, encoding: model.encoding, headers: model.headers, session: model.session)

        waitUntil(timeout: .seconds(30)) { done in
          promisable.then { (result: Result<APIRequestResponse, Error>) in
            self.checkResponese(result: result)
            done()
          }
        }
      }
    }
  }

  func testDownloadRequest() {
    describe("Given 提供调用同花顺的网址及对应参数") {
      let model = APIRequestModel()
      context("When 调用PBSNetwork.APIRequest.downloadRequest") {
        let promisable: PBSPromisable<Result<DownloadResponse, Error>> = PBSNetwork.APIRequest.downloadRequest(url: URL(string: model.url as! String)!)

        waitUntil(timeout: .seconds(30)) { done in
          promisable.then { (_: Result<DownloadResponse, Error>) in
            it("Then 接口调用成功") {
              expect(true).to(beTrue())
            }
            done()
          }
        }
      }
    }
  }

  func testDownloadDataRequest() {
    describe("Given 提供调用同花顺的网址及对应参数") {
      let model = APIRequestModel()
      context("When 调用PBSNetwork.APIRequest.downloadRequest") {
        let promisable: PBSPromisable<Result<AFDownloadResponse<Data>, Error>> = PBSNetwork.APIRequest.downloadDataRequest(url: URL(string: model.url as! String)!)

        waitUntil(timeout: .seconds(30)) { done in
          promisable.then { (_: Result<AFDownloadResponse<Data>, Error>) in
            it("Then 接口调用成功") {
              expect(true).to(beTrue())
            }
            done()
          }
        }
      }
    }
  }

  func checkResponese(result: Result<APIRequestResponse, Error>) {
    switch result {
    case let .success(model):
      if model.errorcode == "0" {
        it("Then 接口调用成功") {
          expect(true).to(beTrue())
        }
      } else {
        it("Then 接口调用失败, \(model.errormsg)") {
          expect(false).to(beTrue())
        }
      }
    case let .failure(error):
      NSLog("request error: \(error.localizedDescription)")
      it("Then 接口调用失败, \(error.localizedDescription)") {
        expect(false).to(beTrue())
      }
    }
  }
}

struct APIRequestModel {
  var url: URLConvertible = "https://www.test.com"
  var method: HTTPMethod = .get
  var parameters: Parameters? = ["id": "0001"]
  var encoding: ParameterEncoding = JSONEncoding.default
  var headers: PBSNetwork.APIRequest.Headers = ["Content-Type": "application/json"]
  var session = Session.pbs.insecure

  init() {
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

struct APIRequestResponse: Codable {
  let errorcode: String
  let errormsg: String
}
