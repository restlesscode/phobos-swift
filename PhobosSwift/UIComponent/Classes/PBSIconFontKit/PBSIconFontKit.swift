//
//
//  PBSIconFontKit.swift
//  PhobosSwiftUIComponent
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

/// Icon Font Info
public struct PBSIconInfo {
  var text: String
  var fontSize: CGFloat
  var rectSize: CGSize
  var color: UIColor
  var backgroundColor: UIColor = .clear
  var fontName: String?

  init(with text: String,
       fontSize: CGFloat,
       color: UIColor,
       rectSize: CGSize) {
    self.text = text
    self.fontSize = fontSize
    self.color = color
    self.rectSize = rectSize
  }
}

/// Icon Font Kit
public class PBSIconFontKit: NSObject {
  /// 注册字体
  /// - Parameter configuration: IconFontKitConfiguration
  static func registerFont(using configuration: PBSIconFontKitConfiguration) {
    guard let bundle = configuration.bundle,
          let fontFamilyName = configuration.fontFamilyName,
          let fontExtension = configuration.fontFileExtension,
          let fontURL = bundle.url(forResource: fontFamilyName, withExtension: fontExtension) else {
      fatalError("Couldn't find font")
    }
    guard let fontDataProvider = CGDataProvider(url: fontURL as CFURL) else {
      fatalError("Couldn't load data from the font \(fontFamilyName)")
    }
    guard let font = CGFont(fontDataProvider) else {
      fatalError("Couldn't create font from data")
    }
    var error: Unmanaged<CFError>?
    CTFontManagerRegisterGraphicsFont(font, &error)
    error?.release()
  }

  /// 生成字体
  /// - Parameters:
  ///   - size: 字体大小
  ///   - fontName: 字体组名称
  /// - Returns: UIFont
  public static func fontWithSize(using configuration: PBSIconFontKitConfiguration, size: CGFloat) -> UIFont {
    guard let fontFamilyName = configuration.fontFamilyName else {
      fatalError("FontName object should not be nil, check if the font file is added to the application bundle and you're using the correct font name.")
    }

    if let font = UIFont(name: fontFamilyName, size: size) {
      return font
    } else {
      registerFont(using: configuration)
      guard let iconFont = UIFont(name: fontFamilyName, size: size) else {
        fatalError("UIFont object should not be nil, check if the font file is added to the application bundle and you're using the correct font name.")
      }
      return iconFont
    }
  }
}

/// 生成图片
extension UIImage {
  convenience init(iconInfo: PBSIconInfo, configuration: PBSIconFontKitConfiguration) {
    let drawText = iconInfo.text
    let size = iconInfo.rectSize
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.alignment = NSTextAlignment.center

    let fontSize = min(size.width, size.height, iconInfo.fontSize)
    let font = PBSIconFontKit.fontWithSize(using: configuration, size: fontSize)
    let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font,
                                                     NSAttributedString.Key.foregroundColor: iconInfo.color,
                                                     NSAttributedString.Key.backgroundColor: iconInfo.backgroundColor,
                                                     NSAttributedString.Key.paragraphStyle: paragraphStyle]
    let attributedString = NSAttributedString(string: drawText, attributes: attributes)
    UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
    attributedString.draw(in: CGRect(x: 0, y: abs((size.height - fontSize) * 0.5), width: size.width, height: size.height))
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    if let image = image {
      self.init(cgImage: image.cgImage!, scale: image.scale, orientation: image.imageOrientation)
    } else {
      let clearImage = UIImage.pbs.makeImage(from: .clear)
      self.init(cgImage: clearImage.cgImage!, scale: clearImage.scale, orientation: clearImage.imageOrientation)
    }
  }
}

/// Font Image Utils
public struct FontImage {
  /// 生成图片
  /// - Parameters:
  ///   - configuration: IconFontKitConfiguration
  ///   - iconUnicode: unicode 字符串
  ///   - fontSize: fon size
  ///   - coloPBSr: color
  ///   - insets: insets
  ///   - backgroundColor: backrgoundcolor
  ///   - renderingMode: rendering mode 默认是automatic
  /// - Returns: UIimage
  public static func icon(using configuration: PBSIconFontKitConfiguration,
                          iconUnicode: String,
                          fontSize: CGFloat,
                          color: UIColor,
                          backgroundColor: UIColor = .clear,
                          rectSize: CGSize,
                          renderingMode: UIImage.RenderingMode = .automatic) -> UIImage? {
    var info = PBSIconInfo(with: iconUnicode, fontSize: fontSize, color: color, rectSize: rectSize)
    info.backgroundColor = backgroundColor
    let image = UIImage(iconInfo: info, configuration: configuration)
    return image.withRenderingMode(renderingMode)
  }
}

///
public struct PBSIconFontKitConfiguration {
  ///
  public var bundle: Bundle?
  ///
  public var fontFamilyName: String?
  ///
  public var fontFileExtension: String?
  ///
  public var fontJsonFileName: String?
  ///
  public var fontJsonFileExtension: String?
  ///
  public init(bundle: Bundle,
              fontFamilyName: String,
              fontFileExtension: String,
              fontJsonFileName: String? = nil,
              fontJsonFileExtension: String? = "json") {
    self.bundle = bundle
    self.fontFamilyName = fontFamilyName
    self.fontFileExtension = fontFileExtension
    self.fontJsonFileName = fontJsonFileName
    self.fontJsonFileExtension = fontJsonFileExtension
  }
}
