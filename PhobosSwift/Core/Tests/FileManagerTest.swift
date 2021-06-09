//
//
//  FileManagerTest.swift
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

@testable import PhobosSwiftCore
import Nimble
import Quick

class FileManagerTest: QuickSpec {
  override func spec() {
    testPathInLibrary()
    testPathInDocuments()
    testPathInBundle()
    testUserDocumentsUrl()
    testUserLibraryUrl()
  }

  func testPathInLibrary() {
    describe("Given 在测试环境中") {
      let fileName = "test"
      let fileExtension = ".jpg"
      context("When 调用FileManager.pbs.path") {
        let fileUrl = FileManager.pbs.path(inLibrary: fileName, withExtension: fileExtension)
        it("Then 返回结果不能为空") {
          expect(fileUrl?.absoluteString).toNot(beNil())
        }
      }
    }
  }

  func testPathInDocuments() {
    describe("Given 在测试环境中") {
      let fileName = "test"
      let fileExtension = ".jpg"
      context("When 调用FileManager.pbs.path") {
        let fileUrl = FileManager.pbs.path(inDocuments: fileName, withExtension: fileExtension)
        it("Then 返回结果不能为空") {
          expect(fileUrl?.absoluteString).toNot(beNil())
        }
      }
    }
  }

  func testPathInBundle() {
    describe("Given 在测试环境中，.main bundle不存在") {
      let fileName = "test"
      let fileExtension = ".jpg"
      context("When 调用FileManager.pbs.path") {
        let fileUrl = FileManager.pbs.path(name: fileName, withExtension: fileExtension)
        it("Then 返回结果为空") {
          expect(fileUrl?.absoluteString).to(beNil())
        }
      }
    }
  }

  func testUserDocumentsUrl() {
    describe("Given 在测试环境中") {
      context("When 调用FileManager.pbs.userDocumentsUrl") {
        let userDocumentsUrl = FileManager.pbs.userDocumentsUrl
        it("Then 返回结果不能为空") {
          expect(userDocumentsUrl?.absoluteString).toNot(beNil())
        }
      }
    }
  }

  func testUserLibraryUrl() {
    describe("Given 在测试环境中") {
      context("When 调用FileManager.pbs.userLibraryUrl") {
        let userLibraryUrl = FileManager.pbs.userLibraryUrl
        it("Then 返回结果不能为空") {
          expect(userLibraryUrl?.absoluteString).toNot(beNil())
        }
      }
    }
  }
}
