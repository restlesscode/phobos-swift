//
//
//  ImageBrowerEditorMenuView.swift
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

enum ImageBrowerEditorType: Int {
  case line = 0
  case box = 1
  case text = 2
  case crop = 3
  case mosaic = 4
}

class ImageBrowerEditorMenuView: UIView {
  var buttonClickBlock: ((ImageBrowerEditorType, Bool) -> Void)?
  var doneClickBlock: (() -> Void)?
  private var selectIndex: Int = 0
  private let endColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
  private let startColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
  override init(frame: CGRect) {
    super.init(frame: frame)
    setGradientBackground(startWithClear: true)
    buttonsViewInit()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setGradientBackground(startWithClear: Bool) {
    if startWithClear {
      pbs.applyVerticalGradientBackground(colorset: [UIColor.clear, endColor])
    } else {
      pbs.applyVerticalGradientBackground(colorset: [startColor, endColor])
    }
  }

  func buttonsViewInit() {
    let icons = ["editor_dl", "editor_fk", "editor_wenzi", "editor_cj", "editor_masaike"]
    let itemWidth: CGFloat = 60 * (ScreenWidth / 414)
    let itemHeight: CGFloat = 50
    let space: CGFloat = 15

    for i in 0..<icons.count {
      let button = UIButton(frame: CGRect(x: space + itemWidth * CGFloat(i), y: 50, width: itemWidth, height: itemHeight))
      button.setImage(baseBundle.image(withName: icons[i]), for: .normal)
      button.tag = 100 + i
      button.addTarget(self, action: #selector(buttonClick(_:)), for: .touchUpInside)
      if let image = baseBundle.image(withName: icons[i] + "_s") {
        button.setImage(image, for: .selected)
      }
      addSubview(button)
    }

    let doneButton = UIButton(frame: CGRect(x: ScreenWidth - 75, y: 59, width: 57, height: 32))
    doneButton.setBackgroundImage(UIImage.pbs.makeImage(from: PBSImageBrower.Color.blue), for: .normal)
    doneButton.setTitle(PBSImageBrowerStrings.sure, for: .normal)
    doneButton.setTitleColor(UIColor.white, for: .normal)
    doneButton.addTarget(self, action: #selector(done), for: .touchUpInside)
    doneButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
    doneButton.pbs.corner(radii: 5)

    addSubview(doneButton)
  }

  @objc func buttonClick(_ btn: UIButton) {
    guard let type = ImageBrowerEditorType(rawValue: btn.tag - 100) else { return }
    switch type {
    case .line, .box, .mosaic:
      btn.isSelected.toggle()
      buttonClickBlock?(type, btn.isSelected)
      guard btn.tag - 100 != selectIndex else {
        return
      }
      guard let oldButton = viewWithTag(100 + selectIndex) as? UIButton else {
        return
      }
      oldButton.isSelected = false

      selectIndex = btn.tag - 100
    default:
      buttonClickBlock?(type, btn.isSelected)
    }
  }

  @objc func done() {
    doneClickBlock?()
  }
}
