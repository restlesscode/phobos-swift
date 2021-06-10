//
//
//  PBSParams.swift
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

import AVFoundation
import Foundation

/// # photoOutput(
/// #     _ captureOutput: AVCapturePhotoOutput,
/// #     didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?,
/// #     previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?,
/// #     resolvedSettings: AVCaptureResolvedPhotoSettings,
/// #     bracketSettings: AVCaptureBracketedStillImageSettings?,
/// #     error: Error?)
/// # 的参数的结构体
public struct PBSDidFinishProcessingPhotoBufferParam {
  ///
  public private(set) var captureOutput: AVCapturePhotoOutput
  ///
  public private(set) var photoSampleBuffer: CMSampleBuffer?
  ///
  public private(set) var previewPhotoSampleBuffer: CMSampleBuffer?
  ///
  public private(set) var resolvedSettings: AVCaptureResolvedPhotoSettings
  ///
  public private(set) var bracketSettings: AVCaptureBracketedStillImageSettings?
  ///
  public private(set) var error: Error?
}

///
@available(iOS 11.0, *)
public struct DidFinishProcessingPhotoParam {
  ///
  public private(set) var output: AVCapturePhotoOutput
  ///
  public private(set) var photo: AVCapturePhoto?
  ///
  public private(set) var error: Error?
}

/// # metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection)
/// # 的参数的结构体
public struct DidOutputMetadataObjectsParam {
  ///
  public private(set) var output: AVCaptureMetadataOutput
  ///
  public private(set) var metadataObjects: [AVMetadataObject]
  ///
  public private(set) var connection: AVCaptureConnection
}
