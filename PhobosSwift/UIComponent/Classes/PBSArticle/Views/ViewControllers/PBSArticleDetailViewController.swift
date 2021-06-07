//
//
//  PBSArticleDetailViewController.swift
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

import RxCocoa
import RxSwift
import SnapKit
import UIKit
import WebKit

open class PBSArticleDetailViewController: UIViewController {
  let disposeBag = DisposeBag()

  let layout = UICollectionViewFlowLayout()

  let layoutManager = NSLayoutManager()

  lazy var colletionView: UICollectionView = {
    let _collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    view.addSubview(_collectionView)
    _collectionView.backgroundColor = .white

    return _collectionView
  }()

  lazy var textView: UITextView = {
    let _textView = UITextView(frame: .zero, textContainer: nil)
    view.addSubview(_textView)

    return _textView
  }()

  lazy var webView: WKWebView = {
    let configuration = WKWebViewConfiguration()
    let _webView = WKWebView(frame: .zero, configuration: configuration)
    view.addSubview(_webView)

    return _webView
  }()

  var articleViewModel: PBSArticleViewModel!

  let textStorage = PBSGhostHtmlTextStorage()

  override open func viewDidLoad() {
    super.viewDidLoad()
    makeSubviews()
    view.backgroundColor = UIColor.pbs.systemBackground
    textView.isEditable = false

    let url = URL(fileURLWithPath: "article_template.html", relativeTo: Bundle.bundle.resourceURL)
    if let data = try? Data(contentsOf: url) {
      if let htmlTemplate = String(data: data, encoding: .utf8) {
        let cssContent = ["\(loadWebResource(fileName: "screen.css") ?? "")",
                          "\(loadWebResource(fileName: "prism-okaidia.min.css") ?? "")"].joined(separator: "\nre")

        let jsContent = ["\(loadWebResource(fileName: "prism.min.js") ?? "")"].joined(separator: "\nre")
        let body = String(format: htmlTemplate,
                          cssContent,
                          articleViewModel.coverImageUrl.value?.absoluteString ?? "",
                          articleViewModel.title.value,
                          articleViewModel.body.value ?? "",
                          jsContent)
        webView.loadHTMLString(body, baseURL: nil)
        webView.uiDelegate = self
      }
    }
  }

  func loadWebResource(fileName: String) -> String? {
    let url = URL(fileURLWithPath: fileName, relativeTo: Bundle.bundle.resourceURL)
    guard let data = try? Data(contentsOf: url) else { return nil }

    return String(data: data, encoding: .utf8)
  }

  func makeSubviews() {
    webView.snp.makeConstraints {
      $0.left.right.equalTo(0)
      $0.bottom.equalTo(0)
      $0.top.equalTo(self.topLayoutGuide.snp.bottom)
    }
  }
}

extension PBSArticleDetailViewController: WKUIDelegate {}
