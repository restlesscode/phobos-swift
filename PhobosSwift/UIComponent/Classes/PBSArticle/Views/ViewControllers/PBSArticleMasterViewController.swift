//
//
//  PBSArticleMasterViewController.swift
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
import PhobosSwiftRouter
import SnapKit
import UIKit

private let kHeaderHeight: CGFloat = 88
private let kFooterHeight: CGFloat = 62

open class PBSArticleMasterViewController: UIViewController, UIArticleKitFlowLayoutDelegate {
  open var sectionViewModels: [PBSArticleSectionViewModel] = []
  
  open lazy var layout: UIArticleKit.ViewFlowLayout = {
    let _layout = UIArticleKit.ViewFlowLayout(delegate: self)
    _layout.minimumLineSpacing = 18.0
    _layout.minimumInteritemSpacing = 18.0
    _layout.scrollDirection = .vertical
    _layout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: kHeaderHeight)
    _layout.footerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: kFooterHeight)
    
    return _layout
  }()
  
  open lazy var collectionView: UICollectionView = {
    let _collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    view.addSubview(_collectionView)
    _collectionView.delegate = self
    _collectionView.dataSource = self
    _collectionView.contentInset = UIEdgeInsets(top: 18, left: 18, bottom: 18, right: 18)
    
    return _collectionView
  }()
  
  override open func viewDidLoad() {
    super.viewDidLoad()
    
    makeSubviews()
    makeStyles()
  }
  
  func generateDemo() {
    title = "Apple News"
    
    if #available(iOS 11.0, *) {
      navigationController?.navigationBar.prefersLargeTitles = true
      navigationItem.largeTitleDisplayMode = .automatic
    }
    
    sectionViewModels = [PBSArticleSectionViewModel.demoViewModel(numberOfArticles: 12),
                         PBSArticleSectionViewModel.demoViewModel(numberOfArticles: 8),
                         PBSArticleSectionViewModel.demoViewModel(numberOfArticles: 8),
                         PBSArticleSectionViewModel.demoViewModel(numberOfArticles: 8),
                         PBSArticleSectionViewModel.demoViewModel(numberOfArticles: 8),
                         PBSArticleSectionViewModel.demoViewModel(numberOfArticles: 8),
                         PBSArticleSectionViewModel.demoViewModel(numberOfArticles: 8),
                         PBSArticleSectionViewModel.demoViewModel(numberOfArticles: 8),
                         PBSArticleSectionViewModel.demoViewModel(numberOfArticles: 8),
                         PBSArticleSectionViewModel.demoViewModel(numberOfArticles: 8)]
    
    sectionViewModels[1].title.accept("iOS Tutorial")
    sectionViewModels[1].subtitle.accept("")
    
    sectionViewModels[5].title.accept("Android Tutorial")
    sectionViewModels[5].subtitle.accept("")
  }
  
  private func makeSubviews() {
    makeCollectionView()
  }
  
  private func makeCollectionView() {
    collectionView.snp.makeConstraints {
      $0.edges.equalTo(0)
    }
    
    registerHeaders()
    registerCells(cellClasses: [PBSArticleColumnCell.self,
                                PBSArticleNormalCell.self,
                                PBSArticleIndexCell.self,
                                PBSArticleCardCell.self,
                                PBSArticleBigCardECell.self,
                                PBSArticleBigCardXCell.self,
                                PBSArticleBigCardYCell.self,
                                PBSArticleBigCardSCell.self])
    registerFooters()
  }
  
  private func makeStyles() {
    if #available(iOS 13.0, *) {
      collectionView.backgroundColor = .systemBackground
    } else {
      collectionView.backgroundColor = .white
    }
  }
  
  private func registerCells(cellClasses: [AnyClass]) {
    cellClasses.forEach { cellClass in
      let id = String(describing: cellClass)
      collectionView.register(cellClass, forCellWithReuseIdentifier: id)
    }
  }
  
  private func registerHeaders() {
    collectionView.register(PBSArticleSectionHeader.self,
                            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                            withReuseIdentifier: PBSArticleSectionHeader.pbs.reuseIdentifier)
  }
  
  private func registerFooters() {
    collectionView.register(PBSArticleSectionFooter.self,
                            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                            withReuseIdentifier: PBSArticleSectionFooter.pbs.reuseIdentifier)
    
    collectionView.register(UICollectionReusableView.self,
                            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                            withReuseIdentifier: UICollectionReusableView.pbs.reuseIdentifier)
  }
  
  /// # param - ArticleMasterViewDelegateFlowLayout
  open func flowLayout(_ collectionViewLayout: UIArticleKit.ViewFlowLayout,
                       themeInSection section: Int) -> PBSArticleSectionTheme {
    let idx = section % 11
    return [.green,
            .red,
            .cherry,
            .yellow,
            .gold,
            .orange,
            .brown,
            .indigo,
            .blue,
            .purple,
            .normal][idx]
  }
  
  open func flowLayout(_ collectionViewLayout: UIArticleKit.ViewFlowLayout, colorSetInSection section: Int) -> (first: UIColor, last: UIColor) {
    let colorSetList = [(UIColor.pbs.color(R: 255, G: 255, B: 255),
                         UIColor.pbs.color(R: 221, G: 236, B: 247)),
                        (UIColor.pbs.color(R: 255, G: 255, B: 255),
                         UIColor.pbs.color(R: 224, G: 224, B: 224)),
                        (UIColor.pbs.color(R: 255, G: 255, B: 255),
                         UIColor.pbs.color(R: 242, G: 242, B: 242))]
    
    if section == 0 {
      return colorSetList.first!
    } else if section == 1 {
      return colorSetList[1]
    }
    
    return colorSetList.last!
  }
  
  open func flowLayout(_ collectionViewLayout: UIArticleKit.ViewFlowLayout,
                       cellTypeOfIndexPath indexPath: IndexPath) -> UIArticleKit.DecorationView.CellType {
    let numberOfItems = collectionViewLayout.collectionView?.numberOfItems(inSection: indexPath.section) ?? 0
    var numberOfColumn = numberOfItems / 2
    numberOfColumn = (numberOfColumn % 2) == 0 ? numberOfColumn : (numberOfColumn - 1)
    
    if indexPath.section == 0 {
      if indexPath.item == 0 {
        return .card
      } else if indexPath.item == 1 {
        return .bigCardS
      } else if indexPath.item < 4 {
        return .normal
      } else if indexPath.item < 8 {
        return .column
      } else {
        return .index
      }
    }
    
    if indexPath.section == 1 {
      return .index
    }
    
    if indexPath.item == 0 {
      if indexPath.section == 2 {
        return .bigCardS
      } else if indexPath.section == 3 {
        return .bigCardE
      } else if indexPath.section == 4 {
        return .bigCardX
      } else if indexPath.section == 5 {
        return .bigCardY
      }
      return .card
    } else if indexPath.item <= numberOfColumn {
      return .column
    } else if indexPath.item > numberOfItems - 3 {
      return .index
    } else {
      return .normal
    }
  }
  
  /// 求出当前index的位置
  open func flowLayout(_ collectionViewLayout: UIArticleKit.ViewFlowLayout, indexInTpyeGroup indexPath: IndexPath) -> Int {
    let cellType = flowLayout(collectionViewLayout, cellTypeOfIndexPath: indexPath)
    
    let items = collectionView.numberOfItems(inSection: indexPath.section)
    
    // 首先计算出IndexType从哪个item开始
    var adjustOffset = (0..<items).filter {
      let currentCellType = flowLayout(collectionViewLayout, cellTypeOfIndexPath: IndexPath(item: $0, section: indexPath.section))
      return currentCellType == cellType
    }.first ?? 0
    
    var isRightColumn = false
    
    for item in 0..<items {
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

extension PBSArticleMasterViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    sectionViewModels[section].articleViewModels.count
  }
  
  open func numberOfSections(in collectionView: UICollectionView) -> Int {
    sectionViewModels.count
  }
  
  open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cellType = flowLayout(layout, cellTypeOfIndexPath: indexPath)
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.reuseIdentifier, for: indexPath)
    let model = sectionViewModels[indexPath.section].articleViewModels[indexPath.item]
    
    if let cell = cell as? PBSArticleIndexCell {
      let rowIndex = flowLayout(layout, indexInTpyeGroup: indexPath) + 1
      cell.indexLabel.text = "\(rowIndex)"
    }
    
    let theme = flowLayout(layout, themeInSection: indexPath.section)
    (cell as? PBSArticleCellProtocol)?.render(theme: theme, model: model)
    
    return cell
  }
  
  open func collectionView(_ collectionView: UICollectionView,
                           viewForSupplementaryElementOfKind kind: String,
                           at indexPath: IndexPath) -> UICollectionReusableView {
    let articleSectionViewModel = sectionViewModels[indexPath.section]
    
    switch kind {
    case UICollectionView.elementKindSectionHeader:
      if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier: PBSArticleSectionHeader.pbs.reuseIdentifier,
                                                                             for: indexPath) as? PBSArticleSectionHeader {
        let theme = flowLayout(layout, themeInSection: indexPath.section)
        sectionHeader.render(theme: theme, sectionViewModel: articleSectionViewModel)
        
        return sectionHeader
      }
    case UICollectionView.elementKindSectionFooter:
      if indexPath.section == 1 {
        let sectionFooter = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                            withReuseIdentifier: UICollectionReusableView.pbs.reuseIdentifier,
                                                                            for: indexPath)
        
        return sectionFooter
      }
      if let sectionFooter = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier: PBSArticleSectionFooter.pbs.reuseIdentifier,
                                                                             for: indexPath) as? PBSArticleSectionFooter {
        let theme = flowLayout(layout, themeInSection: indexPath.section)
        sectionFooter.render(theme: theme, sectionViewModel: articleSectionViewModel)
        
        return sectionFooter
      }
    default:
      return UICollectionReusableView()
    }
    
    return UICollectionReusableView()
  }
  
  open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    collectionView.deselectItem(at: indexPath, animated: true)
    let articleViewModel = sectionViewModels[indexPath.section].articleViewModels[indexPath.row]
    let articleDetailViewCtrl = PBSArticleDetailViewController()
    articleDetailViewCtrl.articleViewModel = articleViewModel
    show(articleDetailViewCtrl, sender: self)
  }
}

extension PBSArticleMasterViewController: UICollectionViewDelegateFlowLayout {
  open func collectionView(_ collectionView: UICollectionView,
                           layout collectionViewLayout: UICollectionViewLayout,
                           sizeForItemAt indexPath: IndexPath) -> CGSize {
    let cellType: UIArticleKit.DecorationView.CellType = flowLayout(layout, cellTypeOfIndexPath: indexPath)
    return cellType.itemSize
  }
}
