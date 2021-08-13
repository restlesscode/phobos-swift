//
//
//  PBSGrowthFeedbackViewModel.swift
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

import Foundation
import RxCocoa
import RxSwift

class PBSGrowthFeedbackViewModel {
  struct MediaImageModel {
    let image: UIImage
    let imageData: Data
  }

  var dataCount: Int {
    datas.count
  }

  var hasData: Bool {
    dataCount > 0
  }

  var textPublishSubject = PublishSubject<String>()
  var addMedia = PublishSubject<MediaImageModel>()
  var removeMedia = PublishSubject<Int>()
  var updateData = PublishSubject<Bool>()
  private var datas: [MediaImageModel] = []
  private let disposeBag = DisposeBag()
  init() {
    _ = addMedia
      .asObserver()
      .subscribe { [weak self] event in
        guard let self = self else { return }
        if case let .next(value) = event {
          self.datas.append(value)
          self.updateData.onNext(self.hasData)
        }
      }
      .disposed(by: disposeBag)

    _ = removeMedia
      .asObserver()
      .subscribe { [weak self] event in
        guard let self = self else { return }
        if case let .next(value) = event, value < self.dataCount, value >= 0 {
          self.datas.remove(at: value)
          self.updateData.onNext(self.hasData)
        }
      }
      .disposed(by: disposeBag)
  }

  func imageModel(at index: Int) -> MediaImageModel? {
    (index < datas.count) ? datas[index] : nil
  }
}
