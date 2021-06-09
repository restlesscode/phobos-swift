//
//
//  ImageBrowerEditorViewController.swift
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

class ImageBrowerEditorViewController: PBSImageBrower.BaseViewController {
  private lazy var menuView: ImageBrowerEditorMenuView = {
    let height = 100 + BottomSafeAreaHeight
    let view = ImageBrowerEditorMenuView(frame: CGRect(x: 0, y: ScreenHeight - height, width: ScreenHeight, height: height))
    view.doneClickBlock = { [weak self] in
      self?.done()
    }

    view.buttonClickBlock = { [weak self] type, isSelected in
      self?.menuButtonClick(type: type, isSelected: isSelected)
    }
    return view
  }()

  private lazy var navigatorView: UIView = {
    let view = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: NavigationBarHeight))
    let startColor = UIColor.clear
    let endColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
    view.pbs.applyVerticalGradientBackground(colorset: [endColor, startColor])
    view.addSubview(backButton)
    return view
  }()

  private lazy var backButton: UIButton = {
    let button = UIButton(frame: CGRect(x: 0, y: StatusHeight, width: 60, height: 44))
    button.setImage(baseBundle.image(withName: "editor_back"), for: .normal)
    button.addTarget(self, action: #selector(self.pop), for: .touchUpInside)
    return button
  }()

  private lazy var zoomView: ImageBrowerZoomView = {
    let zoomView = ImageBrowerZoomView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight))
    if #available(iOS 11.0, *) {
      zoomView.mscrollView?.contentInsetAdjustmentBehavior = .never
    }
    zoomView.imageView?.isUserInteractionEnabled = true
    zoomView.imageView?.clipsToBounds = true
    zoomView.zoomBlock = { [weak self] scale in
      guard let self = self else { return }
      self.drawView.lineWidth = 5 / scale
      self.mosaicView.squareWidth = 15 / scale
      self.mosaicView.paintSize = CGSize(width: 40 / scale, height: 40 / scale)
    }
    return zoomView
  }()

  private lazy var colorsView: ImageBrowerEditorColorSelectView = {
    let view = ImageBrowerEditorColorSelectView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 50))
    view.block = { [weak self] color in
      self?.drawColorChange(color: color)
    }
    view.backBlock = { [weak self] in
      self?.drawBack()
    }
    view.isHidden = true
    return view
  }()

  private lazy var drawView: ImageBrowerDrawView = {
    let view = ImageBrowerDrawView(frame: self.zoomView.imageView?.bounds ?? .zero)
    view.drawEnd = { [weak self] in
      self?.drawEnd()
    }
    view.drawBegan = { [weak self] in
      self?.drawBegan()
    }
    view.isUserInteractionEnabled = false
    view.clipsToBounds = true
    return view
  }()

  private lazy var mosaicView: ImageBrowerMosaicView = {
    let view = ImageBrowerMosaicView(frame: self.zoomView.imageView?.bounds ?? .zero)
    view.brushColor = { [weak self] point -> UIColor in
      guard let self = self else { return UIColor.clear }
      var point = point
      let width: CGFloat = self.zoomView.imageView?.pbs.width ?? 0
      let height: CGFloat = self.zoomView.imageView?.pbs.height ?? 0
      point.x /= width / (self.asset.origin?.size.width ?? 0)
      point.y /= height / (self.asset.origin?.size.height ?? 0)
      point.x *= self.zoomView.scale
      point.y *= self.zoomView.scale

      return self.asset.origin?.pbs.colorAtPoint(point) ?? UIColor.clear
    }
    view.brushBeganBlock = { [weak self] in
      self?.hidden(isBack: false)
    }
    view.brushEndBlock = { [weak self] in
      guard let self = self else { return }
      self.show()
      self.mosaicMenuView.backButton.isEnabled = self.mosaicView.canBack
    }
    view.clipsToBounds = true
    view.isUserInteractionEnabled = true

    return view
  }()

  private lazy var mosaicMenuView: ImageBrowerMosaicStyleChangeVIew = {
    let view = ImageBrowerMosaicStyleChangeVIew(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 50))
    view.backBlock = { [weak self] in
      guard let self = self else { return }
      if self.mosaicView.canBack {
        self.mosaicView.goBack()
        view.backButton.isEnabled = self.mosaicView.canBack
      }
    }
    view.selectChange = { [weak self] type in
      guard let self = self else { return }
      self.mosaicView.mosaicType = type
    }
    view.isHidden = true
    return view
  }()

  private var labelDeleteView: ImageBrowerTextLabelDeleteView!

  var asset: ImageBrowerAsset!
  private var editorType: ImageBrowerEditorType = .line
  var editorBlock: ((ImageBrowerAsset) -> Void)?
  private var editorTextViews: [ImageBrowerEditorTextView] = []
  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    view.addSubview(zoomView)
    zoomView.image = asset.origin
    zoomView.imageView?.addSubview(drawView)
    zoomView.imageView?.addSubview(mosaicView)
    view.addSubview(navigatorView)
    view.addSubview(menuView)
    menuView.addSubview(colorsView)
    menuView.addSubview(mosaicMenuView)
    show()
  }

  override var preferredStatusBarStyle: UIStatusBarStyle {
    .lightContent
  }

  func done() {
    showLoading()
    let image = makeImageWith(view: zoomView.imageView ?? UIImageView())
    DispatchQueue.global().async {
      self.asset.origin = image
      self.asset.thumb = image?.pbs.scaleImageWithSize(CGSize(width: 200, height: 200))
      DispatchQueue.main.async {
        self.hidden(isBack: true)
      }
    }
  }

  func show() {
    navigatorView.alpha = 0
    menuView.alpha = 0

    UIView.animate(withDuration: 0.2) {
      self.navigatorView.alpha = 1
      self.menuView.alpha = 1
    }
  }

  @objc func pop() {
    hidden()
  }

  func hidden(isBack: Bool = true) {
    UIView.animate(withDuration: 0.2, animations: {
      self.navigatorView.alpha = 0
      self.menuView.alpha = 0
    }, completion: { over in
      if over && isBack {
        self.navigationController?.popViewController(animated: false)
        self.editorBlock?(self.asset)
      }
    })
  }

  func makeImageWith(view: UIImageView) -> UIImage? {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, true, UIScreen.main.scale)

    if let context = UIGraphicsGetCurrentContext() {
      view.layer.render(in: context)
    }

    let image = UIGraphicsGetImageFromCurrentImageContext()

    UIGraphicsEndImageContext()

    return image
  }
}

