//
//
//  PBSCameraSessionManager+Rx.swift
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

extension Reactive where Base: PBSCameraSessionManager {
  /// DelegateProxy for AVCapturePhotoCaptureDelegate
  public var delegate: DelegateProxy<PBSCameraSessionManager, PBSCameraSessionManagerDelegate> {
    RxPBSCameraSessionManagerDelegateProxy.proxy(for: base)
  }

  /// Reactive wrapper for delegate method `didFinishProcessingPhotoBuffer`
  public var didFinishProcessingPhotoBuffer: ControlEvent<PBSDidFinishProcessingPhotoBufferParam> {
    let source = RxPBSCameraSessionManagerDelegateProxy.proxy(for: base).didFinishProcessingPhotoBufferPublishSubject
    return ControlEvent(events: source)
  }

  /// Reactive wrapper for delegate method `didFinishProcessingPhoto`
  @available(iOS 11.0, *)
  public var didFinishProcessingPhoto: ControlEvent<DidFinishProcessingPhotoParam> {
    let source = RxPBSCameraSessionManagerDelegateProxy.proxy(for: base).didFinishProcessingPhotoPublishSubject
    return ControlEvent(events: source)
  }

  /// Reactive wrapper for delegate method `didOutputMetadataObjects`
  public var didOutputMetadataObjects: ControlEvent<DidOutputMetadataObjectsParam> {
    let source = RxPBSCameraSessionManagerDelegateProxy.proxy(for: base).didOutputMetadataObjectsPublishSubject
    return ControlEvent(events: source)
  }

  /// Installs delegate as forwarding delegate on `delegate`.
  /// Delegate won't be retained.
  ///
  /// It enables using normal delegate mechanism with reactive delegate mechanism.
  ///
  /// - parameter delegate: Delegate object.
  /// - returns: Disposable object that can be used to unbind the delegate.
  public func setDelegate(_ delegate: PBSCameraSessionManagerDelegate)
    -> Disposable {
    RxPBSCameraSessionManagerDelegateProxy.installForwardDelegate(delegate, retainDelegate: false, onProxyForObject: base)
  }
}
