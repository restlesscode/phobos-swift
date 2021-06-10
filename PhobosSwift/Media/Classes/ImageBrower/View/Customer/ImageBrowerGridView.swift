//
//
//  ImageBrowerGridView.swift
//  PhobosSwiftMedia
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

class ImageBrowerGridMaskLayer: CAShapeLayer {
  var maskColor: CGColor! {
    didSet {
      fillColor = maskColor
      fillRule = CAShapeLayerFillRule.evenOdd
    }
  }

  var maskRect: CGRect! {
    didSet {
      setMaskRect(animated: true)
    }
  }

  private let animationKey = "MaskLayerAnimate"
  private lazy var animation: CAAnimation = {
    let animation = CABasicAnimation(keyPath: "opacity")
    animation.duration = 0.2
    animation.fromValue = NSNumber(0)
    animation.toValue = NSNumber(1)
    return animation
  }()

  override init() {
    super.init()
    contentsScale = UIScreen.main.scale
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setMaskRect(animated: Bool) {
    let path = CGMutablePath()
    path.addRect(bounds)
    path.addRect(maskRect)

    removeAnimation(forKey: animationKey)
    self.path = path
    if animated {
      add(animation, forKey: animationKey)
    }
  }
}

class ImageBrowerGridLayer: CAShapeLayer {
  var gridRect: CGRect! {
    didSet {
      setGridRect(animated: true)
    }
  }

  var gridColor: UIColor!
  var bgColor: UIColor!

  override init() {
    super.init()
    contentsScale = UIScreen.main.scale
    bgColor = UIColor.clear
    gridColor = UIColor.black
    shadowColor = UIColor.black.cgColor
    shadowRadius = 3
    shadowOffset = .zero
    shadowOpacity = 0.5
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setGridRect(animated: Bool) {
    guard let cgPath = drawGrid() else { return }
    if animated {
      let animation = CABasicAnimation(keyPath: "path")
      animation.duration = 0.2
      animation.fromValue = path
      animation.toValue = cgPath

      add(animation, forKey: nil)
    }

    path = cgPath
  }

  func drawGrid() -> CGPath? {
    fillColor = bgColor.cgColor
    strokeColor = gridColor.cgColor

    guard let rect = gridRect else { return nil }
    let path = UIBezierPath()
    var drawWidth: CGFloat = 0
    for _ in 0..<4 {
      path.move(to: CGPoint(x: rect.origin.x + drawWidth, y: rect.origin.y))
      path.addLine(to: CGPoint(x: rect.origin.x + drawWidth, y: rect.origin.y + rect.height))
      drawWidth += rect.width / 3
    }

    drawWidth = 0

    for _ in 0..<4 {
      path.move(to: CGPoint(x: rect.origin.x, y: rect.origin.y + drawWidth))
      path.addLine(to: CGPoint(x: rect.origin.x + rect.width, y: rect.origin.y + drawWidth))
      drawWidth += rect.height / 3
    }

    let offset: CGFloat = 1
    let lenght: CGFloat = 15
    let newRect = rect.insetBy(dx: -offset, dy: -offset)

    path.move(to: CGPoint(x: newRect.minX, y: newRect.minY + lenght))
    path.addLine(to: CGPoint(x: newRect.minX, y: newRect.minY))
    path.addLine(to: CGPoint(x: newRect.minX + lenght, y: newRect.minY))

    path.move(to: CGPoint(x: newRect.maxX - lenght, y: newRect.minY))
    path.addLine(to: CGPoint(x: newRect.maxX, y: newRect.minY))
    path.addLine(to: CGPoint(x: newRect.maxX, y: newRect.minY + lenght))

    path.move(to: CGPoint(x: newRect.maxX, y: newRect.maxY - lenght))
    path.addLine(to: CGPoint(x: newRect.maxX, y: newRect.maxY))
    path.addLine(to: CGPoint(x: newRect.maxX - lenght, y: newRect.maxY))

    path.move(to: CGPoint(x: newRect.minX + lenght, y: newRect.maxY))
    path.addLine(to: CGPoint(x: newRect.minX, y: newRect.maxY))
    path.addLine(to: CGPoint(x: newRect.minX, y: newRect.maxY - lenght))

    return path.cgPath
  }
}

class ImageBrowerResizeControl: UIView {
  weak var delegate: ImageBrowerResizeControlDelegate?
  var translation: CGPoint!
  var startPoint: CGPoint!
//    var enable: Bool! {
//        didSet {
//            pan.isEnabled = enable
//        }
//    }
  var pan: UIPanGestureRecognizer!

