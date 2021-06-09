//
//
//  ImageBrowerEditorAddTextVC.swift
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
import IQKeyboardManagerSwift
import UIKit

struct ImageBrowerEditorText {
  var id: Int = 0
  var font: UIFont!
  var color: UIColor!
  var text: String = ""
  var hasBackground: Bool = false
  var backGroundColor: UIColor!
}

class ImageBrowerEditorAddTextVC: PBSImageBrower.BaseViewController {
  var asset: ImageBrowerAsset!
  var oldEditorText: ImageBrowerEditorText?
  var editorBlock: ((ImageBrowerEditorText) -> Void)?
  override var preferredStatusBarStyle: UIStatusBarStyle {
    .lightContent
  }

  private lazy var imageView: UIImageView = {
    let imageView = UIImageView(frame: view.frame)
    let blurFilter = BlurFilter(blurRadius: 10)
    imageView.image = asset.origin?.af.imageFiltered(withCoreImageFilter: blurFilter.filterName,
                                                     parameters: blurFilter.parameters)
    imageView.contentMode = .scaleAspectFit
    imageView.clipsToBounds = true
    let coverView = UIView()
    coverView.frame = CGRect(origin: .zero, size: imageView.frame.size)
    coverView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
    imageView.addSubview(coverView)
    return imageView
  }()

  private let maxCount = 100
  private let font = UIFont.boldSystemFont(ofSize: 22)
  private lazy var textView: UITextView = {
    let textView = UITextView(frame: CGRect(x: 25, y: NavigationBarHeight + 60, width: ScreenWidth - 50, height: ScreenHeight / 2))
    textView.tintColor = PBSImageBrower.Color.blue
    textView.font = font
    textView.backgroundColor = UIColor.clear
    textView.textColor = PBSImageBrower.Color.blue
    textView.delegate = self
    textView.textContainer.lineFragmentPadding = 0
    textView.textContainerInset = .zero
    return textView
  }()

