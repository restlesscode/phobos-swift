//
//
//  UIView.swift
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

import UIKit

extension UIView: PhobosSwiftCompatible {}

/// # Enhanced features of UIView class is implemented in this extension
extension PhobosSwift where Base: UIView {
  // MARK: Gradient Background

  /// ## 设置梯度背景色
  ///
  public func applyGradientBackground(colorset: [UIColor],
                                      startPoint: CGPoint,
                                      endPoint: CGPoint,
                                      cornerRadius: CGFloat,
                                      gradientLayerFrame: CGRect?,
                                      gradientLayerMaskedCorners: CACornerMask,
                                      isRemoveExistingGradient: Bool) {
    if isRemoveExistingGradient {
      removeGradientBackground()
    }

    let gradientLayer = CAGradientLayer()

    gradientLayer.frame = gradientLayerFrame ?? base.bounds

    gradientLayer.colors = colorset.map { color -> CGColor in
      color.cgColor
    }
    gradientLayer.startPoint = startPoint
    gradientLayer.endPoint = endPoint
    gradientLayer.cornerRadius = cornerRadius
    if #available(iOS 11.0, *) {
      gradientLayer.maskedCorners = gradientLayerMaskedCorners
    }
    gradientLayer.masksToBounds = true

    base.layer.insertSublayer(gradientLayer, at: 0)
  }

  /// remove current gradient background
  public func removeGradientBackground() {
    let gradientLayers = base.layer.sublayers?.filter {
      $0.isKind(of: CAGradientLayer.self)
    }
    gradientLayers?.forEach {
      $0.removeFromSuperlayer()
    }
  }

  /// 设置水平梯度背景色
  ///
  public func applyHorizontalGradientBackground(colorset: [UIColor],
                                                cornerRadius: CGFloat = 0.0,
                                                gradientLayerFrame: CGRect? = nil,
                                                gradientLayerMaskedCorners: CACornerMask = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner],
                                                isRemoveExistingGradient: Bool = true) {
    applyGradientBackground(colorset: colorset,
                            startPoint: CGPoint(x: 0, y: 0),
                            endPoint: CGPoint(x: 1, y: 0),
                            cornerRadius: cornerRadius,
                            gradientLayerFrame: gradientLayerFrame,
                            gradientLayerMaskedCorners: gradientLayerMaskedCorners,
                            isRemoveExistingGradient: isRemoveExistingGradient)
  }

  /// 设置水平垂直背景色
  ///
  public func applyVerticalGradientBackground(colorset: [UIColor],
                                              cornerRadius: CGFloat = 0.0,
                                              gradientLayerFrame: CGRect? = nil,
                                              gradientLayerMaskedCorners: CACornerMask = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner],
                                              isRemoveExistingGradient: Bool = true) {
    applyGradientBackground(colorset: colorset,
                            startPoint: CGPoint(x: 0, y: 0),
                            endPoint: CGPoint(x: 0, y: 1),
                            cornerRadius: cornerRadius,
                            gradientLayerFrame: gradientLayerFrame,
                            gradientLayerMaskedCorners: gradientLayerMaskedCorners,
                            isRemoveExistingGradient: isRemoveExistingGradient)
  }

  /// 设置水平垂直背景色
  ///
  public func applyUpLeftToBottomRightGradientBackground(colorset: [UIColor],
                                                         cornerRadius: CGFloat = 0.0,
                                                         gradientLayerFrame: CGRect? = nil,
                                                         gradientLayerMaskedCorners: CACornerMask = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner],
                                                         isRemoveExistingGradient: Bool = true) {
    applyGradientBackground(colorset: colorset,
                            startPoint: CGPoint(x: 0.25, y: 0.25),
                            endPoint: CGPoint(x: 1, y: 1),
                            cornerRadius: cornerRadius,
                            gradientLayerFrame: gradientLayerFrame,
                            gradientLayerMaskedCorners: gradientLayerMaskedCorners,
                            isRemoveExistingGradient: isRemoveExistingGradient)
  }

  /// 设置斜线背景色
  ///
  public func applyUpRightToBottomLeftGradientBackground(colorset: [UIColor],
                                                         cornerRadius: CGFloat = 0.0,
                                                         gradientLayerFrame: CGRect? = nil,
                                                         gradientLayerMaskedCorners: CACornerMask = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner],
                                                         isRemoveExistingGradient: Bool = true) {
    applyGradientBackground(colorset: colorset,
                            startPoint: CGPoint(x: 0.75, y: 0.75),
                            endPoint: CGPoint(x: 0, y: 1),
                            cornerRadius: cornerRadius,
                            gradientLayerFrame: gradientLayerFrame,
                            gradientLayerMaskedCorners: gradientLayerMaskedCorners,
                            isRemoveExistingGradient: isRemoveExistingGradient)
  }
}

