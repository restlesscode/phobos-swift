//
//
//  PBSGrowthHomeSectionView.swift
//  PhobosSwiftGrowth
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

class PBSGrowthHomeSectionView: UICollectionReusableView, PBSUIInterface {
  var title: String = "" {
    didSet {
      label.text = title
    }
  }

  var hasMoreButton: Bool = false {
    didSet {
      button.isHidden = !hasMoreButton
    }
  }

  var buttonClickBlock: (() -> Void)?

  lazy var label: UILabel = {
    let label = UILabel()
    label.textColor = .white
    label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
    return label
  }()

  lazy var button: UIButton = {
    let button = UIButton()
    button.setTitle("show all", for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
    button.contentHorizontalAlignment = .right
    button.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
    return button
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(label)
    addSubview(button)
    label.snp.makeConstraints { make in
      make.top.bottom.equalToSuperview()
      make.left.equalToSuperview().offset(20)
      make.right.equalToSuperview().offset(-100)
    }
    button.snp.makeConstraints { make in
      make.top.bottom.equalToSuperview()
      make.right.equalToSuperview().offset(-20)
      make.width.equalTo(100)
    }
    button.isHidden = true
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  @objc func buttonClick() {
    guard let buttonClickBlock = buttonClickBlock else { return }
    buttonClickBlock()
  }
}
