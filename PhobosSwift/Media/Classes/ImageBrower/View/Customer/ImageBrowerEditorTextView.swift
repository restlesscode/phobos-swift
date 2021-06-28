//
//
//  ImageBrowerEditorTextView.swift
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

class ImageBrowerEditorTextView: UIView {
  /*
   // Only override draw() if you perform custom drawing.
   // An empty implementation adversely affects performance during animation.
   override func draw(_ rect: CGRect) {
       // Drawing code
   }
   */

  var editorText: ImageBrowerEditorText!
  var block: ((UIGestureRecognizer) -> Void)?
  private let maxWidth = ScreenWidth - 50
  private let label = MPPaddingLabel()
  private var timer: Timer!
  init(editorText: ImageBrowerEditorText) {
    self.editorText = editorText
    super.init(frame: CGRect.zero)
    layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5).cgColor
    label.textAlignment = .center
    label.numberOfLines = 0
    addSubview(label)
    updateLayout()
    addGestureRecognizer()
  }

  override func willMove(toSuperview newSuperview: UIView?) {
    superview?.willMove(toSuperview: newSuperview)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func startTimer() {
    showBorder()
    if timer != nil {
      timer.invalidate()
    }

    timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { [weak self] timer in
      guard let self = self else { return }
      timer.invalidate()
      self.hiddenBorder()
    })
  }

  func showBorder() {
    layer.borderWidth = 1
  }

  func hiddenBorder() {
    layer.borderWidth = 0
  }

  func updateLayout() {
    var width = editorText.text.pbs.width(withConstrainedHeight: 600, font: editorText.font)
    if width > maxWidth {
      width = maxWidth
    }
    let height = editorText.text.pbs.height(withConstrainedWidth: width, font: editorText.font)

    label.bounds.size = CGSize(width: width + 20, height: height + 20)
    label.text = editorText.text
    label.font = editorText.font
    label.textColor = editorText.color
    label.pbs.corner(radii: 8)

    if editorText.hasBackground {
      label.backgroundColor = editorText.backGroundColor
    } else {
      label.backgroundColor = UIColor.clear
    }

    bounds.size = CGSize(width: width + 40, height: height + 40)

    label.center = CGPoint(x: width / 2 + 20, y: height / 2 + 20)
  }
}

extension ImageBrowerEditorTextView: UIGestureRecognizerDelegate {
  func addGestureRecognizer() {
    let tapGR = UITapGestureRecognizer(target: self, action: #selector(singleTapAction(tap:)))
    tapGR.numberOfTouchesRequired = 1
    tapGR.numberOfTapsRequired = 1

    addGestureRecognizer(tapGR)

    let panGR = UIPanGestureRecognizer(target: self, action: #selector(dragAction(pan:)))
    panGR.minimumNumberOfTouches = 1

    addGestureRecognizer(panGR)

    let pinchGR = UIPinchGestureRecognizer(target: self, action: #selector(pinchAction(pinch:)))
    pinchGR.delegate = self

    addGestureRecognizer(pinchGR)

    let routateRG = UIRotationGestureRecognizer(target: self, action: #selector(rotateAction(rotate:)))
    routateRG.delegate = self

    addGestureRecognizer(routateRG)
  }

  @objc func singleTapAction(tap: UITapGestureRecognizer) {
    block?(tap)
    startTimer()
  }

  @objc func dragAction(pan: UIPanGestureRecognizer) {
    block?(pan)
    startTimer()
  }

  @objc func pinchAction(pinch: UIPinchGestureRecognizer) {
    block?(pinch)
    startTimer()
  }

  @objc func rotateAction(rotate: UIRotationGestureRecognizer) {
    block?(rotate)
    startTimer()
  }

  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    true
  }
}

class MPPaddingLabel: UILabel {
  var textPadding = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

  override func drawText(in rect: CGRect) {
    super.drawText(in: rect.inset(by: textPadding))
  }
}
