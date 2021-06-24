//
//
//  NativeAdListViewController.swift
//  PhobosSwiftExample
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

import PhobosSwiftHades
import UIKit

class NativeAdListViewController: UIViewController {
  let dataSource: [PBSNativeAd.PBSNativeAdType] = [.smallTemplate, .mediumTemplate, .advanced, .video]

  lazy var tableView: UITableView = {
    let tableView = UITableView(frame: .zero, style: .plain)
    view.addSubview(tableView)
    tableView.delegate = self
    tableView.dataSource = self
    tableView.showsVerticalScrollIndicator = false
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "NativeAdList")
    return tableView
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Native Ad Demo"
    view.backgroundColor = .pbs.systemBackground
    makeSubviews()
  }

  func makeSubviews() {
    tableView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
}

extension NativeAdListViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    dataSource.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "NativeAdList", for: indexPath)
    switch indexPath.row {
    case 0:
      cell.textLabel?.text = "Native Ad Small Template View"
    case 1:
      cell.textLabel?.text = "Native Ad Medium Template View"
    case 2:
      cell.textLabel?.text = "Native Ad Advanced View"
    default:
      cell.textLabel?.text = "Native Ad Video View"
    }
    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)

    var viewController: UIViewController
    switch indexPath.row {
    case 0:
      viewController = NativeAdSmallTemplateViewController()
    case 1:
      viewController = NativeAdMediumTemplateViewController()
    case 2:
      viewController = NativeAdDemoViewController()
    default:
      viewController = NativeAdvancedVideoViewController()
    }
    navigationController?.pushViewController(viewController, animated: true)
  }
}
