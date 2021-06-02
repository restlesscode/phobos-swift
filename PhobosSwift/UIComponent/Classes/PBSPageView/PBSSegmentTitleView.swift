//
//
//  PBSSegmentTitleView.swift
//  PhobosSwiftUIComponent
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

import PhobosSwiftCore
import UIKit

/// TitleClickHandler
public typealias TitleClickHandler = (PBSSegmentTitleView, Int) -> Void

open class PBSSegmentTitleView: UIView {
  public weak var delegate: PBSSegmentTitleViewDelegate?
  
  /// 点击标题时调用
  public var clickHandler: TitleClickHandler?
  
  /// 当前点
  public private(set) var currentIndex = 0
  
  /// Title Labels
  public private(set) lazy var titleLabels: [UILabel] = []
  
  /// 样式
  public private(set) var style: PBSSegmentViewStyle
  
  /// Segment的Titles
  public private(set) var titles: [String]
  
  private lazy var selectRGB: UIColor.RGB = self.style.titleSelectedColor.pbs.rgb
  private lazy var normalRGB: UIColor.RGB = self.style.titleColor.pbs.rgb
  private lazy var deltaRGB: UIColor.RGB = {
    let deltaR = self.selectRGB.red - self.normalRGB.red
    let deltaG = self.selectRGB.green - self.normalRGB.green
    let deltaB = self.selectRGB.blue - self.normalRGB.blue
    let deltaA = self.selectRGB.alpha - self.normalRGB.alpha
    return UIColor.RGB(red: deltaR, green: deltaG, blue: deltaB, alpha: deltaA)
  }()
  
  private lazy var scrollView: UIScrollView = {
    let scrollView = UIScrollView()
    
    scrollView.showsHorizontalScrollIndicator = false
    scrollView.scrollsToTop = false
    return scrollView
  }()
  
  private lazy var bottomLine: UIView = {
    let bottomLine = UIView()
    bottomLine.backgroundColor = self.style.bottomLineColor
    return bottomLine
  }()
  
  public lazy var coverView: UIView = {
    let coverView = UIView()
    coverView.backgroundColor = self.style.coverViewBackgroundColor
    coverView.alpha = self.style.coverViewAlpha
    return coverView
  }()
  
  public init(frame: CGRect, style: PBSSegmentViewStyle, titles: [String], currentIndex: Int = 0) {
    self.style = style
    self.titles = titles
    self.currentIndex = currentIndex
    super.init(frame: frame)
    setupUI()
    print(" selectRGB: \(selectRGB)")
    print(" normalRGB: \(normalRGB)")
    print(" deltaRGB: \(deltaRGB)")
  }
  
  @available(*, unavailable)
  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override open func layoutSubviews() {
    super.layoutSubviews()
    
    scrollView.frame = bounds
    
    setupLabelsLayout()
    setupBottomLineLayout()
    setupCoverViewLayout()
    adjustToCurrentIndex()
  }
}

// MARK: - 设置UI界面

extension PBSSegmentTitleView {
  func setupUI() {
    addSubview(scrollView)
    
    scrollView.backgroundColor = style.titleViewBackgroundColor
    
    setupTitleLabels()
    
    setupBottomLine()
    
    setupCoverView()
  }
  
  func adjustToCurrentIndex() {
    // 让targetLabel居中显示
    let targetLabel = titleLabels[currentIndex]
    adjustLabelPosition(targetLabel)
    fixUI(targetLabel)
  }
  
  private func setupTitleLabels() {
    for (i, title) in titles.enumerated() {
      let label = UILabel()
      
      label.tag = i
      label.text = title
      label.textColor = i == currentIndex ? style.titleSelectedColor : style.titleColor
      label.textAlignment = .center
      label.font = style.titleFont
      
      //            label.cobBadge.addDot()
      scrollView.addSubview(label)
      
      titleLabels.append(label)
      
      let tapGes = UITapGestureRecognizer(target: self, action: #selector(titleLabelClick(_:)))
      label.addGestureRecognizer(tapGes)
      label.isUserInteractionEnabled = true
    }
  }
  
  private func setupBottomLine() {
    guard style.isShowBottomLine else { return }
    
    scrollView.addSubview(bottomLine)
  }
  
  private func setupCoverView() {
    guard style.isShowCoverView else { return }
    
    scrollView.insertSubview(coverView, at: 0)
    
    coverView.layer.cornerRadius = style.coverViewRadius
    coverView.layer.masksToBounds = true
  }
}

// MARK: - Layout

extension PBSSegmentTitleView {
  private func setupLabelsLayout() {
    let labelH = frame.size.height
    let labelY: CGFloat = 0
    var labelW: CGFloat = 0
    var labelX: CGFloat = 0
    
    let count = titleLabels.count
    for (i, titleLabel) in titleLabels.enumerated() {
      if style.isTitleScrollEnable {
        //                labelW = (titles[i] as NSString).boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: 0),
        //                options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font : titleLabel.font], context: nil).width
        
        let scaleFactor = style.isScaleEnable ? style.maximumScaleFactor : 1.0
        labelW = titles[i].pbs.width(withConstrainedHeight: labelX, font: titleLabel.font) * scaleFactor
        labelX = i == 0 ? style.titleMargin * 0.5 : (titleLabels[i - 1].frame.maxX + style.titleMargin)
        
      } else {
        labelW = bounds.width / CGFloat(count)
        labelX = labelW * CGFloat(i)
      }
      
      titleLabel.frame = CGRect(x: labelX, y: labelY, width: labelW, height: labelH)
      //            if let titleLabelTextWidth = titleLabel.text?.cob_width(withConstrainedHeight: labelH, font: titleLabel.font) {
      //                let x = (titleLabelTextWidth - labelW)*0.5 + 8.0
      //                titleLabel.cobBadge.showBadge()
      //                titleLabel.cobBadge.moveBadge(x: x, y: 10.0)
      //            }else {
      //                titleLabel.cobBadge.hiddenBadge()
      //            }
    }
    
    if style.isScaleEnable {
      titleLabels[style.startIndex].transform = CGAffineTransform(scaleX: style.maximumScaleFactor, y: style.maximumScaleFactor)
    }
    
    if style.isTitleScrollEnable {
      guard let titleLabel = titleLabels.last else { return }
      scrollView.contentSize.width = titleLabel.frame.maxX + style.titleMargin * 0.5
    }
  }
  
