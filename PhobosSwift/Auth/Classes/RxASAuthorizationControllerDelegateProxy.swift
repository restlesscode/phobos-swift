//
//
//  RxASAuthorizationControllerDelegateProxy.swift
//  PhobosSwiftAuth
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

import AuthenticationServices
import RxCocoa
import RxSwift

/// For more information take a look at `DelegateProxyType`.
@available(iOS 13.0, *)
open class RxASAuthorizationControllerDelegateProxy: DelegateProxy<ASAuthorizationController, ASAuthorizationControllerDelegate>, DelegateProxyType {
  /// Typed parent object.
  public private(set) weak var authorizationController: ASAuthorizationController?

  public static func currentDelegate(for object: ASAuthorizationController) -> ASAuthorizationControllerDelegate? {
    object.delegate
  }

  public static func setCurrentDelegate(_ delegate: ASAuthorizationControllerDelegate?, to object: ASAuthorizationController) {
    object.delegate = delegate
  }

  /// - parameter scrollView: Parent object for delegate proxy.
  public init(authorizationController: ASAuthorizationController) {
    self.authorizationController = authorizationController
    super.init(parentObject: authorizationController, delegateProxy: RxASAuthorizationControllerDelegateProxy.self)
  }

  // Register known implementations
  public static func registerKnownImplementations() {
    register { RxASAuthorizationControllerDelegateProxy(authorizationController: $0) }
  }

  private var _didCompleteWithAuthorizationPublishSubject: PublishSubject<ASAuthorization>?

  /// Optimized version used for observing content offset changes.
  internal var didCompleteWithAuthorizationPublishSubject: PublishSubject<ASAuthorization> {
    if let subject = _didCompleteWithAuthorizationPublishSubject {
      return subject
    }

    let subject = PublishSubject<ASAuthorization>()
    _didCompleteWithAuthorizationPublishSubject = subject

    return subject
  }

  private var _didCompleteWithErrorPublishSubject: PublishSubject<Error>?

  /// Optimized version used for observing content offset changes.
  internal var didCompleteWithErrorPublishSubject: PublishSubject<Error> {
    if let subject = _didCompleteWithErrorPublishSubject {
      return subject
    }

    let subject = PublishSubject<Error>()
    _didCompleteWithErrorPublishSubject = subject

    return subject
  }
}

// MARK: delegate methods

@available(iOS 13.0, *)
extension RxASAuthorizationControllerDelegateProxy: ASAuthorizationControllerDelegate {
  public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
    if let subject = _didCompleteWithAuthorizationPublishSubject {
      subject.on(.next(authorization))
    }

    _forwardToDelegate?.authorizationController(controller: controller, didCompleteWithAuthorization: authorization)
  }

  public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    if let subject = _didCompleteWithErrorPublishSubject {
      subject.on(.next(error))
    }

    _forwardToDelegate?.authorizationController(controller: controller, didCompleteWithError: error)
  }
}