  override init(frame: CGRect) {
    super.init(frame: frame)
    addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(panAction(_:))))
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  @objc func panAction(_ pan: UIPanGestureRecognizer) {
    switch pan.state {
    case .began:
      let point = pan.translation(in: superview)
      startPoint = CGPoint(x: round(point.x), y: round(point.y))
      delegate?.beginResize(control: self)
    case .changed:
      let point = pan.translation(in: superview)
      translation = CGPoint(x: round(startPoint.x + point.x), y: round(startPoint.y + point.y))
      delegate?.resizing(control: self)
    case .ended, .cancelled:
      delegate?.endResize(control: self)
    default:
      break
    }
  }
}

protocol ImageBrowerResizeControlDelegate: AnyObject {
  func beginResize(control: ImageBrowerResizeControl)
  func resizing(control: ImageBrowerResizeControl)
  func endResize(control: ImageBrowerResizeControl)
}

protocol ImageBrowerGridViewDelegate: AnyObject {
  func beginResize(gridView: ImageBrowerGridView)
  func resizing(gridView: ImageBrowerGridView)
  func endResize(gridView: ImageBrowerGridView)
}

class ImageBrowerGridView: UIView {
  private lazy var gridLayer: ImageBrowerGridLayer = {
    let layer = ImageBrowerGridLayer()
    layer.frame = self.bounds
    layer.lineWidth = 1
    layer.gridColor = UIColor.white
    layer.gridRect = self.bounds.insetBy(dx: 20, dy: 20)

    return layer
  }()

  private lazy var gridMaskLayer: ImageBrowerGridMaskLayer = {
    let layer = ImageBrowerGridMaskLayer()
    layer.frame = self.bounds
    layer.maskColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
    return layer
  }()

  private var initialRect: CGRect = .zero
  private var topLeftCornerView: ImageBrowerResizeControl!
  private var topRightCornerView: ImageBrowerResizeControl!
  private var bottomLeftCornerView: ImageBrowerResizeControl!
  private var bottomRightCornerView: ImageBrowerResizeControl!
  private var topEdgeView: ImageBrowerResizeControl!
  private var leftEdgeView: ImageBrowerResizeControl!
  private var bottomEdgeView: ImageBrowerResizeControl!
  private var rightEdgeView: ImageBrowerResizeControl!

  var gridRect: CGRect = .zero
  var minGridSize = CGSize(width: 60, height: 60)
  lazy var maxGridRect: CGRect = self.bounds.insetBy(dx: 20, dy: 20)
  lazy var originalGridSize: CGSize = gridRect.size

  weak var delegate: ImageBrowerGridViewDelegate?
  var dragging: Bool = false
  var showMaskLayer: Bool = true
  var cropType: GridCropRectType = .square

  override init(frame: CGRect) {
    super.init(frame: frame)
    UISetUp()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    gridLayer.frame = bounds
    gridMaskLayer.frame = bounds
    updateResizeControlFrame()
  }

  override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
    guard let view = super.hitTest(point, with: event) else { return nil }

    guard self != view else { return nil }

    enableCornerViewUserInteraction(view: view)

    return view
  }

  func enableCornerViewUserInteraction(view: UIView?) {
    for control in subviews {
      guard control.isKind(of: ImageBrowerResizeControl.self) else { continue }
      guard view != nil else {
        control.isUserInteractionEnabled = true
        continue
      }
      if control == view {
        control.isUserInteractionEnabled = true
      } else {
        control.isUserInteractionEnabled = false
      }
    }
  }

