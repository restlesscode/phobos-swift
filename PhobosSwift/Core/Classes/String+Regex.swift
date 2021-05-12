//
//
//  String+Regex.swift
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

/// 正则选择枚举
public struct RegularExpressionType: OptionSet {
    
    public var rawValue: UInt
    
    public static let digit = RegularExpressionType(rawValue: 1 << 0)
    public static let englishLetter = RegularExpressionType(rawValue: 1 << 1)
    public static let chineseCharacter = RegularExpressionType(rawValue: 1 << 2)
    public static let email = RegularExpressionType(rawValue: 1 << 3)
    public static let chineseMobileNumber = RegularExpressionType(rawValue: 1 << 4)
    public static let punctuation = RegularExpressionType(rawValue: 1 << 5)

    public init(rawValue: UInt) {
        self.rawValue = rawValue
    }
    
    public var pattern: String {
        switch self {
        case .digit:
            return "[0-9]+"
        case .englishLetter:
            return "[A-Za-z]+"
        case .chineseCharacter:
            return "[\\u4e00-\\u9fa5]+"
        case .email:
            return "[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\\.[a-zA-Z0-9-.]+"
        case .chineseMobileNumber:
            return "(1[3-9])\\d{9}"
        case .punctuation:
            return "[，。；：“”‘’（）「」【】·～《》,.;:\"\'\\(\\)\\[\\]\\{\\}\\|<>\\-\\+]+"
        default:
            return ""
        }
    }
}

/// Enhanced features of String class is implemented in this extension
public extension String {
    
    /// 根据options选择适配的正则判断
    /// - Parameter regexTypes: 多选正则类型
    /// - Parameter isEmptyAllowed: 是否允许空字符
    func pbs_isText(ofRegexTypes regexTypes: RegularExpressionType, isEmptyAllowed:Bool = false) -> Bool {
        // 如果不允许为空，且会空字符
        if !isEmptyAllowed && self.isEmpty {
            return false
        }
        
        var result = self
        
        if regexTypes.contains(.digit) {
            result = result.replacingOccurrences(of: RegularExpressionType.digit.pattern, with: "", options: [.regularExpression])
        }
        if regexTypes.contains(.englishLetter) {
            result = result.replacingOccurrences(of: RegularExpressionType.englishLetter.pattern, with: "", options: [.regularExpression])
        }
        if regexTypes.contains(.chineseCharacter) {
            result = result.replacingOccurrences(of: RegularExpressionType.chineseCharacter.pattern, with: "", options: [.regularExpression])
        }
        if regexTypes.contains(.email) {
            result = result.replacingOccurrences(of: RegularExpressionType.email.pattern, with: "", options: [.regularExpression])
        }
        if regexTypes.contains(.chineseMobileNumber) {
            result = result.replacingOccurrences(of: RegularExpressionType.chineseMobileNumber.pattern, with: "", options: [.regularExpression])
        }
        if regexTypes.contains(.punctuation) {
            result = result.replacingOccurrences(of: RegularExpressionType.punctuation.pattern, with: "", options: [.regularExpression])
        }

        return result.isEmpty
    }
    
    /// 是否合法的Password
    var pbs_isValidPassword: Bool {
        return !self.isEmpty
    }
    
    func match(regular: String) -> Bool {
        return NSPredicate(format:"SELF MATCHES %@", regular).evaluate(with: self)
    }

//    /**
//     根据 正则表达式 截取字符串
//
//     - parameter regex: 正则表达式，比如 let regex = "(http[^\\s]+(jpg|jpeg|png|tiff)\\b)"
//
//     - returns: 字符串数组
//     */
//    func matches(forRegex regex: String) -> [String]? {
//
//        do {
//            let regularExpression = try NSRegularExpression(pattern: regex, options: [])
//            let range = NSMakeRange(0, self.count)
//            let results = regularExpression.matches(in: self, options: [], range: range)
//            let string = self as NSString
//            return results.map { string.substring(with: $0.range)}
//        } catch {
//            return nil
//        }
//    }
}
