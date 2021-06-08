//
//
//  PBSContainerViewController.swift
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

import RxCocoa
import RxGesture
import RxSwift
import UIKit

/// Slide展开的模式
public struct PBSSlideViewStyle {
  var expandMode: PBSSlideExpandMode
  var expandedOffset: CGFloat = 90
  var scaled: CGFloat = 0.75

  /// 初始化
  public init(expandMode: PBSSlideExpandMode,
              expandedOffset: CGFloat = 90,
              scaled: CGFloat = 0.75) {
    self.expandMode = expandMode
    self.expandedOffset = expandedOffset
    self.scaled = scaled

    if expandMode == .scaled {
      self.expandedOffset = expandedOffset / scaled
    }
  }
}

/// PBSSlideStyle 滑动样式
public enum PBSSlideExpandMode {
  /// 推开模式
  case normal
  /// 推开模式-伴随缩小
  case scaled
  /// 拉过来模式
  case overlapped
}

/// PBSSlideOutState 状态
public enum PBSSlideOutState {
  /// 全部收缩了
  case bothCollapsed
  /// 左面板拉出
  case leftPanelSlidedout
  /// 右面板拉出
  case rightPanelSlidedout
}

/// 整个抽屉的容器View Controller
///
open class PBSSlideViewController: UIViewController {
  let disposeBag = DisposeBag()

  public var style = PBSSlideViewStyle(expandMode: .normal, expandedOffset: 90, scaled: 1.0)

  var centerNavigationController: UINavigationController!

  open var centerViewController: UIViewController!

  var delegate: PBSSlideViewDelegate? {
    centerViewController as? PBSSlideViewDelegate
  }

  var leftViewController: UIViewController?
  var rightViewController: UIViewController?

  open internal(set) var currentState: PBSSlideOutState = .bothCollapsed {
    didSet {
      let shouldShowShadow = currentState != .bothCollapsed
      showShadowForCenterViewController(shouldShowShadow)
    }
  }

  var makeLeftPanelViewController: (() -> UIViewController)?
  var makeRightPanelViewController: (() -> UIViewController)?

  /// Convenience method pushes the root view controller without animation.
  public convenience init<T>(centerViewController: T, style: PBSSlideViewStyle? = nil) where T: PBSSlideViewDelegate, T: UIViewController {
    self.init()
    if let style = style {
      self.style = style
    }
    self.centerViewController = centerViewController
    centerViewController.slideViewController = self
  }

  override open func viewDidLoad() {
    super.viewDidLoad()

    // wrap the centerViewController in a navigation controller, so we can push views to it
    // and display bar button items in the navigation bar
    centerNavigationController = UINavigationController(rootViewController: centerViewController)
    view.addSubview(centerNavigationController.view)
    addChild(centerNavigationController)

    centerNavigationController.didMove(toParent: self)

    centerNavigationController.view.addGestureRecognizer(
      UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
    )
  }

  open func collapseSidePanels() {
    switch currentState {
    case .rightPanelSlidedout:
      toggleRightPanel()
    case .leftPanelSlidedout:
      toggleLeftPanel()
    default:
      break
    }
  }

  /// 对 Center Panel 做动画
  func animateCenterPanel(transform: CGAffineTransform, completion: ((Bool) -> Void)? = nil) {
    animatePanel(panelView: centerNavigationController.view, transform: transform, completion: completion)
  }

  func animatePanel(panelView: UIView, transform: CGAffineTransform, completion: ((Bool) -> Void)? = nil) {
    UIView.animate(withDuration: 0.5,
                   delay: 0,
                   usingSpringWithDamping: 0.8,
                   initialSpringVelocity: 0,
                   options: .curveEaseInOut, animations: {
                     panelView.transform = transform
                   }, completion: completion)
  }

  func addChildSidePanelController(_ sidePanelController: UIViewController) {
    view.insertSubview(sidePanelController.view, at: 0)
    addChild(sidePanelController)
    sidePanelController.didMove(toParent: self)
  }

  func showShadowForCenterViewController(_ shouldShowShadow: Bool) {
    switch style.expandMode {
    case .normal, .scaled:
      if leftViewController != nil {
        centerNavigationController.view.pbs.addShadow(color: .black,
                                                      opacity: shouldShowShadow ? 0.3 : 0.0,
                                                      offSet: CGSize(width: -2, height: 2),
                                                      radius: 2,
                                                      scale: true)
      }
      if rightViewController != nil {
        centerNavigationController.view.pbs.addShadow(color: .black,
                                                      opacity: shouldShowShadow ? 0.3 : 0.0,
                                                      offSet: CGSize(width: 2, height: 2),
                                                      radius: 2,
                                                      scale: true)
      }
    case .overlapped:
      centerNavigationController.view.pbs.addShadow(color: .black, opacity: 0.0, offSet: CGSize(width: 0, height: 0), radius: 0, scale: true)
    }
  }
}

