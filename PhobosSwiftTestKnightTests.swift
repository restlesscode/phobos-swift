//
//
//  PhobosSwiftTestKnightTests.swift
//  PhobosSwiftTestKnight-Unit-Tests
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


@testable import PhobosSwiftTestKnight
import Nimble
import PhobosSwiftCore
import Quick

class PhobosSwiftTestKnightSpec: QuickSpec {
  
  override func spec() {
    testBundleInit()
    testBundleName()
    testLocalizedString()
    testTkStringExtension()
    testTkObject()
    testTkString()
    testTkArray()
    testTkDictionary()
    testTkData()
    testTkStringArray()
    testTkInteger()
    testTkFloat()
    testTkDouble()
    testTkBool()
    testTkUrl()
    testTkRemoveObject()
  }
  
  func testBundleInit() {
    describe("Given 已知本模块PhobosSwiftTestKnight") {
      context("When 调用Bundle.bundle获取本模块Bundle") {
        let bundle = Bundle.bundle

        it("Then 返回bundle的 为 PhobosSwiftTestKnight") {
          expect(bundle.bundlePath).to(equal("\(PhobosSwiftTestKnight.self)"))
        }
      }
    }
  }
  
  func testBundleName() {
    describe("Given 已知本模块Bundle") {
      context("When 调用bundleName获取本模块bundleName") {
        let bundleName = Bundle.bundleName

        it("Then 返回bundleName的 为 PhobosSwiftTestKnight") {
          expect(bundleName).to(equal("PhobosSwiftTestKnight"))
        }
      }
    }
  }
  
  func testLocalizedString() {
    describe("Given a String") {
      let testString = "test String"
      context("When 调用localized") {
        let localizedString = testString.localized
        it("Then 返回localized string") {
          expect(localizedString).to(equal("testString"))
        }
      }
    }
  }
  
  func testTkStringExtension() {
    describe("Given a String") {
      let testString = "Test"
      context("When 调用tkString") {
        let tkString = testString.pbs.tkString
        it("Then 返回tkString") {
          expect(tkString).to(equal("Development.Test"))
        }
      }
    }
  }
  
  func testTkObject() {
    describe("Given UserDefaults存储一个空object") {
      let key = "testKey"
      UserDefaults.standard.tk_set(nil, forKey: key)
      context("When 调用tk_object获取object") {
        let model = UserDefaults.standard.tk_object(forKey: key)
        it("Then 返回object为nil") {
          expect(model).to(beNil())
        }
      }
    }
  }
  
  func testTkString() {
    describe("Given UserDefaults存储一个String") {
      let key = "testKey"
      let expectString = "TestString"
      UserDefaults.standard.tk_set(expectString, forKey: key)
      context("When 调用tk_string获取string") {
        let string = UserDefaults.standard.tk_string(forKey: key)
        it("Then 返回string 为TestString") {
          expect(string).to(equal(expectString))
        }
      }
    }
  }
  
  func testTkArray() {
    describe("Given UserDefaults存储一个Array") {
      let key = "testKey"
      let expectArray: [Int] = [1, 2, 3]
      UserDefaults.standard.tk_set(expectArray, forKey: key)
      context("When 调用tk_array获取object") {
        let array = UserDefaults.standard.tk_array(forKey: key) as? [Int]
        it("Then 返回Array 为expectArray") {
          expect(array).to(equal(expectArray))
        }
      }
    }
  }
  
  func testTkDictionary() {
    describe("Given UserDefaults存储一个Dict") {
      let key = "testKey"
      let expectDict: [String: Any]? = ["One": 1, "Two": 2,"Three": 3]
      UserDefaults.standard.tk_set(expectDict, forKey: key)
      context("When 调用tk_dictionary获取dict") {
         let dict = UserDefaults.standard.tk_dictionary(forKey: key)
        it("Then 返回Dict为expectDict") {
          expect(dict?.count).to(equal(3))
        }
      }
    }
  }
  
