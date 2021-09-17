//
//
//  ImageBrowerZoomView.swift
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

class ImageBrowerZoomView: UIControl, UIScrollViewDelegate {
  private let screenWidth: CGFloat = UIScreen.main.bounds.size.width
  private let screenHeight: CGFloat = UIScreen.main.bounds.size.height
  private let maxScale: CGFloat = 3.0 // 最大的缩放比例
  private let minScale: CGFloat = 1.0 // 最小的缩放比例

  private let animDuration: TimeInterval = 0.2 // 动画时长
  // 图片开始时的frame
  open var originFrame = CGRect.zero

  // 回调返回
  var back: (() -> Void)?
  var zoomBlock: ((CGFloat) -> Void)?
  // 要显示的图片
  open var image: UIImage? {
    didSet {
      if let _image = image {
        if originFrame == CGRect.zero {
          let imageViewH = _image.size.height / _image.size.width * screenWidth
          imageView?.bounds = CGRect(x: 0, y: 0, width: screenWidth, height: imageViewH)
          imageView?.center = (mscrollView?.center)!
        } else {
          imageView?.frame = originFrame
        }
        imageView?.image = image
      }
    }
  }

  // MARK: - Private property

  var mscrollView: UIScrollView?
  var imageView: UIImageView?

  var scale: CGFloat = 1.0 // 当前的缩放比例
  private var touchX: CGFloat = 0.0 // 双击点的X坐标
  private var touchY: CGFloat = 0.0 // 双击点的Y坐标

  private var isDoubleTapingForZoom: Bool = false // 是否是双击缩放

  // MARK: - Life cycle

  override public init(frame: CGRect) {
    super.init(frame: frame)
    // 初始化View
    initAllView()
  }

  @available(*, unavailable)
  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - UIScrollViewDelegate

  open func scrollViewDidZoom(_ scrollView: UIScrollView) {
    // 当捏或移动时，需要对center重新定义以达到正确显示位置
    var centerX = scrollView.center.x
    var centerY = scrollView.center.y
    centerX = scrollView.contentSize.width > scrollView.frame.size.width ? scrollView.contentSize.width / 2 : centerX
    centerY = scrollView.contentSize.height > scrollView.frame.size.height ?scrollView.contentSize.height / 2 : centerY

    imageView?.center = CGPoint(x: centerX, y: centerY)

    // ****************双击放大图片关键代码*******************

    if isDoubleTapingForZoom {
      let contentOffset = mscrollView?.contentOffset
      let center = self.center
      let offsetX = center.x - touchX
      mscrollView?.contentOffset = CGPoint(x: (contentOffset?.x)! - offsetX * 2.2, y: (contentOffset?.y)!)
    }

    // ****************************************************
  }

  open func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
    self.scale = scale
    zoomBlock?(scale)
  }

  open func viewForZooming(in scrollView: UIScrollView) -> UIView? {
    imageView!
  }

  // MARK: - Event response

  // 单击手势事件
  @objc func singleTapClick(_ tap: UITapGestureRecognizer) {
    if scale == 1.0 {
      back?()
    } else {
      mscrollView?.setZoomScale(minScale, animated: true)
    }
  }

  // 双击手势事件
  @objc func doubleTapClick(_ tap: UITapGestureRecognizer) {
    touchX = tap.location(in: tap.view).x
    touchY = tap.location(in: tap.view).y

    if scale > 1.0 {
      scale = 1.0
      mscrollView?.setZoomScale(scale, animated: true)
    } else {
      scale = maxScale
      isDoubleTapingForZoom = true
      mscrollView?.setZoomScale(maxScale, animated: true)
    }
    isDoubleTapingForZoom = false
  }

  // MARK: - Private methods

  private func initAllView() {
    // UIScrollView
    mscrollView = UIScrollView()
    mscrollView?.showsVerticalScrollIndicator = false
    mscrollView?.showsHorizontalScrollIndicator = false
    mscrollView?.maximumZoomScale = maxScale // scrollView最大缩放比例
    mscrollView?.minimumZoomScale = minScale // scrollView最小缩放比例
    mscrollView?.backgroundColor = UIColor.black
    mscrollView?.delegate = self
    mscrollView?.frame = bounds
    addSubview(mscrollView!)

    // 添加手势
    // 1.单击手势
    let singleTap = UITapGestureRecognizer(target: self, action: #selector(singleTapClick(_:)))
    singleTap.numberOfTapsRequired = 1
    mscrollView?.addGestureRecognizer(singleTap)
    // 2.双击手势
    let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapClick(_:)))
    doubleTap.numberOfTapsRequired = 2
    mscrollView?.addGestureRecognizer(doubleTap)
    // 必须加上这句，否则双击手势不管用
    singleTap.require(toFail: doubleTap)

    // UIImageView
    imageView = UIImageView()
    imageView?.contentMode = .scaleAspectFit
    imageView?.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight)
    mscrollView?.addSubview(imageView!)
  }

  // MARK: - Public methods

  open func show() {
    if image == nil {
      return
    }

    mscrollView?.setZoomScale(minScale, animated: false)

    imageView?.bounds = CGRect(x: 0, y: 0, width: screenWidth, height: image!.size.height / image!.size.width * screenWidth)
    imageView?.center = (mscrollView?.center)!
  }
}
