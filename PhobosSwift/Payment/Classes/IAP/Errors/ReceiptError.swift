//
//
//  ReceiptError.swift
//  PhobosSwiftPayment
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

import StoreKit

public let PBSReceiptErrorDomain = "PBSReceiptErrorDomain"

extension PBSPayment.IAP {
  // error codes for the SKErrorDomain
  public class ReceiptError: Error {
    private var _code: Code

    public init(code: Code) {
      _code = code
    }

    public var code: Code {
      _code
    }

    public enum Code: Int {
      public typealias ErrorType = ReceiptError

      case unknown = -188_800
      case receiptNotFound = -188_801 // 无法加载本地收据
      case receiptRequestFailed = -188_804 // 由于网络错误造成的

      /// 21000: App Store 无法读取您提供的 JSON 对象。
      case jsonInvalid = 21_000

      /// 21002: receipt-data 属性中的数据格式错误或丢失。
      case receiptInvalid = 21_002 // 收据无法解析，收据格式不正确,

      /// 21003: 无法认证收据。
      case receiptVerifyFailed = 21_003 // 收据验证失败，收据格式正确，但是验证失败

      /// 21004: 您提供的共享密钥与您帐户存档的共享密钥不匹配。
      case appSecretInvalid = 21_004

      /// 21005: 收据服务器当前不可用。
      case serverNotFound = 21_005

      /// * 21006: 此收据有效，但订阅已过期。当此状态代码返回到您的服务器时，收据数据也将 解码并作为响应的一部分返回。 只有在交易收据为 iOS 6 样式且为自动续期订阅时才会返回。

      /// 21007: 此收据来自测试环境，但发送到生产环境进行验证。应将其发送到测试环境。
      case receiptIsFromSandbox = 21_007

      /// 21008: 此收据来自生产环境，但发送到测试环境进行验证。应将其发送到生产环境。
      case receiptIsFromProduct = 21_008

      /// 21010: 此收据无法获得授权。对待此收据的方式与从未进行过任何交易时的处理方式相同。
      case receiptUnauthorized = 21_010

      /// 21100-21199: 内部数据访问错误。
      case internalError = 21_199
    }

    private var message: String {
      let code = ReceiptError.Code(rawValue: errorCode) ?? .unknown
      switch code {
      case .receiptNotFound:
        return "收据（Receipt）没有找到"
      case .receiptVerifyFailed:
        return "收据（Receipt）验证失败，该笔交易没有通过验证，可能是过期、或者是用户主动取消"
      case .receiptInvalid:
        return "收据（Receipt）为无效收据，该收据无法经过app store解析"
      case .receiptRequestFailed:
        return "收据（Receipt）解析中发生网络（http/https）错误"
      case .unknown:
        return "收据（Receipt）解析中发生未知（unkown）错误"
      case .jsonInvalid:
        return "App Store 无法读取您提供的 JSON 对象"
      case .appSecretInvalid:
        return "您提供的共享密钥与您帐户存档的共享密钥不匹配"
      case .serverNotFound:
        return "收据服务器当前不可用"
      case .receiptIsFromSandbox:
        return "此收据来自生产环境，但发送到测试环境进行验证。应将其发送到生产环境"
      case .receiptIsFromProduct:
        return "此收据无法获得授权。对待此收据的方式与从未进行过任何交易时的处理方式相同"
      case .receiptUnauthorized:
        return "此收据无法获得授权,对待此收据的方式与从未进行过任何交易时的处理方式相同"
      case .internalError:
        return "内部数据访问错误"
      }
    }
  }
}

extension PBSPayment.IAP.ReceiptError: CustomNSError {
  public static var errorDomain: String {
    PBSReceiptErrorDomain
  }

  public var errorCode: Int {
    code.rawValue
  }

  public var errorUserInfo: [String: Any] {
    [String: Any]()
  }

  public var localizedDescription: String {
    message
  }
}

extension PBSPayment.IAP.ReceiptError: LocalizedError {
  /// A localized message describing what error occurred.
  public var errorDescription: String? {
    message
  }
}
