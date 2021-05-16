//
//
//  CocoaMQTTEvent.swift
//  PhobosSwiftNetwork
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

import PhobosSwiftCore
import RxCocoa
import RxSwift
import UIKit

public struct CocoaMQTTEvent<PropertyType>: ObservableType {
  public typealias Element = PropertyType

  let _events: Observable<PropertyType>

  /// Initializes control event with a observable sequence that represents events.
  ///
  /// - parameter events: Observable sequence that represents events.
  /// - returns: Control event created with a observable sequence of events.
  public init<Ev: ObservableType>(events: Ev) where Ev.Element == Element {
    _events = events.subscribe(on: ConcurrentMainScheduler.instance)
  }

  /// Subscribes an observer to control events.
  ///
  /// - parameter observer: Observer to subscribe to events.
  /// - returns: Disposable object that can be used to unsubscribe the observer from receiving control events.
  public func subscribe<Observer: ObserverType>(_ observer: Observer) -> Disposable where Observer.Element == Element {
    _events.subscribe(observer)
  }

  /// - returns: `Observable` interface.
  public func asObservable() -> Observable<Element> {
    _events
  }
}
