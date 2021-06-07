//
//
//  PBSArticleIndexCell.swift
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

class PBSArticleIndexCell: UICollectionViewCell {
  var disposeBag = DisposeBag()
  
  static var itemSize: CGSize {
    let width: CGFloat = UIScreen.main.bounds.width - 36.0
    let height: CGFloat = width / 339.0 * 120.0
    
    return CGSize(width: width, height: height)
  }
  
  static var indexLabelSize: CGSize {
    CGSize(width: 19, height: 19)
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    disposeBag = DisposeBag()
  }
  
  override var isSelected: Bool {
    didSet {
      if self.isSelected {
        contentView.backgroundColor = UIColor.pbs.color(R: 244, G: 244, B: 244)
      } else {
        contentView.backgroundColor = .clear
      }
    }
  }
  
  lazy var indexLabel: UILabel = {
    let label = UILabel(frame: .zero)
    self.contentView.addSubview(label)
    label.font = Styles.Font.articleTitle
    label.textAlignment = .center
    label.layer.cornerRadius = 19.0
    label.layer.borderWidth = 1.0
    
    return label
  }()
  
  lazy var tagLabel: UILabel = {
    let label = UILabel(frame: .zero)
    self.contentView.addSubview(label)
    label.font = Styles.Font.articleTagS
    label.textColor = Styles.Color.articleTitleBlack
    
    return label
  }()
  
  lazy var titleLabel: UILabel = {
    let label = UILabel(frame: .zero)
    self.contentView.addSubview(label)
    label.numberOfLines = 3
    label.lineBreakMode = .byWordWrapping
    label.font = Styles.Font.articleTitle
    label.textColor = Styles.Color.articleTitleBlack
    
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
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func makeSubviews() {
    layer.cornerRadius = 4.0
    layer.masksToBounds = true
    
    indexLabel.snp.makeConstraints {
      $0.left.equalTo(0)
      $0.top.equalTo(0)
      $0.height.width.equalTo(38)
    }
    
    tagLabel.snp.makeConstraints {
      $0.top.equalTo(indexLabel)
      $0.left.equalTo(indexLabel.snp.right).offset(18.0)
      $0.right.equalTo(0)
      $0.height.equalTo(22.0)
    }
    
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(tagLabel.snp.bottom).offset(8.0)
      $0.left.equalTo(tagLabel)
      $0.right.equalTo(tagLabel)
      $0.bottom.lessThanOrEqualTo(timeLabel.snp.top)
    }
    
    timeLabel.snp.makeConstraints {
      $0.left.equalTo(titleLabel)
      $0.right.bottom.equalTo(0)
      $0.height.equalTo(16)
    }
  }
}

extension PBSArticleIndexCell: PBSArticleCellProtocol {
  func render(theme: PBSArticleSectionTheme, model: PBSArticleViewModel) {
    indexLabel.textColor = theme.titleTextColor
    indexLabel.layer.borderColor = theme.titleTextColor.cgColor
    
    model.tag.bind(to: tagLabel.rx.text).disposed(by: disposeBag)
    model.title.bind(to: titleLabel.rx.text).disposed(by: disposeBag)
    model.time.bind(to: timeLabel.rx.text).disposed(by: disposeBag)
  }
  
  func applyStyle(theme: PBSArticleSectionTheme) {}
}
