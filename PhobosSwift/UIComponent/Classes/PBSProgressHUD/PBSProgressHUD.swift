//
//
//  PBSProgressHUD.swift
//  PhobosSwiftUIComponent
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

import PhobosSwiftCore
import SnapKit
import UIKit

@available(iOS 13.0, *)
public enum PBSAnimationType {
  case systemActivityIndicator
  case horizontalCirclesPulse
  case lineScaling
  case singleCirclePulse
  case multipleCirclePulse
  case singleCircleScaleRipple
  case multipleCircleScaleRipple
  case circleSpinFade
  case lineSpinFade
  case circleRotateChase
  case circleStrokeSpin
}

@available(iOS 13.0, *)
public enum PBSAlertIcon {
  case heart
  case like
  case dislike
  case privacy
  case info

  var image: UIImage? {
    switch self {
    case .heart: return UIImage(systemName: "heart.fill")
    case .like: return UIImage(systemName: "hand.thumbsup.fill")
    case .dislike: return UIImage(systemName: "hand.thumbsdown.fill")
    case .privacy: return UIImage(systemName: "hand.raised.fill")
    case .info: return UIImage(systemName: "info.circle")
    }
  }
}

@available(iOS 13.0, *)
public enum PBSBulletinType {
  case success(String?)
  case failed(String?)
  case info(String?)
  case inProgress(String?)
}

@available(iOS 13.0, *)
extension PBSProgressHUD {
  public class var animationType: PBSAnimationType {
    get { shared.animationType }
    set { shared.animationType = newValue }
  }

  public class var colorBackground: UIColor {
    get { shared.colorBackground }
    set { shared.colorBackground = newValue }
  }

  public class var colorHUD: UIColor {
    get { shared.colorHUD }
    set { shared.colorHUD = newValue }
  }

  public class var colorStatus: UIColor {
    get { shared.colorStatus }
    set { shared.colorStatus = newValue }
  }

  public class var colorAnimation: UIColor {
    get { shared.colorAnimation }
    set { shared.colorAnimation = newValue }
  }

  public class var fontStatus: UIFont {
    get { shared.fontStatus }
    set { shared.fontStatus = newValue }
  }

  public class var imageSuccess: UIImage {
    get { shared.imageSuccess }
    set { shared.imageSuccess = newValue }
  }

  public class var imageError: UIImage {
    get { shared.imageError }
    set { shared.imageError = newValue }
  }
}

@available(iOS 13.0, *)
extension PBSProgressHUD {
  public class func dismiss() {
    DispatchQueue.main.async {
      shared.hudHide()
    }
  }

  public class func show(_ status: String? = nil, interaction: Bool = true) {
    DispatchQueue.main.async {
      shared.setup(status: status, hide: false, interaction: interaction)
    }
  }

  public class func show(_ status: String? = nil, icon: PBSAlertIcon, interaction: Bool = true) {
    let image = icon.image?.withTintColor(shared.colorAnimation, renderingMode: .alwaysOriginal)

    DispatchQueue.main.async {
      shared.setup(status: status, staticImage: image, hide: true, interaction: interaction)
    }
  }

  public class func showSuccess(_ status: String? = nil, image: UIImage? = nil, interaction: Bool = true) {
    DispatchQueue.main.async {
      shared.setup(status: status, staticImage: image ?? shared.imageSuccess, hide: true, interaction: interaction)
    }
  }

  public class func showError(_ status: String? = nil, image: UIImage? = nil, interaction: Bool = true) {
    DispatchQueue.main.async {
      shared.setup(status: status, staticImage: image ?? shared.imageError, hide: true, interaction: interaction)
    }
  }

