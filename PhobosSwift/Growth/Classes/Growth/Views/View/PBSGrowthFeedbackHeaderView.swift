//
//
//  PBSGrowthFeedbackHeaderView.swift
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

class PBSGrowthFeedbackHeaderView: UIView {
  let imageView = UIImageView()
  let titleLabel = UILabel()
  let subTitleLabel = UILabel()
  let bottomLine = UIView()

  override init(frame: CGRect) {
    super.init(frame: frame)
    imageView.image = UIImage(named: "quote", in: Bundle.pbs.bundle(with: PhobosSwiftGrowth.self), compatibleWith: nil) ?? UIImage()
    addSubview(imageView)

    titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
    titleLabel.textColor = .white
    titleLabel.numberOfLines = 0
    addSubview(titleLabel)

    subTitleLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
    subTitleLabel.textColor = .white
    subTitleLabel.numberOfLines = 0
    subTitleLabel.textColor = .pbs.color(R: 158, G: 158, B: 158)
    addSubview(subTitleLabel)
    bottomLine.backgroundColor = .pbs.color(R: 255, G: 255, B: 255, alpha: 0.15)
    addSubview(bottomLine)

    imageView.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(40)
      make.left.equalToSuperview().offset(20)
      make.width.height.equalTo(33)
    }

    titleLabel.snp.makeConstraints { make in
      make.top.equalTo(imageView.snp.top)
      make.left.equalTo(imageView.snp.right).offset(20)
      make.right.equalToSuperview().offset(-20)
      make.height.lessThanOrEqualTo(45)
    }

    subTitleLabel.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom).offset(10)
      make.left.equalTo(titleLabel.snp.left)
      make.right.equalTo(titleLabel.snp.right)
      make.height.lessThanOrEqualTo(37)
      make.bottom.equalToSuperview().offset(-45)
    }

    bottomLine.snp.makeConstraints { make in
      make.right.bottom.equalToSuperview()
      make.left.equalTo(imageView.snp.left)
      make.height.equalTo(1 / UIScreen.main.scale)
    }
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
