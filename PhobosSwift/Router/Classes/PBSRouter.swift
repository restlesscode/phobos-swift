//
//
//  PBSRouter.swift
//  PhobosSwiftRouter
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
import PhobosSwiftCore

@objcMembers
open class PBSRouter: Navigator {
  /// Default Router, take it as singleton
  public static let `default` = PBSRouter()

  /// PBSRouter对象所持有的方法交换对象
  /// 该对象，将会交换AppDelegate中的方法
  private let appDelegateSwizzler = PBSRouterAppDelegateSwizzler()

  /// 对PBSRouter对象进行configure
  ///
  open func configure() {
    appDelegateSwizzler.load(withRouter: self)
  }

  deinit {
    appDelegateSwizzler.unload()
  }
}

public protocol PBSRouterViewController: UIViewController {
  func setContext(_ context: Any?)
}

public protocol PBSRouterProtocol: CaseIterable, RawRepresentable {
  var controller: UIViewController? { get }
  var urlPattern: String { get }
}

extension PBSRouterProtocol {
  public static func regist() {
    allCases.forEach { item in
      PBSRouter.default.register(item.urlPattern) {
        let controller = item.controller
        if controller is PBSRouterViewController {
          (controller as? PBSRouterViewController)?.setContext($2)
        }
        return controller
      }
    }
  }

  public func show(context: Any?) {
    PBSRouter.default.showURL(urlPattern, context: context)
  }
}

extension PBSRouterProtocol where Self.RawValue == String {
  public var urlPattern: String {
    String(describing: Self.self) + "/" + rawValue
  }
}
