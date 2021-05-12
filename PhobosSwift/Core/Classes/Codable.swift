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

import UIKit

/// Enhanced features of JSONSerialization class is implemented in this extension
public extension JSONSerialization {
    
    /// 将Dictionary转化成JSON string
    ///
    /// - parameter dict: 要转成Json String的字典对象.
    ///
    /// - returns: JSON String （如果是失败，则为空）
    @objc(stringFromDictionary:)
    static func pbs_string(fromDictionary dict : [AnyHashable:Any]?) -> String? {
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dict ?? [], options: .prettyPrinted)
            let jsonStr = String(data: jsonData, encoding: .utf8)
            
            return jsonStr
        } catch {
            print("JSONSerialization Error:\(error.localizedDescription)")
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
            print(error.localizedDescription)
        }
        
        return nil
    }
}

/// Enhanced features of String class is implemented in this extension
extension String {
    /// 将json string转化成model
    ///
    /// - parameter modelType: 要转成的Model的类型
    ///
    /// - returns: 要转成的Model对象
    public func pbs_model<T>(modelType: T.Type) -> T? where T:Decodable {
        return self.data(using: .utf8)?.pbs_model(modelType: modelType, decoderType: .json)
    }
}

/// Decoder Type enumerator
public enum CodebaseDecoderType {
    /// codebale from plist data object to model
    case propertyList
    /// codebale from json data object to model
    case json
}


/// Enhanced features of Data class is implemented in this extension
extension Data {
    /// 将json data转化成model
    ///
    /// - parameter modelType: 要转成的Model的类型
    ///
    /// - returns: 要转成的Model对象
    public func pbs_model<T>(
        modelType: T.Type,
        decoderType:CodebaseDecoderType = .json) -> T? where T:Decodable {
        
        do {
            switch decoderType {
            case .json:
                let decoder = JSONDecoder()
                let _model = try decoder.decode(modelType, from: self)
                return _model
            case .propertyList:
                let decoder = PropertyListDecoder()
                let _model = try decoder.decode(modelType, from: self)
                return _model
            }
        } catch {
            print(error)
            return nil
        }
    }
    
    /// 将json data转化成model
    ///
    /// - parameter modelType: 要转成的Model的类型
    ///
    /// - returns: 要转成的Model对象
    public func pbs_asModel<ModelType>(
        decoderType:CodebaseDecoderType = .json) throws -> ModelType where ModelType:Decodable {
        
        switch decoderType {
        case .json:
            let decoder = JSONDecoder()
            let _model = try decoder.decode(ModelType.self, from: self)
            return _model
        case .propertyList:
            let decoder = PropertyListDecoder()
            let _model = try decoder.decode(ModelType.self, from: self)
            return _model
        }
    }
    
}


/// Enhanced features of Dictionary class is implemented in this extension
extension Dictionary {
    /// 将字典对象转化成JSON stirng
    ///
    /// - returns: JSON String （如果是失败，则为空）
    public var pbs_jsonString: String? {
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: [])
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        } catch {
            print(error.localizedDescription)
        }
        
        return nil
    }
}
