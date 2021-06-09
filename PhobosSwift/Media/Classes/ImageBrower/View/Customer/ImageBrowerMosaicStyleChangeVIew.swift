//
//
//  ImageBrowerMosaicStyleChangeVIew.swift
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

class ImageBrowerMosaicStyleChangeVIew: UIView {
  let squareButton: UIButton = {
    let button = UIButton(frame: CGRect(x: 0, y: 0, width: ScreenWidth / 3, height: 50))
    button.setImage(baseBundle.image(withName: "mosaic_type_1"), for: .normal)
    button.setImage(baseBundle.image(withName: "mosaic_type_1_s"), for: .selected)
    button.isSelected = true
    return button
  }()

  var paintButton: UIButton = {
    let button = UIButton(frame: CGRect(x: ScreenWidth / 3, y: 0, width: ScreenWidth / 3, height: 50))
    button.setImage(baseBundle.image(withName: "editor_dl"), for: .normal)
    button.setImage(baseBundle.image(withName: "editor_dl_s"), for: .selected)

    return button
  }()

  var backButton: UIButton = {
    let button = UIButton(frame: CGRect(x: ScreenWidth / 3 * 2, y: 0, width: ScreenWidth / 3, height: 50))
    button.setImage(baseBundle.image(withName: "editor_back"), for: .normal)
    button.isEnabled = false
    return button
  }()

  var selectChange: ((ImageBrowerMosaicType) -> Void)?
  var backBlock: (() -> Void)?
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(squareButton)
    addSubview(paintButton)
    addSubview(backButton)

    squareButton.addTarget(self, action: #selector(selectSquare), for: .touchUpInside)
    paintButton.addTarget(self, action: #selector(selectPaint), for: .touchUpInside)
    backButton.addTarget(self, action: #selector(backClick), for: .touchUpInside)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  @objc func selectSquare() {
    guard !squareButton.isSelected else { return }

    selectChange?(.square)
    squareButton.isSelected = true
    paintButton.isSelected = false
  }

  @objc func selectPaint() {
    guard !paintButton.isSelected else { return }

    selectChange?(.paint)
    paintButton.isSelected = true
    squareButton.isSelected = false
  }

  @objc func backClick() {
    backBlock?()
  }
}
