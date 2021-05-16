//
//
//  PhobosSwiftNetwork+Test.swift
//  PhobosSwiftNetwork
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

@testable import PhobosSwiftLog
@testable import PhobosSwiftNetwork
import Foundation
import XCTest

struct ConceptDetail: Codable {
  let title: String
  let body: String

  enum CodingKeys: String, CodingKey {
    case title
    case body = "long"
  }
}

struct ConceptDetailResponse: Codable {
  let errorCode: String
  let errorMsg: String
  let conceptDetails: [ConceptDetail]

  enum CodingKeys: String, CodingKey {
    case errorCode = "errorcode"
    case errorMsg = "errormsg"
    case conceptDetails = "data"
  }
}

/// Test the enhanced features of Bundle class is implemented in this extension
class NetworkTest: XCTestCase {
  override func setUp() {
    super.setUp()
  }

  override func tearDown() {
    super.tearDown()
  }

  func test() {
    let expectation = XCTestExpectation(description: "获取同花顺的股票概念")

    let url = "https://basic.10jqka.com.cn/api/stockph/conceptdetail/000151/"
    PBSNetwork.APIRequest.get(url).then(onResolved: { (result: Result<ConceptDetailResponse, Error>) in
      switch result {
      case let .success(response):
        let titles = response.conceptDetails.compactMap {
          "\($0.title) \n \($0.body)"
        }

        PBSLogger.shared.debug(message: titles.first ?? "", context: "Test")
        XCTAssertFalse(titles.isEmpty)

        expectation.fulfill()
        expectation.fulfill()
      case let .failure(error):
        debugPrint(error)
        expectation.fulfill()
      }
    })
    wait(for: [expectation], timeout: 30)
  }
}