/// # Enhanced features of UIView class is implemented in this extension
extension PhobosSwift where Base: UIView {
  /// 判断触点是否在范围内
  public func isTouched(byLocation: CGPoint, leeaway: CGFloat = 22) -> Bool {
    byLocation.x <= base.bounds.width +
      leeaway && byLocation.x >= 0 - leeaway && byLocation.y <= base.bounds.height +
      leeaway && byLocation.y >= 0 - leeaway
  }
}

// MARK: - Shadow

extension PhobosSwift where Base: UIView {
  /// ## Add a shadow for this view
  ///
  /// Color is black
  public func addShadow(radius: CGFloat, scale: Bool = true) {
    addShadow(color: .black, opacity: 0.5, offSet: .zero, radius: radius, scale: scale)
  }

  /// ## Add a shadow for this view
  ///
  public func addShadow(color: UIColor,
                        opacity: Float = 0.5,
                        offSet: CGSize = .zero,
                        radius: CGFloat = 1,
                        scale: Bool = true,
                        shadowPath: CGPath? = nil) {
    // layer.masksToBounds = false
    base.clipsToBounds = false
    base.layer.shadowColor = color.cgColor
    base.layer.shadowOpacity = opacity
    base.layer.shadowOffset = offSet
    base.layer.shadowRadius = radius

    base.layer.shadowPath = shadowPath
    base.layer.shouldRasterize = true
    base.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
  }
}

// MARK: - Navigator

extension PhobosSwift where Base: UIView {
  ///
  public var firstNavigationController: UINavigationController? {
    if let vc = base.next as? UIViewController {
      if let navCtrl = vc.navigationController {
        return navCtrl
      }
    }

    for subview in base.subviews {
      return subview.pbs.firstNavigationController
    }

    return nil
  }
}

// MARK: - Triangle Indicator

extension PhobosSwift where Base: UIView {
  ///
  public enum IndicatorShapeMode {
    ///
    case upper
    ///
    case lower
  }

  ///
  public static func makeBottomIndicatorShape(onView view: UIView, radius: CGFloat, indicatorSize: CGSize = CGSize(width: 8, height: 4)) {
    /*
     * 形状如下：
     *
     A/B--------------------C\D
     |                      |
     |                      |
     L\K-------J    G-------F/E
     \  /
     I--H
     *
     */

    let deltaY: CGFloat = indicatorSize.height
    let deltaX: CGFloat = indicatorSize.width

    let bezierPath = UIBezierPath()
    let rect = view.bounds

    // 移动到B点
    bezierPath.move(to: CGPoint(x: radius, y: 0))
    // 画-线 BC
    bezierPath.addLine(to: CGPoint(x: rect.maxX - radius, y: 0))
    // 画-圆角 CD
    bezierPath.addCurve(to: CGPoint(x: rect.width, y: radius),
                        controlPoint1: CGPoint(x: rect.maxX - radius / 2, y: 0),
                        controlPoint2: CGPoint(x: rect.width, y: radius / 2))
    // 画-线 DE
    bezierPath.addLine(to: CGPoint(x: rect.width, y: rect.maxY - deltaY - radius))
    // 画-圆角 EF
    bezierPath.addCurve(to: CGPoint(x: rect.maxX - radius, y: rect.maxY - deltaY),
                        controlPoint1: CGPoint(x: rect.width, y: rect.maxY - deltaY - radius / 2),
                        controlPoint2: CGPoint(x: rect.maxX - radius / 2, y: rect.maxY - deltaY))
    // 画-线 FG
    bezierPath.addLine(to: CGPoint(x: rect.maxX - rect.width / 2.0 + deltaX, y: rect.maxY - deltaY))

    // 画-圆角 GH
    bezierPath.addCurve(to: CGPoint(x: rect.maxX - rect.width / 2.0 + deltaX * 0.75, y: rect.maxY - deltaY),
                        controlPoint1: CGPoint(x: rect.maxX - rect.width / 2.0 + deltaX, y: rect.maxY - deltaY),
                        controlPoint2: CGPoint(x: rect.maxX - rect.width / 2.0 + deltaX, y: rect.maxY - deltaY))
    bezierPath.addLine(to: CGPoint(x: rect.maxX - rect.width / 2.0 + deltaX * 0.25, y: rect.maxY - deltaY * 0.5))

    // 画-圆角 HI
    bezierPath.addCurve(to: CGPoint(x: rect.maxX - rect.width / 2.0 - deltaX * 0.25, y: rect.maxY - deltaY * 0.5),
                        controlPoint1: CGPoint(x: rect.maxX - rect.width / 2.0 + deltaX * 0.125, y: rect.maxY),
                        controlPoint2: CGPoint(x: rect.maxX - rect.width / 2.0 - deltaX * 0.125, y: rect.maxY))

    // 画-圆角 IJ
    bezierPath.addLine(to: CGPoint(x: rect.maxX - rect.width / 2.0 - deltaX * 0.75, y: rect.maxY - deltaY))
    bezierPath.addCurve(to: CGPoint(x: rect.maxX - rect.width / 2.0 - deltaX, y: rect.maxY - deltaY),
                        controlPoint1: CGPoint(x: 30.28, y: rect.maxY - deltaY * 0.625),
                        controlPoint2: CGPoint(x: rect.maxX - rect.width / 2.0 - deltaX * 0.875, y: rect.maxY - deltaY))

    // 画-线 JK
    bezierPath.addLine(to: CGPoint(x: radius, y: rect.maxY - deltaY))
    // 画-圆角 KL
    bezierPath.addCurve(to: CGPoint(x: 0, y: rect.maxY - deltaY - radius),
                        controlPoint1: CGPoint(x: radius / 2, y: rect.maxY - deltaY),
                        controlPoint2: CGPoint(x: 0, y: rect.maxY - deltaY - radius / 2))
    // 画-线 LA
    bezierPath.addLine(to: CGPoint(x: 0, y: radius))
    // 画-圆角 AB
    bezierPath.addCurve(to: CGPoint(x: radius, y: 0), controlPoint1: CGPoint(x: 0, y: radius / 2), controlPoint2: CGPoint(x: radius / 2, y: 0))
    bezierPath.close()
    bezierPath.usesEvenOddFillRule = true

    let shapLayer = CAShapeLayer()
    shapLayer.path = bezierPath.cgPath
    view.layer.mask = shapLayer
  }

