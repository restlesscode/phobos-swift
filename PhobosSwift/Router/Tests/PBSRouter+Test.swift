//
//
//  PBSRouter+Test.swift
//  PhobosSwiftRouter
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
import Foundation
import XCTest

/// Test the enhanced features of Bundle class is implemented in this extension
class RouterTest: XCTestCase {
  let router = PBSRouter.default

  override func setUp() {
    super.setUp()

    router.configure()
    router.register("testURL/HelloViewController") { url, _, _ -> UIViewController? in
      print(url.urlStringValue == "testURL/HelloViewController")
      print(url.urlStringValue)
      XCTAssertEqual(url.urlStringValue, "testURL/HelloViewController")
      return UIViewController()
    }

    router.register("testURL/HelloViewController/<string:id>") { _, values, _ -> UIViewController? in
      XCTAssertEqual(values["id"] as? String, "this-is-string-id")
      return UIViewController()
    }

    router.register("testURL/HelloViewController2/<int:id>") { _, values, _ -> UIViewController? in
      XCTAssertEqual(values["id"] as? Int, 123_456)
      return UIViewController()
    }
  }

  override func tearDown() {
    super.tearDown()
  }

  func testURLSchemeSetupInPresent() {
    router.present("testURL/HelloViewController")
  }

  func testURLSchemeSetupInPush() {
    router.show("testURL/HelloViewController")
  }

  func testURLSchemeSetupInOpen() {
    router.open("testURL/HelloViewController")
  }

  /// 测试Values在Present ViewController中的传递
  func testValuesPassingInPresent() {
    router.present("testURL/HelloViewController/this-is-string-id")
    router.present("testURL/HelloViewController2/123456")
  }

  /// 测试Values在Push ViewController中的传递
  func testValuesPassingInPush() {
    router.show("testURL/HelloViewController/this-is-string-id")
    router.show("testURL/HelloViewController2/123456")
  }

  /// 测试Values在Open Url中的传递
  func testValuesPassingInOpen() {
    router.open("testURL/HelloViewController/this-is-string-id")
    router.open("testURL/HelloViewController2/123456")
  }
}
