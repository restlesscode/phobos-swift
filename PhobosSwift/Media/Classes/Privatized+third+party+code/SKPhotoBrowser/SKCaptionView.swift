//
//  SKCaptionView.swift
//  SKPhotoBrowser
//
//  Created by suzuki_keishi  on 2015/10/07.
//  Copyright © 2015 suzuki_keishi. All rights reserved.
//

import UIKit

open class SKCaptionView: UIView {
  fileprivate var photo: SKPhotoProtocol?
  fileprivate var photoLabel: UILabel!
  fileprivate var photoLabelPadding: CGFloat = 10

  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  override public init(frame: CGRect) {
    super.init(frame: frame)
  }

  public convenience init(photo: SKPhotoProtocol) {
    self.init(frame: CGRect(x: 0, y: 0, width: SKMesurement.screenWidth, height: SKMesurement.screenHeight))
    self.photo = photo
    setup()
  }

  override open func sizeThatFits(_ size: CGSize) -> CGSize {
    guard let text = photoLabel.text, !text.isEmpty else {
      return CGSize.zero
    }

    let font: UIFont = photoLabel.font
    let width: CGFloat = size.width - photoLabelPadding * 2
    let height: CGFloat = photoLabel.font.lineHeight * CGFloat(photoLabel.numberOfLines)

    let attributedText = NSAttributedString(string: text, attributes: [NSAttributedString.Key.font: font])
    let textSize = attributedText.boundingRect(with: CGSize(width: width, height: height), options: .usesLineFragmentOrigin, context: nil).size

    return CGSize(width: textSize.width, height: textSize.height + photoLabelPadding * 2)
  }
}

extension SKCaptionView {
  private func setup() {
    isOpaque = false
    autoresizingMask = [.flexibleWidth, .flexibleTopMargin, .flexibleRightMargin, .flexibleLeftMargin]

    // setup photoLabel
    setupPhotoLabel()
  }

  private func setupPhotoLabel() {
    photoLabel = UILabel(frame: CGRect(x: photoLabelPadding, y: 0, width: bounds.size.width - (photoLabelPadding * 2), height: bounds.size.height))
    photoLabel.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    photoLabel.isOpaque = false
    photoLabel.backgroundColor = SKCaptionOptions.backgroundColor
    photoLabel.textColor = SKCaptionOptions.textColor
    photoLabel.textAlignment = SKCaptionOptions.textAlignment
    photoLabel.lineBreakMode = SKCaptionOptions.lineBreakMode
    photoLabel.numberOfLines = SKCaptionOptions.numberOfLine
    photoLabel.font = SKCaptionOptions.font
    photoLabel.shadowColor = UIColor(white: 0.0, alpha: 0.5)
    photoLabel.shadowOffset = CGSize(width: 0.0, height: 1.0)
    photoLabel.text = photo?.caption

    addSubview(photoLabel)
  }
}
