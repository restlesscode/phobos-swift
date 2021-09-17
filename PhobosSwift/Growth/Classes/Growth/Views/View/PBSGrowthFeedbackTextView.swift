//
//
//  PBSGrowthFeedbackTextView.swift
//  PhobosSwiftGrowth
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

class PBSGrowthFeedbackTextView: UIView {
  let titleLabel = UILabel()
  let bottomLine = UIView()
  let textView = UITextView()
  override init(frame: CGRect) {
    super.init(frame: frame)

    addSubview(titleLabel)
    addSubview(textView)
    addSubview(bottomLine)

    titleLabel.text = "Summary"
    titleLabel.textColor = .white
    titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)

    textView.tintColor = .white
    textView.limitLength = 200
    textView.placeholdColor = .pbs.color(R: 142, G: 142, B: 147)
    textView.placeholdFont = .systemFont(ofSize: 16, weight: .regular)
    textView.placeholder = "Please leave your message to us."
    textView.limitLabelColor = .pbs.color(R: 158, G: 158, B: 167)
    textView.limitLabelFont = .systemFont(ofSize: 14, weight: .regular)
    textView.font = .systemFont(ofSize: 16, weight: .regular)
    textView.backgroundColor = .clear
    textView.contentInset = .zero
    if let wordCountLabel = textView.wordCountLabel {
      wordCountLabel.removeFromSuperview()
      wordCountLabel.textAlignment = .right
      addSubview(wordCountLabel)
      wordCountLabel.snp.makeConstraints { make in
        make.right.equalToSuperview().offset(-20)
        make.centerY.equalTo(titleLabel.snp.centerY)
        make.height.equalTo(20)
      }
    }

    bottomLine.backgroundColor = .pbs.color(R: 255, G: 255, B: 255, alpha: 0.15)

    titleLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(11)
      make.left.equalToSuperview().offset(20)
      make.height.equalTo(33)
    }

    textView.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(55)
      make.left.equalToSuperview().offset(15)
      make.right.equalToSuperview().offset(-15)
      make.bottom.equalTo(bottomLine.snp.top).offset(-10)
    }

    bottomLine.snp.makeConstraints { make in
      make.left.equalTo(titleLabel.snp.left)
      make.right.bottom.equalToSuperview()
      make.height.equalTo(1 / UIScreen.main.scale)
    }
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension UITextView {
  fileprivate struct RuntimeKey {
    static let placeholder: UnsafeRawPointer! = UnsafeRawPointer(bitPattern: "PLACEHOLDEL".hashValue)
    static let limitLength: UnsafeRawPointer! = UnsafeRawPointer(bitPattern: "LIMITLENGTH".hashValue)
    static let limitLines: UnsafeRawPointer! = UnsafeRawPointer(bitPattern: "LIMITLINES".hashValue)
    static let placeholderLabel: UnsafeRawPointer! = UnsafeRawPointer(bitPattern: "PLACEHOLDELABEL".hashValue)
    static let wordCountLabel: UnsafeRawPointer! = UnsafeRawPointer(bitPattern: "WORDCOUNTLABEL".hashValue)
    static let placeholdFont: UnsafeRawPointer! = UnsafeRawPointer(bitPattern: "PLACEHOLDFONT".hashValue)
    static let placeholdColor: UnsafeRawPointer! = UnsafeRawPointer(bitPattern: "PLACEHOLDCOLOR".hashValue)
    static let limitLabelFont: UnsafeRawPointer! = UnsafeRawPointer(bitPattern: "LIMITLABELFONT".hashValue)
    static let limitLabelColor: UnsafeRawPointer! = UnsafeRawPointer(bitPattern: "LIMITLABLECOLOR".hashValue)
    static let autoHeight: UnsafeRawPointer! = UnsafeRawPointer(bitPattern: "AUTOHEIGHT".hashValue)
    static let oldFrame: UnsafeRawPointer! = UnsafeRawPointer(bitPattern: "LODFRAME".hashValue)
  }

  var placeholder: String? { // 占位符
    get {
      objc_getAssociatedObject(self, UITextView.RuntimeKey.placeholder) as? String
    }
    set {
      objc_setAssociatedObject(self, UITextView.RuntimeKey.placeholder, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
      initPlaceholder(placeholder!)
    }
  }

  var limitLength: NSNumber? { // 限制的字数
    get {
      objc_getAssociatedObject(self, UITextView.RuntimeKey.limitLength) as? NSNumber
    }
    set {
      objc_setAssociatedObject(self, UITextView.RuntimeKey.limitLength, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
      initWordCountLabel(limitLength!)
    }
  }

  var limitLines: NSNumber? { // 限制的行数
    get {
      objc_getAssociatedObject(self, UITextView.RuntimeKey.limitLines) as? NSNumber
    }
    set {
      objc_setAssociatedObject(self, UITextView.RuntimeKey.limitLines, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
      NotificationCenter.default.addObserver(self, selector: #selector(limitLengthEvent), name: UITextView.textDidChangeNotification, object: self)
    }
  }

  var placeholderLabel: UILabel? {
    get {
      objc_getAssociatedObject(self, UITextView.RuntimeKey.placeholderLabel) as? UILabel
    }
    set {
      objc_setAssociatedObject(self, UITextView.RuntimeKey.placeholderLabel, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
  }

  var wordCountLabel: UILabel? {
    get {
      objc_getAssociatedObject(self, UITextView.RuntimeKey.wordCountLabel) as? UILabel
    }
    set {
      objc_setAssociatedObject(self, UITextView.RuntimeKey.wordCountLabel, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
  }

  var placeholdFont: UIFont? {
    get {
      objc_getAssociatedObject(self, UITextView.RuntimeKey.placeholdFont) as? UIFont == nil ?
        UIFont.systemFont(ofSize: 13) : objc_getAssociatedObject(self, UITextView.RuntimeKey.placeholdFont) as? UIFont
    }
    set {
      objc_setAssociatedObject(self, UITextView.RuntimeKey.placeholdFont, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
      if placeholderLabel != nil {
        placeholderLabel?.font = placeholdFont
      }
    }
  }

  var limitLabelFont: UIFont? {
    get {
      objc_getAssociatedObject(self, UITextView.RuntimeKey.limitLabelFont) as? UIFont == nil ?
        UIFont.systemFont(ofSize: 13) : objc_getAssociatedObject(self, UITextView.RuntimeKey.limitLabelFont) as? UIFont
    }
    set {
      objc_setAssociatedObject(self, UITextView.RuntimeKey.limitLabelFont, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
      if wordCountLabel != nil {
        wordCountLabel?.font = limitLabelFont
      }
    }
  }

  var placeholdColor: UIColor? {
    get {
      objc_getAssociatedObject(self, UITextView.RuntimeKey.placeholdColor) as? UIColor == nil ?
        UIColor.lightGray : objc_getAssociatedObject(self, UITextView.RuntimeKey.placeholdColor) as? UIColor
    }
    set {
      objc_setAssociatedObject(self, UITextView.RuntimeKey.placeholdColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
      if placeholderLabel != nil {
        placeholderLabel?.textColor = placeholdColor
      }
    }
  }

  var limitLabelColor: UIColor? {
    get {
      objc_getAssociatedObject(self, UITextView.RuntimeKey.limitLabelColor) as? UIColor == nil ?
        UIColor.lightGray : objc_getAssociatedObject(self, UITextView.RuntimeKey.limitLabelColor) as? UIColor
    }
    set {
      objc_setAssociatedObject(self, UITextView.RuntimeKey.limitLabelColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
      if wordCountLabel != nil {
        wordCountLabel?.textColor = limitLabelColor
      }
    }
  }

  var oldFrame: CGRect? {
    get {
      objc_getAssociatedObject(self, UITextView.RuntimeKey.oldFrame) as? CGRect
    }
    set {
      objc_setAssociatedObject(self, UITextView.RuntimeKey.oldFrame, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
  }

  var autoHeight: Bool? {
    get {
      objc_getAssociatedObject(self, UITextView.RuntimeKey.autoHeight) as? Bool
    }
    set {
      objc_setAssociatedObject(self, UITextView.RuntimeKey.autoHeight, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
  }

  /*
   *  占位符
   */
  private func initPlaceholder(_ placeholder: String) {
    NotificationCenter.default.addObserver(self, selector: #selector(textChange(_:)), name: UITextView.textDidChangeNotification, object: self)
    placeholderLabel = UILabel()
    placeholderLabel?.font = placeholdFont
    placeholderLabel?.text = placeholder
    placeholderLabel?.numberOfLines = 0
    placeholderLabel?.lineBreakMode = .byWordWrapping
    placeholderLabel?.textColor = placeholdColor
    let rect = placeholder.boundingRect(with: CGSize(width: frame.size.width - 14, height: CGFloat(MAXFLOAT)),
                                        options: .usesLineFragmentOrigin,
                                        attributes: [NSAttributedString.Key.font: placeholdFont!],
                                        context: nil)
    placeholderLabel?.frame = CGRect(x: 7, y: 7, width: rect.size.width, height: rect.size.height)
    addSubview(placeholderLabel!)
    placeholderLabel?.isHidden = !text.isEmpty
  }

  /*
   *  字数限制
   */
  private func initWordCountLabel(_ limitLength: NSNumber) {
    NotificationCenter.default.addObserver(self, selector: #selector(limitLengthEvent), name: UITextView.textDidChangeNotification, object: self)
    if wordCountLabel != nil {
      wordCountLabel?.removeFromSuperview()
    }
    wordCountLabel = UILabel(frame: CGRect(x: 0, y: frame.size.height - 20, width: frame.size.width - 10, height: 20))
    wordCountLabel?.textAlignment = .right
    wordCountLabel?.textColor = limitLabelColor
    wordCountLabel?.font = limitLabelFont
    if text.count > limitLength.intValue {
      text = (text as NSString).substring(to: limitLength.intValue)
    }
    wordCountLabel?.text = "\(text.count) / \(limitLength)"
    addSubview(wordCountLabel!)
    contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
  }

  /*
   *  动态监听
   */
  @objc private func textChange(_ notification: Notification) {
    if placeholder != nil {
      placeholderLabel?.isHidden = true
      if text.isEmpty {
        placeholderLabel?.isHidden = false
      }
    }
    if limitLength != nil {
      var wordCount = text.count
      if wordCount > (limitLength?.intValue)! {
        wordCount = (limitLength?.intValue)!
      }
      let limit = limitLength!.stringValue
      wordCountLabel?.text = "\(wordCount)/\(limit)"
    }
    if autoHeight == true && oldFrame != nil {
      let size = getStringPlaceSize(text, textFont: font!)
      UIView.animate(withDuration: 0.15) {
        self.frame = CGRect(x: (self.oldFrame?.origin.x)!,
                            y: (self.oldFrame?.origin.y)!,
                            width: (self.oldFrame?.size.width)!,
                            height: size.height + 25 <= (self.oldFrame?.size.height)! ? (self.oldFrame?.size.height)! : size.height + 25)
      }
    }
  }

  @objc private func limitLengthEvent() {
    if limitLength != nil {
      guard markedTextRange != nil else {
        if text.count > (limitLength?.intValue)! && limitLength != nil {
          text = String(text.prefix(limitLength!.intValue))
        }
        return
      }
    } else {
      if limitLines != nil { // 行数限制
        let size = getStringPlaceSize(text, textFont: font!)
        let height = font!.lineHeight * CGFloat(limitLines!.floatValue)
        if size.height > height {
          text = (text as NSString).substring(to: text.count - 1)
        }
      }
    }
  }

  @objc private func getStringPlaceSize(_ string: String, textFont: UIFont) -> CGSize {
    /// 计算文本高度
    let attribute = [NSAttributedString.Key.font: textFont]
    let options = NSStringDrawingOptions.usesLineFragmentOrigin
    let size = string.boundingRect(with: CGSize(width: contentSize.width - 10,
                                                height: CGFloat.greatestFiniteMagnitude),
                                   options: options,
                                   attributes: attribute,
                                   context: nil).size
    return size
  }

  override open func layoutSubviews() {
    super.layoutSubviews()
    if limitLength != nil && wordCountLabel != nil {
      /*
       *  避免外部使用了约束 这里再次更新frame
       */
      wordCountLabel!.frame = CGRect(x: 0, y: frame.height - 20 + contentOffset.y, width: frame.width - 10, height: 20)
    }
    if placeholder != nil && placeholderLabel != nil {
      let rect: CGRect = placeholder!.boundingRect(with: CGSize(width: frame.width - 7,
                                                                height: CGFloat.greatestFiniteMagnitude),
                                                   options: .usesLineFragmentOrigin,
                                                   attributes: [NSAttributedString.Key.font: placeholdFont ?? UIFont.systemFont(ofSize: 13.0)],
                                                   context: nil)
      placeholderLabel!.frame = CGRect(x: 7, y: 7, width: rect.size.width, height: rect.size.height)
    }
    if autoHeight == true {
      oldFrame = frame
      isScrollEnabled = false
    } else {
      isScrollEnabled = true
    }
  }
}
