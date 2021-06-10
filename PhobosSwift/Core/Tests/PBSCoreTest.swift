//
//
//  Test.swift
//  PhobosSwiftCore
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

class PBSCoreTest: QuickSpec {
  let core = PBSCore.shared

  override func spec() {
    testCheckInternalVersion()
  }
  
  func testCheckInternalVersion() {
    describe("Given PBSCore inited") {
      let expectPreviousVersion = PBSVersion(major: 0, minor: 0, patch: 0)
      let expectCurrentVersion = PBSVersion(major: 0, minor: 1, patch: 0)
      
      context("When 调用PBSCore.shared.checkInternalVersion") {
        core.checkInternalVersion { (isUpgraded, previousVersion, currentVersion) in
          it("Then isUpgraded为true") {
            expect(isUpgraded).to(beTrue())
          }
          
          it("Then previousVersion、currentVersion为期望值") {
            expect(previousVersion == expectPreviousVersion).to(beTrue())
            expect(expectCurrentVersion == currentVersion).to(beTrue())
          }
        }
      }
      
      it("Then serviceInfo不为空") {
        expect(self.core.serviceInfo).toNot(beNil())
      }
    }
  }
}
