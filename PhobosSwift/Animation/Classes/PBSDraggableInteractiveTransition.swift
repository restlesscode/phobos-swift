//
//
//  PBSDraggableInteractiveTransition.swift
//  PhobosSwiftAnimation
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

import PhobosSwiftLog
import UIKit

/// PBSDraggableInteractiveTransition Style
///
public struct PBSDraggableInteractiveTransitionStyle {
  /// 卡片的Push前初始Y位置
  public var cardViewInitialYPos: CGFloat
  /// 卡片的Push后最后始Y位置
  public var cardViewFinalYPos: CGFloat
  /// 卡片的Pop前初始Y位置
  public var cardViewBackYPos: CGFloat
  /// 动画时间
  public var animationDuration: TimeInterval

  /// 初始化
  public init(cardViewInitialYPos: CGFloat,
              cardViewFinalYPos: CGFloat,
              cardViewBackYPos: CGFloat,
              animationDuration: TimeInterval = 1.0) {
    self.cardViewInitialYPos = cardViewInitialYPos
    self.cardViewFinalYPos = cardViewFinalYPos
    self.cardViewBackYPos = cardViewBackYPos
    self.animationDuration = animationDuration
  }
}

public class PBSDraggableInteractiveTransition: UIPercentDrivenInteractiveTransition {
  public private(set) var style: PBSDraggableInteractiveTransitionStyle!

  private var cardView: UIView!

  public private(set) var interactionInProgress = false

  private var shouldCompleteTransition = false

  private weak var pushFromViewCtrl: UIViewController!

  private var pushToViewCtrl: UIViewController!

  private var operation: UINavigationController.Operation = .push

  public var navigationController: UINavigationController!

  public convenience init(cardView: UIView,
                          pushFromViewCtrl: UIViewController,
                          pushToViewCtrl: UIViewController,
                          navigationController: UINavigationController,
                          style: PBSDraggableInteractiveTransitionStyle) {
    self.init()
    self.cardView = cardView
    self.pushFromViewCtrl = pushFromViewCtrl
    self.pushToViewCtrl = pushToViewCtrl
    self.navigationController = navigationController
    self.style = style
  }

  /// not allowed to call default init
  override private init() {
    super.init()
  }

  /// push
  public func push(isInteractive: Bool) {
    interactionInProgress = isInteractive
    navigationController?.pushViewController(pushToViewCtrl, animated: true)
  }

  /// pop
  public func pop(isInteractive: Bool) {
    interactionInProgress = isInteractive
    navigationController?.popViewController(animated: true)
  }

  public func handlePushGesture(recognizer: UIPanGestureRecognizer) {
    guard let translationView = recognizer.view?.superview else { return }

    let translation = recognizer.translation(in: translationView)
    let translationY = abs(min(translation.y, 0))
    var progress: CGFloat = translationY / (kScreenHeight - style.cardViewFinalYPos)

    /// progress 分为，上滑50%，view转换剩下的50%
    progress = min(max(progress, 0.01), 0.99)
    shouldCompleteTransition = progress > 0.25

    switch recognizer.state {
    case .changed:
      update(progress)
    case .cancelled:
      interactionInProgress = false
      cancel()
    case .ended:
      interactionInProgress = false
      if shouldCompleteTransition {
        finish()
      } else {
        cancel()
      }
    case .possible:
      break
    case .failed:
      interactionInProgress = false
    default:
      break
    }
  }

  public func handlePopGesture(recognizer: UIPanGestureRecognizer) {
    guard let translationView = recognizer.view?.superview else { return }

    let translation = recognizer.translation(in: translationView)
    let translationY = abs(max(translation.y, 0))
    var progress: CGFloat = translationY / (kScreenHeight - style.cardViewFinalYPos)

    /// progress 分为，上滑50%，view转换剩下的50%
    progress = min(max(progress, 0.01), 0.99)
    shouldCompleteTransition = progress > 0.25

    switch recognizer.state {
    case .changed:
      update(progress)
    case .cancelled:
      interactionInProgress = false
      cancel()
    case .ended:
      interactionInProgress = false
      if shouldCompleteTransition {
        finish()
      } else {
        cancel()
      }
    case .possible:
      break
    case .failed:
      interactionInProgress = false
    default:
      break
    }
  }
}

