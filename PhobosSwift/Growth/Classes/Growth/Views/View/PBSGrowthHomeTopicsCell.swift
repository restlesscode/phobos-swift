//
//
//  PBSGrowthHomeTopicsCell.swift
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

import Foundation
import PhobosSwiftCore
import SnapKit

class PBSGrowthHomeTopicsItemCell: UICollectionViewCell, PBSUIInterface {
  let backView = UIView()
  let iconImageView = UIImageView()
  let titleLabel = UILabel()
  let subTitleLabel = UILabel()
  let triangleImageView = UIImageView()
  let bottomLine = UIView()
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .clear
    backView.backgroundColor = UIColor.pbs.color(R: 44, G: 44, B: 46)
    addSubview(backView)
    backView.addSubview(iconImageView)
    iconImageView.backgroundColor = .red
    titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
    titleLabel.textColor = .white
    titleLabel.numberOfLines = 0
    backView.addSubview(titleLabel)
    subTitleLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
    subTitleLabel.textColor = UIColor.pbs.color(R: 158, G: 158, B: 167)
    subTitleLabel.numberOfLines = 0
    backView.addSubview(subTitleLabel)
    triangleImageView.contentMode = .scaleAspectFit
    if #available(iOS 13.0, *) {
      triangleImageView.image = UIImage(systemName: "chevron.right")
    }
    backView.addSubview(triangleImageView)
    bottomLine.backgroundColor = UIColor.pbs.color(R: 59, G: 59, B: 62)
    backView.addSubview(bottomLine)

    backView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    iconImageView.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(13)
      make.left.equalToSuperview().offset(17)
      make.width.height.equalTo(32)
    }
    titleLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(12)
      make.left.equalTo(iconImageView.snp.right).offset(27)
      make.right.equalToSuperview().offset(-50)
      make.height.lessThanOrEqualTo(45)
    }
    subTitleLabel.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom).offset(9)
      make.left.equalTo(titleLabel.snp.left)
      make.right.equalTo(titleLabel.snp.right)
      make.height.lessThanOrEqualTo(37)
    }
    triangleImageView.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(50)
      make.right.equalToSuperview().offset(-14)
      make.width.equalTo(11)
      make.height.equalTo(22)
    }
    bottomLine.snp.makeConstraints { make in
      make.bottom.equalToSuperview()
      make.left.equalToSuperview().offset(62)
      make.right.equalToSuperview()
      make.height.equalTo(1 / UIScreen.main.scale)
    }
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

class PBSGrowthHomeTopicsCell: PBSGrowthHomeBaseCell {
  override init(frame: CGRect) {
    super.init(frame: frame)
    view.layout.scrollDirection = .vertical
    view.layout.minimumLineSpacing = 0
    view.layout.minimumInteritemSpacing = 0
    view.collectionView.collectionViewLayout.invalidateLayout()
    view.collectionView.layer.cornerRadius = 12
    view.collectionView.layer.masksToBounds = true
    view.collectionView.isScrollEnabled = false
    view.collectionView.snp.remakeConstraints { make in
      make.top.bottom.equalToSuperview()
      make.left.equalToSuperview().offset(20)
      make.right.equalToSuperview().offset(-20)
    }
    view.collectionView.register(PBSGrowthHomeTopicsItemCell.self,
                                 forCellWithReuseIdentifier: PBSGrowthHomeTopicsItemCell.id)
    view.cellForItemAt = { [weak self] collectionView, indexPath, data in
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PBSGrowthHomeTopicsItemCell.id, for: indexPath)
      guard
        let _cell = cell as? PBSGrowthHomeTopicsItemCell,
        let self = self
      else {
        return cell
      }
      _cell.titleLabel.text = data.data.title
      _cell.subTitleLabel.text = data.data.subTitle
      _cell.bottomLine.isHidden = (indexPath.row >= (self.view.dataSource.count - 1))
      return cell
    }
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
