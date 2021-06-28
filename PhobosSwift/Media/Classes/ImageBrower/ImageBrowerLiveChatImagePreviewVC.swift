//
//
//  ImageBrowerLiveChatImagePreviewVC.swift
//  PhobosSwiftMedia
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

import Photos
import PhotosUI
import UIKit

class ImageBrowerLiveChatImagePreviewVC: PBSImageBrower.BaseViewController {
  private let originalCellId = "originalCellId"
  private let thumbnailCellId = "thumbnailCellId"
  private lazy var originalCollection: UICollectionView = {
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.itemSize = CGSize(width: ScreenWidth, height: ScreenHeight)
    flowLayout.sectionInset = UIEdgeInsets.zero
    flowLayout.minimumLineSpacing = 0 // 每个相邻layout的上下
    flowLayout.minimumInteritemSpacing = 0 // 每个相邻layout的左右
    flowLayout.scrollDirection = .horizontal

    let collection_image = UICollectionView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight), collectionViewLayout: flowLayout)
    collection_image.isPagingEnabled = true
    collection_image.delegate = self
    collection_image.dataSource = self
    collection_image.tag = 1001
    collection_image.backgroundColor = UIColor.clear
    collection_image.register(UICollectionViewCell.self, forCellWithReuseIdentifier: originalCellId)
    collection_image.showsHorizontalScrollIndicator = false
    if #available(iOS 11.0, *) {
      collection_image.contentInsetAdjustmentBehavior = .never
    }
    return collection_image
  }()

  private lazy var thumbnailCollection: UICollectionView = {
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.itemSize = CGSize(width: 65, height: 65)
    flowLayout.sectionInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    flowLayout.minimumLineSpacing = 12 // 每个相邻layout的上下
    flowLayout.minimumInteritemSpacing = 0 // 每个相邻layout的左右
    flowLayout.scrollDirection = .horizontal

    let height: CGFloat = 95
    let collection_image = UICollectionView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: height), collectionViewLayout: flowLayout)
    collection_image.delegate = self
    collection_image.dataSource = self
    collection_image.backgroundColor = UIColor.clear
    collection_image.tag = 1002
    collection_image.register(UICollectionViewCell.self, forCellWithReuseIdentifier: thumbnailCellId)
    collection_image.showsHorizontalScrollIndicator = false

    return collection_image
  }()

  override var preferredStatusBarStyle: UIStatusBarStyle {
    .lightContent
  }

  var position: Int = 0
  private var positionLabel: UILabel!
  private var editButton: UIButton!
  private var sendButton: UIButton!
  private var navigatorView: UIView!
  private var bottomView: UIView!
  var assets: [ImageBrowerAsset] = []
  var selectBlock: (([UIImage]) -> Void)?
  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    UISetUp()
    loadOriginalImage()
  }

  /*
   // MARK: - Navigation

   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       // Get the new view controller using segue.destination.
       // Pass the selected object to the new view controller.
   }
   */

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    show()
  }

  func show() {
    navigatorView.alpha = 0
    bottomView.alpha = 0
    UIView.animate(withDuration: 0.2, animations: {
      self.navigatorView.alpha = 1
      self.bottomView.alpha = 1
    })
  }
}

extension ImageBrowerLiveChatImagePreviewVC {
  func UISetUp() {
    view.backgroundColor = PBSImageBrower.Color.black
    // Do any additional setup after loading the view.
    view.addSubview(originalCollection)
    originalCollection.contentOffset.x = CGFloat(position) * ScreenWidth
    navigationViewInit()
    bottomViewInit()
  }

