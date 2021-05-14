//
//
//  PBSCertificatePinner.swift
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

public struct PBSCertificatePinner {}

extension PBSCertificatePinner {
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

extension PBSCertificatePinner {
  public final class ServerTrustEvaluator: Alamofire.ServerTrustEvaluating {
    public var certificates: [SecCertificate]
    public var acceptSelfSignedCertificates: Bool
    public var performDefaultValidation: Bool
    public var validateHost: Bool

    /// Creates a `PinnedCertificatesTrustEvaluator`.
    ///
    /// - Parameters:
    ///   - certificates:                 The certificates to use to evaluate the trust. All `cer`, `crt`, and `der`
    ///                                   certificates in `Bundle.main` by default.
    ///   - acceptSelfSignedCertificates: Adds the provided certificates as anchors for the trust evaluation, allowing
    ///                                   self-signed certificates to pass. `false` by default. THIS SETTING SHOULD BE
    ///                                   FALSE IN PRODUCTION!
    ///   - performDefaultValidation:     Determines whether default validation should be performed in addition to
    ///                                   evaluating the pinned certificates. `true` by default.
    ///   - validateHost:                 Determines whether or not the evaluator should validate the host, in addition
    ///                                   to performing the default evaluation, even if `performDefaultValidation` is
    ///                                   `false`. `true` by default.
    public init(certificates: [SecCertificate] = Bundle.main.af.certificates,
                acceptSelfSignedCertificates: Bool = true,
                performDefaultValidation: Bool = true,
                validateHost: Bool = true) {
      self.certificates = certificates
      self.acceptSelfSignedCertificates = acceptSelfSignedCertificates
      self.performDefaultValidation = performDefaultValidation
      self.validateHost = validateHost
    }

    public func evaluate(_ trust: SecTrust, forHost host: String) throws {
      guard !certificates.isEmpty else {
        throw AFError.serverTrustEvaluationFailed(reason: .noCertificatesFound)
      }

      if acceptSelfSignedCertificates {
        try trust.af.setAnchorCertificates(certificates)
      }

      if performDefaultValidation {
        try trust.af.performDefaultValidation(forHost: host)
      }

      if validateHost {
        try trust.af.performValidation(forHost: host)
      }

      let serverCertificatesData = Set(trust.af.certificateData)
      let pinnedCertificatesData = Set(certificates.af.data)
      let pinnedCertificatesInServerData = !serverCertificatesData.isDisjoint(with: pinnedCertificatesData)
      if !pinnedCertificatesInServerData {
        throw AFError.serverTrustEvaluationFailed(
          reason: .certificatePinningFailed(host: host,
                                            trust: trust,
                                            pinnedCertificates: certificates,
                                            serverCertificates: trust.af.certificates))
      }
    }
  }
}
