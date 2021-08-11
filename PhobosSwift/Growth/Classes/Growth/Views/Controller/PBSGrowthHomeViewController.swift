//
//
//  PBSGrowthHomeViewController.swift
//  PhobosSwiftGrowth
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

import MessageUI
import SnapKit
import UIKit

public class PBSGrowthHomeViewController: UIViewController {
  lazy var layout: UICollectionViewFlowLayout = {
    let layout = UICollectionViewFlowLayout()
    return layout
  }()

  lazy var collectionView: UICollectionView = {
    let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
    view.delegate = self
    view.dataSource = self
    view.register(UICollectionViewCell.self,
                  forCellWithReuseIdentifier: "UICollectionViewCell")
    view.register(PBSGrowthHomeHeaderCell.self,
                  forCellWithReuseIdentifier: PBSGrowthHomeHeaderCell.id)
    view.register(PBSGrowthHomeTopicsCell.self,
                  forCellWithReuseIdentifier: PBSGrowthHomeTopicsCell.id)
    view.register(PBSGrowthHomeSupportCell.self,
                  forCellWithReuseIdentifier: PBSGrowthHomeSupportCell.id)
    view.register(PBSGrowthHomeContactCell.self,
                  forCellWithReuseIdentifier: PBSGrowthHomeContactCell.id)
    view.register(PBSGrowthHomeSectionView.self,
                  forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                  withReuseIdentifier: PBSGrowthHomeSectionView.id)

    return view
  }()

  lazy var viewModel: PBSGrowthHomeViewModel = {
    let viewModel = PBSGrowthHomeViewModel()
    return viewModel
  }()

  override public func viewDidLoad() {
    super.viewDidLoad()
    title = "Help us to improve"
    if #available(iOS 11.0, *) {
      navigationController?.navigationBar.prefersLargeTitles = true
      navigationItem.largeTitleDisplayMode = .automatic
      navigationController?.navigationBar.largeTitleTextAttributes = [.font: UIFont.systemFont(ofSize: 34.0, weight: .bold),
                                                                      .foregroundColor: UIColor(white: 1.0, alpha: 1.0),
                                                                      .kern: 0.37]
    }
    view.backgroundColor = .white
    view.addSubview(collectionView)
    makeConstraints()
    viewModel.mockData()
    collectionView.reloadData()
  }

  func makeConstraints() {
    collectionView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
}

extension PBSGrowthHomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  public func numberOfSections(in collectionView: UICollectionView) -> Int {
    viewModel.sections.count
  }

  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    viewModel.numberOfItems(section: section)
  }

  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    var identifier = "UICollectionViewCell"
    switch viewModel.sections[indexPath.section].type {
    case .head: identifier = PBSGrowthHomeHeaderCell.id
    case .topics: identifier = PBSGrowthHomeTopicsCell.id
    case .support: identifier = PBSGrowthHomeSupportCell.id
    case .contact: identifier = PBSGrowthHomeContactCell.id
    }
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
    if let container = cell as? PBSGrowthHomeBaseCell {
      container.didSelectItem = { [weak self] indexPath, data in
        guard let self = self else { return }
        self.didSelectItemAt(indexPath, data)
      }
      container.view.dataSource = viewModel.sections[indexPath.section].containerViewModels
    }
    return cell
  }

  public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    if kind == UICollectionView.elementKindSectionHeader {
      let head = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: PBSGrowthHomeSectionView.id, for: indexPath) as? PBSGrowthHomeSectionView
      let type = viewModel.sections[indexPath.section].type
      switch type {
      case .head:
        head?.title = ""
      case let .topics(title, _), let .support(title, _), let .contact(title, _):
        head?.title = title
//      case .support(let title, _):
//      case .contact(let title, _):
      }
      head?.hasMoreButton = type.hasMoreButton()
      head?.buttonClickBlock = { [weak self] in
        guard let self = self else { return }
        self.clickShowAll(indexPath)
      }
      return head ?? UICollectionReusableView()
    } else {
      return UICollectionReusableView()
    }
  }

  public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let type = viewModel.sections[indexPath.section].type
    switch type {
    case let .head(itemSizeHeight):
      return CGSize(width: UIScreen.main.bounds.width,
                    height: CGFloat(itemSizeHeight))
    case let .topics(_, itemSizeHeight), let .support(_, itemSizeHeight), let .contact(_, itemSizeHeight):
      return CGSize(width: UIScreen.main.bounds.width,
                    height: CGFloat(itemSizeHeight))
    }
  }

  public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    UIEdgeInsets(top: 10, left: 0, bottom: 16, right: 0)
  }

  public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    CGSize(width: UIScreen.main.bounds.width,
           height: viewModel.sections[section].type.headHeight())
  }

  public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    navigationController?.pushViewController(PBSGrowthHomeViewController(), animated: true)
  }
}

extension PBSGrowthHomeViewController {
  func clickShowAll(_ indexPath: IndexPath) {
    print("bingo")
  }

  func didSelectItemAt(_ indexPath: IndexPath, _ data: PBSGrowthHomeContainerViewModel) {
    switch data.data.itemType {
    case .custom:
      present(PBSGrowthFeedbackViewController(model: data.data), animated: true, completion: nil)
    case .email:
      sendMail()
    case .chat:
      present(PBSGrowthChatViewController(), animated: true, completion: nil)
    }
  }
}

extension PBSGrowthHomeViewController: MFMailComposeViewControllerDelegate {
  func sendMail() {
    if !MFMailComposeViewController.canSendMail() {
      return
    }
    let vc = MFMailComposeViewController()
    vc.mailComposeDelegate = self
    present(vc, animated: true, completion: nil)
  }

  public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
    controller.dismiss(animated: true, completion: nil)
    switch result {
    case .cancelled: print("cancelled")
    case .saved: print("saved")
    case .sent: print("sent")
    case .failed: print("failed")
    default: break
    }
  }
}