  private func setupCoverViewLayout() {
    guard titleLabels.count - 1 >= currentIndex else { return }
    let label = titleLabels[currentIndex]
    var coverW = label.bounds.width
    let coverH = style.coverViewHeight
    var coverX = label.frame.origin.x
    let coverY = (label.frame.height - coverH) * 0.5
    if style.isTitleScrollEnable {
      coverX -= style.coverMargin
      coverW += 2 * style.coverMargin
    }
    coverView.frame = CGRect(x: coverX, y: coverY, width: coverW, height: coverH)
  }
  
  private func setupBottomLineLayout() {
    guard titleLabels.count - 1 >= currentIndex else { return }
    let label = titleLabels[currentIndex]
    
    bottomLine.layer.cornerRadius = style.bottomLineCornerRadius
    bottomLine.layer.masksToBounds = true
    if let bottomLineWidth = style.bottomLineWidth {
      bottomLine.frame.origin.x = label.frame.origin.x + (label.frame.width - bottomLineWidth) / 2.0
      bottomLine.frame.size.width = bottomLineWidth
    } else {
      bottomLine.frame.origin.x = label.frame.origin.x
      bottomLine.frame.size.width = label.frame.width
    }
    
    bottomLine.frame.size.height = style.bottomLineHeight
    bottomLine.frame.origin.y = bounds.height - style.bottomLineHeight - style.bottomLinePadding
  }
}

// MARK: - 监听label的点击

extension PBSSegmentTitleView {
  @objc func titleLabelClick(_ tapGes: UITapGestureRecognizer) {
    guard let targetLabel = tapGes.view as? UILabel else { return }
    
    clickHandler?(self, targetLabel.tag)
    
    if targetLabel.tag == currentIndex {
      delegate?.reloader??.titleViewDidSelectedSameTitle?()
      return
    }
    
    let sourceLabel = titleLabels[currentIndex]
    
    sourceLabel.textColor = style.titleColor
    targetLabel.textColor = style.titleSelectedColor
    
    currentIndex = targetLabel.tag
    
    adjustLabelPosition(targetLabel)
    
    delegate?.titleView(self, currentIndex: currentIndex)
    
    if style.isScaleEnable {
      UIView.animate(withDuration: 0.25, animations: {
        sourceLabel.transform = CGAffineTransform.identity
        targetLabel.transform = CGAffineTransform(scaleX: self.style.maximumScaleFactor, y: self.style.maximumScaleFactor)
      })
    }
    
    if style.isShowBottomLine {
      UIView.animate(withDuration: 0.25, animations: {
        self.bottomLine.frame.origin.x = targetLabel.frame.origin.x
        self.bottomLine.frame.size.width = self.style.bottomLineWidth ?? targetLabel.frame.width
        
        if let bottomLineWidth = self.style.bottomLineWidth {
          self.bottomLine.frame.origin.x = targetLabel.frame.origin.x + (targetLabel.frame.width - bottomLineWidth) / 2.0
          self.bottomLine.frame.size.width = bottomLineWidth
        } else {
          self.bottomLine.frame.origin.x = targetLabel.frame.origin.x
          self.bottomLine.frame.size.width = targetLabel.frame.width
        }
      })
    }
    
    if style.isShowCoverView {
      let coverX = style.isTitleScrollEnable ? (targetLabel.frame.origin.x - style.coverMargin) : targetLabel.frame.origin.x
      let coverW = style.isTitleScrollEnable ? (targetLabel.frame.width + style.coverMargin * 2) : targetLabel.frame.width
      UIView.animate(withDuration: 0.25, animations: {
        self.coverView.frame.origin.x = coverX
        self.coverView.frame.size.width = coverW
      })
    }
  }
  
