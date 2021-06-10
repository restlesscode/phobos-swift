//
//
//  UIView+Extension.swift
//  PhobosSwiftMedia
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
import UIKit

extension PhobosSwift where Base: UIView {
  /// 顶部
  public var top: CGFloat {
    base.frame.origin.y
  }

  /// 底部坐标
  public var bottom: CGFloat {
    base.frame.origin.y + base.frame.height
  }

  /// 左侧坐标
  public var left: CGFloat {
    base.frame.origin.x
  }

  /// 右侧坐标
  public var right: CGFloat {
    base.frame.origin.x + base.frame.size.width
  }

  /// 宽
  public var width: CGFloat {
    base.frame.width
  }

  /// 高
  public var height: CGFloat {
    base.frame.height
  }

  // swiftlint:disable missing_docs
  public static func getLine(_ x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat = 1) -> UIView {
    let line = UIView(frame: CGRect(x: x, y: y, width: width, height: height))
    line.backgroundColor = UIColor.pbs.color(hex: 0xFFF, alpha: 0.6)
    return line
  }

  /// 部分圆角
  ///
  /// - Parameters:
  ///   - corners: 需要实现为圆角的角，可传入多个，不传则全部圆角
  ///   - radii: 圆角半径
  public func corner(byRoundingCorners corners: UIRectCorner? = UIRectCorner.allCorners, radii: CGFloat) {
    let maskPath = UIBezierPath(roundedRect: base.bounds, byRoundingCorners: corners!, cornerRadii: CGSize(width: radii, height: radii))
    let maskLayer = CAShapeLayer()
    maskLayer.frame = base.bounds
    maskLayer.path = maskPath.cgPath
    base.layer.mask = maskLayer
  }

  /// 获取当前ViewController
  ///
  /// - Parameter view:
  /// - Returns:
  public static func getViewController(_ view: UIView) -> UIViewController {
    if let viewController = view.next as? UIViewController {
      return viewController
    } else {
      return getViewController(view.superview!)
    }
  }

  // swiftlint:disable missing_docs
  public func mpImageByRect(range: CGRect) -> UIImage? {
    let rect = base.bounds
    var range = range
    let size = rect.size
    // 1.开启上下文
    UIGraphicsBeginImageContextWithOptions(size, true, UIScreen.main.scale)
    let context = UIGraphicsGetCurrentContext()
    // 2.绘制图层
    if let context = context {
      base.layer.render(in: context)
    }
    // 3.从上下文中获取新图片
    let fullScreenImage = UIGraphicsGetImageFromCurrentImageContext()
    // 4.关闭图形上下文
    UIGraphicsEndImageContext()
    if rect.equalTo(range) {
      return fullScreenImage
    }
    let imageRef = fullScreenImage?.cgImage
    range.origin.x *= UIScreen.main.scale
    range.origin.y *= UIScreen.main.scale
    range.size.width *= UIScreen.main.scale
    range.size.height *= UIScreen.main.scale

    let imageRefRect = imageRef?.cropping(to: range)
    var image: UIImage?
    if let imageRefRect = imageRefRect {
      image = UIImage(cgImage: imageRefRect)
    }
    return image
  }
}
