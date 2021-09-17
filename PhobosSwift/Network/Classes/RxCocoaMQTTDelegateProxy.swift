//
//
//  RxCocoaMQTTDelegateProxy.swift
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
import PhobosSwiftLog
import RxCocoa
import RxSwift

public class RxCocoaMQTTDelegateProxy: DelegateProxy<CocoaMQTT, CocoaMQTTDelegate>, DelegateProxyType {
  /// Typed parent object.
  public private(set) weak var mqtt: CocoaMQTT?

  /// - parameter textview: Parent object for delegate proxy.
  public init(mqtt: CocoaMQTT) {
    self.mqtt = mqtt
    super.init(parentObject: mqtt, delegateProxy: RxCocoaMQTTDelegateProxy.self)
  }

  public static func currentDelegate(for object: CocoaMQTT) -> CocoaMQTTDelegate? {
    object.delegate
  }

  public static func setCurrentDelegate(_ delegate: CocoaMQTTDelegate?, to object: CocoaMQTT) {
    object.delegate = delegate
  }

  public static func registerKnownImplementations() {
    register { RxCocoaMQTTDelegateProxy(mqtt: $0) }
  }

  internal private(set) var connAckPublishSubject = PublishSubject<CocoaMQTTConnAck>()

  internal private(set) var stateChangeToPublishSubject = PublishSubject<CocoaMQTTConnState>()

  internal private(set) var publishMessagePublishSubject = PublishSubject<CocoaMQTTMessage>()

  internal private(set) var receiveMessagePublishSubject = PublishSubject<(CocoaMQTTMessage, UInt16)>()

  internal private(set) var subscribeTopicsPublishSubject = PublishSubject<[String]>()

  internal private(set) var unsubscribeTopicPublishSubject = PublishSubject<String>()
}

// MARK: CocoaMQTTDelegate

extension RxCocoaMQTTDelegateProxy: CocoaMQTTDelegate {
  /// For more information take a look at `DelegateProxyType`.
  public func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
    PBSLogger.logger.debug(message: "new ack: \(ack)", context: "MQTT")

    connAckPublishSubject.on(.next(ack))

    _forwardToDelegate?.mqtt(mqtt, didConnectAck: ack)
  }

  public func mqtt(_ mqtt: CocoaMQTT, didStateChangeTo state: CocoaMQTTConnState) {
    PBSLogger.logger.debug(message: "new state: \(state)", context: "MQTT")

    stateChangeToPublishSubject.on(.next(state))

    _forwardToDelegate?.mqtt(mqtt, didStateChangeTo: state)
  }

  public func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
    PBSLogger.logger.debug(message: "didPublishMessage: \(message)", context: "MQTT")

    publishMessagePublishSubject.on(.next(message))

    _forwardToDelegate?.mqtt(mqtt, didPublishMessage: message, id: id)
  }

  public func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {
    PBSLogger.logger.debug(message: "didPublishAck: \(id)", context: "MQTT")

    _forwardToDelegate?.mqtt(mqtt, didPublishAck: id)
  }

  public func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16) {
    PBSLogger.logger.debug(message: "Message received in topic \(message.topic) with payload \(message.string!)", context: "MQTT")

    receiveMessagePublishSubject.on(.next((message, id)))

    _forwardToDelegate?.mqtt(mqtt, didReceiveMessage: message, id: id)
  }

  public func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopic topics: [String]) {
    PBSLogger.logger.debug(message: "didSubscribeTopic topics \(topics) ", context: "MQTT")

    subscribeTopicsPublishSubject.on(.next(topics))

    _forwardToDelegate?.mqtt(mqtt, didSubscribeTopic: topics)
  }

  public func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopic topic: String) {
    PBSLogger.logger.debug(message: "didUnsubscribeTopic topic \(topic) ", context: "MQTT")

    unsubscribeTopicPublishSubject.on(.next(topic))

    _forwardToDelegate?.mqtt(mqtt, didUnsubscribeTopic: topic)
  }

  public func mqttDidPing(_ mqtt: CocoaMQTT) {
    PBSLogger.logger.debug(message: "mqttDidPing", context: "MQTT")

    _forwardToDelegate?.mqttDidPing(mqtt)
  }

  public func mqttDidReceivePong(_ mqtt: CocoaMQTT) {
    PBSLogger.logger.debug(message: "mqttDidReceivePong", context: "MQTT")

    _forwardToDelegate?.mqttDidReceivePong(mqtt)
  }

  public func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?) {
    PBSLogger.logger.debug(message: "mqttDidDisconnect with error: \(err?.localizedDescription ?? "")", context: "MQTT")

    if let error = err {
      connAckPublishSubject.on(.error(error))
    } else {
      connAckPublishSubject.on(.completed)
    }

    _forwardToDelegate?.mqttDidDisconnect(mqtt, withError: err)
  }
}