extension ImageBrowerEditorViewController {
  func menuButtonClick(type: ImageBrowerEditorType, isSelected: Bool) {
    switch type {
    case .line, .box:
      hiddenMosaicView()
      if isSelected {
        drawView.drawType = type == .line ? .line : .box
        showDrawColorsView()
      } else {
        hiddenColorsView()
      }
    case .text:
      presentToTextEditor()
    case .crop:
      presentToImageCropping()
    case .mosaic:
      if isSelected {
        hiddenColorsView()
        showMosaicView()
      } else {
        hiddenMosaicView()
      }
    }
    editorType = type
  }
}

// MARK: - cropping image

extension ImageBrowerEditorViewController {
  func presentToImageCropping() {
    let vc = PBSImageBrower.CroppingViewController()
    vc.asset = asset
    vc.modalPresentationStyle = .fullScreen
    vc.isPush = false
    vc.editBlock = { [weak self] asset in
      guard let self = self else { return }
      self.asset = asset
      self.zoomView.image = asset.origin
    }
    present(vc, animated: false, completion: nil)
  }
}

// MARK: - Draw Line and Box

extension ImageBrowerEditorViewController {
  func showDrawColorsView() {
    colorsView.isHidden = false
    drawView.isUserInteractionEnabled = true
    drawColorChange(color: colorsView.currentColor())
    zoomView.mscrollView?.isScrollEnabled = false
    zoomView.mscrollView?.pinchGestureRecognizer?.isEnabled = true
  }

