//
//
//  PBSImageBrowerPreviewViewController.swift
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

import AlamofireImage
import UIKit

public enum PBSMPImageType: String {
  case local
  case bundle
  case url
}

/// The params key to the image preview controller
public struct PBSMPImagePreviewKey {
  /// show position
  public static let position = "position"
  /// image sources
  public static let images = "images"
  /// image type
  public static let imageType = "imageType"
}

public class PBSImageBrowerPreviewViewController: PBSImageBrowerBaseViewController {
//    var commentModel: MPEventMomentModel!
  var position: Int = 0
  var imageType: PBSMPImageType = .url
  private lazy var collection_image: UICollectionView = {
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.itemSize = CGSize(width: ScreenWidth, height: ScreenHeight)
    flowLayout.sectionInset = UIEdgeInsets.zero
    flowLayout.minimumLineSpacing = 0 // 每个相邻layout的上下
    flowLayout.minimumInteritemSpacing = 0 // 每个相邻layout的左右
    flowLayout.scrollDirection = .horizontal

    let height = ScreenHeight - NavigationBarHeight
    let collection_image = UICollectionView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: height), collectionViewLayout: flowLayout)
    collection_image.isPagingEnabled = true
    collection_image.delegate = self
    collection_image.dataSource = self
    collection_image.tag = 1001
    collection_image.backgroundColor = UIColor.clear
    collection_image.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "1")
    collection_image.showsHorizontalScrollIndicator = false

    return collection_image
  }()

  override public var preferredStatusBarStyle: UIStatusBarStyle {
    .lightContent
  }

  private var images = [String]()

  override public func viewDidLoad() {
    super.viewDidLoad()
    UISetUp()
  }

  func setOtherDatas(_ values: [String: Any]) {
    if let position = values[PBSMPImagePreviewKey.position] as? Int {
      self.position = position
    }

    if let images = values[PBSMPImagePreviewKey.images] as? [String] {
      self.images = images
    }

    if let imageTypeRawValue = values[PBSMPImagePreviewKey.imageType] as? String {
      if let imageType = PBSMPImageType(rawValue: imageTypeRawValue) {
        self.imageType = imageType
      }
    }
  }

  /*
   // MARK: - Navigation

   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       // Get the new view controller using segue.destination.
       // Pass the selected object to the new view controller.
   }
   */

  override public func back() {
    super.back()
  }

//    override func setCustomData(_ value: Any) {
//        commentModel = value as? MPEventMomentModel
//        self.images = commentModel.images
//    }

  override public func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigatorStyleChange(isBlack: true)
  }

  override public func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    navigatorStyleChange(isBlack: false)
  }

  override public func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    collection_image.contentOffset.x = CGFloat(position) * ScreenWidth
  }
}

extension PBSImageBrowerPreviewViewController {
  func UISetUp() {
    view.backgroundColor = PBSImageBrowerColor.black
    // Do any additional setup after loading the view.
    view.addSubview(collection_image)
    updateTitle()

    let rightItem = UIButton(frame: CGRect(x: 0, y: 0, width: 28, height: 44))
    rightItem.setImage(baseBundle.image(withName: "ic_share_white")?.withRenderingMode(.alwaysTemplate), for: .normal)
    rightItem.addTarget(self, action: #selector(share), for: .touchUpInside)
    rightItem.tintColor = PBSImageBrowerColor.whiteGrey8
    navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightItem)

    bottomViewInit()
  }

  func bottomViewInit() {
//        guard commentModel != nil else {
//            return
//        }
//        let y = ScreenHeight - 60 - BottomSafeAreaHeight - NavigationBarHeight
//        let bottomView = MPEventCommentHeaderView(frame: CGRect(x: 0, y: y, width: ScreenWidth, height: 60))
//        bottomView.setData(commentModel)
//        bottomView.contentView.backgroundColor = UIColor.clear
//        bottomView.userNameLabel.textColor = ImageBrowerColor.white
//        bottomView.line.isHidden = true
//
//        view.addSubview(bottomView)
  }

  func navigatorStyleChange(isBlack: Bool) {
    navigationController?.navigationBar.barTintColor = isBlack ? PBSImageBrowerColor.black : PBSImageBrowerColor.whiteGrey8
    // 去除分割线
    navigationController?.navigationBar.shadowImage = UIImage()

    // 标题颜色
    let titleColor = isBlack ? PBSImageBrowerColor.white : PBSImageBrowerColor.blackWhite
    navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: titleColor, .font: UIFont.boldSystemFont(ofSize: 17)]

    guard let backButton = navigationItem.leftBarButtonItem?.customView as? UIButton else {
      return
    }

    let backImage = isBlack ? "back_white" : "back"
    let image = baseBundle.image(withName: backImage)?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
    backButton.setImage(image, for: UIControl.State.normal)

    backButton.setTitleColor(titleColor, for: UIControl.State.normal)
  }

  @objc func share() {
    /// 时间、标题
    var items = [Any]()
    items.append(PBSImageBrowerStrings.pictureShare)

    if
      let zoomView = collection_image.cellForItem(at: IndexPath(row: position, section: 0))?.viewWithTag(10_001) as? ImageBrowerZoomView,
      let image = zoomView.imageView?.image {
      items.append(image)
    }

    let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)

    present(activityViewController, animated: true, completion: nil)
  }
}

extension PBSImageBrowerPreviewViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  // 存储图片至指定相册中
  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    images.count
  }

  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "1", for: indexPath)
    var image: ImageBrowerZoomView!
    var indicatorView: UIActivityIndicatorView!
    if cell.viewWithTag(10_001) == nil {
      image = ImageBrowerZoomView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight))
      image.tag = 10_001
      image.back = { [weak self] in
        self?.back()
      }

      indicatorView = UIActivityIndicatorView(style: .whiteLarge)
      indicatorView.frame = CGRect(x: ScreenWidth / 2 - 50, y: ScreenHeight / 2 - 50, width: 100, height: 100)
      indicatorView.tag = 10_002
      indicatorView.hidesWhenStopped = true

      cell.addSubview(image)
      cell.addSubview(indicatorView)
    } else {
      image = cell.viewWithTag(10_001) as? ImageBrowerZoomView
      indicatorView = cell.viewWithTag(10_002) as? UIActivityIndicatorView
    }
    switch imageType {
    case .local:
//            image.imageView?.image = MPImageSanboxUtil.default.getImageWith(images[indexPath.row])
      break
    case .url:
      indicatorView?.startAnimating()
      if let url = URL(string: images[indexPath.row]) {
        image.imageView?.af.setImage(withURL: url, completion: { _ in
          indicatorView?.stopAnimating()
        })
      } else {
        indicatorView?.stopAnimating()
      }
    case .bundle:
      image.imageView?.image = baseBundle.image(withName: images[indexPath.row])
    }

    return cell
  }

  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    position = Int(scrollView.contentOffset.x / ScreenWidth)
    updateTitle()
  }

  func updateTitle() {
    title = "\(PBSImageBrowerStrings.picture)\(position + 1)/\(images.count)"
  }
}
