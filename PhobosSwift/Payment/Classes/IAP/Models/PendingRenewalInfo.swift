//
//
//  PendingRenewalInfo.swift
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

extension PBSPayment.IAP {
  /// App 内购买项目收据字段
  ///
  /// 官方文档：https://developer.apple.com/cn/app-store/Receipt-Validation-Programming-Guide-CN.pdf
  /// 注意：App Store返回的JSON中有很多看起来很有用的字段，但如果这些字段没有在“官方文档”中列出，在PendingRenewalInfo类进行修改，
  /// 请忽略这些未在“官方文档”中列出的属性保留供系统使用，因为它们的内容随时可能被App Store更改。
  /// * 在进行消耗型产品购买时，该 App 内购买项目收据被添加到收据中。
  /// * 在您的 App 完成该笔交易之前， 该 App 内购买项目收据会一直保留在收据内。
  /// * 在交易完成后，该 App 内购买项目收据会在下次收据更新时(例如，顾客进行下一次购买，或者您的 App 明确刷新收据时)从收据中移除。
  /// * 非消耗型产品、自动续期订阅、非续期订阅或免费订阅的 App 内购买项目收据无限期保留在收据中。
  class PendingRenewalInfo: NSObject, Codable {
    /// 此 Key 仅适用于自动续期订阅收据。此 Key 的值与顾客订阅续期的产品的 productIdentifier 属性相 对应。
    /// 您可以在当前订阅到期前，使用此值向顾客提供替代的服务级别。
    let auto_renew_product_id: String

    /// 订阅自动续期状态
    /// 自动续期订阅的当前续期状态。
    /// “1”- 订阅将在当前订阅时间段结束时续期。
    /// “0”- 顾客已关闭自动续期订阅。
    /// 此 Key 仅适用于自动续期订阅收据，包括有效订阅或已过期订阅。此 Key 的值不应被视作顾客的订阅状 态。您可以使用此值在 App 中显示备用订阅产品(例如较低等级订阅计划，以供顾客降级当前的订阅计 划)。
    let auto_renew_status: String

    /// [Optional]订阅到期意图
    /// 针对已过期订阅，解释订阅过期的原因。
    /// ”1“- 顾客取消订阅。
    /// ”2“- 账单错误;例如，顾客的付款信息不再有效。
    /// “3”- 顾客不同意近期提价。
    /// “4”- 在续期时，产品暂无供应。
    /// “5”- 未知错误。
    /// * 此 Key 仅适用于包含已过期自动续期订阅的收据。您可以使用此值决定是否在您的 App 中显示适当的消息，以便顾客重新订阅。
    let expiration_intent: String?

    let is_in_billing_retry_period: String?
    let original_transaction_id: String
    let product_id: String

    /// [Optional]订阅价格认同状态
    /// 顾客当前对订阅价格提价的价格认同状态。
    /// “1”- 顾客同意提价。订阅将以提价后的价格续期。
    /// “0”- 顾客没有针对提价一事采取任何措施。如果顾客在续期日期之前不采取任何措施，订阅将到期。
    /// 此 Key 只在当订阅价格已提价，并且不为现有订阅者保留现有价格时，适用于自动续期订阅收据。您可 以使用此值跟踪顾客对新价格的接受情况，并相应地采取措施。
    let price_consent_status: String?
  }
}
