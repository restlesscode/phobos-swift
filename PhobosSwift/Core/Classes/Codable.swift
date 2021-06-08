//
//
//  Codable.swift
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
import PhobosSwiftLog

extension JSONSerialization: PhobosSwiftCompatible {}

/// Enhanced features of JSONSerialization class is implemented in this extension
extension PhobosSwift where Base: JSONSerialization {
  /// 将Dictionary转化成JSON string
  ///
  /// - parameter dict: 要转成Json String的字典对象.
  ///
  /// - returns: JSON String （如果是失败，则为空）
  public static func jsonString(fromDictionary dict: [AnyHashable: Any]?) -> String? {
    do {
      let jsonData = try JSONSerialization.data(withJSONObject: dict ?? [], options: .prettyPrinted)
      let jsonStr = String(data: jsonData, encoding: .utf8)

      return jsonStr
    } catch {
      PBSLogger.logger.error(message: error.localizedDescription, context: "Dict to String")
    }
    return nil
  }
}

/// Enhanced features of Encodable protocol is implemented in this extension
extension Encodable {
  /// 将Codable的model转化成json stirng
  ///
  /// - returns: JSON String （如果是失败，则为空）
  public var pbs_jsonString: String? {
    let jsonEncoder = JSONEncoder()
    do {
      let jsonData = try jsonEncoder.encode(self)
      let jsonString = String(data: jsonData, encoding: .utf8)

      return jsonString
    } catch {
      PBSLogger.logger.error(message: error.localizedDescription, context: "Model to JSON String")
    }

    return nil
  }
}

/// Enhanced features of String class is implemented in this extension
extension PhobosSwift where Base == String {
  /// 将json string转化成model
  ///
  /// - parameter modelType: 要转成的Model的类型
  ///
  /// - returns: 要转成的Model对象
  public func model<T: Decodable>() -> T? {
    base.data(using: .utf8)?.pbs.model(decoderType: .json)
  }
}

/// Decoder Type enumerator
public enum PBSDecoderType {
  /// codebale from plist data object to model
  case propertyList
  /// codebale from json data object to model
  case json
}

extension Data: PhobosSwiftCompatible {}

/// Enhanced features of Data class is implemented in this extension
extension PhobosSwift where Base == Data {
  /// 将json data转化成model
  ///
  /// - returns: 要转成的Model对象
  public func model<T: Decodable>(decoderType: PBSDecoderType = .json) -> T? {
    do {
      switch decoderType {
      case .json:
        let decoder = JSONDecoder()
        let _model = try decoder.decode(T.self, from: base)
        return _model
      case .propertyList:
        let decoder = PropertyListDecoder()
        let _model = try decoder.decode(T.self, from: base)
        return _model
      }
    } catch {
      PBSLogger.logger.error(message: error.localizedDescription, context: "JSON Data to Model")
      return nil
    }
  }
}

extension Dictionary: PhobosSwiftCompatible {}

/// Enhanced features of Dictionary class is implemented in this extension
extension PhobosSwift where Base == [AnyHashable: Any] {
  /// 将字典对象转化成JSON stirng
  ///
  /// - returns: JSON String （如果是失败，则为空）
  public var jsonString: String? {
    do {
      let jsonData = try JSONSerialization.data(withJSONObject: base, options: [])
      let jsonString = String(data: jsonData, encoding: .utf8)
      return jsonString
    } catch {
      PBSLogger.logger.error(message: error.localizedDescription, context: "Dict to JSON String")
    }

    return nil
  }

  /// convert dictionary to model
  public func model<T: Decodable>() -> T? {
    do {
      let data = try JSONSerialization.data(withJSONObject: base, options: .fragmentsAllowed)
      return try JSONDecoder().decode(T.self, from: data)
    } catch {
      PBSLogger.logger.error(message: error.localizedDescription, context: "JSON Data to Model")
      return nil
    }
  }
}
