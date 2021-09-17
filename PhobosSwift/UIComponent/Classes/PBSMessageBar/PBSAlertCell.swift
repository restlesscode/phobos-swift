//
//
//  PBSAlertCell.swift
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

import Foundation
import RxSwift

class PBSAlertCell: UITableViewCell {
  let alertView = PBSAlertView(frame: .zero)

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    makeSubviews()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func makeSubviews() {
    selectionStyle = .none
    backgroundColor = .clear
    contentView.addSubview(alertView)

    alertView.snp.makeConstraints {
      $0.left.equalTo(20)
      $0.right.equalTo(-20)
      $0.top.equalTo(0)
      $0.bottom.equalTo(-14)
    }

    alertView.pbs.addShadow(color: UIColor.black, radius: 12, scale: true)
  }

  func render(viewModel: PBSAlertViewModel) {
    alertView.render(viewModel: viewModel)
  }
}

class PBSCollapsedAlertCell: UITableViewCell {
  let alertView = PBSAlertView(frame: .zero)

  let decorationAlertViews = [PBSAlertView(frame: .zero),
                              PBSAlertView(frame: .zero)]

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    selectionStyle = .none
    backgroundColor = .clear
    makeSubviews()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func makeSubviews() {
    decorationAlertViews.forEach {
      contentView.addSubview($0)
      $0.isHidden = true
      $0.pbs.addShadow(color: UIColor.black, radius: 12, scale: true)
    }
    contentView.addSubview(alertView)
    alertView.pbs.addShadow(color: UIColor.black, radius: 12, scale: true)

    alertView.snp.makeConstraints {
      $0.left.equalTo(20)
      $0.right.equalTo(-20)
      $0.top.equalTo(0)
      $0.bottom.equalTo(-14)
    }

    decorationAlertViews[0].snp.makeConstraints {
      $0.leading.equalTo(alertView).offset(4)
      $0.trailing.equalTo(alertView).offset(-4)
      $0.top.equalTo(alertView).offset(14)
      $0.bottom.equalTo(alertView).offset(14)
    }

    decorationAlertViews[1].snp.makeConstraints {
      $0.leading.equalTo(alertView).offset(2)
      $0.trailing.equalTo(alertView).offset(-2)
      $0.top.equalTo(alertView).offset(7)
      $0.bottom.equalTo(alertView).offset(7)
    }
  }

  func render(viewModels: [PBSAlertViewModel]) {
    if let vm = viewModels.first {
      alertView.render(viewModel: vm)
    }

    viewModels.enumerated().forEach { idx, vm in
      if idx == 1 {
        decorationAlertViews[1].isHidden = false
        decorationAlertViews[1].renderCollapsed(viewModel: vm)
      }
      if idx == 2 {
        decorationAlertViews[0].isHidden = false
        decorationAlertViews[0].renderCollapsed(viewModel: vm)
      }
    }
  }
}
