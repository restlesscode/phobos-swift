//
//
//  PBSActivityButton.swift
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
import SnapKit
import UIKit

/// 点击后，出现选择loading的button
///
open class PBSActivityButton: UIButton {
  /*
   // Only override draw() if you perform custom drawing.
   // An empty implementation adversely affects performance during animation.
   override func draw(_ rect: CGRect) {
   // Drawing code
   }
   */
  let activity = UIActivityIndicatorView()

  override public var tintColor: UIColor! {
    didSet {
      activity.color = tintColor
    }
  }

  private var backupTitle: String?
  private var backupImage: UIImage?
  public var enabledBackgroundColor = UIColor.pbs.systemFill {
    didSet {
      isEnabled = true
    }
  }

  public var disabledBackgroundColor = UIColor.pbs.systemFill.withAlphaComponent(0.75) {
    didSet {
      isEnabled = true
    }
  }

  override public var isEnabled: Bool {
    didSet {
      backgroundColor = isEnabled ? enabledBackgroundColor : disabledBackgroundColor
    }
  }

  public convenience init(type: UIButton.ButtonType, enabledBackgroundColor: UIColor, disabledBackgroundColor: UIColor) {
    self.init(type: type)
    self.enabledBackgroundColor = enabledBackgroundColor
    self.disabledBackgroundColor = disabledBackgroundColor
  }

  @available(*, unavailable)
  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override public init(frame: CGRect) {
    super.init(frame: frame)

    layer.cornerRadius = 6.0
    tintColor = .white
    backgroundColor = enabledBackgroundColor

    addSubview(activity)
    activity.hidesWhenStopped = true
    activity.snp.remakeConstraints { [weak self] make in
      guard let self = self else { return }
      make.center.equalTo(self.snp.center)
    }
  }

  /// 开始选择loading
  ///
  public func showAnimating(show: Bool) {
    if backupTitle == nil {
      backupTitle = title(for: .normal) ?? ""
    }
    if backupImage == nil {
      backupImage = image(for: .normal)
    }

    if show {
      isUserInteractionEnabled = false
      backupTitle = title(for: .normal) ?? ""
      backupImage = image(for: .normal)
      setTitle("", for: .normal)
      setImage(nil, for: .normal)
      activity.startAnimating()
    } else {
      isUserInteractionEnabled = true
      activity.stopAnimating()
      setTitle(backupTitle, for: .normal)
      setImage(backupImage, for: .normal)
    }
  }
}