extension PBSDraggableInteractiveTransition: UIViewControllerAnimatedTransitioning {
  /// Duration of this transition
  ///
  public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    style.animationDuration
  }

  private func animateTransitionForPush(using transitionContext: UIViewControllerContextTransitioning) {
    let containerView = transitionContext.containerView

    guard let pushToViewCtrl = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else {
      return
    }

    containerView.addSubview(pushToViewCtrl.view)
    pushToViewCtrl.view.alpha = 0.0

    UIView.animateKeyframes(withDuration: style.animationDuration,
                            delay: 0,
                            options: .calculationModeLinear,
                            animations: {
                              UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.5, animations: {
                                self.cardView.transform = CGAffineTransform(translationX: 0, y: self.style.cardViewFinalYPos)
                              })

                              UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5, animations: {
                                pushToViewCtrl.view.alpha = 1.0
                                containerView.bringSubviewToFront(pushToViewCtrl.view)
                              })
                            }, completion: { _ in
                              if transitionContext.transitionWasCancelled {
                                pushToViewCtrl.view.removeFromSuperview()
                              }
                              transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                            })
  }

  private func animateTransitionForPop(using transitionContext: UIViewControllerContextTransitioning) {
    let containerView = transitionContext.containerView

    guard let popFromViewCtrl = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) else {
      return
    }
    guard let popToViewCtrl = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else {
      return
    }

    containerView.insertSubview(popToViewCtrl.view, belowSubview: popFromViewCtrl.view)
    cardView.transform = CGAffineTransform(translationX: 0, y: style.cardViewBackYPos)

    UIView.animateKeyframes(withDuration: style.animationDuration,
                            delay: 0,
                            options: .calculationModeLinear,
                            animations: {
                              UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.25, animations: {
                                popFromViewCtrl.view.alpha = 0.0
                              })

                              UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.75, animations: {
                                self.cardView.transform = CGAffineTransform(translationX: 0,
                                                                            y: self.style.cardViewInitialYPos)
                              })
                            }, completion: { _ in
                              if !transitionContext.transitionWasCancelled {
                                self.navigationController.delegate = nil
                              }
                              transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                            })
  }

  public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    /// 先只针对Push
    if operation == .push {
      animateTransitionForPush(using: transitionContext)
    } else {
      /// 针对pop或none
      animateTransitionForPop(using: transitionContext)
    }
  }
}

extension PBSDraggableInteractiveTransition: UINavigationControllerDelegate {
  public func navigationController(_ navigationController: UINavigationController,
                                   animationControllerFor operation: UINavigationController.Operation,
                                   from fromVC: UIViewController,
                                   to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    if (fromVC == pushFromViewCtrl && toVC == pushToViewCtrl) ||
      (fromVC == pushToViewCtrl && toVC == pushFromViewCtrl) {
      self.operation = operation
      return self
    } else {
      return nil
    }
  }

  public func navigationController(_ navigationController: UINavigationController,
                                   interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
    if interactionInProgress {
      return self
    } else {
      return nil
    }
  }
}

extension UITabBar {
  /// 复写Tabbar push hide的隐藏动画动画
  override open func action(for layer: CALayer, forKey event: String) -> CAAction? {
    if event == "position" {
      if layer.position.x < 0 {
        // show tabbar
        let pushFromTop = CATransition()
        pushFromTop.duration = 0.25
        pushFromTop.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
        pushFromTop.type = CATransitionType.push
        pushFromTop.subtype = CATransitionSubtype.fromTop

        return pushFromTop
      } else if layer.position.x > 0 &&
        (layer.position.y > layer.bounds.size.height) &&
        (layer.position.y < UIScreen.main.bounds.height) {
        // hide tabbar
        if #available(iOS 13.0, *) {
          let pushFromBottom = CATransition()
          pushFromBottom.duration = 0.25
          pushFromBottom.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
          pushFromBottom.type = CATransitionType.push
          pushFromBottom.subtype = CATransitionSubtype.fromBottom

          return pushFromBottom
        } else {
          // FIXME: iOS12会有神奇的bug，这里用补丁的方式结局
          if let action = super.action(for: layer, forKey: event) as? NSObject {
            // let pendingAnimation = action.value(forKey: "_pendingAnimation") as? CAAnimation
            // let animationObject = action.value(forKey: "_animationObject") as? UIViewPropertyAnimator
            let view = action.value(forKey: "_view") as? UIView
            view?.isHidden = true

            return action as? CAAction
          }
        }
      }
    }

    return super.action(for: layer, forKey: event)
  }
}