  func testTkData() {
    describe("Given UserDefaults存储一个Data") {
      let key = "testKey"
      let expectData = Data(count: 10)
      UserDefaults.standard.tk_set(expectData, forKey: key)
      context("When 调用tk_data获取data") {
         let data = UserDefaults.standard.tk_data(forKey: key)
        it("Then 返回data为expectData") {
          expect(data?.count).to(equal(10))
        }
      }
    }
  }
  
  func testTkStringArray() {
    describe("Given UserDefaults存储一个String Array") {
      let key = "testKey"
      let expectStringArray: [String] = ["One", "Two", "Three"]
      UserDefaults.standard.tk_set(expectStringArray, forKey: key)
      context("When 调用tk_stringArray获取string array") {
         let stringArray = UserDefaults.standard.tk_stringArray(forKey: key)
        it("Then 返回stringArray为expectStringArray") {
          expect(stringArray).to(equal(expectStringArray))
        }
      }
    }
  }
  
  func testTkInteger() {
    describe("Given UserDefaults存储一个Int") {
      let key = "testKey"
      let expectInt = 2222
      UserDefaults.standard.tk_set(expectInt, forKey: key)
      context("When 调用tk_integer获取Int") {
         let intValue = UserDefaults.standard.tk_integer(forKey: key)
        it("Then 返回intValue为expectInt") {
          expect(intValue).to(equal(expectInt))
        }
      }
    }
  }
  
  func testTkFloat() {
    describe("Given UserDefaults存储一个Float") {
      let key = "testKey"
      let expectFloat: Float = 2222.2222
      UserDefaults.standard.tk_set(expectFloat, forKey: key)
      context("When 调用tk_float获取float") {
         let floatValue = UserDefaults.standard.tk_float(forKey: key)
        it("Then 返回float为expectFloat") {
          expect(floatValue).to(equal(expectFloat))
        }
      }
    }
  }
  
  func testTkDouble() {
    describe("Given UserDefaults存储一个Double") {
      let key = "testKey"
      let expectDouble: Double = 3333.3333
      UserDefaults.standard.tk_set(expectDouble, forKey: key)
      context("When 调用tk_double获取double") {
         let doubleValue = UserDefaults.standard.tk_double(forKey: key)
        it("Then 返回double为doubleValue") {
          expect(doubleValue).to(equal(expectDouble))
        }
      }
    }
  }
  
  func testTkBool() {
    describe("Given UserDefaults存储一个Bool") {
      let key = "testKey"
      let expectBool: Bool = false
      UserDefaults.standard.tk_set(expectBool, forKey: key)
      context("When 调用tk_bool获取bool") {
         let boolValue = UserDefaults.standard.tk_bool(forKey: key)
        it("Then 返回boolValue为expectBool") {
          expect(boolValue).to(equal(expectBool))
        }
      }
    }
  }
  
  func testTkUrl() {
    describe("Given UserDefaults存储一个URL") {
      let key = "testKey"
      let expectURL: URL = URL(string: "testURL")!
      UserDefaults.standard.tk_set(expectURL, forKey: key)
      context("When 调用tk_url获取url") {
         let url = UserDefaults.standard.tk_url(forKey: key)
        it("Then 返回url为expectURL") {
          expect(url).to(equal(expectURL))
        }
      }
    }
  }
  
  func testTkRemoveObject() {
    describe("Given UserDefaults存储一个String") {
      let key = "testKey"
      let expectString: String = "111"
      UserDefaults.standard.tk_set(expectString, forKey: key)
      context("When 调用tk_removeObject删除object") {
        UserDefaults.standard.tk_removeObject(forKey: key)
        let string = UserDefaults.standard.tk_string(forKey: key)
        it("Then 返回string为nil") {
          expect(string).to(beNil())
        }
      }
    }
  }
}

