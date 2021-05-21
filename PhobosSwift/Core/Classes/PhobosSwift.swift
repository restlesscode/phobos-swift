//
//
//  PhobosSwift.swift
//  PhobosSwiftPush
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

import Foundation

public struct PhobosSwift<Base> {
  /// Base object to extend.
  public let base: Base

  /// Creates extensions with base object.
  ///
  /// - parameter base: Base object.
  public init(_ base: Base) {
    self.base = base
  }
}

/// A type that has PhobosSwift extensions.
public protocol PhobosSwiftCompatible {
  /// Extended type
  associatedtype PhobosSwiftBase

  /// PhobosSwift extensions.
  static var pbs: PhobosSwift<PhobosSwiftBase>.Type { get set }

  /// PhobosSwift extensions.
  var pbs: PhobosSwift<PhobosSwiftBase> { get set }
}

extension PhobosSwiftCompatible {
  /// PhobosSwift extensions.
  public static var pbs: PhobosSwift<Self>.Type {
    get { PhobosSwift<Self>.self }
    // this enables using PhobosSwift to "mutate" base type
    // swiftlint:disable:next unused_setter_value
    set {}
  }

  /// PhobosSwift extensions.
  public var pbs: PhobosSwift<Self> {
    get { PhobosSwift(self) }
    // this enables using PhobosSwift to "mutate" base object
    // swiftlint:disable:next unused_setter_value
    set {}
  }
}