  ///
  public static func makeIndicatorShape(onView view: UIView, mode: IndicatorShapeMode) {
    let rect = view.bounds

    let deltaY: CGFloat = 8
    let deltaX: CGFloat = 10

    let pointX: CGFloat = rect.width / 2.0

    var points: [CGPoint] = []

    switch mode {
    case .upper:
      let pointX: CGFloat = rect.width / 2.0
      points = [CGPoint(x: rect.minX, y: rect.minY + deltaY),
                CGPoint(x: rect.minX, y: rect.maxY),
                CGPoint(x: rect.maxX, y: rect.maxY),
                CGPoint(x: rect.maxX, y: rect.minY + deltaY),
                CGPoint(x: pointX + deltaX, y: rect.minY + deltaY),
                CGPoint(x: pointX, y: rect.minY),
                CGPoint(x: pointX - deltaX, y: rect.minY + deltaY)]
    case .lower:
      points = [CGPoint(x: rect.minX, y: rect.minY),
                CGPoint(x: rect.minX, y: rect.maxY - deltaY),
                CGPoint(x: pointX - deltaX, y: rect.maxY - deltaY),
                CGPoint(x: pointX, y: rect.maxY),
                CGPoint(x: pointX + deltaX, y: rect.maxY - deltaY),
                CGPoint(x: rect.maxX, y: rect.maxY - deltaY),
                CGPoint(x: rect.maxX, y: rect.minY)]
    }

    Self.drawShape(on: view.layer, points: points)
  }

  /// 只可以在view的上部和下部任意X坐标增加指示器
  public static func makeIndicatorShape(at pointX: CGFloat, to view: UIView, mode: IndicatorShapeMode) {
    let rect = view.bounds
    let deltaY: CGFloat = 8
    let deltaX: CGFloat = 10

    if pointX > (rect.maxX - 2 * deltaX) || pointX < deltaX * 2 {
      return
    }

    var points: [CGPoint] = []

    switch mode {
    case .upper:

      points = [CGPoint(x: rect.minX, y: rect.minY + deltaY),
                CGPoint(x: rect.minX, y: rect.maxY),
                CGPoint(x: rect.maxX, y: rect.maxY),
                CGPoint(x: rect.maxX, y: rect.minY + deltaY),
                CGPoint(x: pointX + deltaX, y: rect.minY + deltaY),
                CGPoint(x: pointX, y: rect.minY),
                CGPoint(x: pointX - deltaX, y: rect.minY + deltaY)]
    case .lower:
      points = [CGPoint(x: rect.minX, y: rect.minY),
                CGPoint(x: rect.minX, y: rect.maxY - deltaY),
                CGPoint(x: pointX - deltaX, y: rect.maxY - deltaY),
                CGPoint(x: pointX, y: rect.maxY),
                CGPoint(x: pointX + deltaX, y: rect.maxY - deltaY),
                CGPoint(x: rect.maxX, y: rect.maxY - deltaY),
                CGPoint(x: rect.maxX, y: rect.minY)]
    }

    Self.drawShape(on: view.layer, points: points)
  }

  private static func drawShape(on layer: CALayer, points: [CGPoint]) {
    guard let firstPoint = points.first else {
      return
    }

    let path = UIBezierPath()

    path.move(to: firstPoint)

    points.forEach {
      path.addLine(to: $0)
    }

    path.addLine(to: firstPoint)
    path.close()

    let shapLayer = CAShapeLayer()
    shapLayer.path = path.cgPath
    layer.mask = shapLayer
  }
}
