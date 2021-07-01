//
//
//  Session.swift
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
import PhobosSwiftCore

extension Session: PhobosSwiftCompatible {}

extension PhobosSwift where Base: Session {
  private static func makeDefault() -> Session {
    let config = URLSessionConfiguration.default
    config.timeoutIntervalForRequest = 30.0
    let serverTrustManager = PBSPinner.ServerTrustManager()
    return Session(configuration: config, serverTrustManager: serverTrustManager)
  }

  public static var `default`: Session {
    Session.default
  }

  public static var redirectorDoNotFollow: Session {
    Session.redirectorDoNotFollow
  }

  public static var insecure: Session {
    Session.insecure
  }

  /// 添加PublicKey
  public func addPublicKey(publicKey: String) {
    guard
      let secKey = PublicKey.publicKeys(pemEncoded: publicKey).first?.reference,
      let serverTrustManager = base.serverTrustManager as? PBSPinner.ServerTrustManager
    else {
      return
    }
    serverTrustManager.evaluator.publicKeyEvaluator.keys.append(secKey)
  }

  /// 添加证书
  public func addCertificate(data: Data) {
    guard
      let serverTrustManager = base.serverTrustManager as? PBSPinner.ServerTrustManager,
      let certificate = SecCertificateCreateWithData(nil, data as CFData)
    else {
      return
    }
    serverTrustManager.evaluator.certificateEvaluator.certificates.append(certificate)
  }

  /// 清空所有证书
  public func removeAllCertificates() {
    guard
      let serverTrustManager = base.serverTrustManager as? PBSPinner.ServerTrustManager
    else {
      return
    }
    serverTrustManager.evaluator.certificateEvaluator.certificates.removeAll(keepingCapacity: true)
  }
}

extension Session {
  static let `default`: Session = {
    let config = URLSessionConfiguration.default
    config.timeoutIntervalForRequest = 30.0
    let serverTrustManager = PBSPinner.ServerTrustManager()
    return Session(configuration: config, serverTrustManager: serverTrustManager)
  }()

  static let redirectorDoNotFollow: Session = {
    let config = URLSessionConfiguration.default
    config.timeoutIntervalForRequest = 30.0
    let serverTrustManager = PBSPinner.ServerTrustManager()
    return Session(configuration: config, serverTrustManager: serverTrustManager, redirectHandler: Redirector(behavior: .doNotFollow))
  }()

  static let insecure: Session = {
    let config = URLSessionConfiguration.default
    config.timeoutIntervalForRequest = 30.0
    return Session(configuration: config)
  }()

  static let certifyPublicKey: Session = {
    let config = URLSessionConfiguration.default
    config.timeoutIntervalForRequest = 30.0
    return Session(configuration: config, serverTrustManager: PBSPinner.ServerTrustManager())
  }()
}
