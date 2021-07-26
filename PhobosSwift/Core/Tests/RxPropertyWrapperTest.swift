//
//
//  RxPropertyWrapperTest.swift
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
import RxSwift

class RxPropertyWrapperTest: QuickSpec {
  let testModel = RxPropertyWrapperTestModel()
  let disposeBag = DisposeBag()
  override func spec() {
    testRxBehaviorRelay()
    testRxPublishRelay()
    testRxPublishSubject()
    testRxBehaviorSubject()
  }

  func testRxBehaviorRelay() {
    describe("Given test model 使用了RxBehaviorRelay, 初始值为空") {
      context("When 订阅RxBehaviorRelay") {
        waitUntil(timeout: .seconds(3)) { done in
          let updateName = "hahahah"
          self.testModel.$name.skip(1).subscribe(onNext: { name in
            it("Then 监听到name变化为\(updateName)") {
              expect(name).to(equal(updateName))
            }
            done()
          }).disposed(by: self.disposeBag)
          self.testModel.$name.accept(updateName)
        }
      }
    }
  }

  func testRxPublishRelay() {
    describe("Given test model 使用了RxPublishRelay, 初始值为空") {
      context("When 订阅RxPublishRelay") {
        waitUntil(timeout: .seconds(3)) { done in
          let updateHeight: Float = 178
          self.testModel.$height.subscribe(onNext: { height in
            it("Then 监听到height变化为\(updateHeight)") {
              expect(height).to(equal(updateHeight))
            }
            done()
          }).disposed(by: self.disposeBag)
          self.testModel.$height.accept(updateHeight)
        }
      }
    }
  }

  func testRxPublishSubject() {
    describe("Given test model 使用了RxPublishSubject, 初始值为空") {
      context("When 订阅RxPublishSubject") {
        waitUntil(timeout: .seconds(3)) { done in
          let updateSex: String = "male"
          self.testModel.$sex.subscribe(onNext: { sex in
            it("Then 监听到sex变化为\(updateSex)") {
              expect(sex).to(equal(updateSex))
            }
            done()
          }).disposed(by: self.disposeBag)
          self.testModel.$sex.onNext(updateSex)
        }
      }
    }
  }

  func testRxBehaviorSubject() {
    describe("Given test model 使用了RxBehaviorSubject, 初始值为空") {
      context("When 订阅RxBehaviorSubject") {
        waitUntil(timeout: .seconds(3)) { done in
          let updateAge: Int = 20
          self.testModel.$age.skip(1).subscribe(onNext: { age in
            it("Then 监听到age变化为\(updateAge)") {
              expect(age).to(equal(updateAge))
            }
            done()
          }).disposed(by: self.disposeBag)
          self.testModel.$age.onNext(updateAge)
        }
      }
    }
  }
}

class RxPropertyWrapperTestModel {
  @RxBehaviorRelay(default: "") var name
  @RxPublishRelay var height: Float?
  @RxPublishSubject var sex: String?
  @RxBehaviorSubject(default: 18) var age
}
