//
//
//  PBSArticleViewModel.swift
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
import UIKit

/// Standard ViewModel for Article
public struct PBSArticleViewModel {
  /// Article title
  public var title = BehaviorRelay<String>(value: "")
  /// Article subtitle
  public var subtitle = BehaviorRelay<String>(value: "")
  /// Article tag
  public var tag = BehaviorRelay<String>(value: "")
  /// Article time
  public var time = BehaviorRelay<String>(value: "")
  /// Article timestamp
  public var timestamp = BehaviorRelay<Int?>(value: nil)
  /// Article cover image url
  public var coverImageUrl = BehaviorRelay<URL?>(value: nil)
  /// Article url
  public var url = BehaviorRelay<URL?>(value: nil)
  /// Article body
  public var body = BehaviorRelay<String?>(value: nil)

  ///
  public init(model: PBSArticleModel) {
    title.accept(model.title)
    subtitle.accept(model.subtitle)
    tag.accept(model.tag)
    time.accept(model.time)
    timestamp.accept(model.timestamp)
    coverImageUrl.accept(model.coverImageUrl)
    url.accept(model.url)
    body.accept(model.body)
  }
}

extension PBSArticleViewModel {
  static let kTitle = "In this tutorial, you’ll get hands-on experience with UICollectionView by creating your own grid-based photo browsing app."

  static var demoViewModel: PBSArticleViewModel {
    let model = PBSArticleModel(title: kTitle,
                                subtitle: "您感兴趣的文章可能都在这里，我们根据您的浏览行为和选择做出推荐",
                                tag: "Apple News",
                                time: "3h ago",
                                timestamp: nil,
                                coverImageUrl: nil,
                                url: nil,
                                body: nil)
    return PBSArticleViewModel(model: model)
  }
}
