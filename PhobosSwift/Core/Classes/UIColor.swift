//
//
//  UIColor.swift
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

extension UIColor {
  /// 两个UIColor做增量
  public static func +(lhs: UIColor, rhs: UIColor) -> UIColor {
    UIColor.pbs.color(r255: lhs.pbs.rgb.r255 + rhs.pbs.rgb.r255,
                      g255: lhs.pbs.rgb.g255 + rhs.pbs.rgb.g255,
                      b255: lhs.pbs.rgb.b255 + rhs.pbs.rgb.b255)
  }

  ///
  public struct RGB {
    ///
    public var red: Int = 0
    ///
    public var green: Int = 0
    ///
    public var blue: Int = 0
    ///
    public var alpha: CGFloat = 1
    ///
    public var r255: CGFloat {
      CGFloat(red)
    }

    ///
    public var g255: CGFloat {
      CGFloat(green)
    }

    ///
    public var b255: CGFloat {
      CGFloat(blue)
    }

    public init(red: Int, green: Int, blue: Int, alpha: CGFloat) {
      self.red = red
      self.green = green
      self.blue = blue
    }
  }
}

extension UIColor: PhobosSwiftCompatible {}

/// Enhanced features of UIColor class is implemented in this extension
extension PhobosSwift where Base: UIColor {
  /// Color的RGB Tuple

  public var rgb: UIColor.RGB {
    var red: CGFloat = 0
    var green: CGFloat = 0
    var blue: CGFloat = 0
    var alpha: CGFloat = 0
    base.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
    return UIColor.RGB(red: Int(red * 255), green: Int(green * 255), blue: Int(blue * 255), alpha: alpha)
  }

  /// Inverse Color
  public var inverseColor: UIColor {
    var red: CGFloat = 255.0
    var green: CGFloat = 255.0
    var blue: CGFloat = 255.0
    var alpha: CGFloat = 1.0

    base.getRed(&red, green: &green, blue: &blue, alpha: &alpha)

    red = 1.0 - red
    green = 1.0 - green
    blue = 1.0 - blue

    return UIColor(red: red, green: green, blue: blue, alpha: alpha)
  }

  /// 获取dark mode下颜色
  public var darkColor: UIColor {
    if #available(iOS 13.0, *) {
      let traitCollection = UITraitCollection(userInterfaceStyle: .dark)
      return base.resolvedColor(with: traitCollection)
    } else {
      return base
    }
  }

  /// 获取light mode下颜色
  public var lightColor: UIColor {
    if #available(iOS 13.0, *) {
      let traitCollection = UITraitCollection(userInterfaceStyle: .light)
      return base.resolvedColor(with: traitCollection)
    } else {
      return base
    }
  }
}

///
extension PhobosSwift where Base: UIColor {
  /// 通过RGB的Int值初始化UIColor
  ///
  public static func color(R: Int, G: Int, B: Int, alpha: CGFloat = 1.0) -> UIColor {
    assert(R >= 0 && R <= 255, "Invalid red component")
    assert(G >= 0 && G <= 255, "Invalid green component")
    assert(B >= 0 && B <= 255, "Invalid blue component")

    return UIColor(red: CGFloat(R) / 255.0, green: CGFloat(G) / 255.0, blue: CGFloat(B) / 255.0, alpha: alpha)
  }

  /// 通过RGB创建color对象
  public static func color(r255: CGFloat, g255: CGFloat, b255: CGFloat, alpha: CGFloat = 1.0) -> UIColor {
    UIColor(red: r255 / 255.0, green: g255 / 255.0, blue: b255 / 255.0, alpha: alpha)
  }

  /// 通过hex的Int值初始化UIColor
  ///
  public static func color(hex: Int, alpha: CGFloat = 1.0) -> UIColor {
    UIColor.pbs.color(R: (hex >> 16) & 0xFF,
                      G: (hex >> 8) & 0xFF,
                      B: hex & 0xFF,
                      alpha: alpha)
  }

  /// 通过hex的String值初始化UIColor
  ///
  public static func color(hexString: String, alpha: CGFloat = 1.0) -> UIColor {
    var cString: String = hexString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

    if cString.hasPrefix("#") {
      cString.remove(at: cString.startIndex)
    }

    var rgbValue: UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)

    return UIColor.pbs.color(hex: Int(rgbValue))
  }

  /// 根据传入的颜色生成动态颜色
  public static func dynamicColor(ofLightColor lightColor: UIColor, andDarkColor darkColor: UIColor) -> UIColor {
    if #available(iOS 13.0, *) {
      let dynamicColor = UIColor(dynamicProvider: { traitCollection in
        if traitCollection.userInterfaceStyle == UIUserInterfaceStyle.dark {
          return darkColor
        } else {
          return lightColor
        }
      })
      return dynamicColor
    } else {
      return lightColor
    }
  }
}

