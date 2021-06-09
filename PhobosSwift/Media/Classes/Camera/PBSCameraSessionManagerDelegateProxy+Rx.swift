//
//
//  PBSCameraSessionManagerDelegateProxy+Rx.swift
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
import RxCocoa
import RxSwift

public class RxPBSCameraSessionManagerDelegateProxy: DelegateProxy<PBSCameraSessionManager, PBSCameraSessionManagerDelegate>, DelegateProxyType {
  /// Typed parent object.
  public private(set) weak var sessionManager: PBSCameraSessionManager?

  /// - parameter textview: Parent object for delegate proxy.
  public init(sessionManager: PBSCameraSessionManager) {
    self.sessionManager = sessionManager
    super.init(parentObject: sessionManager, delegateProxy: RxPBSCameraSessionManagerDelegateProxy.self)
  }

  public static func currentDelegate(for object: PBSCameraSessionManager) -> PBSCameraSessionManagerDelegate? {
    object.delegate
  }

  public static func setCurrentDelegate(_ delegate: PBSCameraSessionManagerDelegate?, to object: PBSCameraSessionManager) {
    object.delegate = delegate
  }

  public static func registerKnownImplementations() {
    register { RxPBSCameraSessionManagerDelegateProxy(sessionManager: $0) }
  }

  internal private(set) var didFinishProcessingPhotoBufferPublishSubject = PublishSubject<PBSDidFinishProcessingPhotoBufferParam>()

  @available(iOS 11.0, *)
  internal private(set) lazy var didFinishProcessingPhotoPublishSubject = PublishSubject<DidFinishProcessingPhotoParam>()

  internal private(set) var didOutputMetadataObjectsPublishSubject = PublishSubject<DidOutputMetadataObjectsParam>()
}

// MARK: AVCapturePhotoCaptureDelegate

extension RxPBSCameraSessionManagerDelegateProxy: PBSCameraSessionManagerDelegate {
  ///
  public func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
    let param = DidOutputMetadataObjectsParam(output: output, metadataObjects: metadataObjects, connection: connection)

    didOutputMetadataObjectsPublishSubject.onNext(param)

    _forwardToDelegate?.metadataOutput(output, didOutput: metadataObjects, from: connection)
  }

  ///
  @available(iOS 11.0, *)
  public func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
    let param = DidFinishProcessingPhotoParam(output: output, photo: photo, error: error)

    didFinishProcessingPhotoPublishSubject.onNext(param)

    _forwardToDelegate?.photoOutput(output, didFinishProcessingPhoto: photo, error: error)
  }

  /// For more information take a look at `DelegateProxyType`.
  public func photoOutput(_ captureOutput: AVCapturePhotoOutput,
                          didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?,
                          previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?,
                          resolvedSettings: AVCaptureResolvedPhotoSettings,
                          bracketSettings: AVCaptureBracketedStillImageSettings?,
                          error: Error?) {
    let param = PBSDidFinishProcessingPhotoBufferParam(captureOutput: captureOutput,
                                                       photoSampleBuffer: photoSampleBuffer,
                                                       previewPhotoSampleBuffer: previewPhotoSampleBuffer,
                                                       resolvedSettings: resolvedSettings,
                                                       bracketSettings: bracketSettings,
                                                       error: error)

    didFinishProcessingPhotoBufferPublishSubject.onNext(param)

    _forwardToDelegate?.photoOutput(captureOutput,
                                    didFinishProcessingPhoto: photoSampleBuffer,
                                    previewPhoto: previewPhotoSampleBuffer,
                                    resolvedSettings: resolvedSettings,
                                    bracketSettings: bracketSettings,
                                    error: error)
  }
}
