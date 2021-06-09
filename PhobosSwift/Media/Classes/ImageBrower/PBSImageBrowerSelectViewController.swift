//
//
//  PBSImageBrowerSelectViewController.swift
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
import UIKit
struct ImageBrowerAsset {
  var asset: PHAsset
  var thumb: UIImage?
  var origin: UIImage?

  func getThumbImage(block: @escaping (UIImage?) -> Void) {
    let option = PHImageRequestOptions()
    option.isSynchronous = true
    PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: 150, height: 150), contentMode: .aspectFill, options: option) { image, _ in
      block(image)
    }
  }

  func getOriginImage(block: @escaping (UIImage?) -> Void) {
    let option = PHImageRequestOptions()
    option.isSynchronous = true
    PHImageManager.default().requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFill, options: option) { image, _ in
      guard let image = image else {
        block(nil)
        return
      }
      block(image.scaleImageWithSize(CGSize(width: 1280, height: 1280)))
    }
  }

  init(asset: PHAsset) {
    self.asset = asset
  }

  init(thumb: UIImage?, origin: UIImage?) {
    self.thumb = thumb
    self.origin = origin
    asset = PHAsset()
  }
}

struct ImageBrowerPHCollection {
  var collection: PHCollection
  var asstes: [ImageBrowerAsset] = []
}

public class PBSImageBrowerSelectViewController: PBSImageBrowerBaseViewController {
  /// StatusBarStyle
  override public var preferredStatusBarStyle: UIStatusBarStyle {
    .lightContent
  }

