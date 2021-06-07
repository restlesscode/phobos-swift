//
//
//  PBSArticleCardCell.swift
//  PhobosSwiftUIComponent
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

import Alamofire
import PhobosSwiftCore
import PhobosSwiftNetwork
import RxCocoa
import RxSwift
import SnapKit
import UIKit

///
class PBSArticleCardCell: UICollectionViewCell {
  var disposeBag = DisposeBag()

  override func prepareForReuse() {
    super.prepareForReuse()
    disposeBag = DisposeBag()
  }

  class var coverImageSize: CGSize {
    let width: CGFloat = UIScreen.main.bounds.width - 36.0
    let height: CGFloat = width / 339.0 * 256

    return CGSize(width: width, height: height)
  }

  class var itemSize: CGSize {
    let width: CGFloat = UIScreen.main.bounds.width - 36.0
    let height: CGFloat = width / 339.0 * 380

    return CGSize(width: width, height: height)
  }

  lazy var coverImageView: UIImageView = {
    let imageView = UIImageView(image: Resource.Image.kImageArticlePlaceHolder)
    self.contentView.addSubview(imageView)
    imageView.contentMode = .scaleAspectFill

    return imageView
  }()

  lazy var tagLabel: UILabel = {
    let label = UILabel(frame: .zero)
    self.contentView.addSubview(label)
    label.font = Styles.Font.articleTag
    label.textColor = Styles.Color.articleTagGreen

    return label
  }()

  lazy var titleLabel: UILabel = {
    let label = UILabel(frame: .zero)
    self.contentView.addSubview(label)
    label.numberOfLines = 4
    label.lineBreakMode = .byWordWrapping
    label.font = Styles.Font.articleLargeTitle

    return label
  }()

  lazy var timeLabel: UILabel = {
    let label = UILabel(frame: .zero)
    self.contentView.addSubview(label)
    label.numberOfLines = 1
    label.font = Styles.Font.articleSmallTitle
    label.textColor = Styles.Color.articleTitleGray

    return label
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)

    makeSubviews()
    makeStyles()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func makeSubviews() {
    layer.cornerRadius = 4.0
    layer.masksToBounds = true

    coverImageView.snp.makeConstraints {
      $0.top.left.right.equalTo(0.0)
      $0.height.equalTo(Self.coverImageSize.height)
      $0.bottom.equalTo(tagLabel.snp.top).offset(-8)
    }
    coverImageView.layer.cornerRadius = 4.0
    coverImageView.layer.masksToBounds = true

    tagLabel.snp.makeConstraints {
      $0.top.equalTo(coverImageView.snp.bottom).offset(8)
      $0.left.right.equalTo(0)
      $0.bottom.equalTo(titleLabel.snp.top).offset(-8)
    }

    titleLabel.snp.makeConstraints {
      $0.left.right.equalTo(0)
      $0.bottom.lessThanOrEqualTo(timeLabel.snp.top)
    }

    timeLabel.snp.makeConstraints {
      $0.left.right.bottom.equalTo(0)
      $0.height.equalTo(22)
    }
  }

  func makeStyles() {}
}

extension PBSArticleCardCell: PBSArticleCellProtocol {
  func render(theme: PBSArticleSectionTheme, model: PBSArticleViewModel) {
    tagLabel.textColor = theme.titleTextColor

    model.coverImageUrl.bind(to: coverImageView.rx.imageUrl).disposed(by: disposeBag)
    model.tag.bind(to: tagLabel.rx.text).disposed(by: disposeBag)
    model.title.bind(to: titleLabel.rx.text).disposed(by: disposeBag)
    model.time.bind(to: timeLabel.rx.text).disposed(by: disposeBag)
  }
}
