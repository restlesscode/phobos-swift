//
//
//  ImageBrowerTextLabelDeleteView.swift
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

class ImageBrowerTextLabelDeleteView: UIView {
  let deleteIcon = UIImageView()
  let deleteLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 15)
    label.textColor = UIColor.white
    label.textAlignment = .center
    return label
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(deleteIcon)
    addSubview(deleteLabel)
    corner(radii: 10)
    deleteIcon.frame = CGRect(x: frame.width / 2 - 10, y: 10, width: 20, height: 20)
    deleteLabel.frame = CGRect(x: 0, y: deleteIcon.bottom() + 10, width: frame.width, height: 20)
    setStatus(canDelete: false)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setStatus(canDelete: Bool) {
    deleteLabel.text = canDelete ? "松开即可删除" : "拖到此处删除"
    deleteIcon.image = baseBundle.image(withName: canDelete ? "delete_open" : "delete_close")
    backgroundColor = canDelete ? PBSImageBrowerColor.blue : PBSImageBrowerColor.black
  }
}
