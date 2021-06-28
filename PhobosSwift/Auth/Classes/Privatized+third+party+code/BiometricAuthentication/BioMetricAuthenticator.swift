//
//  BioMetricAuthenticator.swift
//  BiometricAuthentication
//
//  Copyright (c) 2018 Rushi Sangani
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

import LocalAuthentication
import UIKit

open class BioMetricAuthenticator: NSObject {
  // MARK: - Singleton

  public static let shared = BioMetricAuthenticator()

  // MARK: - Private

  override private init() {}
  private lazy var context: LAContext? = {
    LAContext()
  }()

  // MARK: - Public

  public var allowableReuseDuration: TimeInterval? {
    didSet {
      guard let duration = allowableReuseDuration else {
        return
      }
      if #available(iOS 9.0, *) {
        self.context?.touchIDAuthenticationAllowableReuseDuration = duration
      }
    }
  }
}

// MARK: - Public

/// Enhanced features of BioMetricAuthenticator class is implemented in this extension
extension BioMetricAuthenticator {
  /// checks if biometric authentication can be performed currently on the device.
  public class var canAuthenticate: Bool {
    var isBiometricAuthenticationAvailable = false
    var error: NSError?

    if LAContext().canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &error) {
      isBiometricAuthenticationAvailable = (error == nil)
    }
    return isBiometricAuthenticationAvailable
  }

  /// Check for biometric authentication
  public class func authenticateWithBioMetrics(reason: String,
                                               fallbackTitle: String? = "",
                                               cancelTitle: String? = "",
                                               completion: @escaping (Result<Bool, BiometricAuthenticationError>) -> Void) {
    // reason
    let reasonString = reason.isEmpty ? BioMetricAuthenticator.shared.defaultBiometricAuthenticationReason() : reason

    // context
    var context: LAContext!
    if BioMetricAuthenticator.shared.isReuseDurationSet() {
      context = BioMetricAuthenticator.shared.context
    } else {
      context = LAContext()
    }
    context.localizedFallbackTitle = fallbackTitle

    // cancel button title
    if #available(iOS 10.0, *) {
      context.localizedCancelTitle = cancelTitle
    }

    // authenticate
    BioMetricAuthenticator.shared.evaluate(policy: .deviceOwnerAuthenticationWithBiometrics, with: context, reason: reasonString, completion: completion)
  }

  /// Check for device passcode authentication
  public class func authenticateWithPasscode(reason: String, cancelTitle: String? = "", completion: @escaping (Result<Bool, BiometricAuthenticationError>) -> Void) {
    // reason
    let reasonString = reason.isEmpty ? BioMetricAuthenticator.shared.defaultPasscodeAuthenticationReason() : reason

    let context = LAContext()

    // cancel button title
    if #available(iOS 10.0, *) {
      context.localizedCancelTitle = cancelTitle
    }

    // authenticate
    if #available(iOS 9.0, *) {
      BioMetricAuthenticator.shared.evaluate(policy: .deviceOwnerAuthentication, with: context, reason: reasonString, completion: completion)
    } else {
      // Fallback on earlier versions
      BioMetricAuthenticator.shared.evaluate(policy: .deviceOwnerAuthenticationWithBiometrics,
                                             with: context,
                                             reason: reasonString,
                                             completion: completion)
    }
  }

  /// checks if device supports face id authentication
  public var isFaceIDAvailable: Bool {
    if #available(iOS 11.0, *) {
      let context = LAContext()
      return (context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: nil) && context.biometryType == .faceID)
    }
    return false
  }

  /// checks if device supports touch id authentication
  public var isTouchIDAvailable: Bool {
    let context = LAContext()
    var error: NSError?

    let canEvaluate = context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &error)
    if #available(iOS 11.0, *) {
      return canEvaluate && context.biometryType == .touchID
    }
    return canEvaluate
  }
}

// MARK: - Private

extension BioMetricAuthenticator {
  /// get authentication reason to show while authentication
  private func defaultBiometricAuthenticationReason() -> String {
    isFaceIDAvailable ? kFaceIdAuthenticationReason : kTouchIdAuthenticationReason
  }

  /// get passcode authentication reason to show while entering device passcode after multiple failed attempts.
  private func defaultPasscodeAuthenticationReason() -> String {
    isFaceIDAvailable ? kFaceIdPasscodeAuthenticationReason : kTouchIdPasscodeAuthenticationReason
  }

  /// checks if allowableReuseDuration is set
  private func isReuseDurationSet() -> Bool {
    guard allowableReuseDuration != nil else {
      return false
    }
    return true
  }

  /// evaluate policy
  private func evaluate(policy: LAPolicy,
                        with context: LAContext,
                        reason: String,
                        completion: @escaping (Result<Bool, BiometricAuthenticationError>) -> Void) {
    context.evaluatePolicy(policy, localizedReason: reason) { success, err in
      DispatchQueue.main.async {
        if success {
          completion(.success(true))
        } else {
          let error = err as? LAError ?? LAError(.appCancel)
          let errorType = BiometricAuthenticationError.initWithError(error)
          completion(.failure(errorType))
        }
      }
    }
  }
}
