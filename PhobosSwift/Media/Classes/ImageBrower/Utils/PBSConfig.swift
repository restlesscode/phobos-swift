//
//
//  PBSConfig.swift
//  PhobosSwiftMedia
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

/// UIScreen.main.bounds.width
public let ScreenWidth: CGFloat = {
  UIScreen.main.bounds.width
}()

/// UIScreen.main.bounds.height
public let ScreenHeight: CGFloat = {
  UIScreen.main.bounds.height
}()

/// The default bottom space
public let bottomSpace: CGFloat = {
  if BottomSafeAreaHeight == 0 {
    return 20
  } else {
    return BottomSafeAreaHeight
  }
}()

public let baseBundle: Bundle = {
  let podBundle = Bundle(for: PBSConfig.self)
  let bundleURL = podBundle.url(forResource: "\(PhobosSwiftMedia.self)", withExtension: "bundle")
  return Bundle(url: bundleURL!)!
}()

/// The navigationBarHeight
public let NavigationBarHeight: CGFloat = {
  if iphoneXSeries.contains([ScreenWidth, ScreenHeight]) {
    return 88
  } else {
    return 64
  }
}()

/// The status view height
public let StatusHeight: CGFloat = {
  if iphoneXSeries.contains([ScreenWidth, ScreenHeight]) {
    return 44
  } else {
    return 20
  }
}()

/// The tabbafr height
public let TabBarHeight: CGFloat = {
  if iphoneXSeries.contains([ScreenWidth, ScreenHeight]) {
    return 83
  } else {
    return 49
  }
}()

/// The safe area height at bottom
public let BottomSafeAreaHeight: CGFloat = {
  if iphoneXSeries.contains([ScreenWidth, ScreenHeight]) {
    return 34
  } else {
    return 0
  }
}()

public let iphoneXSeries: [[CGFloat]] = {
  [// iphone .X .XS
    [375, 812],
    // iphone .XS Max .XR 11
    [414, 896],
    // iphone 12 mini
    [360, 780],
    // iphone 12 12pro
    [390, 844],
    // iphone 12 pro max
    [428, 926]]
}()

public class PBSConfig {}

extension Bundle {
  /// get image
  /// - Parameter name: image name
  /// - Returns: uiimage
  public func image(withName name: String) -> UIImage? {
    UIImage(named: name, in: self, compatibleWith: nil)
  }
}
