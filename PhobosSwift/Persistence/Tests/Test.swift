//
//
//  Test.swift
//  PhobosSwiftPersistence
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

@testable import PhobosSwiftPersistence
import Foundation
import MirrorRealmSwift
import XCTest

/// Object representing a single flash card
@objcMembers class TestEntity: Object {
  // address dictionary properties
  dynamic var name: String? // eg. Apple Inc.

  override static func primaryKey() -> String? {
    "name"
  }
}

/// Test the enhanced features of Bundle class is implemented in this extension
class Test: XCTestCase {
  let testRealm = Realm.pbs.makeRealm(identifier: "test-realm", in: .memory)

  override func setUp() {
    super.setUp()
  }

  func test() {
    do {
      try testRealm?.write {
        let testEntity = TestEntity()
        testEntity.name = "PhobosSwift-Persisitence-Realm"
        testRealm?.add(testEntity, update: .modified)
      }
    } catch {
      XCTAssertNil(error)
    }

    let testModels = testRealm?.objects(TestEntity.self)

    XCTAssertEqual("PhobosSwift-Persisitence-Realm", testModels?.first?.name)
  }

  override func tearDown() {
    super.tearDown()
  }
}
