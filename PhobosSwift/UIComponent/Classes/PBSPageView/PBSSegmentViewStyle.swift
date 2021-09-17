//
//
//  PBSSegmentViewStyle.swift
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

import UIKit

/// Page Style
public struct PBSSegmentViewStyle {
  /// return a default style
  public static func makeStyle() -> PBSSegmentViewStyle {
    PBSSegmentViewStyle()
  }

  /// 标题是否可以滚动
  public var isTitleScrollEnable: Bool = false

  /// titleView的一些属性
  public var titleViewHeight: CGFloat = 44
  ///
  public var titleColor = UIColor.black
  ///
  public var titleSelectedColor = UIColor.blue
  ///
  public var titleFont = UIFont.systemFont(ofSize: 15)
  ///
  public var titleViewBackgroundColor = UIColor.white
  ///
  public var titleMargin: CGFloat = 30

  /// 是否显示滚动条
  public var isShowBottomLine: Bool = false
  /// 底线颜色
  public var bottomLineColor = UIColor.blue
  /// 底线高度
  public var bottomLineHeight: CGFloat = 2
  /// 底线宽度
  /// nil 代表自动高度
  public var bottomLineWidth: CGFloat?
  /// 边缘
  public var bottomLineCornerRadius: CGFloat = 0
  /// 滚动条距离底部的距离
  public var bottomLinePadding: CGFloat = 0

  /// 是否需要缩放功能
  public var isScaleEnable: Bool = false
  ///
  public var maximumScaleFactor: CGFloat = 1.2

  /// 是否需要显示coverView
  public var isShowCoverView: Bool = false
  ///
  public var coverViewBackgroundColor = UIColor.black
  ///
  public var coverViewAlpha: CGFloat = 0.4
  ///
  public var coverMargin: CGFloat = 8
  ///
  public var coverViewHeight: CGFloat = 25
  ///
  public var coverViewRadius: CGFloat = 12

  /// contentView是否可以滚动
  public var isContentScrollEnable: Bool = true
  ///
  public var contentViewBackgroundColor = UIColor.clear

  /// 默认开始index
  public var startIndex = 0
}
