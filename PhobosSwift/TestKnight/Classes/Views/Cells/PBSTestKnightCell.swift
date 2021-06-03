//
//
//  PBSTestKnightCell.swift
//  PhobosSwiftTestKnight
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
import RxCocoa
import RxSwift
import UIKit

class PBSTestKnightCell: UITableViewCell {
  var disposeBag = DisposeBag()

  lazy var titleLabel: UILabel = {
    let label = UILabel(frame: .zero)
    contentView.addSubview(label)
    label.font = UIFont.boldSystemFont(ofSize: 17.0)

    return label
  }()

  lazy var descriptionLabel: UILabel = {
    let label = UILabel(frame: .zero)
    contentView.addSubview(label)
    label.font = UIFont.systemFont(ofSize: 14.0)
    label.numberOfLines = 0

    return label
  }()

  lazy var iconView: UIImageView = {
    let imageView = UIImageView(frame: .zero)
    contentView.addSubview(imageView)

    return imageView
  }()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    makeSubviews()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func makeSubviews() {
    iconView.snp.makeConstraints {
      $0.left.equalTo(44)
      $0.centerY.equalToSuperview()
      $0.width.height.equalTo(48)
    }

    titleLabel.snp.makeConstraints {
      $0.top.equalTo(4)
      $0.left.equalTo(iconView.snp.right).offset(16.0)
      $0.right.equalTo(-44)
      $0.height.equalTo(22)
    }

    descriptionLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(8.0)
      $0.left.equalTo(titleLabel)
      $0.right.equalTo(titleLabel)
      $0.height.greaterThanOrEqualTo(44.0)
      $0.bottom.equalTo(-8)
    }
  }

  override var isSelected: Bool {
    didSet {}
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    disposeBag = DisposeBag()
  }

  func render(item: PBSTestKnightViewModel) {
    item.title.bind(to: titleLabel.rx.text).disposed(by: disposeBag)
    item.description.bind(to: descriptionLabel.rx.text).disposed(by: disposeBag)
    item.icon.bind(to: iconView.rx.image).disposed(by: disposeBag)
  }
}
