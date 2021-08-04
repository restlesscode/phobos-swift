//
//
//  PBSEndPoint.swift
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

/// 后台网关
public protocol PBSGateway {
  /// 域名
  var domain: String { get }
  /// 路由+版本路径
  var routePath: String { get }
  /// 请求头
  var heards: PBSNetwork.APIRequest.Headers? { get }

  /// API版本切换
  /// - Parameters:
  ///   - old: routePath中的老版本
  ///   - new: 要切换的新版本
  func replaceVersion(old: String, new: String) -> String
}

extension PBSGateway {
  public func replaceVersion(old: String, new: String) -> String {
    routePath.replacingOccurrences(of: old, with: new)
  }

  public var host: String {
    URL(string: domain)?.host ?? ""
  }
}

/// 接口端点配置
public protocol PBSEndPoint {
  /// 必须实现，选择对应后台
  var gateway: PBSGateway { get }
  /// 除域名的全路径，包含路由、版本、api feature
  var path: String { get }
  /// 默认实现 gateway.domain + path，特殊情况可自定义
  var uri: String { get }
  /// 默认获取gateway中的headers
  var heards: PBSNetwork.APIRequest.Headers? { get }
  /// 默认为nil
  var parameters: PBSNetwork.APIRequest.Parameters? { get }
  /// 默认get
  var method: HTTPMethod { get }
  /// 默认JSONEncoding.default
  var encoding: ParameterEncoding { get }
  /// 默认为true   sessionType
  var sessionType: PBSSessionType { get }
}

extension PBSEndPoint {
  public var uri: String {
    gateway.domain + path
  }

  public var parameters: PBSNetwork.APIRequest.Parameters? { nil }
  public var heards: PBSNetwork.APIRequest.Headers? { gateway.heards }
  public var method: HTTPMethod { .get }
  public var encoding: ParameterEncoding {
    switch method {
    case .get:
      return URLEncoding.default
    default:
      return JSONEncoding.default
    }
  }

  public var sessionType: PBSSessionType { .insecure }
}

public enum PBSSessionType {
  case `default`
  case insecure
  case redirectorDoNotFollow

  var session: Session {
    switch self {
    case .default:
      return Session.pbs.default
    case .redirectorDoNotFollow:
      return Session.pbs.redirectorDoNotFollow
    case .insecure:
      return Session.pbs.insecure
    }
  }
}
