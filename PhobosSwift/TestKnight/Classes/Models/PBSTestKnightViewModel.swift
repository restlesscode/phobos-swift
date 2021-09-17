//
//
//  PBSTestKnightViewModel.swift
//  PhobosSwiftTestKnight
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

extension PBSTestKnight {
  public enum Configuration {
    ///
    case debug
    ///
    case staging
    ///
    case preproduction
    ///
    case release
    ///
    public var name: String {
      switch self {
      case .debug:
        return Strings.kDebug
      case .staging:
        return Strings.kStaging
      case .preproduction:
        return Strings.kPreproduction
      case .release:
        return Strings.kRelease
      }
    }

    ///
    public var description: String {
      switch self {
      case .debug:
        return Strings.kDebugDescription
      case .staging:
        return Strings.kStagingDescription
      case .preproduction:
        return Strings.kPreproductionDescription
      case .release:
        return Strings.kReleaseDescription
      }
    }
  }
}

struct PBSTestKnightModel {
  var type: PBSTestKnight.Configuration = .debug
  var title: String
  var description: String
  var icon: UIImage
}

struct PBSTestKnightViewModel {
  var configuration = BehaviorRelay<PBSTestKnight.Configuration>(value: .release)
  var title = BehaviorRelay<String>(value: "")
  var description = BehaviorRelay<String>(value: "")
  var icon = BehaviorRelay<UIImage?>(value: nil)

  init(model: PBSTestKnightModel) {
    configuration.accept(model.type)
    title.accept(model.title)
    description.accept(model.description)
    icon.accept(model.icon)
  }
}