  func UISetUp() {
    layer.addSublayer(gridMaskLayer)
    layer.addSublayer(gridLayer)

    topLeftCornerView = createResizeControl()
    topRightCornerView = createResizeControl()
    bottomLeftCornerView = createResizeControl()
    bottomRightCornerView = createResizeControl()

    topEdgeView = createResizeControl()
    leftEdgeView = createResizeControl()
    bottomEdgeView = createResizeControl()
    rightEdgeView = createResizeControl()
  }

  func createResizeControl() -> ImageBrowerResizeControl {
    let control = ImageBrowerResizeControl(frame: CGRect(origin: .zero, size: CGSize(width: 30, height: 30)))
    control.delegate = self
    addSubview(control)
    control.isUserInteractionEnabled = true
    return control
  }

  func setShowMaskLayer(show: Bool) {
    isUserInteractionEnabled = show
    guard showMaskLayer != show else { return }
    showMaskLayer = show
    if show {
      gridMaskLayer.maskRect = gridRect
    } else {
      gridMaskLayer.maskRect = gridMaskLayer.bounds
    }
  }

  func setGridRect(_ gridRect: CGRect, isMaskLayer: Bool) {
    setNeedsLayout()
    self.gridRect = gridRect
    gridLayer.gridRect = gridRect
    if isMaskLayer {
      gridMaskLayer.maskRect = gridRect
    }
  }
}

extension ImageBrowerGridView {
  func updateResizeControlFrame() {
    let rect = gridRect
    let topLeftPoint = CGPoint(x: rect.minX - topLeftCornerView.bounds.width / 2, y: rect.minY - topLeftCornerView.bounds.height / 2)
    topLeftCornerView.frame = CGRect(origin: topLeftPoint, size: topLeftCornerView.bounds.size)

    let topRightPoint = CGPoint(x: rect.maxX - topRightCornerView.bounds.width / 2, y: rect.minY - topRightCornerView.bounds.height / 2)
    topRightCornerView.frame = CGRect(origin: topRightPoint, size: topRightCornerView.bounds.size)

    let bottomLeftPoint = CGPoint(x: rect.minX - bottomLeftCornerView.bounds.width / 2, y: rect.maxY - bottomLeftCornerView.bounds.height / 2)
    bottomLeftCornerView.frame = CGRect(origin: bottomLeftPoint, size: bottomLeftCornerView.bounds.size)

    let bottomRightPoint = CGPoint(x: rect.maxX - bottomRightCornerView.bounds.width / 2, y: rect.maxY - bottomRightCornerView.bounds.height / 2)
    bottomRightCornerView.frame = CGRect(origin: bottomRightPoint, size: bottomRightCornerView.bounds.size)
    // swiftlint:disable line_length
    let topEdgeArray = [topLeftCornerView.frame.maxX, rect.minY - topEdgeView.frame.height / 2, topRightCornerView.frame.minX - topLeftCornerView.frame.maxX, topEdgeView.bounds.height]
    topEdgeView.frame = CGRect(x: topEdgeArray[0], y: topEdgeArray[1], width: topEdgeArray[2], height: topEdgeArray[3])
    // swiftlint:disable line_length
    let leftEdgeArray = [rect.minX - leftEdgeView.frame.width / 2, topLeftCornerView.frame.maxY, leftEdgeView.bounds.width, bottomLeftCornerView.frame.minY - topLeftCornerView.frame.maxY]
    leftEdgeView.frame = CGRect(x: leftEdgeArray[0], y: leftEdgeArray[1], width: leftEdgeArray[2], height: leftEdgeArray[3])
    // swiftlint:disable line_length
    let bottomEdgeArray = [bottomLeftCornerView.frame.maxX, bottomLeftCornerView.frame.minY, bottomRightCornerView.frame.minX - bottomLeftCornerView.frame.maxX, bottomEdgeView.bounds.height]
    bottomEdgeView.frame = CGRect(x: bottomEdgeArray[0], y: bottomEdgeArray[1], width: bottomEdgeArray[2], height: bottomEdgeArray[3])
    // swiftlint:disable line_length
    let rightEdgeArray = [rect.maxX - rightEdgeView.bounds.width / 2, topRightCornerView.frame.maxY, rightEdgeView.bounds.width, bottomRightCornerView.frame.minY - topRightCornerView.frame.maxY]
    rightEdgeView.frame = CGRect(x: rightEdgeArray[0], y: rightEdgeArray[1], width: rightEdgeArray[2], height: rightEdgeArray[3])
  }

