//
//
//  PBSArticleBigCardCellStyle.swift
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

extension PBSArticleBigCardCell {
  enum Style {
    case brown
    case yellow
    case sliver
    case red

    var actionButtonTintColor: UIColor {
      switch self {
      case .brown:
        return UIColor.pbs.color(R: 105, G: 79, B: 64)
      case .sliver:
        return UIColor.pbs.color(R: 155, G: 155, B: 155)
      case .red, .yellow:
        return UIColor.white
      }
    }

    var actionButtonBackgroundColor: UIColor {
      switch self {
      case .brown, .sliver, .yellow:
        return .clear
      case .red:
        return UIColor.pbs.color(R: 190, G: 37, B: 67)
      }
    }

    var gradientBackgroundColorSet: [UIColor] {
      switch self {
      case .brown:
        return [UIColor.pbs.color(R: 183, G: 156, B: 136), UIColor.pbs.color(R: 156, G: 130, B: 113)]
      case .sliver:
        return [UIColor.pbs.color(R: 229, G: 229, B: 229), UIColor.pbs.color(R: 209, G: 209, B: 209)]
      case .red:
        return [UIColor.pbs.color(R: 253, G: 51, B: 89), UIColor.pbs.color(R: 251, G: 58, B: 94)]
      case .yellow:
        return [UIColor.pbs.color(R: 186, G: 172, B: 102), UIColor.pbs.color(R: 180, G: 155, B: 92)]
      }
    }

    var tagTextColor: UIColor {
      switch self {
      case .brown, .red, .yellow:
        return .white
      case .sliver:
        return .black
      }
    }

    var titleTextColor: UIColor {
      switch self {
      case .brown, .red, .yellow:
        return .white
      case .sliver:
        return .black
      }
    }

    var subtitleTextColor: UIColor {
      switch self {
      case .brown, .red, .yellow:
        return .white
      case .sliver:
        return .black
      }
    }
  }
}
