//
//
//  ImageBrowerEditorColorSelectView.swift
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
enum ImageBrowerEditorColorType {
  case line
  case text
}

class ImageBrowerEditorColorSelectView: UIView {
  let colors = [UIColor.white, UIColor.black, PBSImageBrowerColor.blue, PBSImageBrowerColor.warningYellow, PBSImageBrowerColor.successGreen, PBSImageBrowerColor.soulfulBlue, PBSImageBrowerColor.premiumGold]
  var selectIndex = 2

  var block: ((UIColor) -> Void)?
  var backBlock: (() -> Void)?
  var backButton: UIButton!
  var isBackgroundBtn: UIButton!
  var isBackgroundBlock: ((Bool) -> Void)?
  private var type: ImageBrowerEditorColorType!

  init(frame: CGRect, type: ImageBrowerEditorColorType = .line) {
    super.init(frame: frame)
    self.type = type
    switch type {
    case .line:
      colorsViewInit()
    case .text:
      texstColorsViewInit()
    }
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func texstColorsViewInit() {
    let itemWidth: CGFloat = 20
    let space: CGFloat = (frame.width - CGFloat(colors.count + 1) * itemWidth) / CGFloat(colors.count + 2)

    isBackgroundBtn = UIButton(frame: CGRect(x: space - 5, y: 10, width: 30, height: 30))
    isBackgroundBtn.addTarget(self, action: #selector(changeTextBackground), for: .touchUpInside)
    isBackgroundBtn.setImage(baseBundle.image(withName: "editor_wenzi"), for: .normal)
    isBackgroundBtn.setImage(baseBundle.image(withName: "editor_wenzi_s"), for: .selected)

    addSubview(isBackgroundBtn)

    for i in 0..<colors.count {
      let x = space * 2 + itemWidth + (space + itemWidth) * CGFloat(i)
      let button = UIButton(frame: CGRect(x: x, y: 15, width: itemWidth, height: itemWidth))
      button.backgroundColor = colors[i]
      button.clipsToBounds = true
      button.layer.borderColor = UIColor.white.cgColor
      button.addTarget(self, action: #selector(buttonClick(button:)), for: .touchUpInside)
      button.tag = 200 + i
      buttonConfig(button: button, changeSelected: i == selectIndex)

      addSubview(button)
    }
  }

  func colorsViewInit() {
    let itemWidth: CGFloat = 20
    let space: CGFloat = (frame.width - CGFloat(colors.count + 1) * itemWidth) / CGFloat(colors.count + 2)

    for i in 0..<colors.count {
      let x = space + (space + itemWidth) * CGFloat(i)
      let button = UIButton(frame: CGRect(x: x, y: 15, width: itemWidth, height: itemWidth))
      button.backgroundColor = colors[i]
      button.clipsToBounds = true
      button.layer.borderColor = UIColor.white.cgColor
      button.addTarget(self, action: #selector(buttonClick(button:)), for: .touchUpInside)
      button.tag = 200 + i
      buttonConfig(button: button, changeSelected: i == selectIndex)

      addSubview(button)
    }

    backButton = UIButton(frame: CGRect(x: ScreenWidth - space - 30, y: 10, width: 30, height: 30))
    backButton.addTarget(self, action: #selector(rollBackClick), for: .touchUpInside)
    backButton.setImage(baseBundle.image(withName: "editor_back"), for: .normal)
    backButton.isEnabled = false

    addSubview(backButton)
  }

  func buttonConfig(button: UIButton, changeSelected: Bool = false) {
    if changeSelected {
      button.isSelected.toggle()
      var origin = button.frame.origin
      if button.isSelected {
        origin.x -= 3
        origin.y -= 3
      } else {
        origin.x += 3
        origin.y += 3
      }

      button.frame.origin = origin
    }

    button.frame.size = button.isSelected ? CGSize(width: 26, height: 26) : CGSize(width: 20, height: 20)
    button.layer.borderWidth = button.isSelected ? 4 : 2
    button.layer.cornerRadius = button.width() / 2
  }

  @objc func buttonClick(button: UIButton) {
    guard !button.isSelected else { return }
    buttonConfig(button: button, changeSelected: true)
    if let oldButton = viewWithTag(200 + selectIndex) as? UIButton {
      buttonConfig(button: oldButton, changeSelected: true)
    }

    selectIndex = button.tag - 200

    block?(colors[selectIndex])
  }

  @objc func rollBackClick() {
    backBlock?()
  }

  @objc func changeTextBackground() {
    isBackgroundBtn.isSelected.toggle()
    isBackgroundBlock?(isBackgroundBtn.isSelected)
  }

  func currentColor() -> UIColor {
    colors[selectIndex]
  }

  func setCurrentColor(_ color: UIColor) {
    guard let index = colors.firstIndex(of: color) else { return }
    if let button = viewWithTag(200 + selectIndex) as? UIButton {
      buttonConfig(button: button, changeSelected: true)
    }

    if let button = viewWithTag(200 + index) as? UIButton {
      buttonConfig(button: button, changeSelected: true)
    }

    selectIndex = index
  }
}
