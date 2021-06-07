//
//
//  PBSFingerTapWindow.swift
//  PhobosSwiftCore
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

import AVFoundation
import UIKit

private let kRemovalDelay: TimeInterval = 0.2

class PBSFingerTapView: UIImageView {
  var timestamp: TimeInterval = 0.0
  var shouldAutomaticallyRemoveAfterTimeout = false
  var isFadingOut = false
}

/// A PBSFingerTapWindow gives you automatic presentation mode in your iOS app. Note that currently,
public class PBSFingerTapWindow: UIWindow {
  /// The alpha transparency value to use for the touch image. Defaults to 0.5.
  var touchAlpha: CGFloat = 0.5

  /// The time over which to fade out touch images. Defaults to 0.3.
  var fadeDuration: TimeInterval = 0.3

  /// If using the default touchImage, the color with which to fill the shape. Defaults to white.
  var fillColor: UIColor = .red

  public var active = false

  private var fingerTipRemovalScheduled = false

  /// A custom image to use to show touches on screen. If unset, defaults to a partially-transparent stroked circle.
  private lazy var touchImage: UIImage? = {
    let clipPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: 50, height: 50))

    UIGraphicsBeginImageContext(clipPath.bounds.size)
    let context = UIGraphicsGetCurrentContext()
    context!.setFillColor(fillColor.cgColor)
    context!.fill(clipPath.bounds)
    let img = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return img!
  }()

  private lazy var overlayWindow: UIWindow = {
    var windowFrame = frame
    windowFrame.size.height -= UIApplication.pbs_shared?.statusBarFrame.height ?? 0

    var _overlayWindow = PBSFingerTapOverlayWindow()

    if #available(iOS 13.0, *) {
      if let windowScene = self.windowScene {
        _overlayWindow = PBSFingerTapOverlayWindow(windowScene: windowScene)
      }
    }

    _overlayWindow.frame = windowFrame

    _overlayWindow.isUserInteractionEnabled = false
    _overlayWindow.windowLevel = .statusBar
    _overlayWindow.backgroundColor = UIColor.clear
    _overlayWindow.isHidden = false

    return _overlayWindow
  }()

  override public func sendEvent(_ event: UIEvent) {
    if active {
      guard let allTouches = event.allTouches else {
        super.sendEvent(event)
        scheduleFingerTipRemoval()
        return
      }

      for touch in allTouches {
        switch touch.phase {
        case .began, .moved, .regionMoved, .regionEntered, .regionExited, .stationary:

          var touchView = overlayWindow.viewWithTag(touch.hash) as? PBSFingerTapView

          if touch.phase != .stationary && touchView != nil && touchView!.isFadingOut {
            touchView!.removeFromSuperview()
            touchView = nil
          }

          if touch.phase != .stationary && touchView == nil {
            touchView = PBSFingerTapView(image: touchImage)
            touchView?.layer.cornerRadius = 25
            touchView?.layer.masksToBounds = true
            touchView?.backgroundColor = .red
            overlayWindow.addSubview(touchView!)
          }
          guard let touchPointView = touchView else {
            break
          }
          if !touchPointView.isFadingOut {
            touchPointView.alpha = touchAlpha
            touchPointView.center = touch.location(in: overlayWindow)
            touchPointView.tag = touch.hash
            touchPointView.timestamp = touch.timestamp
            touchPointView.shouldAutomaticallyRemoveAfterTimeout = shouldAutomaticallyRemoveFingerTip(forTouch: touch)
          }

        case .ended, .cancelled:
          removeFingerTip(withHash: touch.hash, animated: true)
        @unknown default:
          break
        }
      }
    }

    super.sendEvent(event)

    // We may not see all UITouchPhaseEnded/UITouchPhaseCancelled events.
    scheduleFingerTipRemoval()
  }

  func scheduleFingerTipRemoval() {
    if fingerTipRemovalScheduled {
      return
    }

    fingerTipRemovalScheduled = true
    perform(#selector(removeInactiveFingerTips), with: nil, afterDelay: 0.1)
  }

  func cancelScheduledFingerTipRemoval() {
    fingerTipRemovalScheduled = true
    NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(removeInactiveFingerTips), object: nil)
  }

  @objc func removeInactiveFingerTips() {
    fingerTipRemovalScheduled = false

    let now: TimeInterval = ProcessInfo.processInfo.systemUptime

    for touchView in overlayWindow.subviews where touchView is PBSFingerTapView {
      if let touchView = touchView as? PBSFingerTapView {
        if touchView.shouldAutomaticallyRemoveAfterTimeout && now > touchView.timestamp + kRemovalDelay {
          self.removeFingerTip(withHash: touchView.tag, animated: true)
        }
      }
    }

    if !overlayWindow.subviews.isEmpty {
      scheduleFingerTipRemoval()
    }
  }

  func removeFingerTip(withHash hash: Int, animated: Bool) {
    guard let touchView = overlayWindow.viewWithTag(hash) as? PBSFingerTapView else { return }

    if !touchView.isKind(of: PBSFingerTapView.self) {
      return
    }

    if touchView.isFadingOut {
      return
    }

    let animationsWereEnabled = PBSFingerTapView.areAnimationsEnabled

    if animated {
      UIView.setAnimationsEnabled(true)
      UIView.beginAnimations(nil, context: nil)
      UIView.setAnimationDuration(fadeDuration)
    }

    touchView.frame = CGRect(x: touchView.center.x - touchView.frame.size.width,
                             y: touchView.center.y - touchView.frame.size.height,
                             width: touchView.frame.size.width * 2,
                             height: touchView.frame.size.height * 2)

    touchView.layer.cornerRadius = 50

    touchView.alpha = 0.0

    if animated {
      UIView.commitAnimations()
      UIView.setAnimationsEnabled(animationsWereEnabled)
    }

    touchView.isFadingOut = true
    touchView.perform(#selector(removeFromSuperview), with: nil, afterDelay: fadeDuration)
  }

  func shouldAutomaticallyRemoveFingerTip(forTouch touch: UITouch) -> Bool {
    var view = touch.view?.hitTest(touch.location(in: touch.view), with: nil)

    while view != nil {
      if view!.isKind(of: UITableViewCell.self) {
        for recognizer in touch.gestureRecognizers ?? [] {
          if recognizer.isKind(of: UISwipeGestureRecognizer.self) {
            return true
          }
        }
      } else if view!.isKind(of: UITableView.self) {
        if touch.gestureRecognizers?.isEmpty ?? false {
          return true
        }
      }

      view = view?.superview
    }

    return false
  }

  lazy var choppingLabel: UILabel = {
    let label = UILabel(frame: .zero)
    self.overlayWindow.addSubview(label)
    label.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalToSuperview()
      $0.width.equalTo(200)
      $0.height.equalTo(50)
    }

    label.numberOfLines = 2
    label.layer.borderWidth = 2.0
    label.layer.cornerRadius = 8.0
    label.clipsToBounds = true
    label.textAlignment = .center
    label.font = UIFont.boldSystemFont(ofSize: 14.0)
    label.isUserInteractionEnabled = false
    //        label.transform = CGAffineTransform(rotationAngle: 120.0/360.0)

    return label
  }()

  public func chopping(text: String, color: UIColor = UIColor.systemRed.withAlphaComponent(0.35)) {
    choppingLabel.layer.borderColor = color.cgColor
    choppingLabel.textColor = color
    choppingLabel.text = text
  }

  public func removeChopping() {
    choppingLabel.removeFromSuperview()
  }
}

class PBSFingerTapOverlayWindow: UIWindow {
  // UIKit tries to get the rootViewController from the overlay window. Use the Fingertips window instead. This fixes
  // issues with status bar behavior, as otherwise the overlay window would control the status bar.
  func rootViewController() -> UIViewController? {
    let mainWindow = UIApplication.pbs_shared?.windows.first(where: { $0 is PBSFingerTapWindow })
    return mainWindow?.rootViewController ?? super.rootViewController
  }
}
