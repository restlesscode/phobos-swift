//
//
//  ReceiptResult.swift
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

import Foundation
import PhobosSwiftLog

extension PBSPayment.IAP {
  /// App 内购买项目收据字段
  ///
  /// 官方文档：https://developer.apple.com/cn/app-store/Receipt-Validation-Programming-Guide-CN.pdf
  /// 注意：App Store返回的JSON中有很多看起来很有用的字段，但如果这些字段没有在“官方文档”中列出，在ReceiptInApp类进行修改，
  /// 请忽略这些未在“官方文档”中列出的属性保留供系统使用，因为它们的内容随时可能被App Store更改。
  /// * 在进行消耗型产品购买时，该 App 内购买项目收据被添加到收据中。
  /// * 在您的 App 完成该笔交易之前， 该 App 内购买项目收据会一直保留在收据内。
  /// * 在交易完成后，该 App 内购买项目收据会在下次收据更新时(例如，顾客进行下一次购买，或者您的 App 明确刷新收据时)从收据中移除。
  /// * 非消耗型产品、自动续期订阅、非续期订阅或免费订阅的 App 内购买项目收据无限期保留在收据中。
  public class ReceiptResult: Codable {
    /// 状态代码
    /// 21000: App Store 无法读取您提供的 JSON 对象。
    /// 21002: receipt-data 属性中的数据格式错误或丢失。
    /// 21003: 无法认证收据。
    /// 21004: 您提供的共享密钥与您帐户存档的共享密钥不匹配。
    /// 21005: 收据服务器当前不可用。
    /// * 21006: 此收据有效，但订阅已过期。当此状态代码返回到您的服务器时，收据数据也将 解码并作为响应的一部分返回。 只有在交易收据为 iOS 6 样式且为自动续期订阅时才会返回。
    /// 21007: 此收据来自测试环境，但发送到生产环境进行验证。应将其发送到测试环境。
    /// 21008: 此收据来自生产环境，但发送到测试环境进行验证。应将其发送到生产环境。
    /// 21010: 此收据无法获得授权。对待此收据的方式与从未进行过任何交易时的处理方式相同。
    /// 21100-21199: 内部数据访问错误。
    public let status: Int
    public let receipt: Receipt?
    public let environment: String?
    internal let pending_renewal_info: [PendingRenewalInfo]?
    public let latest_receipt_info: [ReceiptInApp]?
    public let latest_receipt: String?
  }
}

extension PBSPayment.IAP.ReceiptResult {
  public var jsonString: String? {
    pbs_jsonString
  }

  public static func result(from jsonString: String) -> PBSPayment.IAP.ReceiptResult? {
    guard let jsonData = jsonString.data(using: .utf8) else {
      return nil
    }

    let jsonDecoder = JSONDecoder()
    do {
      let receiptResult = try jsonDecoder.decode(PBSPayment.IAP.ReceiptResult.self, from: jsonData)
      return receiptResult
    } catch {
      PBSLogger.logger.error(message: error.localizedDescription, context: "Payment")
    }
    return nil
  }
}

extension PBSPayment.IAP.ReceiptResult {
  internal var isValidated: Bool {
    // 状态代码 不为0，则代表Receipt校验不通过
    if status != 0 {
      return false
    }

    return receipt?.isValidated ?? false
  }

  var statusError: PBSPayment.IAP.ReceiptError {
    switch status {
    /// 21000: App Store 无法读取您提供的 JSON 对象。
    case 21_000:
      return PBSPayment.IAP.ReceiptError(code: PBSPayment.IAP.ReceiptError.Code.jsonInvalid)
    /// 21002: receipt-data 属性中的数据格式错误或丢失。
    case 21_002:
      return PBSPayment.IAP.ReceiptError(code: PBSPayment.IAP.ReceiptError.Code.receiptInvalid)
    /// 21003: 无法认证收据。
    case 21_003:
      return PBSPayment.IAP.ReceiptError(code: PBSPayment.IAP.ReceiptError.Code.receiptVerifyFailed)
    /// 21004: 您提供的共享密钥与您帐户存档的共享密钥不匹配。
    case 21_004:
      /// 21005: 收据服务器当前不可用。
      return PBSPayment.IAP.ReceiptError(code: PBSPayment.IAP.ReceiptError.Code.appSecretInvalid)
    case 21_005:
      return PBSPayment.IAP.ReceiptError(code: PBSPayment.IAP.ReceiptError.Code.serverNotFound)
    /// * 21006: 此收据有效，但订阅已过期。当此状态代码返回到您的服务器时，收据数据也将 解码并作为响应的一部分返回。 只有在交易收据为 iOS 6 样式且为自动续期订阅时才会返回。
    case 21_006:
      return PBSPayment.IAP.ReceiptError(code: PBSPayment.IAP.ReceiptError.Code.unknown)
    /// 21007: 此收据来自测试环境，但发送到生产环境进行验证。应将其发送到测试环境。
    case 21_007:
      return PBSPayment.IAP.ReceiptError(code: PBSPayment.IAP.ReceiptError.Code.receiptIsFromSandbox)
    /// 21008: 此收据来自生产环境，但发送到测试环境进行验证。应将其发送到生产环境。
    case 21_008:
      return PBSPayment.IAP.ReceiptError(code: PBSPayment.IAP.ReceiptError.Code.receiptIsFromProduct)
    /// 21010: 此收据无法获得授权。对待此收据的方式与从未进行过任何交易时的处理方式相同。
    case 21_010:
      return PBSPayment.IAP.ReceiptError(code: PBSPayment.IAP.ReceiptError.Code.receiptUnauthorized)
    /// 21100-21199: 内部数据访问错误。
    case 21_100...21_199:
      return PBSPayment.IAP.ReceiptError(code: PBSPayment.IAP.ReceiptError.Code.internalError)
    default:
      return PBSPayment.IAP.ReceiptError(code: PBSPayment.IAP.ReceiptError.Code.unknown)
    }
  }
}
