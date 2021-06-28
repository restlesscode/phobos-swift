//
//
//  SplashDemoViewController.swift
//  PhobosSwiftExample
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
import PhobosSwiftSplash

class SplashDemoViewController: PBSDefaultSplashViewController {
  private lazy var loading: UIActivityIndicatorView = {
    let activity = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
    return activity
  }()

  var finish: (() -> Void)?

  convenience init(finish: (() -> Void)? = nil) {
    self.init(nibName: nil, bundle: nil)
    self.finish = finish
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(loading)
    loading.snp.makeConstraints {
      $0.center.equalToSuperview()
      $0.size.equalTo(CGSize(width: 40, height: 40))
    }
    loading.startAnimating()
    finishLaunch()
  }

  private func finishLaunch() {
    DispatchQueue.main.async {
      self.loading.stopAnimating()
      self.finish?()
    }
  }
}