  func navigationViewInit() {
    navigatorView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: ScreenWidth, height: NavigationBarHeight)))
    let effect = UIBlurEffect(style: UIBlurEffect.Style.dark)
    let effectView = UIVisualEffectView(effect: effect)
    effectView.frame = navigatorView.frame

    navigatorView.addSubview(effectView)

    let backButton = UIButton(frame: CGRect(x: 0, y: NavigationBarHeight - 44, width: 50, height: 44))
    backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
    backButton.setImage(baseBundle.image(withName: "back_white"), for: .normal)
    navigatorView.addSubview(backButton)

    positionLabel = UILabel(frame: CGRect(x: ScreenWidth - 45, y: NavigationBarHeight - 37, width: 30, height: 30))
    positionLabel.backgroundColor = PBSImageBrower.Color.blue
    positionLabel.textAlignment = .center
    positionLabel.textColor = UIColor.white
    positionLabel.font = UIFont.boldSystemFont(ofSize: 15)
    positionLabel.pbs.corner(radii: 15)

    navigatorView.addSubview(positionLabel)

    view.addSubview(navigatorView)

    updateTitle()
  }

  func bottomViewInit() {
    let height = 150 + BottomSafeAreaHeight
    bottomView = UIView(frame: CGRect(x: 0, y: ScreenHeight - height, width: ScreenWidth, height: height))
    let effect = UIBlurEffect(style: UIBlurEffect.Style.dark)
    let effectView = UIVisualEffectView(effect: effect)
    effectView.frame = CGRect(origin: .zero, size: bottomView.frame.size)

    bottomView.addSubview(effectView)

    bottomView.addSubview(thumbnailCollection)

    editButton = UIButton(frame: CGRect(x: 0, y: thumbnailCollection.pbs.height, width: 65, height: 55))
    editButton.setTitle(PBSImageBrower.Strings.edit, for: .normal)
    editButton.setTitleColor(UIColor.white, for: .normal)
    editButton.addTarget(self, action: #selector(edit), for: .touchUpInside)
    editButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)

    bottomView.addSubview(editButton)

    sendButton = UIButton(frame: CGRect(x: ScreenWidth - 95, y: 11 + thumbnailCollection.pbs.height, width: 80, height: 34))
    sendButton.setTitleColor(UIColor.white, for: .normal)
    sendButton.addTarget(self, action: #selector(send), for: .touchUpInside)
    sendButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
    sendButton.pbs.corner(radii: 5)
    sendButton.setBackgroundImage(UIImage.pbs.makeImage(from: PBSImageBrower.Color.blue), for: .normal)
    sendButton.setTitle("\(PBSImageBrower.Strings.send) (\(assets.count))", for: .normal)

    bottomView.addSubview(sendButton)

    view.addSubview(bottomView)
  }

  func updateTitle() {
    positionLabel.text = String(position + 1)
  }

  @objc func edit() {
    let vc = ImageBrowerEditorViewController()
    vc.asset = assets[position]
    vc.editorBlock = { [weak self] asset in
      guard let self = self else { return }
      self.assets[self.position] = asset
      let indexPath = IndexPath(row: self.position, section: 0)
      self.originalCollection.reloadItems(at: [indexPath])
      self.thumbnailCollection.reloadItems(at: [indexPath])
    }

    navigationController?.pushViewController(vc, animated: false)
  }

  @objc func send() {
    let images = assets.compactMap { asset -> UIImage? in
      asset.origin
    }

    selectBlock?(images)
    dismiss(animated: true, completion: nil)
  }

  func loadOriginalImage() {
    showLoading()
    let group = DispatchGroup()
    for i in 0..<assets.count {
      group.enter()
      DispatchQueue.global().async {
        self.assets[i].getOriginImage { image in
          self.assets[i].origin = image
          group.leave()
        }
      }
    }

    group.notify(queue: DispatchQueue.main) {
      self.hiddenLoading()
      self.originalCollection.reloadData()
    }
  }
}

extension ImageBrowerLiveChatImagePreviewVC: UICollectionViewDelegate, UICollectionViewDataSource {
  // 存储图片至指定相册中
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    assets.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let asset = assets[indexPath.row]
    if collectionView.tag == originalCollection.tag {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: originalCellId, for: indexPath)
      var zoomView: ImageBrowerZoomView!
      if cell.viewWithTag(10_001) == nil {
        zoomView = ImageBrowerZoomView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight))
        zoomView.tag = 10_001
//                zoomView.back = {[weak self] in
//                    self?.back()
//                }

        cell.addSubview(zoomView)
      } else {
        zoomView = cell.viewWithTag(10_001) as? ImageBrowerZoomView
      }

      zoomView.image = asset.origin

      return cell
    } else {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: thumbnailCellId, for: indexPath)
      var imageView: UIImageView!
      var isSelectedView: UIView!
      if cell.viewWithTag(10_002) == nil {
        imageView = UIImageView(frame: CGRect(origin: .zero, size: cell.frame.size))
        imageView.tag = 10_002
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        cell.addSubview(imageView)

        isSelectedView = UIView(frame: imageView.frame)
        isSelectedView.layer.borderWidth = 2
        isSelectedView.layer.borderColor = PBSImageBrower.Color.blue.cgColor
        isSelectedView.tag = 10_003

        cell.addSubview(isSelectedView)

      } else {
        imageView = cell.viewWithTag(10_002) as? UIImageView
        isSelectedView = cell.viewWithTag(10_003)
      }

      imageView.image = asset.thumb
      isSelectedView.isHidden = position != indexPath.row

      return cell
    }
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard collectionView.tag == thumbnailCollection.tag else { return }
    position = indexPath.row
    updateTitle()
    originalCollection.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    thumbnailCollection.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    thumbnailCollection.reloadData()
  }

  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    guard scrollView.tag == originalCollection.tag else {
      return
    }
    position = Int(scrollView.contentOffset.x / ScreenWidth)
    thumbnailCollection.reloadData()
    thumbnailCollection.scrollToItem(at: IndexPath(row: position, section: 0), at: .centeredHorizontally, animated: true)
    updateTitle()
  }
}
