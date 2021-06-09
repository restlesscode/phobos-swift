//
//
//  UIImage+Extension.swift
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

extension PhobosSwift where Base: UIImage {
  // swiftlint:disable missing_docs
  public func colorAtPoint(_ point: CGPoint) -> UIColor? {
    guard CGRect(origin: CGPoint(x: 0, y: 0), size: base.size).contains(point) else {
      return nil
    }

    let pointX = trunc(point.x)
    let pointY = trunc(point.y)

    let width = base.size.width
    let height = base.size.height
    let colorSpace = CGColorSpaceCreateDeviceRGB()
    var pixelData: [UInt8] = [0, 0, 0, 0]

    pixelData.withUnsafeMutableBytes { pointer in
      // swiftlint:disable line_length
      if let context = CGContext(data: pointer.baseAddress, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue), let cgImage = base.cgImage {
        context.setBlendMode(.copy)
        context.translateBy(x: -pointX, y: pointY - height)
        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
      }
    }

    let red = CGFloat(pixelData[0]) / CGFloat(255.0)
    let green = CGFloat(pixelData[1]) / CGFloat(255.0)
    let blue = CGFloat(pixelData[2]) / CGFloat(255.0)
    let alpha = CGFloat(pixelData[3]) / CGFloat(255.0)

    if #available(iOS 10.0, *) {
      return UIColor(displayP3Red: red, green: green, blue: blue, alpha: alpha)
    } else {
      return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
  }

  /// 将图片压缩到指定尺寸
  ///
  /// - Parameter size: 指定尺寸
  /// - Returns: 返回Image对象
  public func scaleImageWithSize(_ reSize: CGSize) -> UIImage {
    var size = reSize
    let imageSize = base.size
    if imageSize.width > imageSize.height {
      size.height *= imageSize.height / imageSize.width
    } else {
      size.width *= imageSize.width / imageSize.height
    }
    // 打开图片编辑模式
    UIGraphicsBeginImageContext(size)
//        UIGraphicsBeginImageContextWithOptions(size, true, UIScreen.main.scale)

    // 修改图片长和宽
    base.draw(in: CGRect(origin: CGPoint.zero, size: size))

    // 生成新图片
    let img_new = UIGraphicsGetImageFromCurrentImageContext()!

    // 关闭图片编辑模式
    UIGraphicsEndImageContext()
    return img_new
  }
}
