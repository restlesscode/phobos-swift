//
//
//  UIImage.swift
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

import CoreImage
import UIKit

extension UIImage: PhobosSwiftCompatible {}

/// Enhanced features of UIImage class is implemented in this extension
extension PhobosSwift where Base: UIImage {
  /// 设置梯度背景色
  ///
  public static func applyGradientBackground(colorset: [UIColor],
                                             size: CGSize,
                                             startPoint: CGPoint,
                                             endPoint: CGPoint) -> UIImage {
    if size == .zero {
      return UIImage()
    }

    let gradientLayer = CAGradientLayer()
    gradientLayer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)

    gradientLayer.colors = colorset.map { color -> CGColor in
      color.cgColor
    }

    gradientLayer.startPoint = startPoint
    gradientLayer.endPoint = endPoint

    UIGraphicsBeginImageContext(size)
    gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    return image!
  }

  /// 设置水平梯度背景色
  ///
  public static func applyHorizontalGradientBackground(colorset: [UIColor], size: CGSize) -> UIImage {
    UIImage.pbs.applyGradientBackground(colorset: colorset, size: size, startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 1, y: 0))
  }

  /// 设置水平垂直背景色
  ///
  public static func applyVerticalGradientBackground(colorset: [UIColor], size: CGSize) -> UIImage {
    UIImage.pbs.applyGradientBackground(colorset: colorset, size: size, startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 0, y: 1))
  }

  /// 设置水平垂直背景色
  ///
  public static func applyUpLeftToBottomRightGradientBackground(colorset: [UIColor], size: CGSize) -> UIImage {
    UIImage.pbs.applyGradientBackground(colorset: colorset, size: size, startPoint: CGPoint(x: 0.25, y: 0.25), endPoint: CGPoint(x: 1, y: 1))
  }

  /// 设置斜线背景色
  ///
  public static func applyUpRightToBottomLeftGradientBackground(colorset: [UIColor], size: CGSize) -> UIImage {
    UIImage.pbs.applyGradientBackground(colorset: colorset, size: size, startPoint: CGPoint(x: 0.75, y: 0.75), endPoint: CGPoint(x: 0, y: 1))
  }

  /// 根据UIImage设置AlphaComponent
  ///
  public func withAlphaComponent(alpha: CGFloat) -> UIImage? {
    UIGraphicsBeginImageContextWithOptions(base.size, false, base.scale)
    base.draw(at: CGPoint.zero, blendMode: .normal, alpha: alpha)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return newImage
  }

  /// 根据颜色生成1*1的图片
  ///
  public static func makeImage(from color: UIColor) -> UIImage {
    let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
    UIGraphicsBeginImageContext(rect.size)
    let context = UIGraphicsGetCurrentContext()
    context!.setFillColor(color.cgColor)
    context!.fill(rect)
    let img = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return img!
  }

  /// 根据UIView生成图片
  ///
  public static func makeImage(from view: UIView) -> UIImage {
    let renderer = UIGraphicsImageRenderer(bounds: view.bounds)
    let image = renderer.image { rendererContext in
      view.layer.render(in: rendererContext.cgContext)
    }

    return image
  }
}

extension PhobosSwift where Base: UIImage {
  /// 设置UIImage TintColor
  ///
  public func imageWithColor(_ color: UIColor) -> UIImage? {
    var image = base.withRenderingMode(.alwaysTemplate)
    UIGraphicsBeginImageContextWithOptions(base.size, false, base.scale)
    color.set()
    image.draw(in: CGRect(x: 0, y: 0, width: base.size.width, height: base.size.height))
    image = UIGraphicsGetImageFromCurrentImageContext() ?? image
    UIGraphicsEndImageContext()
    return image
  }

  /// render image with tint color
  /// - Parameter tintColor: tint color
  /// - Returns: return tint color image
  public func render(with tintColor: UIColor) -> UIImage? {
    CIImageFilter.render(image: base, with: tintColor)
  }

  /// add mask image at top layer
  /// - Parameter image: overlay image
  /// - Returns: return compose image
  public func overlay(with image: UIImage, alpha: CGFloat) -> UIImage? {
    let size = base.size
    UIGraphicsBeginImageContextWithOptions(CGSize(width: size.width * 3, height: size.height * 3), false, UIScreen.main.scale)
    let rect = CGRect(x: 0, y: 0, width: size.width * 3, height: size.height * 3)
    base.draw(in: rect)
    image.draw(in: rect, blendMode: .normal, alpha: alpha)
    let resultImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return resultImage
  }
}
