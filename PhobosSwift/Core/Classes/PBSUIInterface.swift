//
//
//  PBSUIInterface.swift
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

/// PBSUIInterface Protocol
public protocol PBSUIInterface {
  /// 当前实现PBSUIInterface的class name string
  static var id: String { get }
  /// 当前实现PBSUIInterface的xib name string
  static var uiNib: UINib { get }
}

/// Default features of PBSUIInterface protocol is implemented in this extension
extension PBSUIInterface {
  /// 当前实现PBSUIInterface的class name string
  public static var id: String {
    String(describing: Self.self)
  }

  /// 当前实现PBSUIInterface的xib name string
  public static var uiNib: UINib {
    UINib(nibName: id, bundle: nil)
  }
}

///
extension PhobosSwift where Base: UITableViewCell {
  /// 当前实现PBSUIInterface的class name string
  public static var reuseIdentifier: String {
    String(describing: Self.self)
  }
}

///
extension PhobosSwift where Base: UICollectionReusableView {
  /// 当前实现PBSUIInterface的class name string
  public static var reuseIdentifier: String {
    String(describing: Self.self)
  }
}
