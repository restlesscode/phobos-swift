//
//
//  PBSAlertController.swift
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
import RxCocoa
import RxSwift

public class PBSAlertController: UIViewController {
  let disposeBag = DisposeBag()

  var viewModels: [PBSAlertViewModel] = []

  let timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.global())

  var workItems: [DispatchWorkItem] = []

  enum Mode {
    case collapsed
    case normal
  }

  var mode: Mode = .normal {
    didSet {
      switch mode {
      case .collapsed:
        break
      case .normal:
        break
      }

      self.tableView.reloadSections([0], with: .automatic)
    }
  }

  lazy var tableView: UITableView = {
    let _tableView = UITableView(frame: .zero)
    self.view.addSubview(_tableView)
    _tableView.delegate = self
    _tableView.dataSource = self
    _tableView.backgroundColor = .clear
    _tableView.showsVerticalScrollIndicator = false
    _tableView.separatorStyle = .none
    _tableView.estimatedRowHeight = (view.bounds.width - 40) / 376.0 * 104
    _tableView.rowHeight = UITableView.automaticDimension
    _tableView.bounces = false
    _tableView.register(PBSAlertCell.self, forCellReuseIdentifier: PBSAlertCell.pbs.reuseIdentifier)
    _tableView.register(PBSCollapsedAlertCell.self, forCellReuseIdentifier: PBSCollapsedAlertCell.pbs.reuseIdentifier)
    return _tableView
  }()

  override public init(nibName nibNameOrNil: String? = nil, bundle nibBundleOrNil: Bundle? = nil) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    modalPresentationStyle = .overFullScreen
    modalTransitionStyle = .crossDissolve
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override public func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = UIColor.pbs.systemBackground.withAlphaComponent(0.5)

    tableView.snp.makeConstraints {
      $0.left.right.bottom.top.equalTo(0)
    }

    timer.schedule(deadline: .now(), repeating: .milliseconds(1000), leeway: .milliseconds(10))

    timer.setEventHandler(handler: { [weak self] in
      guard let self = self else { return }

      if let workItem = self.workItems.first {
        DispatchQueue.main.async(execute: workItem)
        self.workItems.removeFirst()
      }
    })

    timer.resume()
  }

  public func show(alert viewModel: PBSAlertViewModel) {
    guard viewModels.filter({ $0.uuid == viewModel.uuid }).isEmpty else {
      return
    }

    if isBeingPresented {
      workItems.append(
        DispatchWorkItem(qos: .userInteractive) {
          self.addAlert(with: viewModel)
        }
      )
    } else {
      UIViewController.pbs.topMost?.present(self, animated: true, completion: { [weak self] in
        guard let self = self else { return }

        self.workItems.append(
          DispatchWorkItem(qos: .userInteractive) {
            self.addAlert(with: viewModel)
          }
        )
      })
    }
  }

  public func addAlert(with viewModel: PBSAlertViewModel) {
    viewModels.insert(viewModel, at: viewModels.startIndex)
    print("insert - \(0), \(viewModel.uuid)")

    viewModel.countDown { [weak self] uuid in
      guard let self = self else { return }

      self.removeAlert(with: uuid)
    }

    tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .right)
  }

  public func removeAlert(at index: Int) {
    viewModels.remove(at: index)
    tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .left)

    if viewModels.isEmpty {
      dismiss(animated: true, completion: nil)
    }
  }

  public func removeAlert(with uuid: UUID) {
    if let idx = viewModels.firstIndex(where: { $0.uuid == uuid }) {
      viewModels.remove(at: idx)
      tableView.deleteRows(at: [IndexPath(row: idx, section: 0)], with: .left)

      if viewModels.isEmpty {
        dismiss(animated: true, completion: nil)
      }
    }
  }
}

extension PBSAlertController: UITableViewDelegate, UITableViewDataSource {
  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    var identifier = PBSAlertCell.pbs.reuseIdentifier

    switch mode {
    case .collapsed:
      identifier = PBSCollapsedAlertCell.pbs.reuseIdentifier
    case .normal:
      identifier = PBSAlertCell.pbs.reuseIdentifier
    }

    let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
    if let cell = cell as? PBSCollapsedAlertCell {
      cell.render(viewModels: viewModels)
    } else if let cell = cell as? PBSAlertCell {
      let viewModel = viewModels[indexPath.row]
      cell.render(viewModel: viewModel)
    }

    return cell
  }

  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch mode {
    case .collapsed:
      return 1
    case .normal:
      return viewModels.count
    }
  }

  public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    true
  }

  public func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
    tableView.setEditing(true, animated: true)

    return .none
  }

  public func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
    tableView.pbs.swipeActionStandardButtons.first?.isHidden = true
  }

  @available(iOS 11.0, *)
  public func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let action = UIContextualAction(style: .normal, title: "") { [weak self] _, _, completionHandler in
      guard let self = self else { return }

      self.removeAlert(at: indexPath.row)

      completionHandler(true)
    }

    action.backgroundColor = .clear

    return UISwipeActionsConfiguration(actions: [action])
  }
}
