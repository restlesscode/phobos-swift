//
//
//  URL.swift
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

/// URLQueryParameterStringConvertible
///
public protocol URLQueryParameterStringConvertible {
  /// string of query parameters, ie key1=value1&key2=value2 .etc
  var queryParameters: String { get }
}

extension Dictionary: URLQueryParameterStringConvertible {
  /// This computed property returns a query parameters string from the given NSDictionary. For
  /// example, if the input is @{@"day":@"Tuesday", @"month":@"January"}, the output
  /// string will be @"day=Tuesday&month=January".
  /// - return The computed parameters string.
  public var queryParameters: String {
    var parts: [String] = []
    for (key, value) in self {
      let part = String(format: "%@=%@",
                        String(describing: key).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!,
                        String(describing: value).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
      parts.append(part as String)
    }
    return parts.joined(separator: "&")
  }
}

extension URL {
  /// Creates a new URL by adding the given query parameters.
  ///
  /// - parameter parametersDictionary The query parameter dictionary to add.
  /// - return A new URL.
  public func pbs_appendingQueryParameters(_ parametersDictionary: [String: String]) -> URL {
    let URLString = String(format: "%@?%@", absoluteString, parametersDictionary.queryParameters)
    return URL(string: URLString)!
  }

  /// 获取url上参数
  public var pbs_parametersFromQueryString: [String: String]? {
    guard let components = URLComponents(url: self, resolvingAgainstBaseURL: true),
          let queryItems = components.queryItems else { return nil }
    return queryItems.reduce(into: [String: String]()) { result, item in
      result[item.name] = item.value
    }
  }
}
