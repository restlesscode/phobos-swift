//
//
//  PBSWechatDelegate.swift
//  PhobosSwiftWechat
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
import MirrorWechatSDK

/// Wechat Delegate
///
@objc public protocol PBSWechatDelegate {
  /// didRecievePayResponse
  func wechat(_ wechat: PBSWechat, didRecievePayResponse response: PayResp)

  /// didRecieveShowMessageRequest
  func wechat(_ wechat: PBSWechat, didRecieveShowMessageRequest request: ShowMessageFromWXReq)

  /// didRecieveLaunchFromWXRequest
  func wechat(_ wechat: PBSWechat, didRecieveLaunchFromWXRequest request: LaunchFromWXReq)

  /// didRecieveMessageResponse
  func wechat(_ wechat: PBSWechat, didRecieveMessageResponse response: SendMessageToWXResp)

  /// didRecieveAuthResponse
  func wechat(_ wechat: PBSWechat, didRecieveAuthResponse response: SendAuthResp)

  /// didRecieveAddCardResponse
  func wechat(_ wechat: PBSWechat, didRecieveAddCardResponse response: AddCardToWXCardPackageResp)

  /// didRecieveChooseCardResponse
  func wechat(_ wechat: PBSWechat, didRecieveChooseCardResponse response: WXChooseCardResp)

  /// didRecieveChooseInvoiceResponse
  func wechat(_ wechat: PBSWechat, didRecieveChooseInvoiceResponse response: WXChooseInvoiceResp)

  /// didRecieveSubscribeMsgResponse
  func wechat(_ wechat: PBSWechat, didRecieveSubscribeMsgResponse response: WXSubscribeMsgResp)

  /// didRecieveLaunchMiniProgram
  func wechat(_ wechat: PBSWechat, didRecieveLaunchMiniProgram response: WXLaunchMiniProgramResp)

  /// didRecieveInvoiceAuthInsertResponse
  func wechat(_ wechat: PBSWechat, didRecieveInvoiceAuthInsertResponse response: WXInvoiceAuthInsertResp)

  /// didRecieveNonTaxpayResponse
  func wechat(_ wechat: PBSWechat, didRecieveNonTaxpayResponse response: WXNontaxPayResp)

  /// didRecievePayInsuranceResponse
  func wechat(_ wechat: PBSWechat, didRecievePayInsuranceResponse response: WXPayInsuranceResp)
}
