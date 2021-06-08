//
//
//  CodableTest.swift
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

class CodableTest: QuickSpec {
  let testModel = CodableTestModel()

  override func spec() {
    testJsonStringInJSONSerialization()
    testJsonStringInEncodable()
    testModelInString()
    testModelInData()
    testJsonStringInDictionary()
    testModelInDictionary()
  }

  func testJsonStringInJSONSerialization() {
    describe("Given 有一个字典为\(testModel.dictionary)") {
      let dictionary = testModel.dictionary

      context("When 调用JSONSerialization.pbs.jsonString") {
        var jsonString = JSONSerialization.pbs.jsonString(fromDictionary: dictionary)
        jsonString = jsonString?.replacingOccurrences(of: "\n", with: "")
        jsonString = jsonString?.replacingOccurrences(of: " ", with: "")
        it("Then 返回的结果须为\(testModel.jsonString)") {
          expect(jsonString?.sorted()).to(equal(self.testModel.jsonString.sorted()))
        }
      }
    }
  }

  func testJsonStringInEncodable() {
    describe("Given 有一个模型为\(testModel.model)") {
      let model = testModel.model

      context("When 调用模型的pbs_jsonString") {
        let jsonString = model.pbs_jsonString
        it("Then 返回的结果须为\(testModel.jsonString)") {
          expect(jsonString?.sorted()).to(equal(self.testModel.jsonString.sorted()))
        }
      }
    }
  }

  func testModelInString() {
    describe("Given 有一个JSON字符串为\(testModel.jsonString)") {
      let jsonString = testModel.jsonString

      context("When 调用字符串的pbs.model") {
        let model: Person? = jsonString.pbs.model()
        it("Then 返回的结果须为\(testModel.model)") {
          expect(model).to(equal(self.testModel.model))
        }
      }
    }
  }

  func testModelInData() {
    describe("Given 有一个Data") {
      let data = testModel.data

      context("When 调用Data的pbs.model") {
        let model: Person? = data?.pbs.model()
        it("Then 返回的结果须为\(testModel.model)") {
          expect(model).to(equal(self.testModel.model))
        }
      }
    }
  }

  func testJsonStringInDictionary() {
    describe("Given 有一个字典为\(testModel.dictionary)") {
      let dictionary = testModel.dictionary

      context("When 调用Dictionary的pbs.jsonString") {
        let jsonString = dictionary.pbs.jsonString
        it("Then 返回的结果须为\(testModel.jsonString)") {
          expect(jsonString?.sorted()).to(equal(self.testModel.jsonString.sorted()))
        }
      }
    }
  }

  func testModelInDictionary() {
    describe("Given 有一个字典为\(testModel.dictionary)") {
      let dictionary = testModel.dictionary

      context("When 调用Dictionary的pbs.model") {
        let model: Person? = dictionary.pbs.model()
        it("Then 返回的结果须为\(testModel.model)") {
          expect(model).to(equal(self.testModel.model))
        }
      }
    }
  }
}

struct CodableTestModel {
  let jsonString = "{\"name\":\"Photos\",\"age\":18,\"weight\":70,\"height\":180,\"gender\":\"male\"}"
  let model = Person(name: "Photos", age: 18, weight: 70, height: 180, gender: .male)
  let dictionary: [AnyHashable: Any] = ["name": "Photos", "age": 18, "weight": 70, "height": 180, "gender": "male"]
  var data: Data? {
    jsonString.data(using: .utf8)
  }
}

struct Person: Codable, Equatable {
  let name: String
  let age: Int
  let weight: Int
  let height: Int
  let gender: Gender

  enum Gender: String, Codable {
    case male
    case female
  }
}
