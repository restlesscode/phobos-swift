//
//
//  PBSPublicKeyPinner.swift
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
import Foundation

/// To be completed

public struct PBSPublicKeyPinner {}

extension PBSPublicKeyPinner {
  public class ServerTrustManager: Alamofire.ServerTrustManager {
    public let evaluator = ServerTrustEvaluator()

    init() {
      super.init(allHostsMustBeEvaluated: true, evaluators: [:])
    }

    override open func serverTrustEvaluator(forHost host: String) throws -> ServerTrustEvaluating? {
      evaluator
    }
  }
}

extension PBSPublicKeyPinner {
  /// Uses the pinned public keys to validate the server trust. The server trust is considered valid if one of the pinned
  /// public keys match one of the server certificate public keys. By validating both the certificate chain and host,
  /// public key pinning provides a very secure form of server trust validation mitigating most, if not all, MITM attacks.
  /// Applications are encouraged to always validate the host and require a valid certificate chain in production
  /// environments.
  public final class ServerTrustEvaluator: Alamofire.ServerTrustEvaluating {
    public var keys: [SecKey]
    public var performDefaultValidation: Bool
    public var validateHost: Bool

    /// Creates a `PublicKeysTrustEvaluator`.
    ///
    /// - Note: Default and host validation will fail when using this evaluator with self-signed certificates. Use
    ///         `PinnedCertificatesTrustEvaluator` if you need to use self-signed certificates.
    ///
    /// - Parameters:
    ///   - keys:                     The `SecKey`s to use to validate public keys. Defaults to the public keys of all
    ///                               certificates included in the main bundle.
    ///   - performDefaultValidation: Determines whether default validation should be performed in addition to
    ///                               evaluating the pinned certificates. `true` by default.
    ///   - validateHost:             Determines whether or not the evaluator should validate the host, in addition to
    ///                               performing the default evaluation, even if `performDefaultValidation` is `false`.
    ///                               `true` by default.
    public init(keys: [SecKey] = Bundle.main.af.publicKeys,
                performDefaultValidation: Bool = true,
                validateHost: Bool = true) {
      self.keys = keys
      self.performDefaultValidation = performDefaultValidation
      self.validateHost = validateHost
    }

    public func evaluate(_ trust: SecTrust, forHost host: String) throws {
      guard !keys.isEmpty else {
        throw AFError.serverTrustEvaluationFailed(reason: .noPublicKeysFound)
      }

      if performDefaultValidation {
        try trust.af.performDefaultValidation(forHost: host)
      }

      if validateHost {
        try trust.af.performValidation(forHost: host)
      }

      let pinnedKeysInServerKeys: Bool = {
        for serverPublicKey in trust.af.publicKeys {
          for pinnedPublicKey in keys {
            if serverPublicKey == pinnedPublicKey {
              return true
            }
          }
        }
        return false
      }()

      if !pinnedKeysInServerKeys {
        throw AFError.serverTrustEvaluationFailed(reason: .publicKeyPinningFailed(host: host,
                                                                                  trust: trust,
                                                                                  pinnedKeys: keys,
                                                                                  serverKeys: trust.af.publicKeys))
      }
    }
  }
}
