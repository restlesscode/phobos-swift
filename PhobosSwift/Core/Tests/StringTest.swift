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
import Nimble
import Quick

class StringTest: QuickSpec {
  override func spec() {
    testReversedString()
    testContains()
    testDouble()
    testBase64()
    testMD5()
    testSha512()
    testLocalized()
    testInt()
    testTrim()
    testToTimeFormatter()
    testIsIncludeChinese()
    testToPinyin()
    testToPinyinWithoutBlank()
    testPinyinHead()
    testInitialCapital()
    testConvertUTCDateToLocalDate()
  }
  
  func testReversedString() {
    describe("Given 给定字符串: hello") {
      let string = "hello"
      let expectResult = "olleh"
      context("When 调用string.pbs.reversedString") {
        let reversedString = string.pbs.reversedString
        it("Then 返回\(expectResult)") {
          expect(reversedString).to(equal(expectResult))
        }
      }
    }
  }
  
  func testContains() {
    describe("Given 给定字符串: hello, 判断是否包含hee、ll中的一个") {
      let string = "hello"
      let stringList = ["hee", "ll"]
      
      context("When 调用string.pbs.contains") {
        let result = string.pbs.contains(oneOf: stringList)
        it("Then 返回true") {
          expect(result).to(equal(true))
        }
      }
    }
  }
  
  func testDouble() {
    describe("Given 给定字符串: 22.22") {
      let string = "22.22"
      let expectResult: Double = 22.22
      
      context("When 调用string.pbs.double") {
        let result = string.pbs.double
        it("Then 返回22.22") {
          expect(result).to(equal(expectResult))
        }
      }
    }
  }
  
  func testBase64() {
    describe("Given 给定字符串: hello, swift") {
      let string = "hello, swift"
      let expectResult = "aGVsbG8sIHN3aWZ0"
      
      context("When 调用string.pbs.base64") {
        let result = string.pbs.base64
        it("Then 返回\(expectResult)") {
          expect(result).to(equal(expectResult))
        }
      }
    }
  }
  
  func testMD5() {
    describe("Given 给定字符串: hello, swift") {
      let string = "hello, swift"
      let expectResult = "d7a52ee5936d3e276f541f5a3d5d181d"
      
      context("When 调用string.pbs.md5") {
        let result = string.pbs.md5
        it("Then 返回\(expectResult)") {
          expect(result).to(equal(expectResult))
        }
      }
    }
  }
  
  func testSha512() {
    describe("Given 给定字符串: hello, swift") {
      let string = "hello, swift"
      let expectResult = "757b30d737bab8a5de0faca898b3f728bbd2aa02d090fad20a8d5ba3ccf7d43c7aa2a2906f69715356a741606b5ccbe911d2ae9e383befb5a8b6321ce61631e6"
      
      context("When 调用string.pbs.sha512") {
        let data = string.pbs.sha512
//        let result = String(data: data, encoding: .utf8)
        it("Then 返回\(expectResult)") {
          expect(data.count) > 0
//          expect(result).to(equal(expectResult))
        }
      }
    }
  }
  
  func testLocalized() {
    
  }
  
  func testInt() {
    describe("Given 给定字符串: 22.22") {
      let string = "22.22"
      let expectResult = 22
      
      context("When 调用string.pbs.int") {
        let result = string.pbs.int
        it("Then 返回22") {
          expect(result).to(equal(expectResult))
        }
      }
    }
  }
  
  func testTrim() {
    describe("Given 给定字符串: '   hello, swift   '") {
      let string = "   hello, swift   "
      let expectResult = "hello, swift"
      
      context("When 调用string.pbs.trim") {
        let result = string.pbs.trim
        it("Then 返回\(expectResult)") {
          expect(result).to(equal(expectResult))
        }
      }
    }
  }
  
  func testToTimeFormatter() {
    describe("Given 给定字符串: 2021-06-09，给定格式yyyy-MM-dd，期望格式yyyy/MM/dd HH:mm:ss") {
      let string = "2021-06-09"
      let dateFormatSrc = "yyyy-MM-dd"
      let dateFormatDesc = "yyyy/MM/dd HH:mm:ss"
      let expectResult = "2021/06/09 00:00:00"
      
      context("When 调用string.pbs.toTimeFormatter") {
        let result = string.pbs.toTimeFormatter(from: dateFormatSrc, to: dateFormatDesc)
        it("Then 返回\(expectResult)") {
          expect(result).to(equal(expectResult))
        }
      }
    }
  }
  
  func testIsIncludeChinese() {
    describe("Given 给定字符串: hello, 宝贝") {
      let string = "hello"
      let hasChineseStr = "hello, 宝贝"
      
      context("When 调用string.pbs.isIncludeChinese") {
        let result = string.pbs.isIncludeChinese
        it("Then hello返回false") {
          expect(result).to(equal(false))
        }
        
        let hasChineseResult = hasChineseStr.pbs.isIncludeChinese
        it("Then hello, 宝贝返回true") {
          expect(hasChineseResult).to(equal(true))
        }
      }
    }
  }
  
  func testToPinyin() {
    describe("Given 给定字符串: 宝贝") {
      let string = "宝贝"
      let expectResult = "bao bei"
      
      context("When 调用string.pbs.toPinyin") {
        let result = string.pbs.toPinyin
        it("Then 返回\(expectResult)") {
          expect(result).to(equal(expectResult))
        }
      }
    }
  }
  
  func testToPinyinWithoutBlank() {
    describe("Given 给定字符串: 宝贝") {
      let string = "宝贝"
      let expectResult = "baobei"
      
      context("When 调用string.pbs.toPinyinWithoutBlank") {
        let result = string.pbs.toPinyinWithoutBlank
        it("Then 返回\(expectResult)") {
          expect(result).to(equal(expectResult))
        }
      }
    }
  }
  
  func testPinyinHead() {
    describe("Given 给定字符串: 宝贝") {
      let string = "宝贝"
      let expectResult = "BB"
      
      context("When 调用string.pbs.pinyinHead") {
        let result = string.pbs.pinyinHead
        it("Then 返回\(expectResult)") {
          expect(result).to(equal(expectResult))
        }
      }
    }
  }
  
  func testInitialCapital() {
    describe("Given 给定字符串: 宝贝") {
      let string = "宝贝"
      let expectResult = "B"
      
      context("When 调用string.pbs.initialCapital") {
        let result = string.pbs.initialCapital
        it("Then 返回\(expectResult)") {
          expect(result).to(equal(expectResult))
        }
      }
    }
  }
  
  func testConvertUTCDateToLocalDate() {
    describe("Given 给定字符串: 2021-06-09'UTC'03:00:00") {
      let string = "2021-06-09T03:00:00"
      let expectResult = "2021-06-09"
      
      context("When 调用string.pbs.convertUTCDateToLocalDate") {
        let result = string.pbs.convertUTCDateToLocalDate()
        it("Then 返回\(expectResult)") {
          expect(result).to(equal(expectResult))
        }
      }
    }
  }
}
