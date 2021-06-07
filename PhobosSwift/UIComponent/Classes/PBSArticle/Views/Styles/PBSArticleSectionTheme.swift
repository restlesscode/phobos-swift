//
//
//  PBSArticleSectionTheme.swift
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

/// Article Section Theme
public enum PBSArticleSectionTheme {
  ///
  case green
  ///
  case red
  ///
  case cherry
  ///
  case yellow
  ///
  case gold
  ///
  case orange
  ///
  case brown
  ///
  case indigo
  ///
  case blue
  ///
  case purple
  ///
  case normal
  
  var titleTextColor: UIColor {
    switch self {
    case .green:
      return Styles.Color.sectionTitleGreen
    case .red:
      return Styles.Color.sectionTitleRed
    case .cherry:
      return Styles.Color.sectionTitleCherry
    case .yellow:
      return Styles.Color.sectionTitleYellow
    case .gold:
      return Styles.Color.sectionTitleGold
    case .orange:
      return Styles.Color.sectionTitleOrange
    case .brown:
      return Styles.Color.sectionTitleBrown
    case .indigo:
      return Styles.Color.sectionTitleIndigo
    case .blue:
      return Styles.Color.sectionTitleBlue
    case .purple:
      return Styles.Color.sectionTitlePurple
    case .normal:
      return Styles.Color.sectionTitleBlack
    }
  }
}
