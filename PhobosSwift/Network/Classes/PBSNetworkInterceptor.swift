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
  public func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
    #if DEBUG
    NSLog("\nPBSNetworkInterceptor\n\(request.cURLDescription())\n\n response=\(String(describing: request.task?.response))")
    #endif
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
