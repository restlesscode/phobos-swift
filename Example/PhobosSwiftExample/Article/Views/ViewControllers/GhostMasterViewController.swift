//
//
//  GhostMasterViewController.swift
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

import PhobosSwiftUIComponent
import RxCocoa
import RxSwift
import UIKit

class GhostMasterViewController: PBSArticleMasterViewController {
  let disposeBag = DisposeBag()

  lazy var refreshCtrl: UIRefreshControl = {
    let _refreshCtrl = UIRefreshControl()
    collectionView.refreshControl = _refreshCtrl
    return _refreshCtrl
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    title = "Articles"

    if #available(iOS 11.0, *) {
      navigationController?.navigationBar.prefersLargeTitles = true
      navigationItem.largeTitleDisplayMode = .automatic
    }

    refreshCtrl.rx.controlEvent(.valueChanged).subscribe(onNext: { [weak self] in
      guard let self = self else { return }
      self.refresh()
    }).disposed(by: disposeBag)

    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
      self.beginRefreshing()
    }
  }

  func beginRefreshing() {
    guard !refreshCtrl.isRefreshing else {
      return
    }

    refreshCtrl.beginRefreshing()
    refreshCtrl.sendActions(for: .valueChanged)
  }

  func refresh() {
    let postObservable = PBSArticleRequest.getGhostPosts()
    postObservable.subscribe(onNext: { posts in

      let articleViewModels = posts.compactMap { post -> PBSArticleViewModel in
        let title = post.title
        let subtitle = post.excerpt
        let tag = post.primaryTag?.name ?? ""
        let time = post.publishedAt.pbs.convertUTCDateToLocalDate("yyyy-MM-dd'T'HH:mm:ssZ") ?? ""
        let timestamp = post.publishedAt.pbs_iso8601Date?.timeIntervalSince1970 ?? 0
        let coverImageUrl = post.featureImage
        let url = post.url
        let body = post.html
        let articleModel = PBSArticleModel(title: title, subtitle: subtitle, tag: tag, time: time, timestamp: Int(timestamp), coverImageUrl: coverImageUrl, url: url, body: body)

        return PBSArticleViewModel(model: articleModel)
      }

      self.sectionViewModels.append(PBSArticleSectionViewModel(title: "Ghost", subtitle: "", articleViewModels: articleViewModels))

      self.collectionView.reloadData()
    }, onError: { [weak self] error in
      guard let self = self else { return }
      self.refreshCtrl.endRefreshing()
      print(error)
    }, onCompleted: { [weak self] in
      guard let self = self else { return }
      self.refreshCtrl.endRefreshing()
    }).disposed(by: disposeBag)
  }

  //    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
  //        collectionView.deselectItem(at: indexPath, animated: true)
  //
  //        let articleViewModel = self.sectionViewModels[indexPath.section].articleViewModels[indexPath.item]
  //        let viewCtrl = GhostDetailViewController()
  //        show(viewCtrl, sender: self)
  //    }

  override func flowLayout(_ collectionViewLayout: UIArticleKit.ViewFlowLayout, colorSetInSection section: Int) -> (first: UIColor, last: UIColor) {
    if #available(iOS 13.0, *) {
      if self.traitCollection.userInterfaceStyle == .dark {
        return PhobosSwiftExample.Color.kBlackgroudColorTuple
      } else {
        return (UIColor.pbs.color(R: 255, G: 255, B: 255),
                UIColor.pbs.color(R: 221, G: 236, B: 247))
      }
    } else {
      return (UIColor.pbs.color(R: 255, G: 255, B: 255),
              UIColor.pbs.color(R: 221, G: 236, B: 247))
    }
  }

  override func flowLayout(_ collectionViewLayout: UIArticleKit.ViewFlowLayout, cellTypeOfIndexPath indexPath: IndexPath) -> UIArticleKit.DecorationView.CellType {
    let numberOfItems = collectionViewLayout.collectionView?.numberOfItems(inSection: indexPath.section) ?? 0
    var numberOfColumn = numberOfItems / 2
    numberOfColumn = (numberOfColumn % 2) == 0 ? numberOfColumn : (numberOfColumn - 1)

    if indexPath.item == 0 {
      if indexPath.section == 0 {
        return .card
      } else if indexPath.section == 1 {
        return .bigCardY
      } else if indexPath.section == 2 {
        return .card
      } else if indexPath.section == 3 {
        return .bigCardY
      } else if indexPath.section == 4 {
        return .card
      } else {
        return .card
      }
    }

    if indexPath.item < 7 {
      return .column
    }

    return .normal
  }
}

class GhostDetailViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
  }
}
