//
//
//  IntersitialAdListViewController.swift
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

import UIKit

class IntersitialAdListViewController: UIViewController {
  lazy var tableView: UITableView = {
    let tableView = UITableView(frame: .zero, style: .plain)
    view.addSubview(tableView)
    tableView.delegate = self
    tableView.dataSource = self
    tableView.showsVerticalScrollIndicator = false
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "IntersitialList")
    return tableView
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Intersitial Ad Demo"
    view.backgroundColor = .pbs.systemBackground
    makeSubviews()
  }

  func makeSubviews() {
    tableView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
}

extension IntersitialAdListViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    1
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "IntersitialList", for: indexPath)
    cell.textLabel?.text = "GADIntersitialAd"
    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)

    navigationController?.pushViewController(InterstitialAdDemoViewController(), animated: true)
  }
}
