//
//
//  PBSGrowthHomeContactCell.swift
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

class PBSGrowthHomeContactItemCell: UICollectionViewCell, PBSUIInterface {
  let backView = UIView()
  let iconImageView = UIImageView()
  let titleLabel = UILabel()

  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .clear
    backView.backgroundColor = UIColor.pbs.color(R: 44, G: 44, B: 46)
    backView.layer.cornerRadius = 12
    addSubview(backView)
    backView.addSubview(iconImageView)
    titleLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
    titleLabel.textColor = .white
    titleLabel.textAlignment = .center
    backView.addSubview(titleLabel)
    backView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    iconImageView.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(8)
      make.centerX.equalToSuperview()
      make.width.equalTo(38)
      make.height.equalTo(33)
    }
    titleLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(38)
      make.left.right.equalToSuperview()
      make.height.equalTo(22)
    }
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

class PBSGrowthHomeContactCell: PBSGrowthHomeBaseCell {
  override init(frame: CGRect) {
    super.init(frame: frame)
    view.collectionView.register(PBSGrowthHomeContactItemCell.self,
                                 forCellWithReuseIdentifier: PBSGrowthHomeContactItemCell.id)
    view.cellForItemAt = { collectionView, indexPath, data in
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PBSGrowthHomeContactItemCell.id, for: indexPath)
      guard let _cell = cell as? PBSGrowthHomeContactItemCell else { return cell }
      _cell.titleLabel.text = data.data.title
      if #available(iOS 13.0, *) {
        if
          case let .systemImage(name) = data.data.imageType,
          let name = name,
          let image = UIImage(systemName: name) {
          _cell.iconImageView.image = image
        }
      }
      return cell
    }
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
