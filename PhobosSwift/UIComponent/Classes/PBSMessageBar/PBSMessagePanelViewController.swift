//
//
//  PBSMessagePanelViewController.swift
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

class PBSMessagePanelViewController: UIViewController {
  private let contentView = UIView()
  private let actionsContentView = UIView()
  private var iconImageView = UIImageView()

  private lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.font = self.style.titleFont
    label.textColor = self.style.titleColor
    return label
  }()

  private lazy var messageLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.font = self.style.messageFont
    label.textColor = self.style.messageColor
    return label
  }()

  private var buttons: [UIButton] = []

  private var iconName: String {
    switch style.iconType {
    case .success:
      return "message_bar_success"
    case .fail:
      return "message_bar_warning"
    case .info:
      return "message_bar_info"
    }
  }

  private var selfWidth: CGFloat {
    UIScreen.main.bounds.size.width - 2 * style.spaceToHorizontalEdge
  }

  private var style: PBSMessagePanelStyle!
  private var titleText: String?
  private var messageText: String?
  private var defaultActionTitle: String?
  private var defaultActionHandler: (() -> Void)?
  private var otherActionTitle: String?
  private var otherActionHandler: (() -> Void)?

  convenience init(style: PBSMessagePanelStyle,
                   title: String?,
                   message: String?,
                   defaultActionTitle: String?,
                   defaultActionHandler: (() -> Void)? = nil,
                   otherActionTitle: String?,
                   otherActionHandler: (() -> Void)? = nil) {
    self.init()
    self.style = style
    titleText = title
    messageText = message
    self.defaultActionTitle = defaultActionTitle
    self.defaultActionHandler = defaultActionHandler
    self.otherActionTitle = otherActionTitle
    self.otherActionHandler = otherActionHandler
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    setupUI()
  }

  private func setupUI() {
    view.backgroundColor = .lightGray
    view.layer.cornerRadius = 6.0
    if #available(iOS 11.0, *) {
      self.view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
    setupContentUI()
    setupActionsContentUI()
  }

  private func setupContentUI() {
    view.addSubview(contentView)

    contentView.snp.makeConstraints { make in
      make.left.top.right.equalTo(self.view)
    }

    iconImageView.image = UIImage.image(named: iconName)
    iconImageView.contentMode = .scaleAspectFill
    iconImageView.clipsToBounds = true
    contentView.addSubview(iconImageView)

    iconImageView.snp.makeConstraints { make in
      make.left.top.equalTo(contentView).offset(5.0)
      make.width.height.equalTo(20.0)
    }

    if let titleStr = titleText, !titleStr.isEmpty {
      titleLabel.text = titleStr
      contentView.addSubview(titleLabel)

      titleLabel.snp.makeConstraints { make in
        make.left.equalTo(iconImageView.snp.right).offset(10.0)
        make.right.equalTo(contentView).offset(-5.0)
        make.centerY.equalTo(iconImageView)
      }

      if let messageStr = messageText, !messageStr.isEmpty {
        messageLabel.text = messageStr
        contentView.addSubview(messageLabel)

        messageLabel.snp.makeConstraints { make in
          make.left.right.equalTo(titleLabel)
          make.top.equalTo(titleLabel.snp.bottom).offset(5.0)
          make.bottom.equalTo(contentView).offset(-10.0)
        }
      } else {
        iconImageView.snp.makeConstraints { make in
          make.bottom.equalTo(contentView).offset(-5.0)
        }
      }
    } else {
      if let messageStr = messageText, !messageStr.isEmpty {
        messageLabel.text = messageStr
        contentView.addSubview(messageLabel)

        messageLabel.snp.makeConstraints { make in
          make.left.equalTo(iconImageView.snp.right).offset(10.0)
          make.top.equalTo(iconImageView)
          make.right.equalTo(contentView).offset(-5.0)
          make.bottom.equalTo(contentView).offset(-10.0)
        }
      } else {
        iconImageView.snp.makeConstraints { make in
          make.bottom.equalTo(contentView).offset(-5.0)
        }
      }
    }
  }

  private func setupActionsContentUI() {
    if let otherTitle = otherActionTitle {
      let button = UIButton(type: .custom)
      button.titleLabel?.font = style.otherButtonFont
      button.setTitleColor(style.otherButtonTitleColor, for: .normal)
      button.setTitle(otherTitle, for: .normal)
      button.addTarget(self, action: #selector(otherButtonDidClicked), for: .touchUpInside)
      buttons.append(button)
    }

    if let defaultTitle = defaultActionTitle {
      let button = UIButton(type: .custom)
      button.titleLabel?.font = style.defaultButtonFont
      button.setTitleColor(style.defaultButtonTitleColor, for: .normal)
      button.setTitle(defaultTitle, for: .normal)
      button.addTarget(self, action: #selector(defaultButtonDidClicked), for: .touchUpInside)
      buttons.append(button)
    }

    if !buttons.isEmpty {
      let count = buttons.count
      view.addSubview(actionsContentView)
      actionsContentView.snp.makeConstraints { make in
        make.top.equalTo(contentView.snp.bottom)
        make.height.equalTo(44.0)
        make.left.bottom.right.equalTo(self.view)
      }

      let horizontalLineView = UIView()
      horizontalLineView.backgroundColor = .black
      actionsContentView.addSubview(horizontalLineView)
      horizontalLineView.snp.makeConstraints { make in
        make.left.top.right.equalTo(actionsContentView)
        make.height.equalTo(0.5)
      }

      let lineWidth: CGFloat = 0.5
      let buttonWidth = (selfWidth - CGFloat(count - 1) * lineWidth) / CGFloat(count)
      for (index, button) in buttons.enumerated() {
        actionsContentView.addSubview(button)

        button.snp.makeConstraints { make in
          make.top.bottom.equalTo(actionsContentView)
          make.width.equalTo(buttonWidth)
          make.left.equalTo(actionsContentView).offset(CGFloat(index) * (buttonWidth + lineWidth))
        }

        if count > 1 {
          if index != count - 1 {
            let verticalLineView = UIView()
            verticalLineView.backgroundColor = .black
            actionsContentView.addSubview(verticalLineView)

            verticalLineView.snp.makeConstraints { make in
              make.top.bottom.equalTo(actionsContentView)
              make.width.equalTo(lineWidth)
              make.left.equalTo(actionsContentView).offset(buttonWidth + CGFloat(index) * (buttonWidth + lineWidth))
            }
          }
        }
      }
    } else {
      contentView.snp.makeConstraints { make in
        make.bottom.equalTo(self.view)
      }
    }
  }

  @objc private func defaultButtonDidClicked() {
    if let handler = defaultActionHandler {
      handler()
    }
  }

  @objc private func otherButtonDidClicked() {
    if let handler = otherActionHandler {
      handler()
    }
  }
}
