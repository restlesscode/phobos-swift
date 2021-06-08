//
//
//  AppleNewsFormatModel.swift
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

import PhobosSwiftCore
import UIKit

enum ANFAnchorPosition: String, Codable {
  case center
}

struct ANFAnchor: Codable {
  let targetAnchorPosition: ANFAnchorPosition
  let originAnchorPosition: ANFAnchorPosition
}

struct ANFStyle: Codable {
  let type: String
  let url: String
  let fillMode: String

  enum CodingKeys: String, CodingKey {
    case type
    case url = "URL"
    case fillMode
  }
}

struct ANFLayout: Codable {
  let columnStart: Int
  let columnSpan: Int
}

enum ANFLayoutType: Codable {
  /// 某个Layout的类型
  case some(String)
  /// 具体的Layoutt
  case detail(ANFLayout)

  init(from decoder: Decoder) throws {
    do {
      let container = try decoder.singleValueContainer()
      let layoutName = try container.decode(String.self)
      self = .some(layoutName)
    } catch {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      let columnStart = try container.decode(Int.self, forKey: .columnStart)
      let columnSpan = try container.decode(Int.self, forKey: .columnSpan)
      let layout = ANFLayout(columnStart: columnStart, columnSpan: columnSpan)
      self = .detail(layout)
    }

    DispatchQueue.global().async {}

    DispatchQueue.global(qos: .background).async {}
  }

  func encode(to encoder: Encoder) throws {
    switch self {
    case let .some(layoutName):
      var container = encoder.singleValueContainer()
      try container.encode(layoutName)
    case let .detail(layout):
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(layout.columnStart, forKey: .columnStart)
      try container.encode(layout.columnSpan, forKey: .columnSpan)
    }
  }

  private enum CodingKeys: String, CodingKey {
    case columnStart
    case columnSpan
  }
}

struct ANFComponent: Codable {
  let role: String
  let layout: ANFLayoutType
}

struct AppleNewsFormatModel: Codable {
  let version: String
  let identifier: String
  let title: String
  let language: String
  let subtitle: String

  let components: [ANFComponent]

  static var demoModel: AppleNewsFormatModel? {
    demoStr.pbs_model(modelType: AppleNewsFormatModel.self)
  }
}

