//
//
//  PBSPromise.swift
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

import UIKit

/// protocol PBSPromisableType
public protocol PBSPromisableType {}

/// Extension for  Protocol PBSPromisableType
extension PBSPromisableType {
  /// transfer a PBSPromisableType to PBSPromisable
  public func asPromisableable<Element>(executor: (_ resolve: @escaping (Element) -> Void) -> Void) -> PBSPromisable<Element> {
    PBSPromisable.create(executor: executor)
  }
}

/// Lightweighted PromiseKit
public class PBSPromisable<Wrapper> {
  enum State<T> {
    case pending
    case resolved(T)
  }

  private var callbacks: [(Wrapper) -> Void] = []

  private var state: State<Wrapper> = .pending

  private func resolve(_ element: Wrapper) {
    updateState(to: .resolved(element))
  }

  private init(executor: (_ resolve: @escaping (Wrapper) -> Void) -> Void) {
    executor(resolve)
  }

  ///
  public static func create(executor: (_ resolve: @escaping (Wrapper) -> Void) -> Void) -> PBSPromisable<Wrapper> {
    PBSPromisable.unity(executor: executor)
  }

  private static func unity(executor: (_ resolve: @escaping (Wrapper) -> Void) -> Void) -> PBSPromisable<Wrapper> {
    PBSPromisable(executor: executor)
  }

  /// then
  ///
  /// - parameter onResolved: the callback when promise is resolved
  /// - returns: PBSPromisable
  @discardableResult
  public func then<Result>(onResolved: @escaping (Wrapper) -> PBSPromisable<Result>) -> PBSPromisable<Result> {
    flatMap(onResolved: onResolved)
  }

  /// then
  ///
  /// - parameter onResolved: the callback when promise is resolved
  /// - returns: PBSPromisable
  @discardableResult
  public func then<Result>(onResolved: @escaping (Wrapper) -> Result) -> PBSPromisable<Result> {
    map(onResolved: onResolved)
  }

  /// then
  ///
  /// - parameter onResolved: the callback when promise is resolved
  public func then(onResolved: @escaping (Wrapper) -> Void) {
    observe(onResolved: onResolved)
  }

  /// it is actually map
  private func map<Result>(onResolved: @escaping (Wrapper) -> Result) -> PBSPromisable<Result> {
    flatMap { value -> PBSPromisable<Result> in
      PBSPromisable<Result>.unity { resolve in
        let newValue = onResolved(value)
        resolve(newValue)
      }
    }
  }

  /// it is actually  flatMap
  private func flatMap<Result>(onResolved: @escaping (Wrapper) -> PBSPromisable<Result>) -> PBSPromisable<Result> {
    PBSPromisable<Result>.unity { resolve in
      observe { element in
        onResolved(element).observe(onResolved: resolve)
      }
    }
  }

  /// it is actually an observe
  private func observe(onResolved: @escaping (Wrapper) -> Void) {
    callbacks.append(onResolved)
    triggerCallbackIfResolved()
  }

  private func triggerCallbackIfResolved() {
    guard case let .resolved(value) = state else { return }
    callbacks.forEach { callback in
      callback(value)
    }
    callbacks.removeAll()
  }

  private func updateState(to newState: State<Wrapper>) {
    guard case .pending = state else { return }
    state = newState
    triggerCallbackIfResolved()
  }
}
