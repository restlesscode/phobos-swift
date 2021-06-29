//
//
//  MainViewController.swift
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

import PhobosSwiftMedia
import PhobosSwiftTestKnight
import PhobosSwiftUIComponent

class MainViewController: PBSArticleMasterViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    generateDemo()
  }

  func generateDemo() {
    title = "Features Demo"

    if #available(iOS 11.0, *) {
      navigationController?.navigationBar.prefersLargeTitles = true
      navigationItem.largeTitleDisplayMode = .automatic
    }

    addCameraGuideExample()
    addBrowerSelect()
    addGhostExample()
    addHadesExample()
    addTestKnightExample()
    addSlideExample()
  }

  private func addCameraGuideExample() {
    let articleModel = PBSArticleModel(title: "相机中有引导框，照相后只获得框中内容",
                                       subtitle: "subtitle",
                                       tag: "PhobosSwiftUIComponent",
                                       time: "Feb 4, 2020",
                                       timestamp: nil,
                                       coverImageUrl: nil,
                                       url: nil,
                                       body: nil)

    let articleViewModels = [PBSArticleViewModel(model: articleModel)]
    sectionViewModels.append(
      PBSArticleSectionViewModel(title: "PhobosSwiftUIComponent",
                                 subtitle: "",
                                 articleViewModels: articleViewModels))
  }

  private func addBrowerSelect() {
    let articleModel = PBSArticleModel(title: "图片选择",
                                       subtitle: "subtitle",
                                       tag: "PhobosSwiftMedia",
                                       time: "Jun 29, 2021",
                                       timestamp: nil,
                                       coverImageUrl: nil,
                                       url: nil,
                                       body: nil)

    let articleViewModels = [PBSArticleViewModel(model: articleModel)]
    sectionViewModels.append(
      PBSArticleSectionViewModel(title: "PhobosSwiftMedia",
                                 subtitle: "",
                                 articleViewModels: articleViewModels))
  }

  private func addGhostExample() {
    let articleModel = PBSArticleModel(title: "Blog Articles",
                                       subtitle: "展现 Blog 中的文章",
                                       tag: "PBSArticle",
                                       time: "Feb 4, 2020",
                                       timestamp: nil,
                                       coverImageUrl: nil,
                                       url: nil,
                                       body: nil)

    let articleViewModels = [PBSArticleViewModel(model: articleModel)]
    sectionViewModels.append(PBSArticleSectionViewModel(title: "PBSArticle", subtitle: "有关 Article 控件的使用例子", articleViewModels: articleViewModels))
  }

  private func addHadesExample() {
    let articleModel = PBSArticleModel(title: "Hades Mobile Ads", subtitle: "展现移动端广告例子", tag: "PhobosSwiftHades", time: "Feb 11, 2021", timestamp: nil, coverImageUrl: nil, url: nil, body: nil)

    let articleViewModels = [PBSArticleViewModel(model: articleModel)]

    sectionViewModels.append(PBSArticleSectionViewModel(title: "PhobosSwiftHades", subtitle: "展现移动端广告使用例子", articleViewModels: articleViewModels))
  }

  private func addTestKnightExample() {
    let articleModel = PBSArticleModel(title: "PhobosSwiftTestKnight",
                                       subtitle: "",
                                       tag: "PhobosSwiftTestKnight",
                                       time: "Jun 24, 2021",
                                       timestamp: nil,
                                       coverImageUrl: nil,
                                       url: nil,
                                       body: nil)

    let articleViewModels = [PBSArticleViewModel(model: articleModel)]
    sectionViewModels.append(PBSArticleSectionViewModel(title: "PhobosSwiftTestKnight", subtitle: "有关 TestKnight 页面的使用例子", articleViewModels: articleViewModels))
  }

  private func addSlideExample() {
    let articleModel = PBSArticleModel(title: "PhobosSwiftSlideout",
                                       subtitle: "",
                                       tag: "PhobosSwiftSlideout",
                                       time: "Jun 25, 2021",
                                       timestamp: nil,
                                       coverImageUrl: nil,
                                       url: nil,
                                       body: nil)

    let articleViewModels = [PBSArticleViewModel(model: articleModel)]
    sectionViewModels.append(PBSArticleSectionViewModel(title: "PhobosSwiftSlideout", subtitle: "有关 Slideout 页面的使用例子", articleViewModels: articleViewModels))
  }

  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    collectionView.deselectItem(at: indexPath, animated: true)

    let articleViewModel = sectionViewModels[indexPath.section].articleViewModels[indexPath.item]
    if articleViewModel.title.value == "相机中有引导框，照相后只获得框中内容" {
      let viewCtrl = CameraGuideViewController()
      show(viewCtrl, sender: self)
    } else if articleViewModel.title.value == "图片选择" {
      modalPresentationStyle = .fullScreen
      let vc = UINavigationController(rootViewController: PBSImageBrower.SelectViewController())
      vc.modalPresentationStyle = .fullScreen
      present(vc, animated: true, completion: nil)
    } else if articleViewModel.title.value == "Blog Articles" {
      let viewCtrl = GhostMasterViewController()
      show(viewCtrl, sender: self)
    } else if articleViewModel.title.value == "Hades Mobile Ads" {
      let viewCtrl = HadesMainViewController()
      show(viewCtrl, sender: self)
    } else if articleViewModel.title.value == "PhobosSwiftTestKnight" {
      if let keyWindow = UIApplication.pbs_shared?.windows.first {
        let lastRootViewController = keyWindow.rootViewController
        PBSTestKnight.shared.configure(window: keyWindow, completed: {
          UIWindow.transition(with: keyWindow, duration: 0.5, options: .transitionFlipFromLeft, animations: {
            keyWindow.rootViewController = lastRootViewController
          })
        })
      }
    } else if articleViewModel.title.value == "PhobosSwiftSlideout" {
      present(SlideoutDemoCenterViewController.makeTheSlideoutDemo(), animated: true, completion: nil)
    }
  }

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
