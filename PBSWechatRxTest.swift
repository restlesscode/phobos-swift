//
//
//  PBSWechatRxTest.swift
//  PhobosSwiftWechat-Unit-Tests
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


@testable import PhobosSwiftWechat
import MirrorWechatSDK
import Nimble
import Quick

class PBSWechatRxSpec: QuickSpec {
  override func spec() {
    describe("Given PBSWechat正常初始化") {
      let wechat = PBSWechat.shared
      context("When 获取Reactive所有计算属性及函数") {
        _ = wechat.rx.delegate
        _ = wechat.rx.didRecievePayResponse
        _ = wechat.rx.didRecieveShowMessageRequest
        _ = wechat.rx.didRecieveLaunchFromWXRequest
        _ = wechat.rx.didRecieveMessageResponse
        _ = wechat.rx.didRecvAuthResponse
        _ = wechat.rx.didRecieveAddCardResponse
        _ = wechat.rx.didRecieveChooseCardResponse
        _ = wechat.rx.didRecieveChooseInvoiceResponse
        _ = wechat.rx.didRecieveSubscribeMsgResponse
        _ = wechat.rx.didRecieveLaunchMiniProgram
        _ = wechat.rx.didRecieveInvoiceAuthInsertResponse
        _ = wechat.rx.didRecieveNonTaxpayResponse
        _ = wechat.rx.didRecievePayInsuranceResponse
        _ = wechat.rx.setDelegate(PBSWechatDelegateStub())
        
        it("不会闪退") {
          expect(true).to(beTrue())
        }
      }
    }
  }
}

class PBSWechatDelegateStub: PBSWechatDelegate {
  func wechat(_ wechat: PBSWechat, didRecievePayResponse response: PayResp) {
    
  }
  
  func wechat(_ wechat: PBSWechat, didRecieveShowMessageRequest request: ShowMessageFromWXReq) {
    
  }
  
  func wechat(_ wechat: PBSWechat, didRecieveLaunchFromWXRequest request: LaunchFromWXReq) {
    
  }
  
  func wechat(_ wechat: PBSWechat, didRecieveMessageResponse response: SendMessageToWXResp) {
    
  }
  
  func wechat(_ wechat: PBSWechat, didRecieveAuthResponse response: SendAuthResp) {
    
  }
  
  func wechat(_ wechat: PBSWechat, didRecieveAddCardResponse response: AddCardToWXCardPackageResp) {
    
  }
  
  func wechat(_ wechat: PBSWechat, didRecieveChooseCardResponse response: WXChooseCardResp) {
    
  }
  
  func wechat(_ wechat: PBSWechat, didRecieveChooseInvoiceResponse response: WXChooseInvoiceResp) {
    
  }
  
  func wechat(_ wechat: PBSWechat, didRecieveSubscribeMsgResponse response: WXSubscribeMsgResp) {
    
  }
  
  func wechat(_ wechat: PBSWechat, didRecieveLaunchMiniProgram response: WXLaunchMiniProgramResp) {
    
  }
  
  func wechat(_ wechat: PBSWechat, didRecieveInvoiceAuthInsertResponse response: WXInvoiceAuthInsertResp) {
    
  }
  
  func wechat(_ wechat: PBSWechat, didRecieveNonTaxpayResponse response: WXNontaxPayResp) {
    
  }
  
  func wechat(_ wechat: PBSWechat, didRecievePayInsuranceResponse response: WXPayInsuranceResp) {
    
  }

}
