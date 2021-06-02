//
//
//  PBSSegmentContentView.swift
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

private let kCellID = "CellID"
open class PBSSegmentContentView: UIView {
  public weak var delegate: PBSSegmentContentViewDelegate?
  
  public weak var reloader: PBSSegmentContentViewReloadable?
  
  public var style: PBSSegmentViewStyle
  
  public var childViewControllers: [UIViewController]
  
  /// 初始化后，默认显示的页数
  public var startIndex: Int = 0
  
  private var startOffsetX: CGFloat = 0
  
  private var isDelegateForbidden: Bool = false
  
  public private(set) lazy var collectionView: UICollectionView = {
    let layout = PBSSegmentCollectionViewFlowLayout()
    layout.minimumLineSpacing = 0
    layout.minimumInteritemSpacing = 0
    layout.scrollDirection = .horizontal
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.showsHorizontalScrollIndicator = false
    collectionView.isPagingEnabled = true
    collectionView.scrollsToTop = false
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.bounces = false
    if #available(iOS 10, *) {
      collectionView.isPrefetchingEnabled = false
    }
    collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kCellID)
    return collectionView
  }()
  
  public init(frame: CGRect, style: PBSSegmentViewStyle, childViewControllers: [UIViewController], startIndex: Int = 0) {
    self.childViewControllers = childViewControllers
    self.style = style
    self.startIndex = startIndex
    super.init(frame: frame)
    setupUI()
  }
  
  public required init?(coder aDecoder: NSCoder) {
    childViewControllers = [UIViewController]()
    style = PBSSegmentViewStyle()
    super.init(coder: aDecoder)
  }
  
  override open func layoutSubviews() {
    super.layoutSubviews()
    collectionView.frame = bounds
    if let layout = collectionView.collectionViewLayout as? PBSSegmentCollectionViewFlowLayout {
      layout.itemSize = bounds.size
      layout.offset = CGFloat(startIndex) * bounds.size.width
    }
  }
}

extension PBSSegmentContentView {
  func setupUI() {
    addSubview(collectionView)
    
    collectionView.backgroundColor = style.contentViewBackgroundColor
    collectionView.isScrollEnabled = style.isContentScrollEnable
  }
}

extension PBSSegmentContentView: UICollectionViewDataSource {
  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    childViewControllers.count
  }
  
  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCellID, for: indexPath)
    
    for subview in cell.contentView.subviews {
      subview.removeFromSuperview()
    }
    let childVc = childViewControllers[indexPath.item]
    
    reloader = childVc as? PBSSegmentContentViewReloadable
    childVc.view.frame = cell.contentView.bounds
    cell.contentView.addSubview(childVc.view)
    
    return cell
  }
}

extension PBSSegmentContentView: UICollectionViewDelegate {
  public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    isDelegateForbidden = false
    startOffsetX = scrollView.contentOffset.x
  }
  
  public func scrollViewDidScroll(_ scrollView: UIScrollView) {
    updateUI(scrollView)
  }
  
  public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    if !decelerate {
      collectionViewDidEndScroll(scrollView)
    }
  }
  
  public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    collectionViewDidEndScroll(scrollView)
  }
  
  func collectionViewDidEndScroll(_ scrollView: UIScrollView) {
    let inIndex = Int(round(collectionView.contentOffset.x / collectionView.bounds.width))
    
    let childVc = childViewControllers[inIndex]
    
    reloader = childVc as? PBSSegmentContentViewReloadable
    
    reloader?.contentViewDidEndScroll?()
    
    delegate?.contentView(self, inIndex: inIndex)
  }
  
  private func updateUI(_ scrollView: UIScrollView) {
    if isDelegateForbidden {
      return
    }
    
    var progress: CGFloat = 0
    var targetIndex = 0
    var sourceIndex = 0
    
    progress = scrollView.contentOffset.x.truncatingRemainder(dividingBy: scrollView.bounds.width) / scrollView.bounds.width
    if progress == 0 {
      return
    }
    
    let index = Int(scrollView.contentOffset.x / scrollView.bounds.width)
    
    if collectionView.contentOffset.x > startOffsetX { // 左滑动
      sourceIndex = index
      targetIndex = index + 1
      if targetIndex > childViewControllers.count - 1 {
        return
      }
    } else {
      sourceIndex = index + 1
      targetIndex = index
      progress = 1 - progress
      if targetIndex < 0 {
        return
      }
    }
    
    if progress > 0.998 {
      progress = 1
    }
    
    delegate?.contentView(self, sourceIndex: sourceIndex, targetIndex: targetIndex, progress: progress)
  }
}

extension PBSSegmentContentView: PBSSegmentTitleViewDelegate {
  public func titleView(_ titleView: PBSSegmentTitleView, currentIndex: Int) {
    isDelegateForbidden = true
    
    if currentIndex > childViewControllers.count - 1 {
      return
    }
    let indexPath = IndexPath(item: currentIndex, section: 0)
    
    collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
  }
}
