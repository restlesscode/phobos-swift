//
//
//  PBSArticleSectionHeader.swift
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

open class PBSArticleSectionHeader: UICollectionReusableView {
  var disposeBag = DisposeBag()
  
  var theme: PBSArticleSectionTheme = .normal {
    didSet {
      titleLabel.textColor = theme.titleTextColor
    }
  }
  
  lazy var titleLabel: UILabel = {
    let label = UILabel(frame: .zero)
    self.addSubview(label)
    label.numberOfLines = 1
    label.font = Styles.Font.sectionTitle
    
    return label
  }()
  
  lazy var subtitleLabel: UILabel = {
    let label = UILabel(frame: .zero)
    self.addSubview(label)
    label.numberOfLines = 2
    label.lineBreakMode = .byWordWrapping
    label.font = Styles.Font.sectionSubtitle
    label.textColor = Styles.Color.sectionSubtitleGray
    
    return label
  }()
  
  override public init(frame: CGRect) {
    super.init(frame: frame)
    
    makeSubviews()
    makeStyles()
  }
  
  @available(*, unavailable)
  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override open func prepareForReuse() {
    super.prepareForReuse()
    
    disposeBag = DisposeBag()
  }
  
  func makeSubviews() {
    titleLabel.snp.makeConstraints {
      $0.left.right.equalTo(0)
      $0.centerY.equalToSuperview()
      $0.bottom.equalTo(subtitleLabel.snp.top)
    }
    
    subtitleLabel.snp.makeConstraints {
      $0.left.right.equalTo(0)
      $0.bottom.equalTo(-8)
      $0.top.equalTo(titleLabel.snp.bottom)
    }
  }
  
  func remakeTitle(with sectionViewModel: PBSArticleSectionViewModel) {
    titleLabel.snp.remakeConstraints {
      $0.bottom.equalTo(subtitleLabel.snp.top)
    }
  }
  
  func makeStyles() {}
  
  public func render(theme: PBSArticleSectionTheme, sectionViewModel: PBSArticleSectionViewModel) {
    BehaviorRelay(value: theme).bind(to: rx.theme).disposed(by: disposeBag)
    
    sectionViewModel.title.bind(to: titleLabel.rx.text).disposed(by: disposeBag)
    sectionViewModel.subtitle.bind(to: subtitleLabel.rx.text).disposed(by: disposeBag)
    
    remakeTitle(with: sectionViewModel)
  }
}

extension Reactive where Base: PBSArticleSectionHeader {
  /// Bindable sink for `textColor` property.
  internal var theme: Binder<PBSArticleSectionTheme> {
    Binder(base) { cell, theme in
      cell.theme = theme
    }
  }
}
