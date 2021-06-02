//
//
//  PBSSegmentView.swift
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

import SnapKit
import UIKit

/// 通过这个类创建的SegmentView，默认titleView和contentView连在一起，效果类似于网易新闻
/// 只能用代码创建，不能在xib或者storyboard里面使用
///
open class PBSSegmentView: UIView {
  public private(set) var style: PBSSegmentViewStyle
  public private(set) var titles: [String]
  public private(set) var childViewControllers: [UIViewController]

  public private(set) lazy var titleView = PBSSegmentTitleView(frame: .zero, style: style, titles: titles, currentIndex: style.startIndex)

  public private(set) lazy var contentView = PBSSegmentContentView(frame: .zero,
                                                                   style: style,
                                                                   childViewControllers: childViewControllers,
                                                                   startIndex: style.startIndex)

  public init(frame: CGRect, style: PBSSegmentViewStyle, titles: [String], childViewControllers: [UIViewController]) {
    self.style = style
    self.titles = titles
    self.childViewControllers = childViewControllers
    super.init(frame: frame)

    setupUI()
  }

  @available(*, unavailable)
  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension PBSSegmentView {
  private func setupUI() {
    addSubview(titleView)
    titleView.snp.makeConstraints {
      $0.top.left.right.equalTo(0)
      $0.height.equalTo(style.titleViewHeight)
    }

    contentView.backgroundColor = style.contentViewBackgroundColor
    addSubview(contentView)

    contentView.snp.makeConstraints {
      $0.top.equalTo(titleView.snp.bottom)
      $0.left.right.bottom.equalTo(0)
    }

    titleView.delegate = contentView
    contentView.delegate = titleView
  }
}