  private lazy var cancelButton: UIButton = {
    let button = UIButton(frame: CGRect(x: 0, y: StatusHeight, width: 60, height: 44))
    button.setTitle(PBSImageBrowerStrings.cancel, for: .normal)
    button.setTitleColor(UIColor.white, for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
    button.addTarget(self, action: #selector(self.back), for: .touchUpInside)

    return button
  }()

  private lazy var doneButton: UIButton = {
    let doneButton = UIButton(frame: CGRect(x: ScreenWidth - 75, y: StatusHeight + 6, width: 57, height: 32))
    doneButton.setBackgroundImage(UIImage.pbs.makeImage(from: PBSImageBrower.Color.blue), for: .normal)
    doneButton.setTitle(PBSImageBrowerStrings.sure, for: .normal)
    doneButton.setTitleColor(UIColor.white, for: .normal)
    doneButton.addTarget(self, action: #selector(self.done), for: .touchUpInside)
    doneButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
    doneButton.pbs.corner(radii: 5)

    return doneButton
  }()

  private lazy var colorsView: ImageBrowerEditorColorSelectView = {
    let view = ImageBrowerEditorColorSelectView(frame: CGRect(x: 0, y: colorsViewDefaultY, width: ScreenWidth, height: 50), type: .text)
    view.block = { [weak self] color in
      self?.changeSelectColor(color)
    }
    view.isBackgroundBlock = { [weak self] isSelected in
      self?.changeTextBackground(isSelected)
    }
    return view
  }()

  private let colorsViewDefaultY = ScreenHeight - 50 - BottomSafeAreaHeight

  private var showTextBackground: Bool = false
  private var nowSelectedColor: UIColor = PBSImageBrower.Color.blue
  private lazy var textBackgroundView: UIView = {
    let x = textView.frame.origin.x - 10
    let y = textView.frame.origin.y - 10
    let view = UIView(frame: CGRect(x: x, y: y, width: 0, height: 0))
    view.layer.cornerRadius = 8
    return view
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.black
    guard asset != nil else { return }
    view.addSubview(imageView)
    view.addSubview(textBackgroundView)
    view.addSubview(textView)
    view.addSubview(cancelButton)
    view.addSubview(doneButton)
    view.addSubview(colorsView)
    registerNotification()

    if let editorText = oldEditorText {
      textView.text = editorText.text
      if editorText.hasBackground {
        changeSelectColor(editorText.backGroundColor)
      } else {
        changeSelectColor(editorText.color)
      }

      changeTextBackground(editorText.hasBackground)
      colorsView.setCurrentColor(editorText.color)
      colorsView.isBackgroundBtn.isSelected = editorText.hasBackground
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

  @objc func done() {
    guard textView.text != "" else {
      showMessage(PBSImageBrowerStrings.pleaseInputText)
      return
    }

    var editorText = ImageBrowerEditorText()
    editorText.id = oldEditorText?.id ?? Int(Date().timeIntervalSince1970)
    editorText.font = font
    editorText.hasBackground = showTextBackground
    editorText.text = textView.text
    if showTextBackground {
      editorText.backGroundColor = nowSelectedColor
      editorText.color = nowSelectedColor == UIColor.white ? PBSImageBrower.Color.blue : UIColor.white
    } else {
      editorText.color = nowSelectedColor
      editorText.backGroundColor = UIColor.white
    }
    editorBlock?(editorText)

    back()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    IQKeyboardManager.shared.enable = false
    IQKeyboardManager.shared.enableAutoToolbar = false

    textView.becomeFirstResponder()
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    IQKeyboardManager.shared.enable = true
    IQKeyboardManager.shared.enableAutoToolbar = true
  }

  deinit {
    NotificationCenter.default.removeObserver(self)
  }
}

extension ImageBrowerEditorAddTextVC {
  func changeSelectColor(_ color: UIColor) {
    nowSelectedColor = color
    changeTextViewColor()

    if showTextBackground {
      changeBackgroundColor()
    }
  }

  func changeTextBackground(_ change: Bool) {
    showTextBackground = change
    textBackgroundView.isHidden = !change

    if change {
      changeBackgroundColor()
      changeBackgroundSize()
    }
    changeTextViewColor()
  }

  func changeTextViewColor() {
    if showTextBackground {
      if nowSelectedColor == UIColor.white {
        textView.textColor = PBSImageBrower.Color.blue
      } else {
        textView.textColor = UIColor.white
      }

    } else {
      textView.textColor = nowSelectedColor
    }
  }

  func changeBackgroundColor() {
    textBackgroundView.backgroundColor = nowSelectedColor
  }

  func changeBackgroundSize() {
    let text = textView.text ?? ""
    let beginning = textView.beginningOfDocument
    guard let start = textView.position(from: beginning, offset: 0) else { return }
    guard let end = textView.position(from: start, offset: text.count) else { return }
    guard let range = textView.textRange(from: start, to: end) else { return }
    let rects = textView.selectionRects(for: range)
    var rect = CGRect.zero
    for thisSelRect in rects {
      // if it's the first one, just set the return rect
      if thisSelRect == rects.first {
        rect = thisSelRect.rect
      } else {
        // ignore selection rects with a width of Zero
        if thisSelRect.rect.size.width > 0 {
          // we only care about the top (the minimum origin.y) and the
          // sum of the heights
          rect.origin.y = min(rect.origin.y, thisSelRect.rect.origin.y)
          rect.size.height += thisSelRect.rect.size.height
        }
      }
    }

//        textBackgroundView.frame.size = CGSize(width: rect.size.width + 20, height: rect.size.height + 20)
    let resultWidth = rect.width + 20

    let resultSize = CGSize(width: resultWidth, height: rect.height + 20)
    textBackgroundView.frame.size = resultSize
  }
}

extension ImageBrowerEditorAddTextVC: UITextViewDelegate {
  func registerNotification() {
    NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)

    NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
  }

  @objc func keyBoardWillShow(_ notification: Notification) {
    guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
//        guard colorsView.frame.origin.y == colorsViewDefaultY else { return }
//
    UIView.animate(withDuration: 0.2) {
      self.colorsView.frame.origin.y = self.colorsViewDefaultY - keyboardSize.height + BottomSafeAreaHeight
    }
  }

  @objc func keyBoardWillHide(_ notification: Notification) {
    UIView.animate(withDuration: 0.2) {
      self.colorsView.frame.origin.y = self.colorsViewDefaultY
    }
  }

  func textViewDidChange(_ textView: UITextView) {
    let text = textView.text ?? ""

    if text.count > maxCount {
      textView.text = String(text.prefix(maxCount))
    }

    if showTextBackground {
      changeBackgroundSize()
    }
  }
}