  // swiftlint:disable cyclomatic_complexity
  func cropRectMake(withResizeControlView resizeControlView: ImageBrowerResizeControl) -> CGRect {
    switch cropType {
    case .square:
      return cropRectSquare(withResizeControlView: resizeControlView)
    default:
      return cropRectRandom(withResizeControlView: resizeControlView)
    }
  }

  /// 正方形rect得出裁切区域
  func cropRectSquare(withResizeControlView resizeControlView: ImageBrowerResizeControl) -> CGRect {
    var rect = gridRect
    if resizeControlView == topEdgeView {
      // swiftlint:disable line_length
      rect = CGRect(x: initialRect.minX, y: initialRect.minY + resizeControlView.translation.y, width: initialRect.width - resizeControlView.translation.y, height: initialRect.height - resizeControlView.translation.y)
    } else if resizeControlView == leftEdgeView {
      // swiftlint:disable line_length
      rect = CGRect(x: initialRect.minX + resizeControlView.translation.x, y: initialRect.minY, width: initialRect.width - resizeControlView.translation.x, height: initialRect.height - resizeControlView.translation.x)
    } else if resizeControlView == bottomEdgeView {
      rect = CGRect(x: initialRect.minX, y: initialRect.minY, width: initialRect.width + resizeControlView.translation.y, height: initialRect.height + resizeControlView.translation.y)
    } else if resizeControlView == rightEdgeView {
      rect = CGRect(x: initialRect.minX, y: initialRect.minY, width: initialRect.width + resizeControlView.translation.x, height: initialRect.height + resizeControlView.translation.x)
    } else if resizeControlView == topLeftCornerView {
      // swiftlint:disable line_length
      var translation = resizeControlView.translation ?? .zero
      translation.x = translation.y
      rect = CGRect(x: initialRect.minX + resizeControlView.translation.x, y: initialRect.minY + translation.y, width: initialRect.width - translation.x, height: initialRect.height - translation.y)
    } else if resizeControlView == topRightCornerView {
      // swiftlint:disable line_length
      var translation = resizeControlView.translation ?? .zero
      translation.x = translation.y
      rect = CGRect(x: initialRect.minX, y: initialRect.minY + translation.y, width: initialRect.width + translation.x, height: initialRect.height - translation.y)
    } else if resizeControlView == bottomLeftCornerView {
      // swiftlint:disable line_length
      var translation = resizeControlView.translation ?? .zero
      translation.x = translation.y
      rect = CGRect(x: initialRect.minX + translation.x, y: initialRect.minY, width: initialRect.width - translation.x, height: initialRect.height + translation.y)
    } else if resizeControlView == bottomRightCornerView {
      // swiftlint:disable line_length
      var translation = resizeControlView.translation ?? .zero
      translation.x = translation.y
      rect = CGRect(x: initialRect.minX, y: initialRect.minY, width: initialRect.width + translation.x, height: initialRect.height + translation.y)
    }

    return handleEdageSideSituation(with: rect, resizeControlView: resizeControlView)
  }

