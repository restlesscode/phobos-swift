//
//
//  PBSImageCroppingViewController.swift
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

import UIKit

public protocol PBSImageCroppingViewControllerDelegate: NSObjectProtocol {
  func cropImageFinished(cropImage: UIImage)
}

public enum GridCropRectType {
  case square
  case random
}

extension PBSImageBrower {
  public class CroppingViewController: BaseViewController {
    var asset: ImageBrowerAsset!
    var editBlock: ((ImageBrowerAsset) -> Void)?
    public weak var delegate: PBSImageCroppingViewControllerDelegate?
    private let KGridLRMargin: CGFloat = 30
    private let KGridBottomMargin: CGFloat = 20
    private let KGridTopMargin: CGFloat = 20 + StatusHeight
    private let KBottomMenuHeight: CGFloat = 100
    private lazy var zoomView: ImageBrowerImageZoomView = {
      let imageSize = asset.origin?.size ?? .zero
      let width = ScreenWidth - KGridLRMargin * 2
      let height = width * imageSize.height / imageSize.width
      let zoomView = ImageBrowerImageZoomView(frame: CGRect(x: KGridLRMargin, y: KGridTopMargin, width: width, height: height))
      zoomView.zoomViewDelegate = self
      zoomView.center.y = (ScreenHeight - KBottomMenuHeight) / 2
      return zoomView
    }()

    private lazy var maxGridRect: CGRect = {
      let height = ScreenHeight - KBottomMenuHeight - KGridBottomMargin - KGridTopMargin
      return CGRect(x: KGridLRMargin, y: KGridTopMargin, width: ScreenWidth - KGridLRMargin * 2, height: height)
    }()

    private var originalRect = CGRect.zero
    private var rotateAngle: Int = 0
    private var imageOrientation: UIImage.Orientation = .up
    private let rotateBtn: UIButton = {
      let button = UIButton(frame: CGRect(x: 10, y: ScreenHeight - 150, width: 50, height: 50))
      button.setImage(baseBundle.image(withName: "editor_rotate"), for: .normal)

      return button
    }()

    private let cancelButton: UIButton = {
      let button = UIButton(frame: CGRect(x: 10, y: ScreenHeight - 75, width: 50, height: 50))
      button.setImage(baseBundle.image(withName: "editor_cancel"), for: .normal)

      return button
    }()

    private let sureButton: UIButton = {
      let button = UIButton(frame: CGRect(x: ScreenWidth - 60, y: ScreenHeight - 75, width: 50, height: 50))
      button.setImage(baseBundle.image(withName: "editor_sure"), for: .normal)

      return button
    }()

    private let reductionButton: UIButton = {
      let button = UIButton(frame: CGRect(x: ScreenWidth / 2 - 25, y: ScreenHeight - 75, width: 50, height: 50))
      button.setTitle(PBSImageBrowerStrings.reduction, for: .normal)
      button.setTitleColor(UIColor.white, for: .normal)
      button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
      return button
    }()

    private lazy var gridView: ImageBrowerGridView = {
      let gridView = ImageBrowerGridView(frame: view.bounds)
      gridView.delegate = self
      return gridView
    }()

    var cropType: GridCropRectType = .square

    override public var prefersStatusBarHidden: Bool {
      true
    }

    public convenience init(image: UIImage?, cropType: GridCropRectType = .square) {
      self.init()
      asset = ImageBrowerAsset(thumb: nil, origin: image)
      self.cropType = cropType
    }

    override public func viewDidLoad() {
      super.viewDidLoad()

      // Do any additional setup after loading the view.
      zoomView.image = asset.origin
      imageOrientation = asset.origin?.imageOrientation ?? .up
      let imageSize = asset.origin?.size ?? .zero
      var newSize = CGSize(width: ScreenWidth - 2 * KGridLRMargin, height: (ScreenWidth - 2 * KGridLRMargin) * imageSize.height / imageSize.width)
      if newSize.height > maxGridRect.size.height {
        newSize = CGSize(width: maxGridRect.size.height * imageSize.width / imageSize.height, height: maxGridRect.size.height)
        zoomView.frame.size = newSize
        zoomView.frame.origin.y = KGridTopMargin
        zoomView.center.x = ScreenWidth / 2
      } else {
        zoomView.frame.size = newSize
        zoomView.center = CGPoint(x: ScreenWidth / 2.0, y: (ScreenHeight - KBottomMenuHeight) / 2.0)
      }

      view.addSubview(zoomView)
      zoomView.imageView.frame = zoomView.bounds

      switch cropType {
      case .square:
        originalRect = CGRect(x: zoomView.frame.origin.x, y: (zoomView.pbs.height - zoomView.pbs.width) / 2.0 + zoomView.frame.origin.y, width: zoomView.pbs.width, height: zoomView.pbs.width)
      default:
        originalRect = zoomView.frame
      }
      gridView.cropType = cropType
      gridView.setGridRect(originalRect, isMaskLayer: true)
      gridView.maxGridRect = maxGridRect

      rotateBtn.addTarget(self, action: #selector(rotate), for: .touchUpInside)
      cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
      sureButton.addTarget(self, action: #selector(sure), for: .touchUpInside)
      reductionButton.addTarget(self, action: #selector(reduction), for: .touchUpInside)

      view.addSubview(gridView)
      view.addSubview(rotateBtn)
      view.addSubview(cancelButton)
      view.addSubview(sureButton)
      view.addSubview(reductionButton)
      view.backgroundColor = UIColor.black
    }

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
     }
     */
  }
}

extension PBSImageBrower.CroppingViewController {
  @objc func cancel() {
    dismiss(animated: false, completion: nil)
  }

