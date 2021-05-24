//
//
//  Int.swift
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

import Foundation

extension Int: PhobosSwiftCompatible {}

extension PhobosSwift where Base == Int {
  /// 将数字转成自然语言textual，语言根据用户设置而定
  public var textualString: String? {
    let formatter = NumberFormatter()

    formatter.numberStyle = NumberFormatter.Style(rawValue: UInt(CFNumberFormatterRoundingMode.roundHalfDown.rawValue))!
    let string = formatter.string(from: NSNumber(value: base))

    return string
  }

  /// 将数字转成中文
  public var cn: String {
    if base == 0 {
      return "零"
    }
    let zhNumbers = ["零", "一", "二", "三", "四", "五", "六", "七", "八", "九"]
    let units = ["", "十", "百", "千", "万", "十", "百", "千", "亿", "十", "百", "千"]
    var cn = ""
    var currentNum = 0
    var beforeNum = 0
    let intLength = Int(floor(log10(Double(base))))
    for index in 0...intLength {
      currentNum = base / Int(pow(10.0, Double(index))) % 10
      if index == 0 {
        if currentNum != 0 {
          cn = zhNumbers[currentNum]
          continue
        }
      } else {
        beforeNum = base / Int(pow(10.0, Double(index - 1))) % 10
      }
      if [1, 2, 3, 5, 6, 7, 9, 10, 11].contains(index) {
        if currentNum == 1, [1, 5, 9].contains(index), index == intLength { // 处理一开头的含十单位
          cn = units[index] + cn
        } else if currentNum != 0 {
          cn = zhNumbers[currentNum] + units[index] + cn
        } else if beforeNum != 0 {
          cn = zhNumbers[currentNum] + cn
        }
        continue
      }
      if [4, 8, 12].contains(index) {
        cn = units[index] + cn
        if (beforeNum != 0 && currentNum == 0) || currentNum != 0 {
          cn = zhNumbers[currentNum] + cn
        }
      }
    }
    return cn
  }

  /// 获取之间的随机数
  public static func random(between from: Int, and to: Int) -> Int {
    let range = UInt32(to - from)
    return Int(arc4random_uniform(range)) + from
  }
}
