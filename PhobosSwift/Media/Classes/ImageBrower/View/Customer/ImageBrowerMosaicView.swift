//
//
//  ImageBrowerMosaicView.swift
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

private func radiansToDegrees(_ x: CGFloat) -> CGFloat {
  180.0 * x / .pi
}

/// 两点之间的角度
private func angleBetweenPoints(_ startPoint: CGPoint, _ endPoint: CGPoint) -> CGFloat {
  let Xpoint = CGPoint(x: startPoint.x + 100, y: startPoint.y)
  let a = endPoint.x - startPoint.x
  let b = endPoint.y - startPoint.y
  let c = Xpoint.x - startPoint.x
  let d = Xpoint.y - startPoint.y
  var rads = acos((a * c + b * d) / (sqrt(a * a + b * b) * sqrt(c * c + d * d)))
  if startPoint.y > endPoint.y {
    rads = -rads
  }
  return rads
}

/// 直线之间的夹角
private func angleBetweenLines(_ line1Start: CGPoint, _ line1End: CGPoint, _ line2Start: CGPoint, _ line2End: CGPoint) -> CGFloat {
  let a = line1End.x - line1Start.x
  let b = line1End.y - line1Start.y
  let c = line2End.x - line2Start.x
  let d = line2End.y - line2Start.y
  let rads = acos((a * c + b * d) / (sqrt(a * a + b * b) * sqrt(c * c + d * d)))
  return radiansToDegrees(rads)
}

struct ImageBrowerMosaicPointElement {
  var rect: CGRect = .zero
  var color = UIColor.clear
  var imageName: String!
}

class ImageBrowerMosaicLineLayer: CALayer {
  var elementArray: [ImageBrowerMosaicPointElement] = []

  override init() {
    super.init()
    contentsScale = UIScreen.main.scale
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func draw(in ctx: CGContext) {
    UIGraphicsPushContext(ctx)
    UIColor.clear.setFill()
    UIRectFill(bounds)

    ctx.setLineCap(CGLineCap.round)
    ctx.setLineJoin(CGLineJoin.round)
    for i in 0..<elementArray.count {
      let blur = elementArray[i]
      let rect = blur.rect
      if blur.imageName != nil {
        guard let image = baseBundle.image(withName: blur.imageName) else { continue }
        // * 创建颜色图片
        let colorRef = CGColorSpaceCreateDeviceRGB()
        // swiftlint:disable line_length
        guard let contextRef = CGContext(data: nil, width: Int(image.size.width), height: Int(image.size.height), bitsPerComponent: 8, bytesPerRow: Int(image.size.width * 4), space: colorRef, bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue) else {
          continue
        }

        guard let cgImage = image.cgImage else { continue }
        let imageRect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        contextRef.clip(to: imageRect, mask: cgImage)
        contextRef.setFillColor(blur.color.cgColor)
        contextRef.fill(imageRect)

        // * 生成图片
        guard let imageRef = contextRef.makeImage() else { continue }
        ctx.draw(imageRef, in: rect)
      } else {
        ctx.setFillColor(blur.color.cgColor)
        ctx.fill(rect)
      }

      UIGraphicsPopContext()
    }
  }
}

enum ImageBrowerMosaicType {
  case square
  case paint
}

class ImageBrowerMosaicView: UIView {
  private var isWork = false
  private var isBegan = false
  private var layerArray: [ImageBrowerMosaicLineLayer] = []
  private var frameArray: [NSValue] = []
  var mosaicType = ImageBrowerMosaicType.square
  var squareWidth: CGFloat = 15
  var paintSize = CGSize(width: 40, height: 40)
  var isBrushing = false
  var brushBeganBlock: (() -> Void)?
  var brushEndBlock: (() -> Void)?
  var brushColor: ((CGPoint) -> UIColor)!
  override init(frame: CGRect) {
    super.init(frame: frame)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func divideMosaicPoint(point: CGPoint) -> CGPoint {
    let scope = squareWidth
    let x = Int(point.x / scope)
    let y = Int(point.y / scope)
    return CGPoint(x: CGFloat(x) * scope, y: CGFloat(y) * scope)
  }

  func divideMosaicRect(_ rect: CGRect) -> [NSValue]? {
    let scope = squareWidth

    var array: [AnyHashable] = []

    if CGRect.zero.equalTo(rect) {
      return array as? [NSValue]
    }

    let minX = rect.minX
    let maxX = rect.maxX
    let minY = rect.minY
    let maxY = rect.maxY

    // * 左上角
    let leftTop = divideMosaicPoint(point: CGPoint(x: minX, y: minY))
    // * 右下角
    let rightBoom = divideMosaicPoint(point: CGPoint(x: maxX, y: maxY))

    let countX = Int((rightBoom.x - leftTop.x) / scope)
    let countY = Int((rightBoom.y - leftTop.y) / scope)

    for i in 0..<countX {
      for j in 0..<countY {
        let point = CGPoint(x: leftTop.x + CGFloat(i) * scope, y: leftTop.y + CGFloat(j) * scope)
        let value = NSValue(cgPoint: point)
        array.append(value)
      }
    }
    return array as? [NSValue]
  }
}

extension ImageBrowerMosaicView {
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    defer {
      super.touchesBegan(touches, with: event)
    }

    guard touches.count == 1 else { return }
    isWork = false
    isBegan = true
    guard let touch = touches.randomElement() else { return }
    let point = touch.location(in: self)

