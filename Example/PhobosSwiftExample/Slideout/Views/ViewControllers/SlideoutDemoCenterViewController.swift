//
//
//  SlideoutDemoCenterViewController.swift
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
import PhobosSwiftSlideout
import UIKit

class SlideoutDemoLeftViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .red
  }
}

class SlideoutDemoRightViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .blue
  }
}

class SlideoutDemoCenterViewController: UIViewController {
  class func makeTheSlideoutDemo() -> UIViewController {
    let vc = PBSSlideViewController(centerViewController: SlideoutDemoCenterViewController())
    vc.setLeftPanelViewController {
      SlideoutDemoLeftViewController()
    }
    vc.setRightPanelViewController {
      SlideoutDemoRightViewController()
    }
    return vc
  }

  var backButton = UIButton(type: .custom)

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .black
  }
}

extension SlideoutDemoCenterViewController: PBSSlideViewDelegate {
  /// 左侧即将划出
  func leftPanelWillToggle(slideViewController: PBSSlideViewController) {}

  /// 左侧正在滑动
  func leftPanelIsToggling(slideViewController: PBSSlideViewController, offset: CGFloat) {}

  /// 左侧完成划动
  func leftPanelDidToggle(slideViewController: PBSSlideViewController) {}

  /// 右侧即将划出
  func rightPanelWillToggle(slideViewController: PBSSlideViewController) {}

  /// 右侧正在滑动
  func rightPanelIsToggling(slideViewController: PBSSlideViewController, offset: CGFloat) {}

  /// 右侧完成划动
  func rightPanelDidToggle(slideViewController: PBSSlideViewController) {}
}