  @objc func sure() {
    dismiss(animated: false, completion: nil)

    guard let clipImage = zoomView.imageView.pbs.mpImageByRect(range: rectOfGridOnImageByGridRect(cropRect: gridView.gridRect))?.cgImage else {
      return
    }
    let resultImage = UIImage(cgImage: clipImage, scale: UIScreen.main.scale, orientation: imageOrientation)
    asset.origin = resultImage
    editBlock?(asset)
    delegate?.cropImageFinished(cropImage: resultImage)
  }

  @objc func reduction() {
    zoomView.minimumZoomScale = 1
    zoomView.zoomScale = 1
    zoomView.transform = CGAffineTransform.identity
    zoomView.frame = originalRect
    gridView.setGridRect(zoomView.frame, isMaskLayer: true)
    rotateAngle = 0
  }

  @objc func rotate() {
    rotateAngle = (rotateAngle + 90) % 360
    updateImageOrientation()
    var angleInRadians: CGFloat = 0.0
    switch rotateAngle {
    case 90:
      angleInRadians = .pi / 2
    case -90:
      angleInRadians = -.pi / 2
    case 180:
      angleInRadians = .pi
    case -180:
      angleInRadians = -.pi
    case 270:
      angleInRadians = .pi + .pi / 2
    case -270:
      angleInRadians = -(.pi + .pi / 2)
    default:
      break
    }
    // 旋转前获得网格框在图片上选择的区域
    let gridRectOfImage = rectOfGridOnImageByGridRect(cropRect: gridView.gridRect)

    /// 旋转变形
    let transform = CGAffineTransform.identity.rotated(by: angleInRadians)
    zoomView.transform = transform
    // transform后，bounds不会变，frame会变
    let width = zoomView.frame.width
    let height = zoomView.frame.height
    // 计算旋转之后
    var newSize = CGSize(width: view.pbs.width - 40, height: (view.pbs.width - 40) * height / width)

    if newSize.height > gridView.maxGridRect.size.height {
      newSize = CGSize(width: gridView.maxGridRect.size.height * width / height, height: gridView.maxGridRect.size.height)
      zoomView.frame.size = newSize
      zoomView.frame.origin.y = 40
      zoomView.center.x = view.pbs.width / 2.0
    } else {
      zoomView.frame.size = newSize
      zoomView.center = CGPoint(x: ScreenWidth / 2.0, y: (ScreenHeight - 100) / 2.0)
    }
    gridView.setGridRect(zoomView.frame, isMaskLayer: true)

    // 重置最小缩放系数
    resetMinimumZoomScale()
    let scale = min(zoomView.frame.width / width, zoomView.frame.height / height)
    zoomView.zoomScale *= scale
    // 调整contentOffset
    let zoomViewScale = zoomView.zoomScale
    zoomView.contentOffset = CGPoint(x: gridRectOfImage.origin.x * zoomViewScale, y: gridRectOfImage.origin.y * zoomViewScale)
  }

