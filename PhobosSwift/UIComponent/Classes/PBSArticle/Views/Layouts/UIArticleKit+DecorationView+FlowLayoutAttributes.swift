//
//
//  UIArticleKit+DecorationView+FlowLayoutAttributes.swift
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

private let kHeader = "header"
private let kFooter = "footer"

extension UIArticleKit.DecorationView {
  /// The kind of decoration view
  public enum Kind {
    /// header
    case header
    /// footer
    case footer
    /// cell
    case cell(type: CellType)

    var rawValue: String {
      switch self {
      case .header:
        return kHeader
      case .footer:
        return kFooter
      case let .cell(type):
        return type.rawValue
      }
    }
  }

  public enum CellType: String {
    case card
    case bigCardS
    case bigCardE
    case bigCardX
    case bigCardY
    case index
    case column
    case normal
  }
}

extension UIArticleKit.DecorationView {
  public class FlowLayoutAttributes: UICollectionViewLayoutAttributes {
    var numberOfRows = 0

    var rowIndex = 0

    var colorSet: (first: UIColor, last: UIColor) = (.white, .black)

    var kind: UIArticleKit.DecorationView.Kind!

    public convenience init(forDecorationViewOfKind kind: UIArticleKit.DecorationView.Kind,
                            with indexPath: IndexPath,
                            rowIndex: Int,
                            colorSet: (UIColor, UIColor),
                            numberOfRows: Int) {
      self.init(forDecorationViewOfKind: kind.rawValue, with: indexPath)
      self.rowIndex = rowIndex
      self.kind = kind
      self.colorSet = colorSet
      self.numberOfRows = numberOfRows
    }
  }
}
