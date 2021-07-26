//
//
//  RxPropertyWrapper.swift
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

import RxCocoa
import RxSwift

@propertyWrapper
public struct RxBehaviorRelay<Value> {
  private let relay: BehaviorRelay<Value>
  public init(default value: Value) {
    relay = .init(value: value)
  }

  public var wrappedValue: Value {
    relay.value
  }

  public var projectedValue: BehaviorRelay<Value> {
    relay
  }
}

@propertyWrapper
public struct RxPublishRelay<Value> {
  private let relay: PublishRelay<Value>
  public init() {
    relay = .init()
  }

  public var wrappedValue: Value? {
    nil
  }

  public var projectedValue: PublishRelay<Value> {
    relay
  }
}

@propertyWrapper
public struct RxPublishSubject<Value> {
  private let subject: PublishSubject<Value>
  public init() {
    subject = .init()
  }

  public var wrappedValue: Value? {
    nil
  }

  public var projectedValue: PublishSubject<Value> {
    subject
  }
}

@propertyWrapper
public struct RxBehaviorSubject<Value> {
  private let subject: BehaviorSubject<Value>
  public init(default value: Value) {
    subject = .init(value: value)
  }

  public var wrappedValue: Value? {
    try? subject.value()
  }

  public var projectedValue: BehaviorSubject<Value> {
    subject
  }
}