  func updateImageOrientation() {
    var orientation = UIImage.Orientation.up
    switch rotateAngle {
    case 90, -270:
      orientation = UIImage.Orientation.right
    case -90, 270:
      orientation = UIImage.Orientation.left
    case 180, -180:
      orientation = UIImage.Orientation.down
    default:
      break
    }
    imageOrientation = orientation
  }
}

extension PBSImageBrower.CroppingViewController {
  // swiftlint:disable cyclomatic_complexity
  func zoomInToRect(gridRect: CGRect) {
    guard !zoomView.isDragging else { return }
    guard !zoomView.isDecelerating else { return }
    let imageRect = zoomView.convert(zoomView.imageView.frame, to: view)
    guard !imageRect.contains(gridRect) else { return }
    var contentOffset = zoomView.contentOffset
    if imageOrientation == .right {
      if gridRect.maxX > imageRect.maxX {
        contentOffset.y = 0
      }
      if gridRect.minY < imageRect.minY {
        contentOffset.x = 0
      }
    }
    if imageOrientation == .left {
      if gridRect.minX < imageRect.minX {
        contentOffset.y = 0
      }
      if gridRect.maxY > imageRect.maxY {
        contentOffset.x = 0
      }
    }
    if imageOrientation == .up {
      if gridRect.minY < imageRect.minY {
        contentOffset.y = 0
      }
      if gridRect.minX < imageRect.minX {
        contentOffset.x = 0
      }
    }
    if imageOrientation == .down {
      if gridRect.maxY > imageRect.maxY {
        contentOffset.y = 0
      }
      if gridRect.maxX > imageRect.maxX {
        contentOffset.x = 0
      }
    }
    zoomView.contentOffset = contentOffset
    var myFrame = zoomView.frame
    myFrame.origin.x = min(myFrame.origin.x, gridRect.origin.x)
    myFrame.origin.y = min(myFrame.origin.y, gridRect.origin.y)
    myFrame.size.width = max(myFrame.size.width, gridRect.size.width)
    myFrame.size.height = max(myFrame.size.height, gridRect.size.height)
    zoomView.frame = myFrame

    resetMinimumZoomScale()
    zoomView.zoomScale = zoomView.zoomScale
  }

  func resetMinimumZoomScale() {
    let rotateoriginalRect = originalRect.applying(zoomView.transform)
    if rotateoriginalRect.size.equalTo(CGSize.zero) {
      return
    }
    // 设置最小缩放系数
    let zoomScale = max(zoomView.frame.width / rotateoriginalRect.width, zoomView.frame.height / rotateoriginalRect.height)
    zoomView.minimumZoomScale = zoomScale
  }

  func rectOfGridOnImageByGridRect(cropRect: CGRect) -> CGRect {
    view.convert(cropRect, to: zoomView.imageView)
  }
}

extension PBSImageBrower.CroppingViewController: ImageBrowerGridViewDelegate {
  func beginResize(gridView: ImageBrowerGridView) {
    var contentOffset = zoomView.contentOffset
    if zoomView.contentOffset.x < 0 {
      contentOffset.x = 0
    }
    if zoomView.contentOffset.y < 0 {
      contentOffset.y = 0
    }
    zoomView.setContentOffset(contentOffset, animated: true)
  }

  func resizing(gridView: ImageBrowerGridView) {
    zoomInToRect(gridRect: gridView.gridRect)
  }

  func endResize(gridView: ImageBrowerGridView) {
    let gridRectOfImage = rectOfGridOnImageByGridRect(cropRect: gridView.gridRect)
    // 居中
    UIView.animate(withDuration: 0.25, delay: 0.0, options: .beginFromCurrentState, animations: {
      let gridRect = gridView.gridRect
      let maxRect = gridView.maxGridRect
      // swiftlint:disable line_length
      var newSize = CGSize(width: ScreenWidth - 2 * self.KGridLRMargin, height: (ScreenWidth - 2 * self.KGridLRMargin) * gridRect.size.height / gridRect.size.width)
      if newSize.height > gridView.maxGridRect.size.height {
        newSize = CGSize(width: maxRect.size.height * gridRect.size.width / gridRect.size.height, height: maxRect.size.height)
        self.zoomView.frame.size = newSize
        self.zoomView.frame.origin.y = self.KGridTopMargin
        self.zoomView.center.x = ScreenWidth / 2.0
      } else {
        self.zoomView.frame.size = newSize
        self.zoomView.center = CGPoint(x: ScreenWidth / 2.0, y: (ScreenHeight - self.KBottomMenuHeight) / 2.0)
      }

      // 重置最小缩放系数
      self.resetMinimumZoomScale()
      self.zoomView.zoomScale = self.zoomView.zoomScale
      // 调整contentOffset
      let zoomScale: CGFloat = self.zoomView.frame.width / gridRect.size.width
      gridView.setGridRect(self.zoomView.frame, isMaskLayer: true)
      self.zoomView.zoomScale *= zoomScale
      self.zoomView.contentOffset = CGPoint(x: gridRectOfImage.origin.x * self.zoomView.zoomScale, y: gridRectOfImage.origin.y * self.zoomView.zoomScale)

    })
  }
}

extension PBSImageBrower.CroppingViewController: ImageBrowerImageZoomViewDelegate {
  func zoomViewDidBeginMoveImage(zoomView: ImageBrowerImageZoomView) {
    gridView.setShowMaskLayer(show: false)
  }

  func zoomViewDidEndMoveImage(zoomView: ImageBrowerImageZoomView) {
    gridView.setShowMaskLayer(show: true)
  }
}