  private func adjustLabelPosition(_ targetLabel: UILabel) {
    guard style.isTitleScrollEnable else { return }
    
    var offsetX = targetLabel.center.x - bounds.width * 0.5
    
    if offsetX < 0 {
      offsetX = 0
    }
    if offsetX > scrollView.contentSize.width - scrollView.bounds.width {
      offsetX = scrollView.contentSize.width - scrollView.bounds.width
    }
    
    scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
  }
}

extension PBSSegmentTitleView: PBSSegmentContentViewDelegate {
  public func contentView(_ contentView: PBSSegmentContentView, inIndex: Int) {
    currentIndex = inIndex
    
    let targetLabel = titleLabels[currentIndex]
    
    // 2.让targetLabel居中显示
    adjustLabelPosition(targetLabel)
    
    fixUI(targetLabel)
  }
  
  public func contentView(_ contentView: PBSSegmentContentView, sourceIndex: Int, targetIndex: Int, progress: CGFloat) {
    if sourceIndex > titleLabels.count - 1 || sourceIndex < 0 {
      return
    }
    if targetIndex > titleLabels.count - 1 || targetIndex < 0 {
      return
    }
    let sourceLabel = titleLabels[sourceIndex]
    let targetLabel = titleLabels[targetIndex]
    
    sourceLabel.textColor = UIColor.pbs.color(r255: selectRGB.r255 - progress * deltaRGB.r255,
                                              g255: selectRGB.g255 - progress * deltaRGB.g255,
                                              b255: selectRGB.b255 - progress * deltaRGB.b255,
                                              alpha: selectRGB.alpha - progress * deltaRGB.alpha)
    targetLabel.textColor = UIColor.pbs.color(r255: normalRGB.r255 + progress * deltaRGB.r255,
                                              g255: normalRGB.g255 + progress * deltaRGB.g255,
                                              b255: normalRGB.b255 + progress * deltaRGB.b255,
                                              alpha: normalRGB.alpha + progress * deltaRGB.alpha)
    
    if style.isScaleEnable {
      let deltaScale = style.maximumScaleFactor - 1.0
      sourceLabel.transform = CGAffineTransform(scaleX: style.maximumScaleFactor - progress * deltaScale,
                                                y: style.maximumScaleFactor - progress * deltaScale)
      targetLabel.transform = CGAffineTransform(scaleX: 1.0 + progress * deltaScale, y: 1.0 + progress * deltaScale)
    }
    
    if style.isShowBottomLine {
      if let bottomLineWidth = style.bottomLineWidth {
        let deltaX: CGFloat = targetLabel.center.x - sourceLabel.center.x
        bottomLine.frame.origin.x = sourceLabel.frame.origin.x + progress * deltaX + (sourceLabel.frame.width - bottomLineWidth) / 2.0
        bottomLine.frame.size.width = bottomLineWidth
      } else {
        let deltaX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
        let deltaW = targetLabel.frame.width - sourceLabel.frame.width
        bottomLine.frame.origin.x = sourceLabel.frame.origin.x + progress * deltaX
        bottomLine.frame.size.width = sourceLabel.frame.width + progress * deltaW
      }
    }
    
    if style.isShowCoverView {
      let deltaX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
      let deltaW = targetLabel.frame.width - sourceLabel.frame.width
      coverView.frame.size.width = style.isTitleScrollEnable ?
        (sourceLabel.frame.width + 2 * style.coverMargin + deltaW * progress) : (sourceLabel.frame.width + deltaW * progress)
      coverView.frame.origin.x = style.isTitleScrollEnable ?
        (sourceLabel.frame.origin.x - style.coverMargin + deltaX * progress) : (sourceLabel.frame.origin.x + deltaX * progress)
    }
  }
  
  private func fixUI(_ targetLabel: UILabel) {
    UIView.animate(withDuration: 0.05) {
      targetLabel.textColor = self.style.titleSelectedColor
      
      if self.style.isScaleEnable {
        targetLabel.transform = CGAffineTransform(scaleX: self.style.maximumScaleFactor, y: self.style.maximumScaleFactor)
      }
      
      if self.style.isShowBottomLine {
        if let bottomLineWidth = self.style.bottomLineWidth {
          self.bottomLine.frame.origin.x = targetLabel.frame.origin.x + (targetLabel.frame.width - bottomLineWidth) / 2.0
          self.bottomLine.frame.size.width = bottomLineWidth
        } else {
          self.bottomLine.frame.origin.x = targetLabel.frame.origin.x
          self.bottomLine.frame.size.width = targetLabel.frame.width
        }
      }
      
      if self.style.isShowCoverView {
        self.coverView.frame.size.width = self.style.isTitleScrollEnable ?
          (targetLabel.frame.width + 2 * self.style.coverMargin) : targetLabel.frame.width
        self.coverView.frame.origin.x = self.style.isTitleScrollEnable ?
          (targetLabel.frame.origin.x - self.style.coverMargin) : targetLabel.frame.origin.x
      }
    }
  }
}