  public class func show(_ bulletinType: PBSBulletinType, interaction: Bool = false) {
    DispatchQueue.main.async {
      switch bulletinType {
      case let .failed(string):
        PBSProgressHUD.colorHUD = UIColor.pbs.color(hex: 0x834040)
        shared.setup(status: string, staticImage: PBSAlertIcon.info.image?.withTintColor(UIColor.pbs.color(hex: 0xE0B912), renderingMode: .alwaysOriginal), hide: true, interaction: interaction)
      case let .success(string):
        PBSProgressHUD.colorHUD = UIColor.pbs.color(hex: 0x234939)
        shared.setup(status: string, staticImage: PBSAlertIcon.info.image?.withTintColor(UIColor.pbs.color(hex: 0xD8D8D8), renderingMode: .alwaysOriginal), hide: true, interaction: interaction)
      case let .info(string):
        PBSProgressHUD.colorHUD = UIColor.pbs.color(hex: 0x45698B)
        shared.setup(status: string, staticImage: PBSAlertIcon.info.image?.withTintColor(UIColor.pbs.color(hex: 0xD8D8D8), renderingMode: .alwaysOriginal), hide: true, interaction: interaction)
      case let .inProgress(string):
        PBSProgressHUD.animationType = .circleSpinFade
        PBSProgressHUD.colorHUD = UIColor.pbs.color(hex: 0x45698B)
        PBSProgressHUD.colorAnimation = .white
        shared.setup(status: string, hide: false, interaction: interaction)
      }
    }
  }
}

@available(iOS 13.0, *)
public class PBSProgressHUD: UIView {
  private var viewBackground: UIView?
  private var toolbarHUD: UIToolbar?
  private var labelStatus: UILabel?

  private var viewAnimation: UIView?
  private var staticImageView: UIImageView?

  private var timer: Timer?

  private var animationType = PBSAnimationType.systemActivityIndicator

  private var colorBackground = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
  private var colorHUD = UIColor.systemGray
  private var colorStatus = UIColor.label
  private var colorAnimation = UIColor.white
  private var colorProgress = UIColor.lightGray

  private var fontStatus = UIFont.boldSystemFont(ofSize: 16)
  private var imageSuccess = UIImage.checkmark.withTintColor(UIColor.systemGreen, renderingMode: .alwaysOriginal)
  private var imageError = UIImage.remove.withTintColor(UIColor.systemRed, renderingMode: .alwaysOriginal)

  static let shared: PBSProgressHUD = {
    let instance = PBSProgressHUD()
    return instance
  }()

  private convenience init() {
    self.init(frame: UIScreen.main.bounds)
    alpha = 0
  }

  internal required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  override private init(frame: CGRect) {
    super.init(frame: frame)
  }

  private func setup(status: String? = nil, staticImage: UIImage? = nil, hide: Bool, interaction: Bool) {
    setupBackground(interaction)
    setupToolbar()
    setupLabel(status)

    if staticImage == nil { setupAnimation() }
    if staticImage != nil { setupStaticImage(staticImage) }

    setupSize()

    hudShow()

    if hide {
      timer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { _ in
        self.hudHide()
      }
    }
  }

  private func setupBackground(_ interaction: Bool) {
    if viewBackground == nil {
      let mainWindow = UIApplication.shared.windows.first ?? UIWindow()
      viewBackground = UIView(frame: bounds)
      mainWindow.addSubview(viewBackground!)
    }

    viewBackground?.backgroundColor = interaction ? .clear : colorBackground
    viewBackground?.isUserInteractionEnabled = (interaction == false)
  }

  private func setupToolbar() {
    if toolbarHUD == nil {
      toolbarHUD = UIToolbar(frame: CGRect.zero)
      toolbarHUD?.isTranslucent = true
      toolbarHUD?.clipsToBounds = true
      toolbarHUD?.layer.cornerRadius = 12
      toolbarHUD?.layer.masksToBounds = true
      viewBackground?.addSubview(toolbarHUD!)
    }

    toolbarHUD?.backgroundColor = colorHUD
  }

  private func setupLabel(_ status: String?) {
    if labelStatus == nil {
      labelStatus = UILabel()
      labelStatus?.textAlignment = .left
      labelStatus?.baselineAdjustment = .alignCenters
      labelStatus?.numberOfLines = 0
      toolbarHUD?.addSubview(labelStatus!)
    }

    labelStatus?.text = (status != "") ? status : nil
    labelStatus?.font = fontStatus
    labelStatus?.textColor = colorStatus
    labelStatus?.isHidden = (status == nil) ? true : false
  }

