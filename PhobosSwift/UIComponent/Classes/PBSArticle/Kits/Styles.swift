//
//
//  Styles.swift
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

struct Styles {
  struct Font {
    static var sectionTitle = UIFont.systemFont(ofSize: 28.0, weight: .black)
    static var sectionSubtitle = UIFont.systemFont(ofSize: 14.0, weight: .semibold)
    static var sectionFooterTitle = UIFont.systemFont(ofSize: 12.0, weight: .semibold)
    static var articleTag = UIFont.systemFont(ofSize: 14.0)
    static var articleTagS = UIFont.systemFont(ofSize: 14.0, weight: .semibold)
    static var articleLargeTitle = UIFont.systemFont(ofSize: 24.0, weight: .semibold)
    static var articleTitle = UIFont.systemFont(ofSize: 17.0, weight: .semibold)
    static var articleMediumTitle = UIFont.systemFont(ofSize: 14.0, weight: .regular)
    static var articleSmallTitle = UIFont.systemFont(ofSize: 12.0, weight: .regular)
    static var moreActionTitle = UIFont.systemFont(ofSize: 14.0, weight: .black)
    static var moreActionTitleX = UIFont.systemFont(ofSize: 12.0, weight: .semibold)
  }
  
  struct Color {
    static var sectionTitleGreen = UIColor.pbs.color(hex: 0x5CC08C)
    static var sectionTitleRed = UIColor.pbs.color(R: 222, G: 21, B: 18)
    static var sectionTitleCherry = UIColor.pbs.color(R: 255, G: 46, B: 85)
    static var sectionTitleYellow = UIColor.pbs.color(R: 255, G: 142, B: 1)
    static var sectionTitleGold = UIColor.pbs.color(R: 169, G: 150, B: 89)
    static var sectionTitleOrange = UIColor.pbs.color(R: 255, G: 173, B: 0)
    static var sectionTitleBrown = UIColor.pbs.color(R: 166, G: 134, B: 120)
    static var sectionTitleIndigo = UIColor.pbs.color(R: 8, G: 181, B: 204)
    static var sectionTitleBlue = UIColor.pbs.color(R: 52, G: 84, B: 147)
    static var sectionTitlePurple = UIColor.pbs.color(R: 105, G: 86, B: 179)
    static var sectionTitleBlack = UIColor.black
    
    static var sectionSubtitleGray = UIColor.pbs.color(hex: 0x8A8A8E)
    static var articleTagGreen = UIColor.pbs.color(hex: 0x5CC08C)
    static var articleTitleBlack: UIColor {
      if #available(iOS 13.0, *) {
        return UIColor.systemBackground.pbs.inverseColor
      } else {
        return UIColor.black
      }
    }
    
    static var articleTitleGray = UIColor.pbs.color(hex: 0x87878B)
    static var articleSeporatorGray = UIColor.pbs.color(hex: 0xD0D3D6)
  }
}
