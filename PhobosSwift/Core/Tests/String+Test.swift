//
//
//  String+Test.swift
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
import Foundation
import XCTest

class StringTest: XCTestCase {
  override func setUp() {
    super.setUp()
  }

  override func tearDown() {
    super.tearDown()
  }

  func testRegex() {
    XCTAssertTrue("03323@smail.tongji.edu.cn".pbs_isText(ofRegexTypes: .email), "Email regex passed")
    XCTAssertTrue("theo.chen@me.7zip".pbs_isText(ofRegexTypes: .email), "Email regex passed")
    XCTAssertTrue("13148469712".pbs_isText(ofRegexTypes: .chineseMobileNumber), "Chinese mobile number regex passed")
    XCTAssertTrue("18273213211231213213".pbs_isText(ofRegexTypes: .digit), "Digital regex passed")
    XCTAssertTrue("世上只有妈妈好".pbs_isText(ofRegexTypes: .chineseCharacter), "Chinese regex passed")
    XCTAssertFalse("世上只 有妈妈 好".pbs_isText(ofRegexTypes: .chineseCharacter), "Chinese with space regex NOT passed")
    XCTAssertTrue("IloveiOS".pbs_isText(ofRegexTypes: .englishLetter), "English Letters regex passed")
    XCTAssertFalse("I love iOS".pbs_isText(ofRegexTypes: .englishLetter), "English Letters with space regex NOT passed")
    XCTAssertTrue("Ilove88912321iOS".pbs_isText(ofRegexTypes: [.englishLetter, .digit]), "English Letters and digits regex passed")
    XCTAssertTrue("Ilove88912321iOS".pbs_isText(ofRegexTypes: [.englishLetter, .digit]), "English Letters and digits regex passed")
    XCTAssertTrue("真光路1433弄5号1111室A座".pbs_isText(ofRegexTypes: [.englishLetter, .digit, .chineseCharacter]), "English Letters, Chinese characters and digits regex passed")
    XCTAssertFalse("真光路1433弄5号1111室A😊座".pbs_isText(ofRegexTypes: [.englishLetter, .digit, .chineseCharacter]), "emoji not passed")
    XCTAssertTrue("德国保时捷（上海）销售有限公司".pbs_isText(ofRegexTypes: [.chineseCharacter, .englishLetter, .digit, .punctuation]), "Company Title passed")
  }
}
