//
//
//  StringRegexTest.swift
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

class StringRegexTest: QuickSpec {
  override func spec() {
    testIsText()
    isValidPassword()
    testMatch()
  }
  
  func testIsText() {
    describe("Given 给定一系列参数") {
      let tuples = RegexTestModel().testTuples
      
      context("When 调用string.pbs.isText") {
        for tuple in tuples {
          let result = tuple.testValue.pbs.isText(ofRegexTypes: tuple.type, isEmptyAllowed: tuple.isEmptyAllowed)
          it("Then \(tuple.decribtion)验证返回true") {
            expect(result).to(beTrue())
          }
        }
      }
    }
  }
  
  func isValidPassword() {
    describe("Given 给定123456") {
      let password = "123456"
      
      context("When 调用string.pbs.isValidPassword") {
        let result = password.pbs.isValidPassword
        it("Then 返回true") {
          expect(result).to(beTrue())
        }
      }
    }
  }
  
  func testMatch() {
    describe("Given 给定正则[0-9]+，給定字符串12394") {
      let regular = "^[0-9]+$"
      let string = "12394"
      
      context("When 调用string.pbs.match") {
        let result = string.pbs.match(regular: regular)
        it("Then 返回true") {
          expect(result).to(beTrue())
        }
      }
    }
  }
}

struct RegexTestModel {
  let testTuples: [(type: RegularExpressionType, isEmptyAllowed: Bool, decribtion: String, testValue: String)] = [
    (type: .digit, isEmptyAllowed: false, decribtion: "数字", testValue: "1239"),
    (type: .englishLetter, isEmptyAllowed: false, decribtion: "英文", testValue: "hello"),
    (type: .chineseCharacter, isEmptyAllowed: false, decribtion: "中文", testValue: "中国"),
    (type: .email, isEmptyAllowed: false, decribtion: "邮箱", testValue: "xxxx@xxx.com"),
    (type: .chineseMobileNumber, isEmptyAllowed: false, decribtion: "中国合法手机号", testValue: "13888888888"),
    (type: .punctuation, isEmptyAllowed: false, decribtion: "标点符号", testValue: "，。；：“”‘’（）「」【】·～《》,")
  ]
}