// MARK: Gesture recognizer

extension PBSSlideViewController: UIGestureRecognizerDelegate {
  /// 处理 当中主 viewcontroller的手势
  ///
  /// 仅在 style == .expand / .expandScale  时有效
  @objc func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
    switch style.expandMode {
    case .normal:
      handlePanGestureInExpand(recognizer)
    case .scaled:
      handlePanGestureInExpandScale(recognizer)
    case .overlapped:
      return
    }
  }

  private func handlePanGestureInExpand(_ recognizer: UIPanGestureRecognizer) {
    let gestureIsDraggingFromLeftToRight = (recognizer.velocity(in: view).x > 0)

    switch recognizer.state {
    case .began:
      if currentState == .bothCollapsed {
        if gestureIsDraggingFromLeftToRight {
          addLeftPanelViewController()
        } else {
          addRightPanelViewController()
        }

        showShadowForCenterViewController(true)
      }

    case .changed:
      if leftViewController != nil, let rview = recognizer.view {
        let translationX = max(0, rview.transform.tx + recognizer.translation(in: view).x)
        rview.transform = CGAffineTransform(translationX: translationX, y: 0)
        recognizer.setTranslation(CGPoint.zero, in: view)
      } else if rightViewController != nil, let rview = recognizer.view {
        let translationX = min(0, rview.transform.tx + recognizer.translation(in: view).x)
        rview.transform = CGAffineTransform(translationX: translationX, y: 0)
        recognizer.setTranslation(CGPoint.zero, in: view)
      }

    case .ended:
      if leftViewController != nil,
         let rview = recognizer.view {
        // animate the side panel open or closed based on whether the view
        // has moved more or less than halfway
        let hasMovedGreaterThanHalfway = rview.center.x + rview.transform.tx > view.bounds.size.width
        animateLeftPanel(shouldExpand: hasMovedGreaterThanHalfway)
      } else if rightViewController != nil,
                let rview = recognizer.view {
        let hasMovedGreaterThanHalfway = rview.center.x + rview.transform.tx < 0
        animateRightPanel(shouldExpand: hasMovedGreaterThanHalfway)
      }

    default:
      break
    }
  }

  private func handlePanGestureInExpandScale(_ recognizer: UIPanGestureRecognizer) {
    let gestureIsDraggingFromLeftToRight = (recognizer.velocity(in: view).x > 0)

    switch recognizer.state {
    case .began:
      if currentState == .bothCollapsed {
        if gestureIsDraggingFromLeftToRight {
          addLeftPanelViewController()
        } else {
          addRightPanelViewController()
        }

        showShadowForCenterViewController(true)
      }

    case .changed:
      if leftViewController != nil, let rview = recognizer.view {
        let translationX = max(0, rview.transform.tx + recognizer.translation(in: view).x)
        let scale = 1.0 + (1.0 - style.scaled) * translationX / showRightPanelTransform.tx
        rview.transform = CGAffineTransform(translationX: translationX, y: 0).scaledBy(x: scale, y: scale)
        recognizer.setTranslation(CGPoint.zero, in: view)
      } else if rightViewController != nil, let rview = recognizer.view {
        let translationX = min(0, rview.transform.tx + recognizer.translation(in: view).x)
        let scale = 1.0 - (1.0 - style.scaled) * translationX / showRightPanelTransform.tx
        rview.transform = CGAffineTransform(translationX: translationX, y: 0).scaledBy(x: scale, y: scale)
        recognizer.setTranslation(CGPoint.zero, in: view)
      }

    case .ended:
      if leftViewController != nil,
         let rview = recognizer.view {
        // animate the side panel open or closed based on whether the view
        // has moved more or less than halfway
        let hasMovedGreaterThanHalfway = rview.center.x + rview.transform.tx > view.bounds.size.width
        animateLeftPanel(shouldExpand: hasMovedGreaterThanHalfway)
      } else if rightViewController != nil,
                let rview = recognizer.view {
        let hasMovedGreaterThanHalfway = rview.center.x + rview.transform.tx < 0
        animateRightPanel(shouldExpand: hasMovedGreaterThanHalfway)
      }

    default:
      break
    }
  }
}
