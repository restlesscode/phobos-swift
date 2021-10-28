//
//
//  PBSNetworkInterceptor.swift
//  PhobosSwiftNetwork
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

import Alamofire

class PBSNetworkInterceptor: RequestInterceptor {
  // MARK: - RequestAdapter

  public func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
    #if DEBUG
    NSLog("Request:\n\(urlRequest.cURL(pretty: true))")
    #endif
    var adaptedRequest = urlRequest
    if let header = PBSRefreshTokenUtil.shared.accessTokenPairs[urlRequest.url?.host ?? ""] {
      adaptedRequest.headers.update(name: header.key, value: header.value)
    }
    completion(.success(adaptedRequest))
  }

  public func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
    guard request.retryCount <= 1,
          let response = request.task?.response as? HTTPURLResponse,
          response.statusCode == 401,
          let host = request.request?.url?.host else {
      completion(.doNotRetryWithError(error))
      return
    }

    guard let refreshTokenBlock = PBSRefreshTokenUtil.shared.refreshTokenBlocks[host] else {
      completion(.doNotRetryWithError(error))
      return
    }

    refreshTokenBlock { successed in
      if successed {
        completion(.retry)
      } else {
        completion(.doNotRetryWithError(error))
      }
    }
  }
}

extension URLRequest {
  public func cURL(pretty: Bool = false) -> String {
    let newLine = pretty ? "\\\n" : ""
    let method = (pretty ? "--request " : "-X ") + "\(httpMethod ?? "GET") \(newLine)"
    let url: String = (pretty ? "--url " : "") + "\'\(self.url?.absoluteString ?? "")\' \(newLine)"

    var cURL = "curl "
    var header = ""
    var data: String = ""

    if let httpHeaders = allHTTPHeaderFields, httpHeaders.keys.count > 0 {
      for (key, value) in httpHeaders {
        header += (pretty ? "--header " : "-H ") + "\'\(key): \(value)\' \(newLine)"
      }
    }

    if let bodyData = httpBody, let bodyString = String(data: bodyData, encoding: .utf8), !bodyString.isEmpty {
      data = "--data '\(bodyString)'"
    }

    cURL += method + url + header + data

    return cURL
  }
}
