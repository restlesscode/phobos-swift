//
//
//  PBSContainerViewController+Right.swift
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
  /// 隐藏Right Panel需要做的Transform
  var dismissRightPanelTransform: CGAffineTransform {
    switch style.expandMode {
    case .normal:
      return .identity
    case .scaled:
      return .identity
    case .overlapped:
      return CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)
    }
  }

  /// 显示Right Panel需要做的Transform
  var showRightPanelTransform: CGAffineTransform {
    switch style.expandMode {
    case .normal:
      return CGAffineTransform(translationX: style.expandedOffset - UIScreen.main.bounds.width, y: 0)
    case .scaled:
      let translation = CGAffineTransform(translationX: style.expandedOffset - UIScreen.main.bounds.width, y: 0)
      return translation.scaledBy(x: style.scaled, y: style.scaled)
    case .overlapped:
      return CGAffineTransform(translationX: style.expandedOffset, y: 0)
    }
  }

  /// 对右侧Panel的VC进行设置的回调
  public func setRightPanelViewController(maker: @escaping (() -> UIViewController)) {
    makeRightPanelViewController = maker
  }

  func animateRightPanel(transform: CGAffineTransform, completion: ((Bool) -> Void)? = nil) {
    if let panelView = rightViewController?.view {
      view.bringSubviewToFront(panelView)
      animatePanel(panelView: panelView, transform: transform, completion: completion)
    }
  }

  func addRightPanelViewController() {
    guard rightViewController == nil else { return }

    if let vc = makeRightPanelViewController?() {
      addChildSidePanelController(vc)
      rightViewController = vc

      if style.expandMode == .overlapped {
        vc.view.transform = dismissRightPanelTransform
        vc.view.addGestureRecognizer(
          UIPanGestureRecognizer(target: self, action: #selector(handleRightPanelPanGesture(_:)))
        )
      }
    }
  }

  func toggleRightPanel(completion: ((Bool) -> Void)? = nil) {
    switch currentState {
    /// 如果当前是左侧栏打开了，先关闭右侧栏
    case .leftPanelSlidedout:
      toggleLeftPanel { [weak self] _ in
        guard let self = self else { return }
        self.toggleRightPanel(completion: completion)
      }
    case .rightPanelSlidedout:
      animateRightPanel(shouldExpand: false, completion: completion)
    /// 正常情况，打开Left Panel
    case .bothCollapsed:
      addRightPanelViewController()
      animateRightPanel(shouldExpand: true, completion: completion)
    }

//        /// 如果当前是左侧栏打开了，先关闭右侧栏
//        if currentState == .leftPanelSlidedout {
//            toggleLeftPanel { [weak self] _ in
//                guard let self = self else { return }
//                self.toggleRightPanel(completion: completion)
//            }
//        } else {
//            let notAlreadyExpanded = (currentState != .rightPanelSlidedout)
//
//            if notAlreadyExpanded {
//                addRightPanelViewController()
//            }
//
//            animateRightPanel(shouldExpand: notAlreadyExpanded, completion: completion)
//        }
  }

  func animateRightPanel(shouldExpand: Bool, completion: ((Bool) -> Void)? = nil) {
    delegate?.rightPanelWillToggle?(slideViewController: self)

    if shouldExpand {
      currentState = .rightPanelSlidedout
      switch style.expandMode {
      case .normal,
           .scaled:
        animateCenterPanel(transform: showRightPanelTransform, completion: completion)
      case .overlapped:
        animateRightPanel(transform: showRightPanelTransform, completion: completion)
      }

    } else {
      switch style.expandMode {
      case .normal,
           .scaled:
        animateCenterPanel(transform: dismissRightPanelTransform) { [weak self] in
          guard let self = self else { return }
          self.currentState = .bothCollapsed
          self.rightViewController?.view.removeFromSuperview()
          self.rightViewController = nil
          completion?($0)
          self.delegate?.rightPanelDidToggle?(slideViewController: self)
        }
      case .overlapped:
        animateRightPanel(transform: dismissRightPanelTransform) { [weak self] in
          guard let self = self else { return }
          self.currentState = .bothCollapsed
          self.rightViewController?.view.removeFromSuperview()
          self.rightViewController = nil
          completion?($0)
          self.delegate?.rightPanelDidToggle?(slideViewController: self)
        }
      }
    }
  }
}

// MARK: Gesture recognizer UIGestureRecognizerDelegate

extension PBSSlideViewController {
  /// 处理右侧Panel的手势
  ///
  /// 仅在 style == .overlapped  时有效
  @objc func handleRightPanelPanGesture(_ recognizer: UIPanGestureRecognizer) {
    guard style.expandMode == .overlapped else { return }

    switch recognizer.state {
    case .began:
      break

    case .changed:
      if let rview = recognizer.view {
        let translationX = max(0, rview.transform.tx + recognizer.translation(in: view).x)
        rview.transform = CGAffineTransform(translationX: translationX, y: 0)
        recognizer.setTranslation(CGPoint.zero, in: view)

        (centerViewController as? PBSSlideViewDelegate)?.rightPanelIsToggling?(slideViewController: self, offset: translationX)
      }

    case .ended:
      if let rview = recognizer.view {
        // animate the side panel open or closed based on whether the view
        // has moved more or less than halfway
        let hasMovedGreaterThanHalfway = (rview.center.x + rview.transform.tx) < UIScreen.main.bounds.width
        animateRightPanel(shouldExpand: hasMovedGreaterThanHalfway)
      }

    default:
      break
    }
  }
}
