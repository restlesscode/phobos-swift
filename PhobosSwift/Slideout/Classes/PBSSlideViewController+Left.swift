//
//
//  PBSContainerViewController+Left.swift
//  PhobosSwiftSlideout
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

import UIKit

extension PBSSlideViewController {
  /// 隐藏Left Panel需要做的Transform
  var dismissLeftPanelTransform: CGAffineTransform {
    switch style.expandMode {
    case .normal:
      return .identity
    case .scaled:
      return .identity
    case .overlapped:
      return CGAffineTransform(translationX: -UIScreen.main.bounds.width, y: 0)
    }
  }

  /// 显示Left Panel需要做的Transform
  var showLeftPanelTransform: CGAffineTransform {
    switch style.expandMode {
    case .normal:
      return CGAffineTransform(translationX: UIScreen.main.bounds.width - style.expandedOffset, y: 0)
    case .scaled:
      let translation = CGAffineTransform(translationX: UIScreen.main.bounds.width - style.expandedOffset, y: 0)
      return translation.scaledBy(x: style.scaled, y: style.scaled)
    case .overlapped:
      return CGAffineTransform(translationX: -style.expandedOffset, y: 0)
    }
  }

  /// 对左侧Panel的VC进行设置的回调
  public func setLeftPanelViewController(maker: @escaping (() -> UIViewController)) {
    makeLeftPanelViewController = maker
  }

  func animateLeftPanel(transform: CGAffineTransform, completion: ((Bool) -> Void)? = nil) {
    if let panelView = leftViewController?.view {
      view.bringSubviewToFront(panelView)
      animatePanel(panelView: panelView, transform: transform, completion: completion)
    }
  }

  func addLeftPanelViewController() {
    guard leftViewController == nil else { return }

    if let vc = makeLeftPanelViewController?() {
      addChildSidePanelController(vc)
      leftViewController = vc

      if style.expandMode == .overlapped {
        vc.view.transform = dismissLeftPanelTransform

        vc.view.addGestureRecognizer(
          UIPanGestureRecognizer(target: self, action: #selector(handleLeftPanelPanGesture(_:)))
        )
      }
    }
  }

  func toggleLeftPanel(completion: ((Bool) -> Void)? = nil) {
    switch currentState {
    /// Right Panel is Already Expanded
    case .rightPanelSlidedout:
      /// 如果当前是右侧栏打开了，先关闭右侧栏
      toggleRightPanel { [weak self] _ in
        guard let self = self else { return }
        self.toggleLeftPanel(completion: completion)
      }
    /// Left Panel is Already Expanded
    case .leftPanelSlidedout:
      animateLeftPanel(shouldExpand: false, completion: completion)
    /// 正常情况，打开Left Panel
    case .bothCollapsed:
      addLeftPanelViewController()
      animateLeftPanel(shouldExpand: true, completion: completion)
    }
  }

  /// Show 出 Left Panel
  func animateLeftPanel(shouldExpand: Bool, completion: ((Bool) -> Void)? = nil) {
    delegate?.leftPanelWillToggle?(slideViewController: self)

    if shouldExpand {
      currentState = .leftPanelSlidedout
      switch style.expandMode {
      case .normal,
           .scaled:
        animateCenterPanel(transform: showLeftPanelTransform, completion: completion)
      case .overlapped:
        animateLeftPanel(transform: showLeftPanelTransform, completion: completion)
      }
    } else {
      switch style.expandMode {
      case .normal,
           .scaled:
        animateCenterPanel(transform: dismissLeftPanelTransform) { [weak self] in
          guard let self = self else { return }
          self.currentState = .bothCollapsed
          self.leftViewController?.view.removeFromSuperview()
          self.leftViewController = nil
          completion?($0)
          self.delegate?.leftPanelDidToggle?(slideViewController: self)
        }
      case .overlapped:
        animateLeftPanel(transform: dismissLeftPanelTransform) { [weak self] in
          guard let self = self else { return }
          self.currentState = .bothCollapsed
          self.leftViewController?.view.removeFromSuperview()
          self.leftViewController = nil
          completion?($0)
          self.delegate?.leftPanelDidToggle?(slideViewController: self)
        }
      }
    }
  }
}

// MARK: Gesture recognizer UIGestureRecognizerDelegate

extension PBSSlideViewController {
  /// 处理左侧Panel的手势
  ///
  /// 仅在 style.expandMode == .overlapped  时有效
  @objc func handleLeftPanelPanGesture(_ recognizer: UIPanGestureRecognizer) {
    guard style.expandMode == .overlapped else { return }

    switch recognizer.state {
    case .began:
      break

    case .changed:
      if let rview = recognizer.view {
        let translationX = min(0, rview.transform.tx + recognizer.translation(in: view).x)
        rview.transform = CGAffineTransform(translationX: translationX, y: 0)
        recognizer.setTranslation(CGPoint.zero, in: view)
        (centerViewController as? PBSSlideViewDelegate)?.leftPanelIsToggling?(slideViewController: self, offset: -translationX)
      }

    case .ended:
      if let rview = recognizer.view {
        // animate the side panel open or closed based on whether the view
        // has moved more or less than halfway
        let hasMovedGreaterThanHalfway = (rview.center.x + rview.transform.tx) >= 0
        animateLeftPanel(shouldExpand: hasMovedGreaterThanHalfway)
      }

    default:
      break
    }
  }
}
