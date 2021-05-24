//
//  COBAlipayUnitTest.swift
//  BusinessUnitPayment-Unit-Tests
//
//  Created by Eric Wang on 2020/12/21.
//

@testable import CodebasePayment
import Nimble
import XCTest

class COBAlipayUnitTest: XCTestCase {
  let mockAppScheme: String = "AppScheme"
  let mockOrderString: String = "orderString"

  override class func setUp() {}

  override func setUpWithError() throws {
    super.setUpWithError()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDownWithError() throws {
    super.tearDownWithError()
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }

  func testExample() throws {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
  }

  //    func testPerformanceExample() throws {
  //        // This is an example of a performance test case.
  //        self.measure {
  //            // Put the code you want to measure the time of here.
  //        }
  //    }
  //
  func testConfigureAlipayError() throws {
    expect {
      COBAlipayPayment.shared.configure(withAppScheme: "")
    }
    .to(throwAssertion())
  }

  func testAppSchemeNotNil() {
    COBAlipayPayment.shared.configure(withAppScheme: mockAppScheme)
    expect {
      COBAlipayPayment.shared.appScheme
    }
    .notTo(beNil())
  }

  func testPayWithoutAppscheme() {
    expect {
      COBAlipayPayment.shared.pay(orderString: self.mockOrderString)
    }
    .to(throwAssertion())
  }

  func testPayNormal() {
    COBAlipayPayment.shared.configure(withAppScheme: mockAppScheme)
    expect {
      COBAlipayPayment.shared.pay(orderString: self.mockOrderString)
    }
    .toNot(throwAssertion())
  }

  func testGenerateResultDecodeError() {
    let mockCallbackResult = ["aaa": "bbb"]
    expect {
      COBAlipayPayment.shared.generateResult(withCallbackResult: mockCallbackResult)
    }
    .to(equal(Result<COBAlipayPayment.AlipayStatus, COBAlipayPayment.AlipayError>.failure(COBAlipayPayment.AlipayError.internaleFailed(reason: .alipayResultDecodeError))))
  }

  func testGenerateResultProcessError() {
    let mockCallbackResult = ["memo": "正在处理",
                              "result": "",
                              "resultStatus": "4000"]
    expect {
      COBAlipayPayment.shared.generateResult(withCallbackResult: mockCallbackResult)
    }
    .to(equal(Result<COBAlipayPayment.AlipayStatus, COBAlipayPayment.AlipayError>.failure(.alipayFailed(reason: .paymentProcessError))))
  }

  func testGenerateResultPaymentCancel() {
    let mockCallbackResult = ["memo": "正在处理",
                              "result": "",
                              "resultStatus": "6001"]
    expect {
      COBAlipayPayment.shared.generateResult(withCallbackResult: mockCallbackResult)
    }
    .to(equal(Result<COBAlipayPayment.AlipayStatus, COBAlipayPayment.AlipayError>.failure(.alipayFailed(reason: .paymentCancel))))
  }

  func testGenerateResultPaymentError() {
    let mockCallbackResult = ["memo": "正在处理",
                              "result": "",
                              "resultStatus": "10000"]
    expect {
      COBAlipayPayment.shared.generateResult(withCallbackResult: mockCallbackResult)
    }
    .to(equal(Result<COBAlipayPayment.AlipayStatus, COBAlipayPayment.AlipayError>.failure(.alipayFailed(reason: .paymentError))))
  }

  func testGenerateResultPaymentRepeat() {
    let mockCallbackResult = ["memo": "正在处理",
                              "result": "",
                              "resultStatus": "5000"]
    expect {
      COBAlipayPayment.shared.generateResult(withCallbackResult: mockCallbackResult)
    }
    .to(equal(Result<COBAlipayPayment.AlipayStatus, COBAlipayPayment.AlipayError>.failure(.alipayFailed(reason: .paymentRepeat))))
  }

  func testGenerateResultPaymentNetworkdown() {
    let mockCallbackResult = ["memo": "正在处理",
                              "result": "",
                              "resultStatus": "6002"]
    expect {
      COBAlipayPayment.shared.generateResult(withCallbackResult: mockCallbackResult)
    }
    .to(equal(Result<COBAlipayPayment.AlipayStatus, COBAlipayPayment.AlipayError>.failure(.alipayFailed(reason: .paymentNetworkDown))))
  }

  func testGenerateResultPaymentComplete() {
    let mockCallbackResult = ["memo": "正在处理",
                              "result": "",
                              "resultStatus": "9000"]
    expect {
      COBAlipayPayment.shared.generateResult(withCallbackResult: mockCallbackResult)
    }
    .to(equal(Result<COBAlipayPayment.AlipayStatus, COBAlipayPayment.AlipayError>.success(.complete)))
  }

  func testGenerateResultPaymentProcessing() {
    let mockCallbackResult = ["memo": "正在处理",
                              "result": "",
                              "resultStatus": "8000"]
    expect {
      COBAlipayPayment.shared.generateResult(withCallbackResult: mockCallbackResult)
    }
    .to(equal(Result<COBAlipayPayment.AlipayStatus, COBAlipayPayment.AlipayError>.success(.processing)))
  }

  func testGenerateResultPaymentKnown() {
    let mockCallbackResult = ["memo": "正在处理",
                              "result": "",
                              "resultStatus": "6004"]
    expect {
      COBAlipayPayment.shared.generateResult(withCallbackResult: mockCallbackResult)
    }
    .to(equal(Result<COBAlipayPayment.AlipayStatus, COBAlipayPayment.AlipayError>.success(.unknown)))
  }
}
