//
//
//  ImageBrowerImageZoomView.swift
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

protocol ImageBrowerImageZoomViewDelegate: AnyObject {
  func zoomViewDidBeginMoveImage(zoomView: ImageBrowerImageZoomView)
  func zoomViewDidEndMoveImage(zoomView: ImageBrowerImageZoomView)
}

class ImageBrowerImageZoomView: UIScrollView {
  var image: UIImage? {
    didSet {
      imageView.image = image
    }
  }

  lazy var imageView: UIImageView = {
    let imageView = UIImageView(frame: bounds)
    imageView.isUserInteractionEnabled = true

    return imageView
  }()

  weak var zoomViewDelegate: ImageBrowerImageZoomViewDelegate!
  var isMoving: Bool {
    if !isDecelerating && !isZooming && !isZoomBouncing && !isDragging {
      return true
    } else {
      return false
    }
  }

  /*
   // Only override draw() if you perform custom drawing.
   // An empty implementation adversely affects performance during animation.
   override func draw(_ rect: CGRect) {
       // Drawing code
   }
   */
  override init(frame: CGRect) {
    super.init(frame: frame)
    delegate = self
    clipsToBounds = false
    if #available(iOS 11.0, *) {
      contentInsetAdjustmentBehavior = .never
    } else {
      // Fallback on earlier versions
    }
    maximumZoomScale = 3
    minimumZoomScale = 1
    showsVerticalScrollIndicator = false
    showsHorizontalScrollIndicator = false
    setupUI()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  //  Converted to Swift 5 by Swiftify v5.0.40498 - https://objectivec2swift.com/
  // 超出bounce范围，依然可以触发事件
  override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
    var inside = super.point(inside: point, with: event)
    if imageView.frame.contains(point) {
      inside = true
    }
    return inside
  }

  // MARK: - UI

  func setupUI() {
    addSubview(imageView)
  }
}

extension ImageBrowerImageZoomView: UIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {}

  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    if !isMoving {
      zoomViewDelegate?.zoomViewDidBeginMoveImage(zoomView: self)
    }
  }

  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    if !decelerate {
      if isMoving {
        zoomViewDelegate?.zoomViewDidEndMoveImage(zoomView: self)
      }
    }
  }

  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    if isMoving {
      zoomViewDelegate?.zoomViewDidEndMoveImage(zoomView: self)
    }
  }

  // 返回缩放视图
  func viewForZooming(in scrollView: UIScrollView) -> UIView? {
    imageView
  }

  // 开始缩放
  func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
    if !isMoving {
      zoomViewDelegate?.zoomViewDidBeginMoveImage(zoomView: self)
    }
  }

  func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
    if isMoving {
      zoomViewDelegate?.zoomViewDidEndMoveImage(zoomView: self)
    }
  }

  // 缩放中
  func scrollViewDidZoom(_ scrollView: UIScrollView) {
    if scrollView.isZooming || scrollView.isZoomBouncing {
      // 延中心点缩放
      let rect = scrollView.frame.applying(scrollView.transform)
      let offsetX = (rect.size.width > scrollView.contentSize.width) ? ((rect.size.width - scrollView.contentSize.width) * 0.5) : 0.0
      let offsetY = (rect.size.height > scrollView.contentSize.height) ? ((rect.size.height - scrollView.contentSize.height) * 0.5) : 0.0
      imageView.center = CGPoint(x: scrollView.contentSize.width * 0.5 + offsetX, y: scrollView.contentSize.height * 0.5 + offsetY)
    }
  }
}
