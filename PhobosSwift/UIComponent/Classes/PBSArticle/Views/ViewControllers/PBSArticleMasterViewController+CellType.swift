//
//
//  PBSArticleMasterViewController+CellType.swift
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
import UIKit

extension UIArticleKit.DecorationView.CellType {
  var reuseIdentifier: String {
    switch self {
    case .card:
      return PBSArticleCardCell.pbs.reuseIdentifier
    case .column:
      return PBSArticleColumnCell.pbs.reuseIdentifier
    case .normal:
      return PBSArticleNormalCell.pbs.reuseIdentifier
    case .index:
      return PBSArticleIndexCell.pbs.reuseIdentifier
    case .bigCardE:
      return PBSArticleBigCardECell.pbs.reuseIdentifier
    case .bigCardX:
      return PBSArticleBigCardXCell.pbs.reuseIdentifier
    case .bigCardY:
      return PBSArticleBigCardYCell.pbs.reuseIdentifier
    case .bigCardS:
      return PBSArticleBigCardSCell.pbs.reuseIdentifier
    }
  }
  
  var itemSize: CGSize {
    switch self {
    case .card:
      return PBSArticleCardCell.itemSize
    case .column:
      return PBSArticleColumnCell.itemSize
    case .normal:
      return PBSArticleNormalCell.itemSize
    case .index:
      return PBSArticleIndexCell.itemSize
    case .bigCardE:
      return PBSArticleBigCardECell.itemSize
    case .bigCardX:
      return PBSArticleBigCardXCell.itemSize
    case .bigCardY:
      return PBSArticleBigCardYCell.itemSize
    case .bigCardS:
      return PBSArticleBigCardSCell.itemSize
    }
  }
}