    switch mosaicType {
    case .square:
      let mosaicPoint = divideMosaicPoint(point: point)
      let value = NSValue(cgPoint: mosaicPoint)
      if frameArray.contains(value) {
        let layer = ImageBrowerMosaicLineLayer()
        layer.frame = bounds
        self.layer.addSublayer(layer)
        layerArray.append(layer)
      } else {
        frameArray.append(value)

        var blur = ImageBrowerMosaicPointElement()
        blur.rect = CGRect(x: mosaicPoint.x, y: mosaicPoint.y, width: squareWidth, height: squareWidth)
        blur.color = brushColor(blur.rect.origin)

        let layer = ImageBrowerMosaicLineLayer()
        layer.frame = bounds
        layer.elementArray.append(blur)

        self.layer.addSublayer(layer)
        layerArray.append(layer)
      }
    case .paint:
      var blur = ImageBrowerMosaicPointElement()
      blur.rect = CGRect(x: point.x - paintSize.width / 2, y: point.y - paintSize.height / 2, width: paintSize.width, height: paintSize.height)
      blur.imageName = "editor_mosaic_brush"
      blur.color = brushColor(blur.rect.origin)

      let layer = ImageBrowerMosaicLineLayer()
      layer.frame = bounds
      layer.elementArray.append(blur)

      self.layer.addSublayer(layer)
      layerArray.append(layer)
    }
  }

  // swiftlint:disable function_body_length
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    defer {
      super.touchesMoved(touches, with: event)
    }

    guard isBegan || isWork else { return }
    guard
      let touch = touches.randomElement(),
      let layer = layerArray.last,
      let prevBlur = layer.elementArray.last
    else { return }

    let point = touch.location(in: self)

    switch mosaicType {
    case .square:
      let mosaicPoint = divideMosaicPoint(point: point)
      let value = NSValue(cgPoint: mosaicPoint)
      if !frameArray.contains(value) {
        if isBegan {
          brushBeganBlock?()
        }
        isWork = true
        isBegan = false
        frameArray.append(value)
        var blur = ImageBrowerMosaicPointElement()
        blur.rect = CGRect(x: mosaicPoint.x, y: mosaicPoint.y, width: squareWidth, height: squareWidth)
        blur.color = brushColor(blur.rect.origin)

        layer.elementArray.append(blur)
        layer.setNeedsDisplay()
      }
    case .paint:
      guard !prevBlur.rect.contains(point) else { return }
      if isBegan {
        brushBeganBlock?()
      }
      isWork = true
      isBegan = false

      var blur = ImageBrowerMosaicPointElement()
      blur.imageName = "editor_mosaic_brush"
      blur.color = brushColor(point)
      // * 新增随机位置
      let x = paintSize.width + min(1.0, paintSize.width * 0.4)

      let randomX = CGFloat(floorf(Float(Int(arc4random()) % Int(x)))) - x / 2
      blur.rect = CGRect(x: point.x - paintSize.width / 2 + randomX, y: point.y - paintSize.height / 2, width: paintSize.width, height: paintSize.height)

      layer.elementArray.append(blur)

      // * 新增额外对象 密集图片
      layer.setNeedsDisplay()

      // * 扩大范围
      let paintRect = blur.rect.insetBy(dx: -squareWidth, dy: -squareWidth)

      if let values = divideMosaicRect(paintRect) {
        frameArray = frameArray.filter { !values.contains($0) }
      }
    }
  }

  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    defer {
      isBegan = false
      isWork = false
      super.touchesEnded(touches, with: event)
    }

    if isWork {
      guard let layer = layerArray.last else { return }
      if layer.elementArray.count < 2 {
        goBack()
      } else {
        brushEndBlock?()
      }
    } else {
      if isBegan {
        goBack()
      }
    }
  }

  override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    defer {
      isBegan = false
      isWork = false
      super.touchesCancelled(touches, with: event)
    }

    if isWork {
      guard let layer = layerArray.last else { return }
      if layer.elementArray.count < 2 {
        goBack()
      } else {
        brushEndBlock?()
      }
    } else {
      if isBegan {
        goBack()
      }
    }
  }

  var canBack: Bool {
    !layerArray.isEmpty
  }

  var isDrawing: Bool {
    isWork
  }

  func goBack() {
    guard canBack else { return }
    guard let layer = layerArray.last else { return }

    if layer.elementArray.first != nil {
      for blur in layer.elementArray {
        let value = NSValue(cgPoint: blur.rect.origin)
        if let index = frameArray.firstIndex(where: { $0 == value }) {
          frameArray.remove(at: index)
        }
      }
    }

    layer.removeFromSuperlayer()
    layerArray.removeLast()
  }

  func clear() {
    layerArray.removeAll()
    frameArray.removeAll()
    for layer in layer.sublayers ?? [] {
      layer.removeFromSuperlayer()
    }
  }

  func getData() -> ImageBrowerMosaicViewData? {
    guard !layerArray.isEmpty else { return nil }

    var lineArray: [[ImageBrowerMosaicPointElement]] = []
    layerArray.forEach {
      lineArray.append($0.elementArray)
    }

    var viewData = ImageBrowerMosaicViewData()
    viewData.layerArray = lineArray
    viewData.frameArray = frameArray

    return viewData
  }

  func setData(viewData: ImageBrowerMosaicViewData) {
    let lineArray = viewData.layerArray
    lineArray.forEach {
      let layer = ImageBrowerMosaicLineLayer()
      layer.frame = self.bounds
      layer.elementArray.append(contentsOf: $0)

      self.layer.addSublayer(layer)
      self.layerArray.append(layer)
      layer.setNeedsDisplay()
    }

    frameArray.append(contentsOf: viewData.frameArray)
  }
}

struct ImageBrowerMosaicViewData {
  var layerArray: [[ImageBrowerMosaicPointElement]] = []
  var frameArray: [NSValue] = []
}
