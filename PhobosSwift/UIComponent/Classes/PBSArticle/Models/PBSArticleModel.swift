//
//
//  PBSArticleModel.swift
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

import UIKit

public struct PBSArticleModel: Codable {
  var title: String
  var subtitle: String
  var tag: String
  var time: String
  var timestamp: Int?
  var coverImageUrl: URL?
  var url: URL?
  var body: String?

  public init(title: String,
              subtitle: String,
              tag: String,
              time: String,
              timestamp: Int?,
              coverImageUrl: URL?,
              url: URL?,
              body: String?) {
    self.title = title
    self.subtitle = subtitle
    self.tag = tag
    self.time = time
    self.timestamp = timestamp
    self.coverImageUrl = coverImageUrl
    self.url = url
    self.body = body
  }
}