  private let cellId = "AssetImageCell"
  private let groupCellId = "MPGroupSelectCell"
  public var selectBlock: (([UIImage]) -> Void)?
  private lazy var collectionView: UICollectionView = {
    let space: CGFloat = 3
    let oneRowCount: CGFloat = 4
    let itemSize = (ScreenWidth - space * (oneRowCount + 1)) / oneRowCount
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.itemSize = CGSize(width: itemSize, height: itemSize)
    flowLayout.sectionInset = UIEdgeInsets(top: space, left: space, bottom: space, right: space)
    flowLayout.minimumLineSpacing = space // 每个相邻layout的上下
    flowLayout.minimumInteritemSpacing = space // 每个相邻layout的左右
    flowLayout.scrollDirection = .vertical

    let collection = UICollectionView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight), collectionViewLayout: flowLayout)
    collection.delegate = self
    collection.dataSource = self
    collection.backgroundColor = UIColor.clear
    collection.register(ImageBrowerSelectCell.self, forCellWithReuseIdentifier: cellId)
    collection.showsHorizontalScrollIndicator = false
    if #available(iOS 11.0, *) {
      collection.contentInsetAdjustmentBehavior = .never
    }
    return collection
  }()

  private lazy var coverView: UIView = {
    let view = UIView(frame: CGRect(x: 0, y: NavigationBarHeight, width: ScreenWidth, height: ScreenHeight - NavigationBarHeight))
    view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
    view.alpha = 0
    return view
  }()

  private var groupLabel: UILabel!
  private var groupArrowView: UIImageView!
  private var groupView: UIView = {
    let view = UIView()
    view.backgroundColor = UIColor.pbs.color(R: 50, G: 54, B: 57)
    view.layer.cornerRadius = 15
    view.clipsToBounds = true

    return view
  }()

  private var previewButton: UIButton!
  private var sendButton: UIButton!
  private var albums: [ImageBrowerPHCollection] = []
  private var albumShowIndex = 0
  private var selectIndex: [IndexPath] = []

  override public func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.black
    // Do any additional setup after loading the view.
    view.addSubview(collectionView)
    bottomViewInit()
    view.addSubview(coverView)
    tableViewSetUp()
    navigationViewInit()

    collectionView.contentInset = UIEdgeInsets(top: NavigationBarHeight, left: 0, bottom: BottomSafeAreaHeight + 55, right: 0)

    checkAuthorization()
  }

  func checkAuthorization() {
    if #available(iOS 14, *) {
      switch PHPhotoLibrary.authorizationStatus(for: .readWrite) {
      case .notDetermined:
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] status in
          DispatchQueue.main.async {
            if status == .authorized {
              self?.dataInit()
            } else {
              self?.noAuthorized()
            }
          }
        }
      case .authorized:
        dataInit()
      default:
        noAuthorized()
      }

    } else {
      // Fallback on earlier versions
      switch PHPhotoLibrary.authorizationStatus() {
      case .notDetermined:
        PHPhotoLibrary.requestAuthorization { [weak self] status in
          DispatchQueue.main.async {
            if status == .authorized {
              self?.dataInit()
            } else {
              self?.noAuthorized()
            }
          }
        }
      case .authorized:
        dataInit()
      default:
        noAuthorized()
      }
    }
  }

  func noAuthorized() {
    // swiftlint:disable line_length
    present(getSettingAlertControl(title: PBSImageBrowerStrings.noPhotoLibraryAccess, message: PBSImageBrowerStrings.sureToSetting, cancelBlock: { [weak self] in self?.cancel() }), animated: true, completion: nil)
  }

  func dataInit() {
    showLoading()
    DispatchQueue.global().async { [weak self] in
      guard let self = self else { return }
      self.getAllAlbumAndPHAsset()
      self.albums.sort { a, b -> Bool in
        a.asstes.count > b.asstes.count
      }

      DispatchQueue.main.async { [weak self] in
        guard let self = self else { return }
        self.hiddenLoading()
        self.resetGroupSelectTitle()
        self.collectionView.reloadData()
      }
    }
  }

  func tableViewSetUp() {
    let height = ScreenHeight - NavigationBarHeight
    tableView.frame = CGRect(x: 0, y: -height + NavigationBarHeight, width: view.width(), height: height)
    tableView.separatorStyle = .singleLine
    tableView.separatorColor = PBSImageBrowerColor.grey5Grey3
    tableView.backgroundColor = UIColor.clear
    tableView.contentInset = .zero
    tableView.isHidden = true
    tableView.register(ImageBrowerGroupSelectCell.self, forCellReuseIdentifier: groupCellId)
    tableView.tableFooterView = UIView()

    view.addSubview(tableView)
  }

  func navigationViewInit() {
    let view = UIView(frame: CGRect(origin: .zero, size: CGSize(width: ScreenWidth, height: NavigationBarHeight)))
    let effect = UIBlurEffect(style: UIBlurEffect.Style.dark)
    let effectView = UIVisualEffectView(effect: effect)
    effectView.frame = view.frame

    view.addSubview(effectView)

    let cancelButton = UIButton(frame: CGRect(x: 0, y: NavigationBarHeight - 44, width: 75, height: 44))
    cancelButton.setTitle(PBSImageBrowerStrings.cancel, for: .normal)
    cancelButton.setTitleColor(UIColor.white, for: .normal)
    cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
    cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)

    view.addSubview(cancelButton)

    view.addSubview(groupView)

    groupView.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.bottom.equalToSuperview().offset(-7)
      make.width.greaterThanOrEqualTo(0)
      make.height.equalTo(30)
    }

    groupLabel = UILabel()
    groupLabel.textColor = UIColor.white
    groupLabel.font = UIFont.systemFont(ofSize: 16)

    groupView.addSubview(groupLabel)

    groupArrowView = UIImageView()
    groupArrowView.image = baseBundle.image(withName: "arrow_bottom_s")
    groupArrowView.backgroundColor = PBSImageBrowerColor.grey4
    groupArrowView.layer.cornerRadius = 10
    groupArrowView.clipsToBounds = true
    groupArrowView.contentMode = .center

    groupView.addSubview(groupArrowView)

    groupView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectGroup)))

    groupLabel.snp.makeConstraints { make in
      make.left.equalTo(10)
      make.top.bottom.equalToSuperview()
    }

    groupArrowView.snp.makeConstraints { make in
      make.left.equalTo(groupLabel.snp.right).offset(5)
      make.right.equalToSuperview().offset(-10)
      make.width.height.equalTo(20)
      make.centerY.equalToSuperview()
    }

    self.view.addSubview(view)
  }

  func bottomViewInit() {
    let height = 55 + BottomSafeAreaHeight
    let view = UIView(frame: CGRect(x: 0, y: ScreenHeight - height, width: ScreenWidth, height: height))
    let effect = UIBlurEffect(style: UIBlurEffect.Style.dark)
    let effectView = UIVisualEffectView(effect: effect)
    effectView.frame = CGRect(origin: .zero, size: view.frame.size)

    view.addSubview(effectView)

    previewButton = UIButton(frame: CGRect(x: 0, y: 0, width: 65, height: 55))
    previewButton.setTitle(PBSImageBrowerStrings.preview, for: .normal)
    previewButton.setTitleColor(UIColor.white, for: .normal)
    previewButton.setTitleColor(PBSImageBrowerColor.grey5Grey3, for: .disabled)
    previewButton.addTarget(self, action: #selector(preview), for: .touchUpInside)
    previewButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
    previewButton.isEnabled = false

    view.addSubview(previewButton)

    sendButton = UIButton(frame: CGRect(x: ScreenWidth - 95, y: 11, width: 80, height: 34))
    sendButton.setTitle(PBSImageBrowerStrings.send, for: .disabled)
    sendButton.setTitleColor(UIColor.white, for: .normal)
    sendButton.setTitleColor(PBSImageBrowerColor.grey5Grey3, for: .disabled)
//        sendButton.backgroundColor = ImageBrowerColor.blue
    sendButton.addTarget(self, action: #selector(send), for: .touchUpInside)
    sendButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
    sendButton.corner(radii: 5)
    sendButton.isEnabled = false
    sendButton.setBackgroundImage(UIImage.pbs.makeImage(from: PBSImageBrowerColor.grey4), for: .disabled)
    sendButton.setBackgroundImage(UIImage.pbs.makeImage(from: PBSImageBrowerColor.blue), for: .normal)

    view.addSubview(sendButton)

    self.view.addSubview(view)
  }

  @objc func cancel() {
    dismiss(animated: true, completion: nil)
//        self.navigationController?.popViewController(animated: true)
  }

  @objc func selectGroup() {
    if tableView.isHidden {
      tableView.reloadData()
      tableView.isHidden = false

      UIView.animate(withDuration: 0.2) {
        self.coverView.alpha = 1
        self.tableView.frame.origin.y = NavigationBarHeight
        self.groupArrowView.transform = CGAffineTransform(rotationAngle: CGFloat(.pi * 180.0 / 180))
      }
    } else {
      UIView.animate(withDuration: 0.2, animations: {
        self.coverView.alpha = 0
        self.tableView.frame.origin.y = NavigationBarHeight * 2 - ScreenHeight
        self.groupArrowView.transform = CGAffineTransform(rotationAngle: 0)
      }, completion: { over in
        if over {
          self.tableView.isHidden = true
        }
      })
    }
  }

  @objc func preview() {
    let assets = selectIndex.map { albums[albumShowIndex].asstes[$0.row] }

    let vc = ImageBrowerLiveChatImagePreviewVC()
    vc.assets = assets
    vc.selectBlock = selectBlock

    navigationController?.pushViewController(vc, animated: true)
  }

  @objc func send() {
    showLoading()
    let assets = selectIndex.compactMap { indexPath -> ImageBrowerAsset? in
      albums[albumShowIndex].asstes[indexPath.row]
    }

    var images: [UIImage] = []
    let group = DispatchGroup()
    for i in 0..<assets.count {
      group.enter()
      DispatchQueue.global().async {
        assets[i].getOriginImage { image in
          if let image = image {
            images.append(image)
          }
          group.leave()
        }
      }
    }

    group.notify(queue: DispatchQueue.main) {
      self.hiddenLoading()
      self.selectBlock?(images)
      self.dismiss(animated: true, completion: nil)
    }
  }

  func disableButtons() {
    sendButton.isEnabled = false
    previewButton.isEnabled = false
  }

  func enableButtons() {
    sendButton.isEnabled = true
    previewButton.isEnabled = true
    sendButton.setTitle("\(PBSImageBrowerStrings.send) (\(selectIndex.count))", for: .normal)
  }

  func resetGroupSelectTitle() {
    groupLabel.text = albums[albumShowIndex].collection.localizedTitle ?? ""
  }
}

extension PBSImageBrowerSelectViewController {
  func getAllAlbumAndPHAsset() {
    let smartAlbums: PHFetchResult = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil)
    for i in 0..<smartAlbums.count {
      // 是否按创建时间排序
      let options = PHFetchOptions()
      options.sortDescriptors = [NSSortDescriptor(key: "creationDate",
                                                  ascending: false)] // 时间排序
      options.predicate = NSPredicate(format: "mediaType == %ld", PHAssetMediaType.image.rawValue) // ˙只选照片

      let collection: PHAssetCollection = smartAlbums[i]

      let fetchResult: PHFetchResult = PHAsset.fetchAssets(in: collection, options: options)

      if fetchResult.countOfAssets(with: .image) != 0 {
        var mpCollection = ImageBrowerPHCollection(collection: collection)
        var assets = [ImageBrowerAsset]()
        print("title---%@", collection.localizedTitle as Any)
        fetchResult.enumerateObjects { asset, _, _ in
          let mpAsset = ImageBrowerAsset(asset: asset)
          assets.append(mpAsset)
        }
        mpCollection.asstes = assets
        albums.append(mpCollection)
      }
    }
  }
}

extension PBSImageBrowerSelectViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    guard albumShowIndex < albums.count else { return 0 }
    return albums[albumShowIndex].asstes.count
  }

  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? ImageBrowerSelectCell

    if let thumb = albums[albumShowIndex].asstes[indexPath.row].thumb {
      cell?.setImage(thumb)
    } else {
      albums[albumShowIndex].asstes[indexPath.row].getThumbImage { [weak self] image in
        guard let self = self else { return }
        self.albums[self.albumShowIndex].asstes[indexPath.row].thumb = image
        cell?.setImage(image)
      }
    }

    cell?.setSelectStatus(selected: selectIndex.contains(indexPath))

    return cell ?? UICollectionViewCell()
  }

  public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let cell = collectionView.cellForItem(at: indexPath) as? ImageBrowerSelectCell else {
      return
    }

    if let index = selectIndex.firstIndex(where: { $0 == indexPath }) {
      selectIndex.remove(at: index)
      cell.setSelectStatus(selected: false)
    } else {
      guard selectIndex.count < 9 else {
        return
      }

      selectIndex.append(indexPath)
      cell.setSelectStatus(selected: true)
    }

    if selectIndex.isEmpty {
      disableButtons()
    } else {
      enableButtons()
    }
  }
}

extension PBSImageBrowerSelectViewController {
  override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    albums.count
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    55
  }

  override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: groupCellId) as? ImageBrowerGroupSelectCell else {
      return UITableViewCell()
    }

    cell.setData(collection: albums[indexPath.row], isSelected: albumShowIndex == indexPath.row)

    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    albumShowIndex = indexPath.row
    resetGroupSelectTitle()
    selectGroup()
    selectIndex.removeAll()
    collectionView.reloadData()
    disableButtons()
  }

  func getSettingAlertControl(title: String, message: String, cancelBlock: (() -> Void)? = nil) -> UIAlertController {
    let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)

    controller.addAction(UIAlertAction(title: PBSImageBrowerStrings.sure, style: .default) { _ in
      controller.dismiss(animated: true, completion: nil)
      guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
      guard UIApplication.shared.canOpenURL(url) else { return }
      UIApplication.shared.open(url, options: [:], completionHandler: nil)
    })

    controller.addAction(UIAlertAction(title: PBSImageBrowerStrings.cancel, style: .cancel) { _ in
      controller.dismiss(animated: true, completion: nil)
      cancelBlock?()
    })

    return controller
  }
}
