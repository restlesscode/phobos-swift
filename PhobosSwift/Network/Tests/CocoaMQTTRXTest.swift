//
//
//  CocoaMQTTRXTest.swift
//  PhobosSwiftNetwork-Unit-Tests
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

@testable import PhobosSwiftNetwork
import Nimble
import Quick

class CocoaMQTTRXTest: QuickSpec {
  override func spec() {
    testCrashs()
  }

  func testCrashs() {
    describe("Given CocoaMQTT初始化完成") {
      let host = "https://www.baidu.com"
      let mqtt = CocoaMQTT.pbs.makeMQTT(host: host)
      context("When 调用Reactive的相关方法") {
        _ = mqtt.rx.delegate
        _ = mqtt.rx.didConnectAck
        _ = mqtt.rx.didReceiveMessage
        _ = mqtt.rx.didStateChangeTo
        _ = mqtt.rx.didPublishMessage
        _ = mqtt.rx.didSubscribeTopics
        _ = mqtt.rx.didUnsubscribeTopic
        _ = mqtt.rx.setDelegate(CocoaMQTTDelegateImpl())
        it("Then 不会闪退") {
          expect(true).to(beTrue())
        }
      }
    }
  }
}

class CocoaMQTTDelegateImpl: CocoaMQTTDelegate {
  func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {}

  func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {}

  func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {}

  func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16) {}

  func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopic topics: [String]) {}

  func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopic topic: String) {}

  func mqttDidPing(_ mqtt: CocoaMQTT) {}

  func mqttDidReceivePong(_ mqtt: CocoaMQTT) {}

  func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?) {}
}
