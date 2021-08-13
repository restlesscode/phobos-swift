//
//
//  PBSGrowthHomeHeaderView.swift
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

class PBSGrowthHomeHeaderItemCell: UICollectionViewCell, PBSUIInterface {
  let backView = UIView()
  let iconImageView = UIImageView()
  let titleLabel = UILabel()
  let subTitleLabel = UILabel()

  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .clear
    backView.backgroundColor = UIColor.pbs.color(R: 44, G: 44, B: 46)
    backView.layer.cornerRadius = 12
    addSubview(backView)
    backView.addSubview(iconImageView)
    iconImageView.backgroundColor = .red
    titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
    titleLabel.textColor = .white
    titleLabel.textAlignment = .center
    backView.addSubview(titleLabel)
    subTitleLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
    subTitleLabel.textColor = .white
    subTitleLabel.textAlignment = .center
    subTitleLabel.numberOfLines = 0
    backView.addSubview(subTitleLabel)
    backView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    iconImageView.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(15)
      make.centerX.equalToSuperview()
      make.width.height.equalTo(88)
    }
    titleLabel.snp.makeConstraints { make in
      make.top.equalTo(iconImageView.snp.bottom).offset(10)
      make.left.equalToSuperview().offset(27)
      make.right.equalToSuperview().offset(-27)
      make.height.equalTo(28)
    }
    subTitleLabel.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom).offset(12)
      make.left.equalToSuperview().offset(18)
      make.right.equalToSuperview().offset(-18)
      make.height.lessThanOrEqualTo(55)
    }
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

class PBSGrowthHomeHeaderCell: PBSGrowthHomeBaseCell {
  override init(frame: CGRect) {
    super.init(frame: frame)
    view.collectionView.register(PBSGrowthHomeHeaderItemCell.self,
                                 forCellWithReuseIdentifier: PBSGrowthHomeHeaderItemCell.id)
    view.cellForItemAt = { collectionView, indexPath, data in
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PBSGrowthHomeHeaderItemCell.id, for: indexPath)
      if
        let _cell = cell as? PBSGrowthHomeHeaderItemCell,
        let _data = data.data as? PBSGrowthHomeItemModel {
        _cell.titleLabel.text = _data.title
        _cell.subTitleLabel.text = _data.subTitle
      }
      return cell
    }
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
