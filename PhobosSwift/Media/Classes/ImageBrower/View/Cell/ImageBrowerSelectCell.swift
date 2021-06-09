//
//
//  ImageBrowerSelectCell.swift
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

class ImageBrowerSelectCell: UICollectionViewCell {
  let imageView = UIImageView()
  let selectCoverView: UIView = {
    let view = UIView()
    view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
    view.isHidden = true
    return view
  }()

  let selectNomalView: UIView = {
    let view = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 20, height: 20)))
    view.layer.borderWidth = 2
    view.layer.borderColor = UIColor.white.cgColor
    view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
    view.layer.cornerRadius = 10
//        view.corner(radii: 10)
    return view
  }()

  let selectedView: UIImageView = {
    let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: 20, height: 20)))
    imageView.image = baseBundle.image(withName: "cell_check_selected")
//        label.text = ""
    return imageView
  }()

  let scaleAnimation: CAAnimation = {
    let scaleAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
    scaleAnimation.values = [1, 1.1, 0.9, 1]
    scaleAnimation.duration = 0.5
    return scaleAnimation
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    imageView.frame = CGRect(origin: .zero, size: frame.size)
    selectCoverView.frame = CGRect(origin: .zero, size: frame.size)
    selectNomalView.frame.origin = CGPoint(x: frame.width - selectNomalView.frame.width - 10, y: 10)
    selectedView.frame.origin = selectNomalView.frame.origin
    addSubview(imageView)
    addSubview(selectNomalView)
    addSubview(selectCoverView)
    addSubview(selectedView)
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setImage(_ image: UIImage?) {
    imageView.image = image
  }

  func setSelectStatus(selected: Bool) {
    selectCoverView.isHidden = !selected
    selectNomalView.isHidden = selected
    selectedView.isHidden = !selected
//        selectedView.text = String(index)

    if selected {
      selectedView.layer.add(scaleAnimation, forKey: nil)
    }
  }
}