let demoStr = """
{
  "version": "1.0",
  "identifier": "Apple_Demo",
  "title": "Example News Article",
  "subtitle": "Example News Article Subtitle",
  "language": "en",
  "layout": {
    "columns": 20,
    "width": 1024,
    "margin": 80,
    "gutter": 40
  },
  "metadata": {
    "datePublished": "2015-10-24T11:15:00+00:00",
    "dateCreated": "2015-10-24T11:15:00+00:00",
    "dateModified": "2015-10-24T11:15:00+00:00",
    "authors": [
      "Urna Semper"
    ],
    "generatorName": "Generator",
    "generatorVersion": "1.0",
    "thumbnailURL": "https://developer.apple.com/news-publisher/download/Apple-News-Example-Articles/images/Shanghai01.jpg",
    "canonicalURL": "http://www.apple.com",
    "keywords": [
      "China",
      "Business",
      "Industry",
      "Culture"
    ],
    "excerpt": "How To Succeed In Shanghai (And Have Some Fun, Too)"
  },
  "documentStyle": {
    "backgroundColor": "#f6f6f6"
  },
  "components": [
    {
      "role": "container",
      "layout": "headerContainerLayout",
      "style": {
        "fill": {
          "type": "image",
          "URL": "https://developer.apple.com/news-publisher/download/Apple-News-Example-Articles/images/Shanghai01.jpg",
          "fillMode": "cover"
        }
      }
    },
    {
      "role": "caption",
      "text": "Shanghai's skyline featuring the landmark Oriental Pearl TV Tower.   PHOTO: L. ELLIS",
      "layout": "captionLayout",
      "textStyle": "captionStyle",
      "anchor": {
        "targetAnchorPosition": "center",
        "originAnchorPosition": "center"
      }
    },
    {
      "role": "divider",
      "layout": {
        "columnStart": 0,
        "columnSpan": 20
      },
      "stroke": {
        "color": "#85888D",
        "width": 1
      }
    },
    {
      "role": "title",
      "text": "How To Succeed In Shanghai (And Have Some Fun, Too)",
      "layout": "titleLayout",
      "textStyle": "titleStyle"
    },
    {
      "role": "byline",
      "text": "by Paul Gaita  |  May 14, 2015  |  11:15 AM",
      "layout": "bylineLayout",
      "textStyle": "bylineStyle"
    },
    {
      "role": "body",
      "format": "html",
      "text": "<p>A<span data-anf-textstyle='bodySpanStyle'>ttention business owners</span> seeking international expansion: Shanghai wants to make a deal with you. The venerable port city—China’s largest by population, with more than 24 million residents as of 2014—is the commercial and financial center of the country, and one of the fastest developing cities in the world. The total GDP of Shanghai has grown to 2.35 trillion yuan, or US $384 billion, in 2014, and continues to grow at a rate of 7% per year. Since the early 1990s, Shanghai has sought to establish itself as a leading global hub for financial services, and it’s achieved that goal through a solid base of industries, including manufacturing (which accounted for 39.9 % of its GDP in 2011) and technology, support from China’s central government, and decades of financial reform. Foreign investment in Shanghai is welcomed with open arms: the establishment of the China (Shanghai) Pilot Free-Trade Zone in 2013, which established an array of economic and social reforms to attract international businesses, brought in more than 1,000 foreign-funded projects worth US $5.4 billion in the first half of 2014 alone.</p>",
      "layout": "bodyLayout",
      "textStyle": "dropcapBodyStyle"
    },
    {
      "identifier": "wrap1Text",
      "role": "body",
      "format": "html",
      "text": "<p>But deciding to invest in a booming financial sector like Shanghai and actually carrying out that business plan are two very different scenarios. As international investors have noted for decades, the Chinese way of conducting business is substantially different from Western methods, and requires sensitivity to the country’s practices and policies. Before opening an office in Shanghai, investors are advised to examine China’s five-year plan, which details the country’s social and economic goals and specifies which industries will receive greater focus to achieve greater financial growth. Drafting your own five-year plan that details your company’s objectives will make government approval for your business more attainable, and establish connections with valuable local resources like the <strong>U.S. Commercial Service</strong> or <strong>U.S.-China Business Council</strong> to help you navigate the often dizzying array of local, provincial, and national government officials that are necessary to getting your business approved.</p><p>Be sure to register a trademark for any intellectual property with the Chinese government. Trademarks established in the U.S. do not always remain your property once you cross Chinese borders; in fact, trademarks are usually granted to the first person to register it, regardless of whether that individual actually owns the product or property in question. And do your research when considering a bank; it’s best to find one with a corresponding relationship to the United States to simplify transactions. Consider and develop a digital presence for promotional purposes instead of traditional outlets like newspapers, television, and/or billboards. Online stores are utilized to a greater degree than brick-and-mortar locations, and advertising through social media platforms or other web sites will allow for greater impact with less physical expansion.</p>",
      "layout": "bodyLayout",
      "textStyle": "bodyStyle"
    },
    {
      "role": "body",
      "text": "As international investors have noted for decades, the Chinese way of conducting business is substantially different from Western methods.",
      "layout": "pullquoteWrapLayout",
      "textStyle": "pullquoteWrapStyle",
      "animation": {
        "type": "fade_in",
        "userControllable": true,
        "initialAlpha": 0.0
      },
      "anchor": {
        "targetComponentIdentifier": "wrap1Text",
        "targetAnchorPosition": "center",
        "rangeStart": 1300,
        "rangeLength": 1
      }
    },
    {
      "role": "gallery",
      "items": [
        {
          "URL": "https://developer.apple.com/news-publisher/download/Apple-News-Example-Articles/images/Shanghai02.jpg",
          "caption": "Moonrising over Beijing on Changan Ave.   PHOTO: L. ZHAN"
        },
        {
          "URL": "https://developer.apple.com/news-publisher/download/Apple-News-Example-Articles/images/Shanghai03.jpg",
          "caption": "View of Oriental Pearl TV Tower, Shanghai on The Bund.   PHOTO: A. HUNG"
        },
        {
          "URL": "https://developer.apple.com/news-publisher/download/Apple-News-Example-Articles/images/Shanghai04.jpg",
          "caption": "Shanghai on The Bund.   PHOTO: L. ZHAN"
        }
      ],
      "layout": "galleryLayout"
    },
    {
      "role": "body",
      "format": "html",
      "text": "<p>Most important of all: be conscious of customs in regard to meetings and hiring practices. There are a host of social etiquette values in Chinese culture that also carry weight in business interactions. Punctuality and formality are highly valued, while senior representatives require a greater degree of ceremony and respect, especially during introductions. Indirectness is also a significant element of any business transaction: to be respectful, avoid lengthy direct eye contact and too-firm handshakes, and refrain from asking direct questions. A firm <i>“no”</i> from a Shanghai business representative is less likely than a polite statement of careful consideration.</p><p>Delicacy and tact is also important when hiring staff, especially management. Contracts and employee manuals that detail every aspect of the business and expectations of certain positions are a must-have. Also, when considering a potential employee, weigh the value of their experience over their language skills. The ability to communicate effectively with staff and management is important, but the skills to properly run your business from overseas are far more crucial for your success in the Chinese market.</p><p>At the close of the business day, visitors to Shanghai should also avail themselves of the city’s many attractions. First-timers should pay a visit to The Bund, the city’s lively waterfront and the subject of countless skyline photographs. Shanghai’s most impressive modern architecture, including the Oriental Pearl Tower and Shanghai World Financial Center, can be viewed from across the Huangpu River, while the riverbank itself features shopping and restaurants.</p><p>Nearby is Nanjing Road, the city’s sprawling shopping district with a wealth of international retailers. The Venetian-inspired Zhujiajiao, with its picturesque canals and bridges, is a short taxi ride from downtown Shanghai. For cultural sights, explore the five-acre, 16th century Yuyuan Garden or Longhua Temple, Shanghai’s oldest and largest place of worship. The Shanghai Museum, too, deserves exploring; its unique architecture contains priceless items and artifacts from all eras in Chinese history. More modern wonders include the Shanghai Maglev, one of the fastest passenger trains in the world, with a peak speed of 270 miles an hour. The twin wonders of the Shanghai skyline are the Shanghai World Financial Center—one of the world’s tallest standing structures at 1,555 feet—and the ornate and immediately identifiable Oriental Pearl Tower, which offers a revolving restaurant, 15 observatory levels, and the Space Module, an observation deck that provides one of the best birds’-eye views of Shanghai’s magnificent design.</p>",
      "layout": "bodyLayout",
      "textStyle": "bodyStyle"
    },
    {
      "role": "figure",
      "URL": "https://developer.apple.com/news-publisher/download/Apple-News-Example-Articles/images/economy01.png",
      "layout": "bodyImageLayout",
      "animation": {
        "type": "fade_in",
        "userControllable": true,
        "initialAlpha": 0.0
      }
    },
    {
      "role": "body",
      "text": "Economies are ranked on their ease of doing business, from 1-189. A high ranking means the regulatory environment is more conducive to the startup and operation of a local firm. The rankings are determined by sorting the aggregate distance to frontier scores on 10 topics, each consisting of several indicators, giving equal weight to each topic. The rankings for all economies are benchmarked to June 2014.As this graphic from the World Bank Group indicates, China is gaining on its chief rival, Singapore, as the dominant economic center of Greater China. China, through its largest financial center in Shanghai, has been able to offer to outsiders a wealth of incentives through the Shanghai Free-Trade Zone. These include reduced financial requirements and simplified procedures for establishing a company in China, unrestricted currency exchange (including a 10-year tax-free period), and a list of amenities that includes medical service, telecommunications, ocean freight and international shipping management and banking.",
      "layout": "bodyLayout",
      "textStyle": "bodyStyle"
    }
  ],
  "textStyles": {
    "bodySpanStyle": {
      "fontName": "AvenirNext-Bold",
      "textColor": "#000"
    }
  },
  "componentTextStyles": {
    "default-title": {
      "fontName": "HelveticaNeue-Thin",
      "fontSize": 36,
      "textColor": "#2F2F2F",
      "textAlignment": "center",
      "lineHeight": 44
    },
    "default-subtitle": {
      "fontName": "HelveticaNeue-Thin",
      "fontSize": 20,
      "textColor": "#2F2F2F",
      "textAlignment": "center",
      "lineHeight": 24
    },
    "titleStyle": {
      "textAlignment": "left",
      "fontName": "Georgia-Bold",
      "fontSize": 52,
      "lineHeight": 52,
      "textColor": "#000"
    },
    "bylineStyle": {
      "textAlignment": "left",
      "fontName": "AvenirNext-Medium",
      "fontSize": 16,
      "textColor": "#53585F"
    },
    "dropcapBodyStyle": {
      "textAlignment": "left",
      "fontName": "AvenirNext-Regular",
      "fontSize": 16,
      "lineHeight": 24,
      "textColor": "#000",
      "dropCapStyle": {
        "numberOfLines": 2,
        "numberOfCharacters": 1,
        "fontName": "Georgia-Bold",
        "textColor": "#000"
      }
    },
    "bodyStyle": {
      "textAlignment": "left",
      "fontName": "AvenirNext-Regular",
      "fontSize": 16,
      "lineHeight": 24,
      "textColor": "#000"
    },
    "captionStyle": {
      "textAlignment": "left",
      "fontName": "AvenirNext-Medium",
      "fontSize": 14,
      "lineHeight": 17,
      "textColor": "#53585F"
    },
    "pullquoteWrapStyle": {
      "textAlignment": "left",
      "fontName": "Georgia-Bold",
      "fontSize": 34,
      "lineHeight": 38,
      "textColor": "#263236"
    }
  },
  "componentLayouts": {
    "headerContainerLayout": {
      "columnStart": 0,
      "columnSpan": 20,
      "ignoreDocumentMargin": true,
      "minimumHeight": "50vh"
    },
    "titleLayout": {
      "columnStart": 0,
      "columnSpan": 20,
      "margin": {
        "top": 30,
        "bottom": 10
      }
    },
    "bylineLayout": {
      "columnStart": 0,
      "columnSpan": 20,
      "margin": {
        "top": 15,
        "bottom": 30
      }
    },
    "bodyLayout": {
      "columnStart": 3,
      "columnSpan": 19,
      "margin": {
        "top": 15,
        "bottom": 15
      }
    },
    "captionLayout": {
      "columnStart": 0,
      "columnSpan": 20,
      "margin": {
        "top": 15,
        "bottom": 15
      }
    },
    "galleryLayout": {
      "columnStart": 0,
      "columnSpan": 20,
      "margin": {
        "top": 25,
        "bottom": 25
      }
    },
    "bodyImageLayout": {
      "columnStart": 0,
      "columnSpan": 20,
      "margin": {
        "top": 15,
        "bottom": 15
      }
    },
    "pullquoteWrapLayout": {
      "columnStart": 0,
      "columnSpan": 12,
      "margin": {
        "top": 25,
        "bottom": 15
      }
    }
  }
}
"""