  private func setupAnimation() {
    staticImageView?.removeFromSuperview()

    if viewAnimation == nil {
      viewAnimation = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
    }

    if viewAnimation?.superview == nil {
      toolbarHUD?.addSubview(viewAnimation!)
    }

    viewAnimation?.subviews.forEach {
      $0.removeFromSuperview()
    }

    viewAnimation?.layer.sublayers?.forEach {
      $0.removeFromSuperlayer()
    }

    if animationType == .systemActivityIndicator { animationSystemActivityIndicator(viewAnimation!) }
    if animationType == .horizontalCirclesPulse { animationHorizontalCirclesPulse(viewAnimation!) }
    if animationType == .lineScaling { animationLineScaling(viewAnimation!) }
    if animationType == .singleCirclePulse { animationSingleCirclePulse(viewAnimation!) }
    if animationType == .multipleCirclePulse { animationMultipleCirclePulse(viewAnimation!) }
    if animationType == .singleCircleScaleRipple { animationSingleCircleScaleRipple(viewAnimation!) }
    if animationType == .multipleCircleScaleRipple { animationMultipleCircleScaleRipple(viewAnimation!) }
    if animationType == .circleSpinFade { animationCircleSpinFade(viewAnimation!) }
    if animationType == .lineSpinFade { animationLineSpinFade(viewAnimation!) }
    if animationType == .circleRotateChase { animationCircleRotateChase(viewAnimation!) }
    if animationType == .circleStrokeSpin { animationCircleStrokeSpin(viewAnimation!) }
  }

