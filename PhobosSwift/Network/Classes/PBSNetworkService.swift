//
//
//  PBSNetworkService.swift
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

import Alamofire
import Foundation
import PhobosSwiftCore
import PhobosSwiftLog

public typealias AnyPromisable<T> = PBSPromisable<Result<T, Error>>

/// 通用网络服务
public protocol PBSNetworkService {
  func request<T: Decodable>(endPoint: PBSEndPoint) -> AnyPromisable<T>
}

/// 通用网络服务实现，初始化需传入Session
public class PBSNetworkServiceImpl: PBSNetworkService {
  public init() {}

  public func request<T: Decodable>(endPoint: PBSEndPoint) -> AnyPromisable<T> {
    PBSNetwork.APIRequest.request(endPoint.uri, method: endPoint.method, parameters: endPoint.parameters, encoding: endPoint.encoding, headers: endPoint.heards, session: endPoint.sessionType.session)
  }
}
