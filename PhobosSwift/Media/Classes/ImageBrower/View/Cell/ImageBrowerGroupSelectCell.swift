//
//
//  ImageBrowerGroupSelectCell.swift
//  PhobosSwiftMedia
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
import SnapKit

class ImageBrowerGroupSelectCell: UITableViewCell {
  let assetImageView: UIImageView = {
    let view = UIImageView()
    view.contentMode = .scaleAspectFill
    view.clipsToBounds = true
    return view
  }()

  let nameLabel: UILabel = {
    let label = UILabel()
    label.textColor = UIColor.white
    label.font = UIFont.systemFont(ofSize: 15)
    return label
  }()

  let selectedImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .center
    imageView.image = baseBundle.image(withName: "cell_check_selected")
    return imageView
  }()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    selectionStyle = .none
    backgroundColor = PBSImageBrower.Color.whiteGrey8

    UISetUp()
  }

  @available(*, unavailable)
  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func UISetUp() {
    contentView.addSubview(assetImageView)
    contentView.addSubview(nameLabel)
    contentView.addSubview(selectedImageView)
    backgroundColor = PBSImageBrower.Color.black

    assetImageView.snp.makeConstraints { make in
      make.left.top.bottom.equalToSuperview()
      make.width.equalTo(self.snp.height)
    }

    nameLabel.snp.makeConstraints { make in
      make.left.equalTo(assetImageView.snp.right).offset(15)
      make.centerY.equalToSuperview()
    }

    selectedImageView.snp.makeConstraints { make in
      make.right.equalToSuperview().offset(-20)
      make.centerY.equalToSuperview()
    }
  }

  func setData(collection: ImageBrowerPHCollection, isSelected: Bool) {
    if let image = collection.asstes[0].thumb {
      assetImageView.image = image
    } else {
      collection.asstes[0].getThumbImage { [weak self] image in
        self?.assetImageView.image = image
      }
    }

    selectedImageView.isHidden = !isSelected
    if let title = collection.collection.localizedTitle {
      let fullText = title + "  (\(collection.asstes.count))"
      let attrText = NSMutableAttributedString(string: fullText)
      attrText.addAttribute(.foregroundColor, value: PBSImageBrower.Color.grey5Grey3, range: NSRange(location: title.count, length: fullText.count - title.count))

      nameLabel.attributedText = attrText
    }
  }
}
