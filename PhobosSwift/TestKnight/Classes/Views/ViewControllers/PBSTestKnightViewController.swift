//
//
//  PBSTestKnightViewController.swift
//  PhobosSwiftTestKnight
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
import RxCocoa
import RxSwift
import UIKit

public class PBSTestKnightViewController: UIViewController {
  let disposeBag = DisposeBag()
  var completedHandler: (() -> Void)?

  lazy var titleLabel: UILabel = {
    let label = UILabel(frame: .zero)
    headerView.addSubview(label)
    label.snp.makeConstraints {
      $0.center.equalToSuperview()
    }

    label.numberOfLines = 2
    label.font = UIFont.boldSystemFont(ofSize: 36)
    label.textColor = UIColor.pbs.systemBackground.pbs.inverseColor
    label.textAlignment = .center

    return label
  }()

  lazy var headerView: UIView = {
    let view = UIView(frame: .zero)
    view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 188)

    return view
  }()

  lazy var tableView: UITableView = {
    let _tableView = UITableView()
    view.addSubview(_tableView)

    _tableView.delegate = self
    _tableView.dataSource = self

    _tableView.snp.makeConstraints {
      $0.top.equalTo(self.topLayoutGuide.snp.bottom)
      $0.left.right.equalTo(0)
      $0.bottom.equalTo(startTestingButton.snp.top)
    }

    _tableView.separatorStyle = .none
    _tableView.bounces = false
    _tableView.register(PBSTestKnightCell.self, forCellReuseIdentifier: PBSTestKnightCell.pbs.reuseIdentifier)
    _tableView.tableHeaderView = headerView

    return _tableView
  }()

  lazy var startTestingButton: UIButton = {
    let button = UIButton(type: .system)
    view.addSubview(button)

    button.snp.makeConstraints {
      $0.bottom.equalTo(self.bottomLayoutGuide.snp.top).offset(-66.0)
      $0.left.equalTo(44.0)
      $0.right.equalTo(-44.0)
      $0.height.equalTo(48.0)
    }

    button.backgroundColor = .systemBlue
    button.tintColor = .white
    button.layer.cornerRadius = 12.0
    button.clipsToBounds = true

    return button
  }()

  var viewModels: [PBSTestKnightViewModel] = [PBSTestKnightViewModel(model: PBSTestKnightModel(type: .debug, title: PBSTestKnightConfiguration.debug.name, description: PBSTestKnightConfiguration.debug.description, icon: BUResource.Image.kDebug)),
                                              PBSTestKnightViewModel(model: PBSTestKnightModel(type: .staging, title: PBSTestKnightConfiguration.staging.name, description: PBSTestKnightConfiguration.staging.description, icon: BUResource.Image.kStaging)),
                                              PBSTestKnightViewModel(model: PBSTestKnightModel(type: .preproduction, title: PBSTestKnightConfiguration.preproduction.name, description: PBSTestKnightConfiguration.preproduction.description, icon: BUResource.Image.kPreproduction)),
                                              PBSTestKnightViewModel(model: PBSTestKnightModel(type: .release, title: PBSTestKnightConfiguration.release.name, description: PBSTestKnightConfiguration.release.description, icon: BUResource.Image.kRelease))]

  override public func viewDidLoad() {
    super.viewDidLoad()

    makeSubviews()
    makeRxEvents()
  }

  override public func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    // 默认选中第一个
    DispatchQueue.pbs_once {
      tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .bottom)
      PBSTestKnight.shared.configuration = viewModels[0].configuration.value
    }
  }

  func makeSubviews() {
    titleLabel.text = BUString.kWelcomTitle
    view.backgroundColor = .pbs.systemBackground
    tableView.backgroundColor = .pbs.systemBackground
    startTestingButton.setTitle(BUString.kStartTesting, for: .normal)
  }

  func makeRxEvents() {
    startTestingButton.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] in
      guard let self = self else { return }
      self.completedHandler?()
    }).disposed(by: disposeBag)
  }
}

extension PBSTestKnightViewController: UITableViewDataSource, UITableViewDelegate {
  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    viewModels.count
  }

  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: PBSTestKnightCell.pbs.reuseIdentifier, for: indexPath)
    (cell as? PBSTestKnightCell)?.render(item: viewModels[indexPath.row])

    return cell
  }

  public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let item = viewModels[indexPath.row]
    PBSTestKnight.shared.configuration = item.configuration.value
  }
}
