//
//
//  PBSNativeAdDelegate.swift
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

import Foundation

///
@objc public protocol PBSNativeAdLoaderDelegate {
  ///
  func adLoaderDidFailToReceiveAdWithError(_ error: Error)
  ///
  @objc optional func adLoaderDidFinishLoading()
  ///
  func adLoaderDidReceive(_ nativeAd: PBSNativeAd)
}

///
@objc public protocol PBSNativeAdDelegate {
  ///
  func nativeAdDidRecordImpression(_ nativeAd: PBSNativeAd)
  ///
  func nativeAdDidRecordClick(_ nativeAd: PBSNativeAd)
  ///
  func nativeAdWillPresentScreen(_ nativeAd: PBSNativeAd)
  ///
  func nativeAdWillDismissScreen(_ nativeAd: PBSNativeAd)
  ///
  func nativeAdDidDismissScreen(_ nativeAd: PBSNativeAd)
  ///
  func nativeAdIsMuted(_ nativeAd: PBSNativeAd)
}
