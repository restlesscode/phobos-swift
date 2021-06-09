//
//
//  PBSArticleBigCardYCell.swift
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

import PhobosSwiftCore
import RxCocoa
import RxSwift
import SnapKit
import UIKit

///
class PBSArticleBigCardYCell: PBSArticleBigCardCell {
  static var itemSize: CGSize {
    let width: CGFloat = UIScreen.main.bounds.width - 36.0
    let height: CGFloat = width / 339.0 * 406

    return CGSize(width: width, height: height)
  }

  static var coverImageSize: CGSize {
    let width: CGFloat = UIScreen.main.bounds.width - 36.0
    let height: CGFloat = width / 339.0 * 256

    return CGSize(width: width, height: height)
  }

  lazy var tagImageView: UIImageView = {
    let imageView = UIImageView(image: Resource.Image.kImageArticlePlaceHolder)
    tagImageContainerView.addSubview(imageView)

    imageView.contentMode = .scaleAspectFill
    imageView.layer.masksToBounds = true

    return imageView
  }()

  lazy var tagImageContainerView: UIView = {
    let view = UIView(frame: .zero)
    mainView.addSubview(view)
    view.layer.borderWidth = 4
    view.layer.borderColor = UIColor.pbs.color(R: 250, G: 212, B: 71).cgColor
    view.pbs.addShadow(radius: 8.0, scale: true)

    return view
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)

    style = .yellow

    makeSubviews()
    makeStyles()
  }

//  @available(*, unavailable)
//  required init?(coder: NSCoder) {
//    fatalError("init(coder:) has not been implemented")
//  }

  func makeSubviews() {
    mainView.snp.makeConstraints {
      $0.left.right.top.bottom.equalTo(0)
    }

    coverImageView.snp.makeConstraints {
      $0.top.left.right.equalTo(0.0)
      $0.height.equalTo(244.0)
    }

    tagImageContainerView.snp.makeConstraints {
      $0.top.equalTo(coverImageView.snp.bottom).offset(-45)
      $0.left.equalTo(18)
      $0.height.equalTo(90)
      $0.width.equalTo(60)
    }

    tagImageView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }

    tagLabel.snp.makeConstraints {
      $0.top.equalTo(coverImageView.snp.bottom)
      $0.left.equalTo(tagImageContainerView.snp.right).offset(18)
      $0.width.equalToSuperview().multipliedBy(0.66)
      $0.bottom.equalTo(tagImageContainerView.snp.bottom)
    }

    titleLabel.snp.makeConstraints {
      $0.left.equalTo(18)
      $0.right.equalTo(-18)
      $0.top.equalTo(tagImageView.snp.bottom).offset(8)
    }

    subtitleLabel.snp.makeConstraints {
      $0.left.equalTo(18)
      $0.right.equalTo(-18)
      $0.top.equalTo(titleLabel.snp.bottom).offset(8)
      $0.bottom.lessThanOrEqualTo(-8.0)
    }
  }

  func makeStyles() {
    mainView.frame = CGRect(origin: .zero, size: Self.itemSize)
    mainView.layer.cornerRadius = 8.0
    mainView.pbs.addShadow(radius: 8.0)

    tagLabel.font = Styles.Font.articleTag
    tagLabel.numberOfLines = 2
    tagLabel.lineBreakMode = .byWordWrapping

    titleLabel.font = Styles.Font.articleLargeTitle
    titleLabel.numberOfLines = 2
    titleLabel.lineBreakMode = .byWordWrapping

    subtitleLabel.numberOfLines = 4
    subtitleLabel.lineBreakMode = .byWordWrapping
    subtitleLabel.font = Styles.Font.articleMediumTitle
  }
}

extension PBSArticleBigCardYCell: PBSArticleCellProtocol {
  func render(theme: PBSArticleSectionTheme, model: PBSArticleViewModel) {
    applyStyle(theme: theme)

    model.coverImageUrl.bind(to: coverImageView.rx.imageUrl).disposed(by: disposeBag)
    model.tag.bind(to: tagLabel.rx.text).disposed(by: disposeBag)
    model.title.bind(to: titleLabel.rx.text).disposed(by: disposeBag)
    model.subtitle.bind(to: subtitleLabel.rx.text).disposed(by: disposeBag)
  }
}
