//
//
//  PBSArticleSectionViewModel.swift
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

/// The standard ViewModel for Article Section
///
public struct PBSArticleSectionViewModel {
  /// Section Title
  public var title = BehaviorRelay<String>(value: "")
  /// Section Subtitle
  public var subtitle = BehaviorRelay<String>(value: "")
  /// Section's article list
  public var articleViewModels: [PBSArticleViewModel] = []
  
  ///
  public init(title: String,
              subtitle: String,
              articleViewModels: [PBSArticleViewModel]) {
    self.title.accept(title)
    self.subtitle.accept(subtitle)
    self.articleViewModels = articleViewModels
  }
}

extension PBSArticleSectionViewModel {
  static func demoViewModel(numberOfArticles: Int) -> PBSArticleSectionViewModel {
    let articleViewModels = (0..<numberOfArticles).compactMap { _ in
      PBSArticleViewModel.demoViewModel
    }
    
    return PBSArticleSectionViewModel(title: "For You",
                                      subtitle: "您感兴趣的文章可能都在这里，我们根据您的浏览行为和选择做出推荐",
                                      articleViewModels: articleViewModels)
  }
}
