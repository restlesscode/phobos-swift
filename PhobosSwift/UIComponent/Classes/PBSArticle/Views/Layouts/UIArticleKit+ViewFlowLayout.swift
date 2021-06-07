//
//
//  UIArticleKit+ViewFlowLayout.swift
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

/// Article
public struct UIArticleKit {
  typealias SectionElementKind = String

  public class ViewFlowLayout: UICollectionViewFlowLayout {
    public weak var delegate: UIArticleKitFlowLayoutDelegate!

    convenience init(delegate: UIArticleKitFlowLayoutDelegate) {
      self.init()
      self.delegate = delegate
    }

    override private init() {
      super.init()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }

    override public func prepare() {
      super.prepare()

      register(UIArticleKit.DecorationView.self,
               forDecorationViewOfKind: UIArticleKit.DecorationView.Kind.cell(type: .card))
      register(UIArticleKit.DecorationView.self,
               forDecorationViewOfKind: UIArticleKit.DecorationView.Kind.cell(type: .bigCardS))
      register(UIArticleKit.DecorationView.self,
               forDecorationViewOfKind: UIArticleKit.DecorationView.Kind.cell(type: .bigCardE))
      register(UIArticleKit.DecorationView.self,
               forDecorationViewOfKind: UIArticleKit.DecorationView.Kind.cell(type: .bigCardX))
      register(UIArticleKit.DecorationView.self,
               forDecorationViewOfKind: UIArticleKit.DecorationView.Kind.cell(type: .bigCardY))
      register(UIArticleKit.DecorationView.self,
               forDecorationViewOfKind: UIArticleKit.DecorationView.Kind.cell(type: .column))
      register(UIArticleKit.DecorationView.self,
               forDecorationViewOfKind: UIArticleKit.DecorationView.Kind.cell(type: .normal))
      register(UIArticleKit.DecorationView.self,
               forDecorationViewOfKind: UIArticleKit.DecorationView.Kind.cell(type: .index))
      register(UIArticleKit.DecorationView.self,
               forDecorationViewOfKind: UIArticleKit.DecorationView.Kind.header)
      register(UIArticleKit.DecorationView.self,
               forDecorationViewOfKind: UIArticleKit.DecorationView.Kind.footer)
    }

    private func register(_ viewClass: AnyClass?, forDecorationViewOfKind kind: UIArticleKit.DecorationView.Kind) {
      register(viewClass, forDecorationViewOfKind: kind.rawValue)
    }

    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
      guard let attributes = super.layoutAttributesForElements(in: rect),
            let collectionView = self.collectionView else {
        return nil
      }

      let headerAttributes = attributes.filter {
        $0.representedElementKind == UICollectionView.elementKindSectionHeader
      }.flatMap { attr -> [UICollectionViewLayoutAttributes] in

        let decorationAttributes = UIArticleKit.DecorationView.FlowLayoutAttributes(forDecorationViewOfKind: DecorationView.Kind.header,
                                                                                    with: attr.indexPath,
                                                                                    rowIndex: attr.indexPath.item,
                                                                                    colorSet: delegate.flowLayout(self, colorSetInSection: attr.indexPath.section),
                                                                                    numberOfRows: numberOfRows(inSection: attr.indexPath.section))

        decorationAttributes.frame = CGRect(x: attr.frame.origin.x - collectionView.contentInset.left,
                                            y: attr.frame.origin.y,
                                            width: attr.frame.width + collectionView.contentInset.left + collectionView.contentInset.right,
                                            height: attr.frame.height)

        decorationAttributes.zIndex = min(-1, attr.zIndex - 1)
        decorationAttributes.colorSet = delegate.flowLayout(self, colorSetInSection: attr.indexPath.section)
        return [attr, decorationAttributes]
      }

      let footerAttributes = attributes.filter {
        $0.representedElementKind == UICollectionView.elementKindSectionFooter
      }.flatMap { attr -> [UICollectionViewLayoutAttributes] in

        let decorationAttributes = UIArticleKit.DecorationView.FlowLayoutAttributes(forDecorationViewOfKind: DecorationView.Kind.footer,
                                                                                    with: attr.indexPath,
                                                                                    rowIndex: attr.indexPath.item,
                                                                                    colorSet: delegate.flowLayout(self, colorSetInSection: attr.indexPath.section),
                                                                                    numberOfRows: numberOfRows(inSection: attr.indexPath.section))

        decorationAttributes.frame = CGRect(x: attr.frame.origin.x - collectionView.contentInset.left,
                                            y: attr.frame.origin.y,
                                            width: attr.frame.width + collectionView.contentInset.left + collectionView.contentInset.right,
                                            height: attr.frame.height)

        decorationAttributes.zIndex = min(-1, attr.zIndex - 1)
        decorationAttributes.colorSet = delegate.flowLayout(self, colorSetInSection: attr.indexPath.section)
        return [attr, decorationAttributes]
      }

