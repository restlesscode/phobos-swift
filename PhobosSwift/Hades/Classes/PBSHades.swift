//
//
//  PBSHades.swift
//  PhobosSwiftHades
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

import GoogleMobileAds
import PhobosSwiftLog

/// PBSHades
public class PBSHades: NSObject {
  /// PBSAdProvider
  public enum PBSAdProvider {
    ///
    case google
    ///
    case baidu
    ///
    case facebook
    ///
    case tencent
    ///
    case twitter
  }

  ///
  public static let shared = PBSHades()

  override private init() {
    super.init()
  }

  /// add Ad configuration
  public static func configuration(adProviders: [PBSAdProvider]) {
    guard !adProviders.isEmpty else {
      fatalError("Ad provider should not be empty")
    }

    PBSLogger.logger.debug(message: "Google Mobile Ads SDK version: \(GADMobileAds.sharedInstance().sdkVersion)")

    if adProviders.contains(.google) {
      // Initialize Google Mobile Ads SDK
      GADMobileAds.sharedInstance().start(completionHandler: nil)
      // use sample device id for simulators
//     GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = ["058548c9e87505f2788186e0642ca839" ] // Sample device ID
    }
  }
}
