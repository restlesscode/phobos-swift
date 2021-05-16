//
//
//  CocoaMQTT+Rx.swift
//  PhobosSwiftNetwork
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
import PhobosSwiftCore
import RxCocoa
import RxSwift

extension Reactive where Base: CocoaMQTT {
  /// DelegateProxy for CocoaMQTTDelegate
  public var delegate: DelegateProxy<CocoaMQTT, CocoaMQTTDelegate> {
    RxCocoaMQTTDelegateProxy.proxy(for: base)
  }

  /// Reactive wrapper for delegate method `didConnectAck`
  public var didConnectAck: CocoaMQTTEvent<CocoaMQTTConnAck> {
    let source = RxCocoaMQTTDelegateProxy.proxy(for: base).connAckPublishSubject
    return CocoaMQTTEvent(events: source)
  }

  /// Reactive wrapper for delegate method `didReceiveMessage`
  public var didReceiveMessage: CocoaMQTTEvent<(CocoaMQTTMessage, UInt16)> {
    let source = RxCocoaMQTTDelegateProxy.proxy(for: base).receiveMessagePublishSubject
    return CocoaMQTTEvent(events: source)
  }

  /// Reactive wrapper for delegate method `didStateChangeTo`
  public var didStateChangeTo: CocoaMQTTEvent<CocoaMQTTConnState> {
    let source = RxCocoaMQTTDelegateProxy.proxy(for: base).stateChangeToPublishSubject
    return CocoaMQTTEvent(events: source)
  }

  /// Reactive wrapper for delegate method `didPublishMessage`
  public var didPublishMessage: CocoaMQTTEvent<CocoaMQTTMessage> {
    let source = RxCocoaMQTTDelegateProxy.proxy(for: base).publishMessagePublishSubject
    return CocoaMQTTEvent(events: source)
  }

  /// Reactive wrapper for delegate method `didSubscribeTopic`
  public var didSubscribeTopics: CocoaMQTTEvent<[String]> {
    let source = RxCocoaMQTTDelegateProxy.proxy(for: base).subscribeTopicsPublishSubject
    return CocoaMQTTEvent(events: source)
  }

  /// Reactive wrapper for delegate method `didUnsubscribeTopic`
  public var didUnsubscribeTopic: CocoaMQTTEvent<String> {
    let source = RxCocoaMQTTDelegateProxy.proxy(for: base).unsubscribeTopicPublishSubject
    return CocoaMQTTEvent(events: source)
  }

  /// Installs delegate as forwarding delegate on `delegate`.
  /// Delegate won't be retained.
  ///
  /// It enables using normal delegate mechanism with reactive delegate mechanism.
  ///
  /// - parameter delegate: Delegate object.
  /// - returns: Disposable object that can be used to unbind the delegate.
  public func setDelegate(_ delegate: CocoaMQTTDelegate)
    -> Disposable {
    RxCocoaMQTTDelegateProxy.installForwardDelegate(delegate, retainDelegate: false, onProxyForObject: base)
  }
}
