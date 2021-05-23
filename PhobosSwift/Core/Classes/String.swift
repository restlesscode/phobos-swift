//
//
//  String.swift
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

import CommonCrypto
import Security

extension String: PhobosSwiftCompatible {}

extension PhobosSwift where Base == String {
  /// 字符串反转
  public var reversedString: String {
    let reversedCharacters = base.reversed()

    return String(reversedCharacters)
  }

  /// 字符串包含一系列字符串
  public func contains(_ stringList: [String]) -> Bool {
    for str in stringList {
      if base.range(of: str) != nil {
        return true
      }
    }

    return false
  }

  /// 字符串转浮点数
  public var double: Double? {
    NumberFormatter().number(from: base)?.doubleValue
  }

  /// 字符串encode成base64
  public var base64: String {
    base.data(using: .utf8)?.base64EncodedString() ?? ""
  }

  /// 字符串encode成md5
  public var md5: String {
    let str = base.cString(using: String.Encoding.utf8)
    let strLen = CUnsignedInt(base.lengthOfBytes(using: String.Encoding.utf8))
    let digestLen = Int(CC_MD5_DIGEST_LENGTH)
    let result = UnsafeMutablePointer<UInt8>.allocate(capacity: 16)
    CC_MD5(str!, strLen, result)
    let hash = NSMutableString()
    for i in 0..<digestLen {
      hash.appendFormat("%02x", result[i])
    }
    free(result)
    return String(format: hash as String)
  }

  /// 字符串encode成sha512
  public var sha512: Data {
    let stringData = base.data(using: String.Encoding.utf8)!
    let result = (stringData as NSData).swiftyRSASHA512()

    return result
  }

  /// 转成多语言字符串
  ///
  /// - parameter bundle 对bundle对象中的多语言字符串，进行转换
  public func localized(inBundle bundle: Bundle = Bundle.main, value: String = "", comment: String = "") -> String {
    NSLocalizedString(base, tableName: nil, bundle: bundle, value: value, comment: comment)
  }

  /// 字符串转成整数
  public var int: Int? {
    NumberFormatter().number(from: base)?.intValue
  }

  /// 字符串结尾去空格
  public var trim: String {
    base.trimmingCharacters(in: [" "])
  }

  /// 时间转换 transfer to time in format
  public func toTimeFormatter(from dateFormatStrSrc: String, to dateFormatStrDesc: String) -> String? {
    let formatter1 = DateFormatter()
    formatter1.dateFormat = dateFormatStrSrc
    if let datetime = formatter1.date(from: base) {
      let formatter2 = DateFormatter()
      formatter2.dateFormat = dateFormatStrDesc
      let datetimeStr = formatter2.string(from: datetime)

      return datetimeStr
    }

    return nil
  }
}

// MARK: - 获取汉字首字母

extension PhobosSwift where Base == String {
  /// 是否包含中文
  public var isIncludeChinese: Bool {
    // 中文字符范围：0x4e00 ~ 0x9fff
    base.unicodeScalars.contains { ch in
      ch.value > 0x4E00 && ch.value < 0x9FFF
    }
  }

  /// 改成拼音
  public var toPinyin: String {
    let stringRef = NSMutableString(string: base) as CFMutableString
    // 转换为带音标的拼音
    CFStringTransform(stringRef, nil, kCFStringTransformToLatin, false)
    // 去掉音标
    CFStringTransform(stringRef, nil, kCFStringTransformStripCombiningMarks, false)
    let pinyin = stringRef as String

    return pinyin
  }

  /// 改成拼音
  ///
  public var toPinyinWithoutBlank: String {
    var pinyin = toPinyin
    pinyin = pinyin.replacingOccurrences(of: " ", with: "")
    return pinyin
  }

  /// 获得拼音大写字母
  ///
  public var pinyinHead: String {
    // 字符串转换为首字母大写
    let pinyin = toPinyin.capitalized
    var headPinyinStr = ""

    // 获取所有大写字母
    for ch in pinyin where ch <= "Z" && ch >= "A" {
      headPinyinStr.append(ch)
    }
    return headPinyinStr
  }

  /// 获取第一个字符
  public var initialCapital: String {
    String(pinyinHead.prefix(1))
  }
}
