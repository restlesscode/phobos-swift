//
//
//  PBSSplash.swift
//  PhobosSwiftSplash
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

import Foundation
import PhobosSwiftCore
import RxCocoa
import RxSwift

///
public class PBSSplash: NSObject {
  /// sharedInstance of PBSSplash
  public static let shared = PBSSplash()

  override private init() {
    super.init()
  }

  private var disposeBag = DisposeBag()

  private var window: UIWindow?

  var protectionSplashViewCtrl: UIViewController?

  var didBecomeActiveCompletionHander: (() -> Void)?

  /// 是否开启Splash
  public var isEnabled: Bool = false {
    didSet {
      if isEnabled {
        enableProtection()
      } else {
        disposeBag = DisposeBag()
      }
    }
  }

  public func configuration(window: UIWindow?,
                            isEnabled: Bool,
                            protectionSplashViewCtrl: UIViewController? = nil,
                            didBecomeActiveCompletionHander handler: (() -> Void)? = nil) {
    if protectionSplashViewCtrl == nil {
      self.protectionSplashViewCtrl = PBSDefaultSplashViewController()
    } else {
      self.protectionSplashViewCtrl = protectionSplashViewCtrl
    }

    didBecomeActiveCompletionHander = handler

    self.window = window
    self.isEnabled = isEnabled
  }

  private func enableProtection() {
    disposeBag = DisposeBag()

    NotificationCenter.default.rx.notification(UIApplication.didEnterBackgroundNotification).subscribe(onNext: { [weak self] _ in

      guard let self = self else { return }

      guard let protectionViewCtrl = self.protectionSplashViewCtrl else {
        return
      }

      if let window = self.window {
        window.addSubview(protectionViewCtrl.view)
      }

    }).disposed(by: disposeBag)

    NotificationCenter.default.rx.notification(UIApplication.didBecomeActiveNotification).subscribe(onNext: { [weak self] _ in

      guard let self = self else { return }

      if let window = self.window {
        UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
          self.protectionSplashViewCtrl?.view.removeFromSuperview()
        })
      }

    }).disposed(by: disposeBag)
  }

  public func remove() {
    if let window = self.window {
      UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
        self.protectionSplashViewCtrl?.view.removeFromSuperview()
      })
    }
  }
}