  func hiddenColorsView() {
    guard !colorsView.isHidden else { return }
    colorsView.isHidden = true
    drawView.isUserInteractionEnabled = false
    zoomView.mscrollView?.isScrollEnabled = true
  }

  func drawColorChange(color: UIColor) {
    drawView.lineColor = color
  }

  func drawBack() {
    drawView.back()
    colorsView.backButton.isEnabled = !drawView.lineArray.isEmpty
  }

  func drawEnd() {
    colorsView.backButton.isEnabled = !drawView.lineArray.isEmpty
    guard menuView.alpha == 0 else { return }
    show()
  }

  func drawBegan() {
    guard menuView.alpha == 1 else { return }
    hidden(isBack: false)
  }
}

// MARK: - Draw Text

extension ImageBrowerEditorViewController {
  func presentToTextEditor(editorText: ImageBrowerEditorText? = nil) {
    let vc = ImageBrowerEditorAddTextVC()
    vc.asset = asset
    vc.oldEditorText = editorText
    vc.modalPresentationStyle = .fullScreen
    vc.isPush = false
    vc.editorBlock = { [weak self] editorText in
      guard let self = self else { return }
      if let index = self.editorTextViews.firstIndex(where: { $0.editorText.id == editorText.id }) {
        self.editorTextViews[index].editorText = editorText
        self.editorTextViews[index].updateLayout()
      } else {
        let editorTextView = ImageBrowerEditorTextView(editorText: editorText)
        editorTextView.block = { [weak self] gr in
          self?.textLabelGestureRecognizer(gr: gr)
        }
        self.editorTextViews.append(editorTextView)
        self.setTextCenter(editorTextView: editorTextView)

        self.zoomView.imageView?.addSubview(editorTextView)
      }
    }
    present(vc, animated: true, completion: nil)
  }

  func setTextCenter(editorTextView: ImageBrowerEditorTextView) {
    let imageRect = zoomView.mscrollView?.convert(zoomView.imageView?.frame ?? .zero, to: view) ?? .zero
    var center = CGPoint.zero
    let zoomHeight = zoomView.mscrollView?.pbs.height ?? 0
    let zoomWidth = zoomView.mscrollView?.pbs.width ?? 0
    center.x = abs(imageRect.origin.x) + zoomWidth / 2
    if imageRect.origin.y >= 0 && imageRect.size.height <= zoomHeight {
      center.y = imageRect.size.height / 2
    } else {
      center.y = abs(imageRect.origin.y) + zoomHeight / 2
    }
    let zoomScale = zoomView.scale
    editorTextView.transform.scaledBy(x: 1 / zoomScale, y: 1 / zoomScale)
    center = CGPoint(x: center.x / zoomScale, y: center.y / zoomScale)
    editorTextView.center = center
  }

  // swiftlint:disable cyclomatic_complexity
  func textLabelGestureRecognizer(gr: UIGestureRecognizer) {
    guard let editorTextView = gr.view as? ImageBrowerEditorTextView else { return }
    switch gr {
    case is UITapGestureRecognizer:
      presentToTextEditor(editorText: editorTextView.editorText)
    case is UIPanGestureRecognizer:
      guard let pan = gr as? UIPanGestureRecognizer else { return }
      textLabelPanAction(pan: pan, editorTextView: editorTextView)
    case is UIPinchGestureRecognizer:
      guard let pinch = gr as? UIPinchGestureRecognizer else { return }
      textLabelPinchAction(pinch: pinch, editorTextView: editorTextView)
    case is UIRotationGestureRecognizer:
      guard let rotation = gr as? UIRotationGestureRecognizer else { return }
      textLabelRotationAction(rotation: rotation, editorTextView: editorTextView)
    default:
      break
    }

    switch gr.state {
    case .began:
      zoomView.imageView?.clipsToBounds = false
    case .ended, .failed, .cancelled:
      zoomView.imageView?.clipsToBounds = true
    default:
      break
    }
  }

