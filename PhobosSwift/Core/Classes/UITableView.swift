//
//
//  UITableView.swift
//  PhobosSwiftCore
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

/// enhanced features for UITableView
extension PhobosSwift where Base: UITableView {
  /// 滚动到头部
  public func scrollToTop(animated: Bool = false) {
    DispatchQueue.main.async {
      let indexPath = IndexPath(row: 0, section: 0)
      base.scrollToRow(at: indexPath, at: .top, animated: animated)
    }
  }

  /// 滚动到底部
  public func scrollToBottom(animated: Bool = false) {
    DispatchQueue.main.async {
      let indexPath = IndexPath(row: base.numberOfRows(inSection: base.numberOfSections - 1) - 1,
                                section: base.numberOfSections - 1)
      base.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
  }

  /// 对tableview进行更新
  public func update(deletions: [IndexPath], insertions: [IndexPath], updates: [IndexPath]) {
    base.beginUpdates()
    base.deleteRows(at: deletions, with: .automatic)
    base.insertRows(at: insertions, with: .automatic)
    base.reloadRows(at: updates, with: .automatic)
    base.endUpdates()
  }

  /// 对TableView添加可以伸缩的HeaderView
  public func addStretchableHeaderView<T>(view: T) where T: PBSStretchableTableHeaderViewProtocol, T: UIView {
    base.addSubview(view)
    base.sendSubviewToBack(view)
    base.contentInset = UIEdgeInsets(top: view.bounds.height, left: 0, bottom: 0, right: 0)
  }

  ///
  public var cellSwipeContainerViews: [UIView] {
    base.subviews.filter {
      if let _UITableViewCellSwipeContainerViewClass = NSClassFromString("_UITableViewCellSwipeContainerView") {
        return $0.isMember(of: _UITableViewCellSwipeContainerViewClass)
      }
      return false
    }
  }

  ///
  public var swipeActionPullViews: [UIView] {
    cellSwipeContainerViews.flatMap { $0.subviews }.filter {
      if let UISwipeActionPullViewClass = NSClassFromString("UISwipeActionPullView") {
        return $0.isMember(of: UISwipeActionPullViewClass)
      }
      return false
    }
  }

  ///
  public var swipeActionStandardButtons: [UIButton] {
    swipeActionPullViews.flatMap { $0.subviews }.filter {
      if let UISwipeActionStandardButtonClass = NSClassFromString("UISwipeActionStandardButton") {
        return $0.isMember(of: UISwipeActionStandardButtonClass)
      }
      return false
    }.compactMap { $0 as? UIButton }
  }
}
