//
//
//  PBSGrowthHomeViewModel.swift
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
import SwiftUI

struct PBSGrowthHomeContainerViewModel {
  let data: PBSGrowthHomeItemModel
  let itemHeight: Float
  let itemWidth: Float
}

struct PBSGrowthHomeViewModel {
  var sections: [PBSGrowthHomeSectionModel] = []
  public func numberOfItems(section: Int) -> Int {
    1
  }

  mutating func mockData() {
    sections.removeAll()
    var type = PBSGrowthHomeSectionType.head(itemSizeHeight: 228)
    if true {
      if case let .head(itemSizeHeight) = type {
        let m = PBSGrowthHomeItemModel(imageType: .webImage(url: nil),
                                       title: "Suggestions for Improvement",
                                       subTitle: "Help us provide event better services and user experiences for you.",
                                       itemType: .custom)
        let model = PBSGrowthHomeContainerViewModel(data: m,
                                                    itemHeight: Float(itemSizeHeight),
                                                    itemWidth: Float(UIScreen.main.bounds.width - 40))
        self.sections.append(PBSGrowthHomeSectionModel(type: type, containerViewModels: [model, model, model]))
      }
    }

    if true {
      type = .topics(title: "Topics", itemSizeHeight: 336)
      if case .topics = type {
        let m = PBSGrowthHomeItemModel(imageType: .webImage(url: nil),
                                       title: "How do you think about our app icon",
                                       subTitle: "We work hard to make our app icon more attractable, tell us your opion. ",
                                       itemType: .custom)
        let model = PBSGrowthHomeContainerViewModel(data: m,
                                                    itemHeight: 112,
                                                    itemWidth: Float(UIScreen.main.bounds.width - 40))
        self.sections.append(PBSGrowthHomeSectionModel(type: type, containerViewModels: [model, model, model]))
      }
    }

    if true {
      type = .support(title: "Support for Services", itemSizeHeight: 108)
      if case let .support(_, itemSizeHeight) = type {
        let m = PBSGrowthHomeItemModel(imageType: .webImage(url: nil),
                                       title: "XXX three year’s subsrciption ",
                                       subTitle: "Help us provide event better services and user experiences for you.",
                                       itemType: .custom)
        let model = PBSGrowthHomeContainerViewModel(data: m,
                                                    itemHeight: Float(itemSizeHeight),
                                                    itemWidth: 180)
        self.sections.append(PBSGrowthHomeSectionModel(type: type, containerViewModels: [model, model, model]))
      }
    }

    if true {
      type = .contact(title: "Contact", itemSizeHeight: 64)

      if case let .contact(_, itemSizeHeight) = type {
        var containerViewModels: [PBSGrowthHomeContainerViewModel] = []
        var model = PBSGrowthHomeContainerViewModel(data: PBSGrowthHomeItemModel(imageType: .systemImage(name: "envelope.fill"),
                                                                                 title: "Mail",
                                                                                 subTitle: "",
                                                                                 itemType: .email),
                                                    itemHeight: Float(itemSizeHeight),
                                                    itemWidth: 180)

        containerViewModels.append(model)

//        model = PBSGrowthHomeContainerViewModel(data: PBSGrowthHomeItemModel(imageType: .systemImage(name: "message.fill"),
//                                                                             title: "Chat",
//                                                                             subTitle: "",
//                                                                             itemType: .chat),
//                                                itemHeight: Float(itemSizeHeight),
//                                                itemWidth: 180)
//
//        containerViewModels.append(model)

        model = PBSGrowthHomeContainerViewModel(data: PBSGrowthHomeItemModel(imageType: .systemImage(name: "briefcase.fill"),
                                                                             title: "Briefcase",
                                                                             subTitle: "",
                                                                             itemType: .custom),
                                                itemHeight: Float(itemSizeHeight),
                                                itemWidth: 180)

        containerViewModels.append(model)

        self.sections.append(PBSGrowthHomeSectionModel(type: type, containerViewModels: containerViewModels))
      }
    }
  }
}
