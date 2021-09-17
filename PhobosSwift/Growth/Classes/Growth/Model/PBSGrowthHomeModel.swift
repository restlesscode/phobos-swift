//
//
//  PBSGrowthHomeModel.swift
//  PBSGrowthHomeModel
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

enum PBSGrowthHomeSectionType {
  case head(itemSizeHeight: CGFloat)
  case topics(title: String, itemSizeHeight: CGFloat)
  case support(title: String, itemSizeHeight: CGFloat)
  case contact(title: String, itemSizeHeight: CGFloat)

  func headHeight() -> CGFloat {
    switch self {
    case .head:
      return 0
    default:
      return 33
    }
  }

  func hasMoreButton() -> Bool {
    switch self {
    case .topics:
      return true
    default:
      return false
    }
  }
}

struct PBSGrowthHomeItemModel {
  enum ImageType {
    case webImage(url: URL? = nil)
    case localImage(name: String? = nil)
    case systemImage(name: String? = nil)
  }

  enum ItemType {
    case email
    case chat
    case custom
  }

  let imageType: ImageType
  let title: String
  let subTitle: String
  let itemType: ItemType
}

struct PBSGrowthHomeSectionModel {
  let type: PBSGrowthHomeSectionType
  let containerViewModels: [PBSGrowthHomeContainerViewModel]
}
