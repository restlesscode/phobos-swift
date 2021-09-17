//
//
//  ImageBrowerDrawView.swift
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
enum ImageBrowerDrawType {
  case line
  case box
}

class ImageBrowerDrawView: UIView {
  var lineWidth: CGFloat = 5
  var lineColor: UIColor = PBSImageBrower.Color.blue
  var layerArray: [CAShapeLayer] = []
  var lineArray: [UIBezierPath] = []
  var isBegan: Bool = false
  var isWork: Bool = false

  var drawEnd: (() -> Void)?
  var drawBegan: (() -> Void)?

  var drawType: ImageBrowerDrawType = .line
  /*
   // Only override draw() if you perform custom drawing.
   // An empty implementation adversely affects performance during animation.
   override func draw(_ rect: CGRect) {
       // Drawing code
   }
   */
  override init(frame: CGRect) {
    super.init(frame: frame)
    isExclusiveTouch = true
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension ImageBrowerDrawView {
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    defer {
      super.touchesBegan(touches, with: event)
    }
    guard event?.allTouches?.count == 1 else {
      return
    }
    isBegan = true
    isWork = false
    guard let touch = touches.randomElement() else {
      isBegan = false
      return
    }
    var path: UIBezierPath!
    switch drawType {
    case .line:
      path = getPath(point: touch.location(in: self))
    case .box:
      path = getBoxPath(point: touch.location(in: self))
    }

    lineArray.append(path)

    let slayer = getShapeLayer(path: path)
    layer.addSublayer(slayer)
    layerArray.append(slayer)
  }

  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    defer {
      super.touchesMoved(touches, with: event)
    }

    guard event?.allTouches?.count == 1 else {
      return
    }

    guard isBegan || isWork else {
      return
    }

    guard let touch = touches.randomElement(), var path = lineArray.last else {
      return
    }

    let point = touch.location(in: self)

    guard point != path.currentPoint else {
      return
    }
    if !isWork {
      drawBegan?()
    }
    isBegan = false
    isWork = true

    switch drawType {
    case .line:
      path.addLine(to: point)
    case .box:
      path = resetBoxPath(path: path, point: point)
    }

    layerArray.last?.path = path.cgPath
  }

  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    defer {
      super.touchesEnded(touches, with: event)
    }
    guard event?.allTouches?.count == 1 else {
      return
    }
    resetStatus()
  }

  override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    defer {
      super.touchesCancelled(touches, with: event)
    }
    guard event?.allTouches?.count == 1 else {
      return
    }
    resetStatus()
  }

  func resetStatus() {
    if isWork == false && !lineArray.isEmpty {
      back()
    }
    isBegan = false
    isWork = false
    drawEnd?()
  }
}

extension ImageBrowerDrawView {
  func getShapeLayer(path: UIBezierPath) -> CAShapeLayer {
    let layer = CAShapeLayer()
    layer.path = path.cgPath
    layer.backgroundColor = UIColor.clear.cgColor
    layer.fillColor = UIColor.clear.cgColor
    layer.lineCap = .round
    layer.lineJoin = .round
    layer.strokeColor = lineColor.cgColor
    layer.lineWidth = path.lineWidth

    return layer
  }

  func getPath(point: CGPoint) -> UIBezierPath {
    let path = UIBezierPath()
    path.lineWidth = lineWidth
    path.lineCapStyle = .round
    path.lineJoinStyle = .round
    path.move(to: point)

    return path
  }

  func getBoxPath(point: CGPoint, size: CGSize = CGSize(width: 5, height: 5)) -> UIBezierPath {
    let rect = CGRect(origin: point, size: size)
    let path = UIBezierPath(roundedRect: rect, cornerRadius: 5)
    path.lineWidth = lineWidth
    lineColor.setStroke()
    path.stroke()

    return path
  }

  func resetBoxPath(path: UIBezierPath, point: CGPoint) -> UIBezierPath {
    var oldPoint = path.currentPoint
    let width = abs(point.x - oldPoint.x)
    let height = abs(point.y - oldPoint.y)
    if oldPoint.x > point.x {
      oldPoint.x = point.x
    }
    if oldPoint.y > point.y {
      oldPoint.y = point.y
    }

    return getBoxPath(point: oldPoint, size: CGSize(width: width, height: height))
  }
}

extension ImageBrowerDrawView {
  func back() {
    layerArray.last?.removeFromSuperlayer()
    layerArray.removeLast()
    lineArray.removeLast()
  }
}