  private func setupStaticImage(_ staticImage: UIImage?) {
    viewAnimation?.removeFromSuperview()

    if staticImageView == nil {
      staticImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 22, height: 22))
    }

    if staticImageView?.superview == nil {
      toolbarHUD?.addSubview(staticImageView!)
    }

    staticImageView?.image = staticImage
    staticImageView?.contentMode = .scaleAspectFit
  }

  private func setupSize() {
    var width: CGFloat = UIScreen.main.bounds.size.width - 18 * 2
    var height: CGFloat = 66

    toolbarHUD?.bounds = CGRect(x: 0, y: 0, width: width, height: height)

    if viewAnimation?.superview != nil {
      viewAnimation?.snp.makeConstraints {
        $0.centerY.equalToSuperview()
        $0.right.equalToSuperview().offset(-16)
        $0.size.equalTo(40)
      }
    }
    if staticImageView?.superview != nil {
      staticImageView?.snp.makeConstraints {
        $0.centerY.equalToSuperview()
        $0.size.equalTo(22)
        $0.left.equalToSuperview().offset(16)
      }
    }

    if labelStatus?.superview != nil {
      labelStatus?.snp.makeConstraints {
        $0.centerY.equalToSuperview()
        $0.left.equalToSuperview().offset(49)
        $0.right.equalToSuperview().offset(-50)
      }
    }

//    if let text = labelStatus?.text {
//      let sizeMax = CGSize(width: 250, height: 250)
//      let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: labelStatus?.font as Any]
//      var rectLabel = text.boundingRect(with: sizeMax, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
//
//      width = ceil(rectLabel.size.width) + 60
//      height = ceil(rectLabel.size.height) + 120
//
//      if width < 120 { width = 120 }
//
//      rectLabel.origin.x = (width - rectLabel.size.width) / 2
//      rectLabel.origin.y = (height - rectLabel.size.height) / 2 + 45
//
//      labelStatus?.frame = rectLabel
//    }

//    let centerX = width / 2
//    var centerY = height + 33
//
//    if labelStatus?.text != nil { centerY = 55 }
//
//    viewAnimation?.center = CGPoint(x: centerX, y: centerY)
//    staticImageView?.center = CGPoint(x: centerX, y: centerY)
  }

  private func hudShow() {
    timer?.invalidate()
    timer = nil

    if alpha != 1 {
      alpha = 1
      toolbarHUD?.alpha = 0
      let screen = UIScreen.main.bounds
      toolbarHUD?.center = CGPoint(x: screen.size.width / 2, y: screen.size.height + 33)

      UIView.animate(withDuration: 0.15, delay: 0, options: [.allowUserInteraction], animations: {
        self.toolbarHUD?.center = CGPoint(x: screen.size.width / 2, y: screen.size.height - 76)
        self.toolbarHUD?.alpha = 1
      }, completion: nil)
    }
  }

  private func hudHide() {
    if alpha == 1 {
      let screen = UIScreen.main.bounds
      UIView.animate(withDuration: 0.15, delay: 0, options: [.allowUserInteraction], animations: {
        self.toolbarHUD?.center = CGPoint(x: screen.size.width / 2, y: screen.size.height + 33)
        self.toolbarHUD?.alpha = 0
      }, completion: { _ in
        self.hudDestroy()
        self.alpha = 0
      })
    }
  }

  private func hudDestroy() {
    NotificationCenter.default.removeObserver(self)

    staticImageView?.removeFromSuperview(); staticImageView = nil
    viewAnimation?.removeFromSuperview(); viewAnimation = nil

    labelStatus?.removeFromSuperview(); labelStatus = nil
    toolbarHUD?.removeFromSuperview(); toolbarHUD = nil
    viewBackground?.removeFromSuperview(); viewBackground = nil

    timer?.invalidate()
    timer = nil
  }

  // MARK: - Animation

  private func animationSystemActivityIndicator(_ view: UIView) {
    let spinner = UIActivityIndicatorView(style: .large)
    spinner.frame = view.bounds
    spinner.color = colorAnimation
    spinner.hidesWhenStopped = true
    spinner.startAnimating()
    spinner.transform = CGAffineTransform(scaleX: 1.6, y: 1.6)
    view.addSubview(spinner)
  }

  private func animationHorizontalCirclesPulse(_ view: UIView) {
    let width = view.frame.size.width
    let height = view.frame.size.height

    let spacing: CGFloat = 3
    let radius: CGFloat = (width - spacing * 2) / 3
    let ypos: CGFloat = (height - radius) / 2

    let beginTime = CACurrentMediaTime()
    let beginTimes = [0.36, 0.24, 0.12]
    let timingFunction = CAMediaTimingFunction(controlPoints: 0.2, 0.68, 0.18, 1.08)

    let animation = CAKeyframeAnimation(keyPath: "transform.scale")
    animation.keyTimes = [0, 0.5, 1]
    animation.timingFunctions = [timingFunction, timingFunction]
    animation.values = [1, 0.3, 1]
    animation.duration = 1
    animation.repeatCount = HUGE
    animation.isRemovedOnCompletion = false

    let path = UIBezierPath(arcCenter: CGPoint(x: radius / 2, y: radius / 2), radius: radius / 2, startAngle: 0, endAngle: 2 * .pi, clockwise: false)

    for i in 0..<3 {
      let layer = CAShapeLayer()
      layer.frame = CGRect(x: (radius + spacing) * CGFloat(i), y: ypos, width: radius, height: radius)
      layer.path = path.cgPath
      layer.fillColor = colorAnimation.cgColor

      animation.beginTime = beginTime - beginTimes[i]

      layer.add(animation, forKey: "animation")
      view.layer.addSublayer(layer)
    }
  }

  private func animationLineScaling(_ view: UIView) {
    let width = view.frame.size.width
    let height = view.frame.size.height

    let lineWidth = width / 9

    let beginTime = CACurrentMediaTime()
    let beginTimes = [0.5, 0.4, 0.3, 0.2, 0.1]
    let timingFunction = CAMediaTimingFunction(controlPoints: 0.2, 0.68, 0.18, 1.08)

    let animation = CAKeyframeAnimation(keyPath: "transform.scale.y")
    animation.keyTimes = [0, 0.5, 1]
    animation.timingFunctions = [timingFunction, timingFunction]
    animation.values = [1, 0.4, 1]
    animation.duration = 1
    animation.repeatCount = HUGE
    animation.isRemovedOnCompletion = false

    let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: lineWidth, height: height), cornerRadius: width / 2)

    for i in 0..<5 {
      let layer = CAShapeLayer()
      layer.frame = CGRect(x: lineWidth * 2 * CGFloat(i), y: 0, width: lineWidth, height: height)
      layer.path = path.cgPath
      layer.backgroundColor = nil
      layer.fillColor = colorAnimation.cgColor

      animation.beginTime = beginTime - beginTimes[i]

      layer.add(animation, forKey: "animation")
      view.layer.addSublayer(layer)
    }
  }

  private func animationSingleCirclePulse(_ view: UIView) {
    let width = view.frame.size.width
    let height = view.frame.size.height

    let duration: CFTimeInterval = 1.0

    let animationScale = CABasicAnimation(keyPath: "transform.scale")
    animationScale.duration = duration
    animationScale.fromValue = 0
    animationScale.toValue = 1

    let animationOpacity = CABasicAnimation(keyPath: "opacity")
    animationOpacity.duration = duration
    animationOpacity.fromValue = 1
    animationOpacity.toValue = 0

    let animation = CAAnimationGroup()
    animation.animations = [animationScale, animationOpacity]
    animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
    animation.duration = duration
    animation.repeatCount = HUGE
    animation.isRemovedOnCompletion = false

    let path = UIBezierPath(arcCenter: CGPoint(x: width / 2, y: height / 2), radius: width / 2, startAngle: 0, endAngle: 2 * .pi, clockwise: false)

    let layer = CAShapeLayer()
    layer.frame = CGRect(x: 0, y: 0, width: width, height: height)
    layer.path = path.cgPath
    layer.fillColor = colorAnimation.cgColor

    layer.add(animation, forKey: "animation")
    view.layer.addSublayer(layer)
  }

  private func animationMultipleCirclePulse(_ view: UIView) {
    let width = view.frame.size.width
    let height = view.frame.size.height

    let duration = 1.0
    let beginTime = CACurrentMediaTime()
    let beginTimes = [0, 0.3, 0.6]

    let animationScale = CABasicAnimation(keyPath: "transform.scale")
    animationScale.duration = duration
    animationScale.fromValue = 0
    animationScale.toValue = 1

    let animationOpacity = CAKeyframeAnimation(keyPath: "opacity")
    animationOpacity.duration = duration
    animationOpacity.keyTimes = [0, 0.05, 1]
    animationOpacity.values = [0, 1, 0]

    let animation = CAAnimationGroup()
    animation.animations = [animationScale, animationOpacity]
    animation.timingFunction = CAMediaTimingFunction(name: .linear)
    animation.duration = duration
    animation.repeatCount = HUGE
    animation.isRemovedOnCompletion = false

    let path = UIBezierPath(arcCenter: CGPoint(x: width / 2, y: height / 2), radius: width / 2, startAngle: 0, endAngle: 2 * .pi, clockwise: false)

    for i in 0..<3 {
      let layer = CAShapeLayer()
      layer.frame = CGRect(x: 0, y: 0, width: width, height: height)
      layer.path = path.cgPath
      layer.fillColor = colorAnimation.cgColor
      layer.opacity = 0

      animation.beginTime = beginTime + beginTimes[i]

      layer.add(animation, forKey: "animation")
      view.layer.addSublayer(layer)
    }
  }

  private func animationSingleCircleScaleRipple(_ view: UIView) {
    let width = view.frame.size.width
    let height = view.frame.size.height

    let duration: CFTimeInterval = 1.0
    let timingFunction = CAMediaTimingFunction(controlPoints: 0.21, 0.53, 0.56, 0.8)

    let animationScale = CAKeyframeAnimation(keyPath: "transform.scale")
    animationScale.keyTimes = [0, 0.7]
    animationScale.timingFunction = timingFunction
    animationScale.values = [0.1, 1]
    animationScale.duration = duration

    let animationOpacity = CAKeyframeAnimation(keyPath: "opacity")
    animationOpacity.keyTimes = [0, 0.7, 1]
    animationOpacity.timingFunctions = [timingFunction, timingFunction]
    animationOpacity.values = [1, 0.7, 0]
    animationOpacity.duration = duration

    let animation = CAAnimationGroup()
    animation.animations = [animationScale, animationOpacity]
    animation.duration = duration
    animation.repeatCount = HUGE
    animation.isRemovedOnCompletion = false

    let path = UIBezierPath(arcCenter: CGPoint(x: width / 2, y: height / 2), radius: width / 2, startAngle: 0, endAngle: 2 * .pi, clockwise: false)

    let layer = CAShapeLayer()
    layer.frame = CGRect(x: 0, y: 0, width: width, height: height)
    layer.path = path.cgPath
    layer.backgroundColor = nil
    layer.fillColor = nil
    layer.strokeColor = colorAnimation.cgColor
    layer.lineWidth = 3

    layer.add(animation, forKey: "animation")
    view.layer.addSublayer(layer)
  }

  private func animationMultipleCircleScaleRipple(_ view: UIView) {
    let width = view.frame.size.width
    let height = view.frame.size.height

    let duration = 1.25
    let beginTime = CACurrentMediaTime()
    let beginTimes = [0, 0.2, 0.4]
    let timingFunction = CAMediaTimingFunction(controlPoints: 0.21, 0.53, 0.56, 0.8)

    let animationScale = CAKeyframeAnimation(keyPath: "transform.scale")
    animationScale.keyTimes = [0, 0.7]
    animationScale.timingFunction = timingFunction
    animationScale.values = [0, 1]
    animationScale.duration = duration

    let animationOpacity = CAKeyframeAnimation(keyPath: "opacity")
    animationOpacity.keyTimes = [0, 0.7, 1]
    animationOpacity.timingFunctions = [timingFunction, timingFunction]
    animationOpacity.values = [1, 0.7, 0]
    animationOpacity.duration = duration

    let animation = CAAnimationGroup()
    animation.animations = [animationScale, animationOpacity]
    animation.duration = duration
    animation.repeatCount = HUGE
    animation.isRemovedOnCompletion = false

    let path = UIBezierPath(arcCenter: CGPoint(x: width / 2, y: height / 2), radius: width / 2, startAngle: 0, endAngle: 2 * .pi, clockwise: false)

    for i in 0..<3 {
      let layer = CAShapeLayer()
      layer.frame = CGRect(x: 0, y: 0, width: width, height: height)
      layer.path = path.cgPath
      layer.backgroundColor = nil
      layer.strokeColor = colorAnimation.cgColor
      layer.lineWidth = 3
      layer.fillColor = nil

      animation.beginTime = beginTime + beginTimes[i]

      layer.add(animation, forKey: "animation")
      view.layer.addSublayer(layer)
    }
  }

  private func animationCircleSpinFade(_ view: UIView) {
    let width = view.frame.size.width

    let spacing: CGFloat = 3
    let radius = (width - 4 * spacing) / 3.5
    let radiusX = (width - radius) / 2

    let duration = 1.0
    let beginTime = CACurrentMediaTime()
    let beginTimes: [CFTimeInterval] = [0.84, 0.72, 0.6, 0.48, 0.36, 0.24, 0.12, 0]

    let animationScale = CAKeyframeAnimation(keyPath: "transform.scale")
    animationScale.keyTimes = [0, 0.5, 1]
    animationScale.values = [1, 0.4, 1]
    animationScale.duration = duration

    let animationOpacity = CAKeyframeAnimation(keyPath: "opacity")
    animationOpacity.keyTimes = [0, 0.5, 1]
    animationOpacity.values = [1, 0.3, 1]
    animationOpacity.duration = duration

    let animation = CAAnimationGroup()
    animation.animations = [animationScale, animationOpacity]
    animation.timingFunction = CAMediaTimingFunction(name: .linear)
    animation.duration = duration
    animation.repeatCount = HUGE
    animation.isRemovedOnCompletion = false

    let path = UIBezierPath(arcCenter: CGPoint(x: radius / 2, y: radius / 2), radius: radius / 2, startAngle: 0, endAngle: 2 * .pi, clockwise: false)

    for i in 0..<8 {
      let angle = .pi / 4 * CGFloat(i)

      let layer = CAShapeLayer()
      layer.path = path.cgPath
      layer.fillColor = colorAnimation.cgColor
      layer.backgroundColor = nil
      layer.frame = CGRect(x: radiusX * (cos(angle) + 1), y: radiusX * (sin(angle) + 1), width: radius, height: radius)

      animation.beginTime = beginTime - beginTimes[i]

      layer.add(animation, forKey: "animation")
      view.layer.addSublayer(layer)
    }
  }

  private func animationLineSpinFade(_ view: UIView) {
    let width = view.frame.size.width
    let height = view.frame.size.height

    let spacing: CGFloat = 3
    let lineWidth = (width - 4 * spacing) / 5
    let lineHeight = (height - 2 * spacing) / 3
    let containerSize = max(lineWidth, lineHeight)
    let radius = width / 2 - containerSize / 2

    let duration = 1.2
    let beginTime = CACurrentMediaTime()
    let beginTimes: [CFTimeInterval] = [0.96, 0.84, 0.72, 0.6, 0.48, 0.36, 0.24, 0.12]
    let timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

    let animation = CAKeyframeAnimation(keyPath: "opacity")
    animation.keyTimes = [0, 0.5, 1]
    animation.timingFunctions = [timingFunction, timingFunction]
    animation.values = [1, 0.3, 1]
    animation.duration = duration
    animation.repeatCount = HUGE
    animation.isRemovedOnCompletion = false

    let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: lineWidth, height: lineHeight), cornerRadius: lineWidth / 2)

    for i in 0..<8 {
      let angle = .pi / 4 * CGFloat(i)

      let line = CAShapeLayer()
      line.frame = CGRect(x: (containerSize - lineWidth) / 2, y: (containerSize - lineHeight) / 2, width: lineWidth, height: lineHeight)
      line.path = path.cgPath
      line.backgroundColor = nil
      line.fillColor = colorAnimation.cgColor

      let container = CALayer()
      container.frame = CGRect(x: radius * (cos(angle) + 1), y: radius * (sin(angle) + 1), width: containerSize, height: containerSize)
      container.addSublayer(line)
      container.sublayerTransform = CATransform3DMakeRotation(.pi / 2 + angle, 0, 0, 1)

      animation.beginTime = beginTime - beginTimes[i]

      container.add(animation, forKey: "animation")
      view.layer.addSublayer(container)
    }
  }

  private func animationCircleRotateChase(_ view: UIView) {
    let width = view.frame.size.width
    let height = view.frame.size.height

    let spacing: CGFloat = 3
    let radius = (width - 4 * spacing) / 3.5
    let radiusX = (width - radius) / 2

    let duration: CFTimeInterval = 1.5

    let path = UIBezierPath(arcCenter: CGPoint(x: radius / 2, y: radius / 2), radius: radius / 2, startAngle: 0, endAngle: 2 * .pi, clockwise: false)

    let pathPosition = UIBezierPath(arcCenter: CGPoint(x: width / 2, y: height / 2), radius: radiusX, startAngle: 1.5 * .pi, endAngle: 3.5 * .pi, clockwise: true)

    for i in 0..<5 {
      let rate = Float(i) * 1 / 5
      let fromScale = 1 - rate
      let toScale = 0.2 + rate
      let timeFunc = CAMediaTimingFunction(controlPoints: 0.5, 0.15 + rate, 0.25, 1)

      let animationScale = CABasicAnimation(keyPath: "transform.scale")
      animationScale.duration = duration
      animationScale.repeatCount = HUGE
      animationScale.fromValue = fromScale
      animationScale.toValue = toScale

      let animationPosition = CAKeyframeAnimation(keyPath: "position")
      animationPosition.duration = duration
      animationPosition.repeatCount = HUGE
      animationPosition.path = pathPosition.cgPath

      let animation = CAAnimationGroup()
      animation.animations = [animationScale, animationPosition]
      animation.timingFunction = timeFunc
      animation.duration = duration
      animation.repeatCount = HUGE
      animation.isRemovedOnCompletion = false

      let layer = CAShapeLayer()
      layer.frame = CGRect(x: 0, y: 0, width: radius, height: radius)
      layer.path = path.cgPath
      layer.fillColor = colorAnimation.cgColor

      layer.add(animation, forKey: "animation")
      view.layer.addSublayer(layer)
    }
  }

  private func animationCircleStrokeSpin(_ view: UIView) {
    let width = view.frame.size.width
    let height = view.frame.size.height

    let beginTime: Double = 0.5
    let durationStart: Double = 1.2
    let durationStop: Double = 0.7

    let animationRotation = CABasicAnimation(keyPath: "transform.rotation")
    animationRotation.byValue = 2 * Float.pi
    animationRotation.timingFunction = CAMediaTimingFunction(name: .linear)

    let animationStart = CABasicAnimation(keyPath: "strokeStart")
    animationStart.duration = durationStart
    animationStart.timingFunction = CAMediaTimingFunction(controlPoints: 0.4, 0, 0.2, 1)
    animationStart.fromValue = 0
    animationStart.toValue = 1
    animationStart.beginTime = beginTime

    let animationStop = CABasicAnimation(keyPath: "strokeEnd")
    animationStop.duration = durationStop
    animationStop.timingFunction = CAMediaTimingFunction(controlPoints: 0.4, 0, 0.2, 1)
    animationStop.fromValue = 0
    animationStop.toValue = 1

    let animation = CAAnimationGroup()
    animation.animations = [animationRotation, animationStop, animationStart]
    animation.duration = durationStart + beginTime
    animation.repeatCount = .infinity
    animation.isRemovedOnCompletion = false
    animation.fillMode = .forwards

    let path = UIBezierPath(arcCenter: CGPoint(x: width / 2, y: height / 2), radius: width / 2, startAngle: -0.5 * .pi, endAngle: 1.5 * .pi, clockwise: true)

    let layer = CAShapeLayer()
    layer.frame = CGRect(x: 0, y: 0, width: width, height: height)
    layer.path = path.cgPath
    layer.fillColor = nil
    layer.strokeColor = colorAnimation.cgColor
    layer.lineWidth = 3

    layer.add(animation, forKey: "animation")
    view.layer.addSublayer(layer)
  }
}