// MARK: - 根据系统的颜色生成

extension PhobosSwift where Base: UIColor {
  ///
  public static var systemLight: UIColor {
    UIColor.pbs.dynamicColor(ofLightColor: .white, andDarkColor: .black)
  }

  ///
  public static var systemDark: UIColor {
    UIColor.pbs.dynamicColor(ofLightColor: .black, andDarkColor: .white)
  }

  /// systemGroupedBackground
  public static var systemGroupedBackground: UIColor {
    if #available(iOS 13.0, *) {
      return UIColor.systemGroupedBackground
    } else {
      return UIColor.pbs.color(R: 242, G: 242, B: 247)
    }
  }

  /// secondarySystemGroupedBackground
  public static var secondarySystemGroupedBackground: UIColor {
    if #available(iOS 13.0, *) {
      return UIColor.secondarySystemGroupedBackground
    } else {
      return UIColor.pbs.color(R: 255, G: 255, B: 255, alpha: 1.0)
    }
  }

  /// tertiarySystemGroupedBackground
  public static var tertiarySystemGroupedBackground: UIColor {
    if #available(iOS 13.0, *) {
      return UIColor.tertiarySystemGroupedBackground
    } else {
      return UIColor.pbs.color(R: 242, G: 242, B: 247, alpha: 1.0)
    }
  }

  /// groupTableViewBackground
  public static var groupTableViewBackground: UIColor {
    if #available(iOS 13.0, *) {
      return UIColor.groupTableViewBackground
    } else {
      return UIColor.pbs.color(R: 242, G: 242, B: 247)
    }
  }

  /// systemGray
  public static var systemGray: UIColor {
    if #available(iOS 13.0, *) {
      return UIColor.systemGray
    } else {
      return UIColor.pbs.color(R: 142, G: 142, B: 147, alpha: 1.0)
    }
  }

  /// systemGray2
  public static var systemGray2: UIColor {
    if #available(iOS 13.0, *) {
      return UIColor.systemGray2
    } else {
      return UIColor.pbs.color(R: 174, G: 174, B: 178)
    }
  }

  /// systemGray2
  public static var systemGray3: UIColor {
    if #available(iOS 13.0, *) {
      return UIColor.systemGray3
    } else {
      return UIColor.pbs.color(R: 199, G: 199, B: 204)
    }
  }

  /// systemGray4
  public static var systemGray4: UIColor {
    if #available(iOS 13.0, *) {
      return UIColor.systemGray4
    } else {
      return UIColor.pbs.color(R: 209, G: 209, B: 214)
    }
  }

  /// systemGray5
  public static var systemGray5: UIColor {
    if #available(iOS 13.0, *) {
      return UIColor.systemGray5
    } else {
      return UIColor.pbs.color(R: 229, G: 229, B: 234)
    }
  }

  /// systemGray6
  public static var systemGray6: UIColor {
    if #available(iOS 13.0, *) {
      return UIColor.systemGray6
    } else {
      return UIColor.pbs.color(R: 242, G: 242, B: 247)
    }
  }

  /// systemPink
  public static var systemPink: UIColor {
    if #available(iOS 13.0, *) {
      return UIColor.systemPink
    } else {
      return UIColor.pbs.color(R: 255, G: 45, B: 85)
    }
  }

  /// systemPurple
  public static var systemPurple: UIColor {
    if #available(iOS 13.0, *) {
      return UIColor.systemPurple
    } else {
      return UIColor.pbs.color(R: 175, G: 82, B: 222)
    }
  }

  /// systemOrange
  public static var systemOrange: UIColor {
    if #available(iOS 13.0, *) {
      return UIColor.systemOrange
    } else {
      return UIColor.pbs.color(R: 255, G: 149, B: 0)
    }
  }

  /// systemYellow
  public static var systemYellow: UIColor {
    if #available(iOS 13.0, *) {
      return UIColor.systemYellow
    } else {
      return UIColor.pbs.color(R: 255, G: 204, B: 0)
    }
  }

  /// systemGreen
  public static var systemGreen: UIColor {
    if #available(iOS 13.0, *) {
      return UIColor.systemGreen
    } else {
      return UIColor.pbs.color(R: 52, G: 199, B: 89)
    }
  }

  /// systemBlue
  public static var systemBlue: UIColor {
    if #available(iOS 13.0, *) {
      return UIColor.systemBlue
    } else {
      return UIColor.pbs.color(R: 0, G: 122, B: 255)
    }
  }

  /// systemIndigo
  public static var systemIndigo: UIColor {
    if #available(iOS 13.0, *) {
      return UIColor.systemIndigo
    } else {
      return UIColor.pbs.color(R: 88, G: 86, B: 214)
    }
  }

  /// systemTeal
  public static var systemTeal: UIColor {
    if #available(iOS 13.0, *) {
      return UIColor.systemTeal
    } else {
      return UIColor.pbs.color(R: 90, G: 200, B: 250)
    }
  }

  /// systemFill
  public static var systemFill: UIColor {
    if #available(iOS 13.0, *) {
      return UIColor.systemFill
    } else {
      return UIColor.pbs.color(R: 120, G: 120, B: 128, alpha: 0.2)
    }
  }

  /// secondarySystemFill
  public static var secondarySystemFill: UIColor {
    if #available(iOS 13.0, *) {
      return UIColor.secondarySystemFill
    } else {
      return UIColor.pbs.color(R: 120, G: 120, B: 128, alpha: 0.16)
    }
  }

  /// tertiarySystemFill
  public static var tertiarySystemFill: UIColor {
    if #available(iOS 13.0, *) {
      return UIColor.tertiarySystemFill
    } else {
      return UIColor.pbs.color(R: 120, G: 120, B: 128, alpha: 0.12)
    }
  }

  /// quaternarySystemFill
  public static var quaternarySystemFill: UIColor {
    if #available(iOS 13.0, *) {
      return UIColor.quaternarySystemFill
    } else {
      return UIColor.pbs.color(R: 116, G: 116, B: 128, alpha: 0.08)
    }
  }

  /// opaqueSeparator
  public static var opaqueSeparator: UIColor {
    if #available(iOS 13.0, *) {
      return UIColor.opaqueSeparator
    } else {
      return UIColor.pbs.color(R: 198, G: 198, B: 200)
    }
  }

  /// primary label
  public static var label: UIColor {
    if #available(iOS 13.0, *) {
      return UIColor.label
    } else {
      return UIColor.pbs.color(R: 0, G: 0, B: 0)
    }
  }

  /// secondary Label
  public static var secondaryLabel: UIColor {
    if #available(iOS 13.0, *) {
      return UIColor.secondaryLabel
    } else {
      return UIColor.pbs.color(R: 60, G: 60, B: 67, alpha: 0.6)
    }
  }

  /// tertiary Label
  public static var tertiaryLabel: UIColor {
    if #available(iOS 13.0, *) {
      return UIColor.tertiaryLabel
    } else {
      return UIColor.pbs.color(R: 60, G: 60, B: 67, alpha: 0.3)
    }
  }

  /// quaternary Label
  public static var quaternaryLabel: UIColor {
    if #available(iOS 13.0, *) {
      return UIColor.quaternaryLabel
    } else {
      return UIColor.pbs.color(R: 60, G: 60, B: 67, alpha: 0.18)
    }
  }

  /// link
  public static var link: UIColor {
    if #available(iOS 13.0, *) {
      return UIColor.link
    } else {
      return UIColor.pbs.color(R: 0, G: 122, B: 255)
    }
  }

  /// placeholderText
  public static var placeholderText: UIColor {
    if #available(iOS 13.0, *) {
      return UIColor.placeholderText
    } else {
      return UIColor.pbs.color(R: 60, G: 60, B: 67, alpha: 0.3)
    }
  }

  /// separator
  public static var separator: UIColor {
    if #available(iOS 13.0, *) {
      return UIColor.separator
    } else {
      return UIColor.pbs.color(R: 60, G: 60, B: 67, alpha: 0.29)
    }
  }

  /// systemBackground
  public static var systemBackground: UIColor {
    if #available(iOS 13.0, *) {
      return UIColor.systemBackground
    } else {
      return .white
    }
  }

  /// secondarySystemBackground
  public static var secondarySystemBackground: UIColor {
    if #available(iOS 13.0, *) {
      return UIColor.secondarySystemBackground
    } else {
      return UIColor.pbs.color(R: 242, G: 242, B: 247, alpha: 1.0)
    }
  }

  /// tertiarySystemBackground
  public static var tertiarySystemBackground: UIColor {
    if #available(iOS 13.0, *) {
      return UIColor.tertiarySystemBackground
    } else {
      return .white
    }
  }

  /// lightText
  public static var lightText: UIColor {
    if #available(iOS 13.0, *) {
      return UIColor.lightText
    } else {
      return UIColor.pbs.color(R: 255, G: 255, B: 255, alpha: 0.6)
    }
  }

  /// darkText
  public static var darkText: UIColor {
    if #available(iOS 13.0, *) {
      return UIColor.darkText
    } else {
      return .black
    }
  }

  /// systemRed
  public static var systemRed: UIColor {
    if #available(iOS 13.0, *) {
      return UIColor.systemRed
    } else {
      return UIColor.pbs.color(R: 255, G: 59, B: 48, alpha: 1.0)
    }
  }
}
