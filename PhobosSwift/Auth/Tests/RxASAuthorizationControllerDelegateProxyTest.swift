//
//
//  RxASAuthorizationControllerDelegateProxyTest.swift
//  PhobosSwiftAuth-Unit-Tests
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

@testable import PhobosSwiftAuth
import Nimble
import Quick
import AuthenticationServices

class RxASAuthorizationControllerDelegateProxyTest: QuickSpec {
  override func spec() {
    testCrashs()
  }
  
  func testCrashs() {
    describe("Given ASAuthorizationController初始化，ASAuthorizationControllerDelegate初始化") {
      if #available(iOS 13.0, *) {
        let controller = getASAuthorizationController()
        let delegate = ASAuthorizationControllerDelegateImpl()
        let proxy = RxASAuthorizationControllerDelegateProxy(authorizationController: controller)
        context("When 调用各个方法") {
          // will be crash
//          RxASAuthorizationControllerDelegateProxy.registerKnownImplementations()
          _ = RxASAuthorizationControllerDelegateProxy.currentDelegate(for: controller)
          RxASAuthorizationControllerDelegateProxy.setCurrentDelegate(delegate, to: controller)
          
          _ = proxy.didCompleteWithErrorPublishSubject
          _ = proxy.didCompleteWithAuthorizationPublishSubject
          proxy.authorizationController(controller: controller, didCompleteWithError: NSError.init(domain: "", code: 0, userInfo: nil))

          it("Then 不会闪退") {
            expect(true).to(beTrue())
          }
        }
      } else {
        // Fallback on earlier versions
      }
    }
  }
  
  @available(iOS 13.0, *)
  func getASAuthorizationController() -> ASAuthorizationController {
    let appleIDProvider = ASAuthorizationAppleIDProvider()
    let request = appleIDProvider.createRequest()
    request.requestedScopes = [.fullName, .email]
    let controller = ASAuthorizationController.init(authorizationRequests: [request])
    
    return controller
  }
}

class ASAuthorizationControllerDelegateImpl: ASAuthorizationControllerDelegate {
  func isEqual(_ object: Any?) -> Bool {
    true
  }

  var hash: Int = 0

  var superclass: AnyClass?

  func `self`() -> Self {
    ASAuthorizationControllerDelegateImpl() as! Self
  }

  func perform(_ aSelector: Selector!) -> Unmanaged<AnyObject>! {
    nil
  }

  func perform(_ aSelector: Selector!, with object: Any!) -> Unmanaged<AnyObject>! {
    nil
  }

  func perform(_ aSelector: Selector!, with object1: Any!, with object2: Any!) -> Unmanaged<AnyObject>! {
    nil
  }

  func isProxy() -> Bool {
    true
  }

  func isKind(of aClass: AnyClass) -> Bool {
    true
  }

  func isMember(of aClass: AnyClass) -> Bool {
    true
  }

  func conforms(to aProtocol: Protocol) -> Bool {
    true
  }

  func responds(to aSelector: Selector!) -> Bool {
    true
  }

  var description: String = ""
}
