//
//
//  PBSIconFontUtils.swift
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

/// icon font 工具类
public struct PBSIconFontDecoder {
  ///
  public static func decodeFontJson(with configuration: PBSIconFontKitConfiguration) -> PBSIconFontFamilyModel? {
    guard let bundle = configuration.bundle,
          let jsonFileName = configuration.fontJsonFileName,
          let jsonFileExtension = configuration.fontJsonFileExtension,
          let url = bundle.path(forResource: jsonFileName, ofType: jsonFileExtension) else {
      print("url 没有数据")
      return nil
    }
    let data = try? Data(contentsOf: URL(fileURLWithPath: url), options: Data.ReadingOptions.alwaysMapped)
    guard let iconFontFamilyModel = try? JSONDecoder().decode(PBSIconFontFamilyModel.self, from: data!) else {
      print("iconfont 没有数据")
      return nil
    }
    return iconFontFamilyModel
  }
}

/// Icon Font Family Model
public struct PBSIconFontFamilyModel: Codable {
  /// cssPrefixText
  public var cssPrefixText: String!
  /// descriptionField
  public var descriptionField: String!
  /// fontFamily
  public var fontFamily: String!
  /// glyphs
  public var glyphs: [PBSGlyph]?
  /// id
  public var id: String!
  /// name
  public var name: String!
  enum CodingKeys: String, CodingKey {
    case cssPrefixText = "css_prefix_text"
    case descriptionField = "description"
    case fontFamily = "font_family"
    case glyphs
    case id
    case name
  }

  /// subscript
  public subscript(key: String) -> PBSGlyph? {
    guard let glyphs = glyphs else {
      return nil
    }
    let glyph = glyphs.first(where: { $0.name == key })
    return glyph
  }
}

/// Glyph Model
public struct PBSGlyph: Codable, Equatable {
  /// fonclass
  public var fontClass: String!
  /// icon id
  public var iconId: String!
  /// name
  public var name: String!
  /// unicode
  public var unicode: String!
  /// unicode decimal
  public var unicodeDecimal: Int!
  enum CodingKeys: String, CodingKey {
    case fontClass = "font_class"
    case iconId = "icon_id"
    case name
    case unicode
    case unicodeDecimal = "unicode_decimal"
  }
}

extension UIImageView {
  /// Change ImageView TintColor
  public func withTintColor(color: UIColor) {
    tintColor = color
  }
}
