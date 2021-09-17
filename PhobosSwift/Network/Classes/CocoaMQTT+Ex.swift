//
//
//  CocoaMQTT+Ex.swift
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

import PhobosSwiftCore
import RxRelay
import RxSwift
import UIKit

extension CocoaMQTT: PhobosSwiftCompatible {}

/// 对CocoaMQTT的增强
extension PhobosSwift where Base: CocoaMQTT {
  /// 对MQTT进行连接
  ///
  /// - parameter: host
  /// - parameter: port
  /// - parameter: username 可以为空
  /// - parameter: password 可以为空
  /// - parameter: keepAlive 连接超时的时间（秒）
  /// - parameter: allowUntrustCACertificate 是否同意非安全的连接
  /// - parameter: retry 发生disconnect后，重新连接的次数
  /// - parameter: didConnectAckHandler 连接收到Ack后的回调
  /// - parameter: didDisconnectHandler 连接断开后的回调
  public static func makeMQTTAndConnect(host: String,
                                        port: UInt16 = 1883,
                                        username: String? = nil,
                                        password: String? = nil,
                                        keepAlive: UInt16 = 60,
                                        allowUntrustCACertificate: Bool = true,
                                        retry: Int = 0,
                                        didConnectAckHandler: @escaping (CocoaMQTT, CocoaMQTTConnAck) -> Void,
                                        didDisconnectHandler: @escaping (CocoaMQTT, Error?) -> Void) -> CocoaMQTT? {
    let mqtt = CocoaMQTT.pbs.makeMQTT(host: host,
                                      port: port,
                                      username: username,
                                      password: password,
                                      keepAlive: keepAlive,
                                      allowUntrustCACertificate: allowUntrustCACertificate)
    let result = mqtt.pbs.connect(retry: retry, didConnectAckHandler: didConnectAckHandler, didDisconnectHandler: didDisconnectHandler)

    return result ? mqtt : nil
  }

  /// Make a new MQTT
  ///
  /// - parameter: host
  /// - parameter: port
  /// - parameter: username 可以为空
  /// - parameter: password 可以为空
  /// - parameter: keepAlive 连接超时的时间（秒）
  /// - parameter: allowUntrustCACertificate 是否同意非安全的连接
  public static func makeMQTT(host: String,
                              port: UInt16 = 1883,
                              username: String? = nil,
                              password: String? = nil,
                              keepAlive: UInt16 = 60,
                              allowUntrustCACertificate: Bool = true) -> CocoaMQTT {
    let clientID = "PBSNetworkMQTT-" + String(ProcessInfo().processIdentifier)
    let mqtt = CocoaMQTT(clientID: clientID, host: host, port: port)
    if let username = username {
      mqtt.username = username
    }
    if let password = password {
      mqtt.password = password
    }
    mqtt.allowUntrustCACertificate = allowUntrustCACertificate
    // mqtt.willMessage = CocoaMQTTWill(topic: "news", message: "dieout")
    mqtt.keepAlive = keepAlive
    return mqtt
  }

  /// 连接，并且在成功后运行回调函数
  ///
  /// - parameter: retry 发生disconnect后，重新连接的次数
  /// - parameter: didConnectAckHandler 连接收到Ack后的回调
  /// - parameter: didDisconnectHandler 连接断开后的回调
  @discardableResult
  public func connect(retry: Int = 0,
                      didConnectAckHandler: @escaping (CocoaMQTT, CocoaMQTTConnAck) -> Void,
                      didDisconnectHandler: @escaping (CocoaMQTT, Error?) -> Void) -> Bool {
    Retry.countOfRetry = retry

    base.didConnectAck = didConnectAckHandler
    base.didDisconnect = {
      if Retry.countOfRetry == 0 || $1 == nil {
        didDisconnectHandler($0, $1)
      } else {
        Retry.countOfRetry -= 1
        connect(retry: Retry.countOfRetry, didConnectAckHandler: didConnectAckHandler, didDisconnectHandler: didDisconnectHandler)
      }
    }

    return base.connect()
  }
}

enum Retry {
  static var countOfRetry: Int = 0
}
