@testable import PhobosSwiftLog
import Foundation
import XCTest

class PBSLogTest: XCTestCase {
  let log = PBSLog(identifier: "testIdentifier", level: .debug)

  override func setUp() {
    super.setUp()
    XCTAssertEqual(log.identifier, "testIdentifier")
    XCTAssertEqual(log.outputLevel, .debug)
  }

  override func tearDown() {
    super.tearDown()
  }

//  func testLogToFileWhenNotEnabled() {
//    log.debug("testLogToFileWhenNotEnabled", isToFile: true)
//  }
//
//  func testDonotLogToFileWhenEnabled() {
//    log.debug("testDonotLogToFileWhenEnabled", isToFile: false)
//  }
}
