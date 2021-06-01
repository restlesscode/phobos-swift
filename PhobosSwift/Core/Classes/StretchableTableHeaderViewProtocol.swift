//
//
//  StretchableTableHeaderViewProtocol.swift
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

/// 可升缩的TableViewHeader
public protocol StretchableTableHeaderViewProtocol {
  /// scrollViewDidScroll
  func scrollViewDidScroll(_ scrollView: UIScrollView)
}

/// 可升缩的TableViewHeader的Extension
extension StretchableTableHeaderViewProtocol where Self: UIView {
  /// scrollViewDidScroll默认实现
  public func scrollViewDidScroll(_ scrollView: UIScrollView) {
    /// 下拉
    if scrollView.contentOffset.y < -bounds.height {
      layer.position = CGPoint(x: UIScreen.main.bounds.size.width / 2.0,
                               y: scrollView.contentOffset.y / 2.0)
      let zoomScale = scrollView.contentOffset.y / -bounds.height
      transform = CGAffineTransform(scaleX: zoomScale, y: zoomScale)
    } else {
      /// 上拉
      /// to do nothing
    }
  }
}
