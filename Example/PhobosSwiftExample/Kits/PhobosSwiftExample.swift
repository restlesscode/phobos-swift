//
//
//  PhobosSwiftExample.swift
//  PhobosSwiftExample
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
import UIKit

struct PhobosSwiftExample {
  struct Constants {
    static let kTestGADBannerViewAdUnitID = "ca-app-pub-3940256099942544/2934735716"
    static let kTestGADRewardedAdUnitID = "ca-app-pub-3940256099942544/1712485313"
    static let kTestGADIntersitialAdUnitID = "ca-app-pub-3940256099942544/4411468910"
    static let kTestGADAppOpenAdUnitID = "ca-app-pub-3940256099942544/5662855259"
    static let kTestGADNativeAdUnitID = "ca-app-pub-3940256099942544/3986624511"
    static let kTestGADNativeAdVideoUnitID = "ca-app-pub-3940256099942544/2521693316"
  }

  struct Color {
    static let kBlackgroudColorSet = [UIColor.black, UIColor.pbs.color(R: 36, G: 41, B: 43)]
    static let kBlackgroudColorTuple = (UIColor.black, UIColor.pbs.color(R: 36, G: 41, B: 43))
  }
}

extension String {
  /// # "2016-04-14T10:44:00+0000" to Date
  var pbs_iso8601Date: Date? {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    let date = dateFormatter.date(from: self)
    return date
  }
}
