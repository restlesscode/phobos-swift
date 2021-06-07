//
//
//  PBSArticleSectionFooter.swift
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

open class PBSArticleSectionFooter: UICollectionReusableView {
  var disposeBag = DisposeBag()
  
  lazy var moreActionBtn: UIButton = {
    let button = UIButton(type: .system)
    addSubview(button)
    return button
  }()
  
  lazy var seporateLine: UIView = {
    let view = UIView(frame: .zero)
    addSubview(view)
    
    view.backgroundColor = Styles.Color.articleSeporatorGray
    
    return view
  }()
  
  override public init(frame: CGRect) {
    super.init(frame: frame)
    
    makeSubviews()
  }
  
  @available(*, unavailable)
  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override public func prepareForReuse() {
    super.prepareForReuse()
    disposeBag = DisposeBag()
  }
  
  func makeSubviews() {
    seporateLine.snp.makeConstraints {
      $0.top.equalTo(18)
      $0.left.equalTo(0)
      $0.right.equalTo(0)
      $0.height.equalTo(0.5)
    }
    
    moreActionBtn.snp.makeConstraints {
      $0.centerY.equalToSuperview().offset(9)
      $0.right.equalToSuperview()
    }
  }
  
  func render(theme: PBSArticleSectionTheme, sectionViewModel: PBSArticleSectionViewModel) {
    let text = NSMutableAttributedString(string: Resource.Strings.kMoreAbout,
                                         attributes: [NSAttributedString.Key.foregroundColor: Styles.Color.articleTitleGray,
                                                      NSAttributedString.Key.font: Styles.Font.sectionFooterTitle])
    
    text.append(
      NSAttributedString(string: "\(sectionViewModel.title.value) ▶︎".uppercased(),
                         attributes: [NSAttributedString.Key.foregroundColor: theme.titleTextColor,
                                      NSAttributedString.Key.font: Styles.Font.sectionFooterTitle]))
    
    BehaviorRelay<NSAttributedString>(value: text).bind(to: moreActionBtn.rx.attributedTitle()).disposed(by: disposeBag)
  }
}
