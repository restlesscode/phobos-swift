//
//
//  PBSArticleBigCardCell.swift
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
import UIKit

protocol PBSArticleCellProtocol: AnyObject {
  func render(theme: PBSArticleSectionTheme, model: PBSArticleViewModel)
}

class PBSArticleBigCardCell: UICollectionViewCell {
  var disposeBag = DisposeBag()

  var style: PBSArticleBigCardCell.Style = .brown {
    didSet {
      mainView.pbs.applyHorizontalGradientBackground(colorset: style.gradientBackgroundColorSet, cornerRadius: 8.0)
      tagLabel.textColor = style.tagTextColor
      titleLabel.textColor = style.titleTextColor
      subtitleLabel.textColor = style.subtitleTextColor
      actionBtn.tintColor = style.actionButtonTintColor
    }
  }

  lazy var mainView: UIView = {
    let view = UIView()
    contentView.addSubview(view)

    return view
  }()

  lazy var coverImageView: UIImageView = {
    let imageView = UIImageView(image: Resource.Image.kImageArticlePlaceHolder)
    mainView.addSubview(imageView)
    imageView.contentMode = .scaleAspectFill
    imageView.layer.cornerRadius = 8.0
    if #available(iOS 11.0, *) {
      imageView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
    imageView.layer.masksToBounds = true

    return imageView
  }()

  lazy var tagLabel: UILabel = {
    let label = UILabel(frame: .zero)
    mainView.addSubview(label)
    label.font = Styles.Font.articleTag

    return label
  }()

  lazy var titleLabel: UILabel = {
    let label = UILabel(frame: .zero)
    mainView.addSubview(label)
    label.font = Styles.Font.articleLargeTitle

    return label
  }()

  lazy var subtitleLabel: UILabel = {
    let label = UILabel(frame: .zero)
    mainView.addSubview(label)
    label.numberOfLines = 4
    label.lineBreakMode = .byWordWrapping
    label.font = Styles.Font.articleMediumTitle

    return label
  }()

  lazy var actionBtn: UIButton = {
    let button = UIButton(type: .system)
    mainView.addSubview(button)
    button.titleLabel?.font = Styles.Font.moreActionTitle

    return button
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func prepareForReuse() {
    super.prepareForReuse()

    disposeBag = DisposeBag()
  }

  func applyStyle(theme: PBSArticleSectionTheme) {
    let style = BehaviorRelay<PBSArticleBigCardCell.Style>(value: .brown)
    style.bind(to: rx.style).disposed(by: disposeBag)

    switch theme {
    case .green:
      style.accept(.brown)
    case .red:
      style.accept(.red)
    case .cherry:
      style.accept(.red)
    case .yellow:
      style.accept(.yellow)
    case .gold:
      style.accept(.yellow)
    case .orange:
      style.accept(.yellow)
    case .brown:
      style.accept(.brown)
    case .indigo:
      style.accept(.brown)
    case .blue:
      style.accept(.brown)
    case .purple:
      style.accept(.sliver)
    case .normal:
      style.accept(.sliver)
    }
  }
}