      let cellAttributes = attributes.filter {
        $0.representedElementCategory == UICollectionView.ElementCategory.cell
      }.flatMap { attr -> [UICollectionViewLayoutAttributes] in

        let lineSpacing = attr.indexPath.item == 0 ? 0 : self.minimumLineSpacing

        let cellType: UIArticleKit.DecorationView.CellType = delegate?.flowLayout(self, cellTypeOfIndexPath: attr.indexPath) ?? .normal

        let decorationAttributes = UIArticleKit.DecorationView.FlowLayoutAttributes(forDecorationViewOfKind: DecorationView.Kind.cell(type: cellType),
                                                                                    with: attr.indexPath,
                                                                                    rowIndex: row(ofIndexPath: attr.indexPath),
                                                                                    colorSet: delegate.flowLayout(self, colorSetInSection: attr.indexPath.section),
                                                                                    numberOfRows: numberOfRows(inSection: attr.indexPath.section))

        decorationAttributes.frame = CGRect(x: attr.frame.origin.x - collectionView.contentInset.left,
                                            y: attr.frame.origin.y - lineSpacing,
                                            width: attr.frame.width + collectionView.contentInset.left + collectionView.contentInset.right,
                                            height: attr.frame.height + lineSpacing + 1)

        decorationAttributes.zIndex = attr.zIndex - 1
        decorationAttributes.colorSet = delegate.flowLayout(self, colorSetInSection: attr.indexPath.section)
        return [attr, decorationAttributes]
      }

      return headerAttributes + footerAttributes + cellAttributes
    }
  }
}

extension UIArticleKit.ViewFlowLayout {
  private func numberCells(cellTypes: [UIArticleKit.DecorationView.CellType], inSection section: Int) -> Int {
    guard let collectionView = self.collectionView, let delegate = self.delegate else { return 0 }

    let items = collectionView.numberOfItems(inSection: section)

    return (0..<items).compactMap {
      delegate.flowLayout(self, cellTypeOfIndexPath: IndexPath(item: $0, section: section))
    }.filter {
      cellTypes.contains($0)
    }.count
  }

  /// total number of card cells
  public func numberOfCardCell(inSection section: Int) -> Int {
    numberCells(cellTypes: [.card, .bigCardS, .bigCardE, .bigCardX, .bigCardY], inSection: section)
  }

  /// total number of column cells
  public func numberOfColumnCells(inSection section: Int) -> Int {
    numberCells(cellTypes: [.column], inSection: section)
  }

  /// total number of normal cells
  public func numberOfNormalCells(inSection section: Int) -> Int {
    numberCells(cellTypes: [.normal], inSection: section)
  }

  /// total number of index cells
  public func numberOfIndexCells(inSection section: Int) -> Int {
    numberCells(cellTypes: [.index], inSection: section)
  }

  /// total number of rows for all cells
  /// # `rows` is not equal to the `number` of cells
  public func numberOfRows(inSection section: Int) -> Int {
    guard let collectionView = self.collectionView else { return 0 }

    let items = collectionView.numberOfItems(inSection: section)

    return items - numberOfColumnCells(inSection: section) / 2
  }

  /// row number for an indexpath
  public func row(ofIndexPath indexPath: IndexPath) -> Int {
    guard let collectionView = self.collectionView, let delegate = self.delegate else { return 0 }

    let items = collectionView.numberOfItems(inSection: indexPath.section)

    var adjustOffset = 0
    var isRightColumn = false

    for item in 0..<items {
      let cellType = delegate.flowLayout(self, cellTypeOfIndexPath: IndexPath(item: item, section: indexPath.section))

      if cellType == .column {
        if isRightColumn {
          adjustOffset += 1
        }
        isRightColumn = !isRightColumn
      }

      if indexPath.item == item {
        return indexPath.item - adjustOffset
      }
    }

    return indexPath.item
  }
}