  func textLabelPanAction(pan: UIPanGestureRecognizer, editorTextView: ImageBrowerEditorTextView) {
    let transPoint = pan.translation(in: zoomView.imageView)
    switch pan.state {
    case .began:
      hidden(isBack: false)
      showTextDeleteView()
    case .changed:
      guard let panView = pan.view else { return }
      let center = CGPoint(x: panView.center.x + transPoint.x, y: panView.center.y + transPoint.y)
      panView.center = center
      pan.setTranslation(.zero, in: zoomView.imageView)
      let touchPoint = pan.location(in: view)
      if labelDeleteView.frame.contains(touchPoint) {
        labelDeleteView.setStatus(canDelete: true)
      } else {
        labelDeleteView.setStatus(canDelete: false)
      }
    case .failed, .ended:
      hiddenTextDeleteView()
      show()
      let touchPoint = pan.location(in: view)
      let imageRect = zoomView.convert(zoomView.imageView?.frame ?? .zero, to: view)
      if labelDeleteView.frame.contains(touchPoint) {
        editorTextView.removeFromSuperview()
        if let index = editorTextViews.firstIndex(of: editorTextView) {
          editorTextViews.remove(at: index)
        }
      } else if !imageRect.contains(touchPoint) {
        UIView.animate(withDuration: 0.2) {
          self.setTextCenter(editorTextView: editorTextView)
        }
      }
    default:
      break
    }
  }

  func textLabelPinchAction(pinch: UIPinchGestureRecognizer, editorTextView: ImageBrowerEditorTextView) {
    switch pinch.state {
    case .began:
      zoomView.mscrollView?.pinchGestureRecognizer?.isEnabled = false
    case .failed, .ended:
      zoomView.mscrollView?.pinchGestureRecognizer?.isEnabled = true
    default:
      break
    }
    let transform = editorTextView.transform.scaledBy(x: pinch.scale, y: pinch.scale)
    editorTextView.transform = transform
    pinch.scale = 1
  }

  func textLabelRotationAction(rotation: UIRotationGestureRecognizer, editorTextView: ImageBrowerEditorTextView) {
    let transform = editorTextView.transform.rotated(by: rotation.rotation)
    editorTextView.transform = transform
    rotation.rotation = 0
  }

  func showTextDeleteView() {
    let toY = ScreenHeight - 70 - BottomSafeAreaHeight
    if labelDeleteView == nil {
      labelDeleteView = ImageBrowerTextLabelDeleteView(frame: CGRect(x: ScreenWidth / 2 - 70, y: ScreenHeight, width: 140, height: 70))
      view.addSubview(labelDeleteView)
    } else {
      labelDeleteView.alpha = 1
    }

    UIView.animate(withDuration: 0.2) {
      self.labelDeleteView.frame.origin.y = toY
    }
  }

  func hiddenTextDeleteView() {
    UIView.animate(withDuration: 0.2, animations: {
      self.labelDeleteView.alpha = 0
    }, completion: { over in
      if over {
        self.labelDeleteView.frame.origin.y = ScreenHeight
      }
    })
  }
}

extension ImageBrowerEditorViewController {
  func hiddenMosaicView() {
    guard mosaicView.isUserInteractionEnabled else { return }
    mosaicView.isUserInteractionEnabled = false
    mosaicMenuView.isHidden = true
    zoomView.mscrollView?.isScrollEnabled = true
  }

  func showMosaicView() {
    zoomView.mscrollView?.isScrollEnabled = false
    mosaicView.isUserInteractionEnabled = true
    mosaicMenuView.isHidden = false
  }
}