  /// 任意rect形状得出裁切区域
  func cropRectRandom(withResizeControlView resizeControlView: ImageBrowerResizeControl) -> CGRect {
    var rect = gridRect

    if resizeControlView == topEdgeView {
      // swiftlint:disable line_length
      rect = CGRect(x: initialRect.minX, y: initialRect.minY + resizeControlView.translation.y, width: initialRect.width, height: initialRect.height - resizeControlView.translation.y)
    } else if resizeControlView == leftEdgeView {
      // swiftlint:disable line_length
      rect = CGRect(x: initialRect.minX + resizeControlView.translation.x, y: initialRect.minY, width: initialRect.width - resizeControlView.translation.x, height: initialRect.height)
    } else if resizeControlView == bottomEdgeView {
      rect = CGRect(x: initialRect.minX, y: initialRect.minY, width: initialRect.width, height: initialRect.height + resizeControlView.translation.y)
    } else if resizeControlView == rightEdgeView {
      rect = CGRect(x: initialRect.minX, y: initialRect.minY, width: initialRect.width + resizeControlView.translation.x, height: initialRect.height)
    } else if resizeControlView == topLeftCornerView {
      // swiftlint:disable line_length
      rect = CGRect(x: initialRect.minX + resizeControlView.translation.x, y: initialRect.minY + resizeControlView.translation.y, width: initialRect.width - resizeControlView.translation.x, height: initialRect.height - resizeControlView.translation.y)
    } else if resizeControlView == topRightCornerView {
      // swiftlint:disable line_length
      rect = CGRect(x: initialRect.minX, y: initialRect.minY + resizeControlView.translation.y, width: initialRect.width + resizeControlView.translation.x, height: initialRect.height - resizeControlView.translation.y)
    } else if resizeControlView == bottomLeftCornerView {
      // swiftlint:disable line_length
      rect = CGRect(x: initialRect.minX + resizeControlView.translation.x, y: initialRect.minY, width: initialRect.width - resizeControlView.translation.x, height: initialRect.height + resizeControlView.translation.y)
    } else if resizeControlView == bottomRightCornerView {
      // swiftlint:disable line_length
      rect = CGRect(x: initialRect.minX, y: initialRect.minY, width: initialRect.width + resizeControlView.translation.x, height: initialRect.height + resizeControlView.translation.y)
    }

    return handleEdageSideSituation(with: rect, resizeControlView: resizeControlView)
  }

  func handleEdageSideSituation(with rect: CGRect, resizeControlView: ImageBrowerResizeControl) -> CGRect {
    var resizeRect = rect
    if ceil(rect.origin.x) < ceil(maxGridRect.minX) {
      resizeRect.origin.x = maxGridRect.origin.x
      resizeRect.size.width = initialRect.maxX - rect.origin.x
    }
    if ceil(rect.origin.y) < ceil(maxGridRect.minY) {
      resizeRect.origin.y = maxGridRect.origin.y
      resizeRect.size.height = initialRect.maxY - rect.origin.y
    }
    if ceil(rect.origin.x + rect.size.width) > ceil(maxGridRect.maxX) {
      resizeRect.size.width = maxGridRect.maxX - rect.minX
    }
    if ceil(rect.origin.y + rect.size.height) > ceil(maxGridRect.maxY) {
      resizeRect.size.height = maxGridRect.maxY - rect.minY
    }
    if ceil(rect.size.width) <= ceil(minGridSize.width) {
      if resizeControlView == topLeftCornerView || resizeControlView == leftEdgeView || resizeControlView == bottomLeftCornerView {
        resizeRect.origin.x = initialRect.maxX - minGridSize.width
      }
      resizeRect.size.width = minGridSize.width
    }
    if ceil(rect.size.height) <= ceil(minGridSize.height) {
      if resizeControlView == topLeftCornerView || resizeControlView == topEdgeView || resizeControlView == topRightCornerView {
        resizeRect.origin.y = initialRect.maxY - minGridSize.height
      }
      resizeRect.size.height = minGridSize.height
    }
    return rect
  }
}

extension ImageBrowerGridView: ImageBrowerResizeControlDelegate {
  func beginResize(control: ImageBrowerResizeControl) {
    initialRect = gridRect
    dragging = true
    setShowMaskLayer(show: false)
    delegate?.beginResize(gridView: self)
  }

  func resizing(control: ImageBrowerResizeControl) {
    let girdRect = cropRectMake(withResizeControlView: control)
    setGridRect(girdRect, isMaskLayer: false)
    delegate?.resizing(gridView: self)
  }

  func endResize(control: ImageBrowerResizeControl) {
    enableCornerViewUserInteraction(view: nil)
    dragging = false
    setShowMaskLayer(show: true)
    delegate?.endResize(gridView: self)
  }
}
