//
//
//  PBSGrowthHomeContainerView.swift
//  PhobosSwiftGrowth
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
import SnapKit
import UIKit

class PBSGrowthHomeBaseCell: UICollectionViewCell, PBSGrowthContainerProtocol, PBSUIInterface {
  var didSelectItem: ((IndexPath, PBSGrowthHomeContainerViewModel) -> Void)? {
    didSet {
      view.didSelectItem = didSelectItem
    }
  }

  lazy var view: PBSGrowthHomeContainerView = {
    let view = PBSGrowthHomeContainerView()
    return view
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(view)
    view.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    view.didSelectItem = didSelectItem
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

class PBSGrowthHomeContainerView: UIView, PBSGrowthContainerProtocol {
  var dataSource: [Any] = [] {
    didSet {
      collectionView.reloadData()
    }
  }

  var didSelectItem: ((_ indexPath: IndexPath, _ data: PBSGrowthHomeContainerViewModel) -> Void)?

  var cellForItemAt: ((_ collectionView: UICollectionView, _ indexPath: IndexPath, _ data: PBSGrowthHomeContainerViewModel) -> UICollectionViewCell)?

  lazy var layout: UICollectionViewFlowLayout = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    return layout
  }()

  lazy var collectionView: UICollectionView = {
    let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
    view.delegate = self
    view.dataSource = self
    view.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCell")
    view.showsVerticalScrollIndicator = false
    view.showsHorizontalScrollIndicator = false
    return view
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(collectionView)
    collectionView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension PBSGrowthHomeContainerView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    dataSource.count
  }

  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard
      let data = dataSource[indexPath.row] as? PBSGrowthHomeContainerViewModel,
      let cellForItemAt = cellForItemAt
    else {
      return collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCell", for: indexPath)
    }
    return cellForItemAt(collectionView, indexPath, data)
  }

  public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    guard let data = dataSource[indexPath.row] as? PBSGrowthHomeContainerViewModel else { return .zero }
    return CGSize(width: CGFloat(data.itemWidth),
                  height: CGFloat(data.itemHeight))
  }

  public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
  }

  public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard
      let data = dataSource[indexPath.row] as? PBSGrowthHomeContainerViewModel,
      let didSelectItem = didSelectItem
    else {
      return
    }
    didSelectItem(indexPath, data)
  }
}
