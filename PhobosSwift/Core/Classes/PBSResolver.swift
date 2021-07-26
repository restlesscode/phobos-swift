//
//
//  PBSResolver.swift
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

public class PBSResolver {
  public static let shared = PBSResolver()
  private var factory: [String: () -> Any] = [:]
  private init() {}

  /// 添加工厂方法及对应类型到Resolver中
  /// - Parameters:
  ///   - type: Any
  ///   - factoryBlock: 返回传入type的实例Block
  public func add<T>(type: T.Type, _ factoryBlock: @escaping () -> T) {
    factory.updateValue(factoryBlock, forKey: String(describing: type.self))
  }

  /// 根据类型获取实例
  /// - Parameter type: 获取目标类型
  /// - Returns: 目标类型实例
  public func resolve<T>(_ type: T.Type) -> T {
    factory[String(describing: T.self)]?() as! T
  }
}
