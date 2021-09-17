//
//
//  ReceiptInApp.swift
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
  /// 注意：App Store返回的JSON中有很多看起来很有用的字段，但如果这些字段没有在“官方文档”中列出，在ReceiptInApp类进行修改，
  /// 请忽略这些未在“官方文档”中列出的属性保留供系统使用，因为它们的内容随时可能被App Store更改。
  /// * 在进行消耗型产品购买时，该 App 内购买项目收据被添加到收据中。
  /// * 在您的 App 完成该笔交易之前， 该 App 内购买项目收据会一直保留在收据内。
  /// * 在交易完成后，该 App 内购买项目收据会在下次收据更新时(例如，顾客进行下一次购买，或者您的 App 明确刷新收据时)从收据中移除。
  /// * 非消耗型产品、自动续期订阅、非续期订阅或免费订阅的 App 内购买项目收据无限期保留在收据中。
  public class ReceiptInApp: Codable {
    /// 购买的项目的数量。
    /// 这个值与存储在交易的 payment 属性中 SKPayment 对象的 quantity 属性相对应
    public let quantity: String

    /// 产品标识符
    /// 这个值与存储在交易的 payment 属性中 SKPayment 对象的 productIdentifier 属性相对应。
    public let product_id: String

    /// 交易标识符
    /// 这个值与交易的 transactionIdentifier 属性相对应。
    /// * 针对恢复先前交易的交易，此值与原始购买交易的交易标识符不同。
    /// * 在自动续期订阅收据中，每次在新设备上自动续期或恢复订阅时，都会为交易标识符生成新值。
    public let transaction_id: String

    /// 原始交易标识符
    /// 针对恢复先前交易的交易，该交易标识符代表原始交易。否则，与交易标识符相同。
    /// 这个值与原始交易的 transactionIdentifier 属性相对应。
    public let original_transaction_id: String

    /// 购买日期
    /// 购买项目的日期和时间。
    /// 这个值与交易的 transactionDate 属性相对应。
    /// * 对于恢复先前交易的交易，购买日期与原始购买日期相同。通过“原始购买日期 (第 28 页)”字段可获 取原始交易的日期。
    /// * 在自动续期订阅收据中，购买日期是购买或续期订阅的日期(无论订阅是否失效)。
    ///     * 对于在当前时间段有效日期发生的自动续期，购买日期与当前时段的结束日期相同，为下一时间段的开始日期。
    /// 格式为"yyyy-MM-dd HH:mm:ss VV" - "2018-11-29 08:47:04 Etc/GMT"
    public let purchase_date: String

    /// 原始购买日期
    /// 对于恢复先前交易的交易，此值为原始交易的日期。
    /// 这个值与原始交易的 transactionDate 属性相对应。
    /// 在自动续期订阅收据中，此值表示订阅时间段的开始(即使订阅已续期)。
    public let original_purchase_date: String

    /// [Optional]订阅有效日期
    /// 订阅的有效日期，以距离格林威治时间 1970 年 1 月 1 日 00 时 00 分 00 秒的毫秒数表示。
    /// * 此 Key 仅适用于自动续期订阅收据。
    /// 使用此值确定订阅续期日期或有效日期，确认顾客是否拥有对内容或服务的访问权限。验证最新收据后，如果最新续期交易的订阅有效日期是过去的日期，则可以断定订阅已过期。
    /// # 转换表：Actual durations translate to sandbox durations: (Actual durations vs sandbox durations)
    /// - 1 week vs 3 minutes
    /// - 1 month vs 5 minutes
    /// - 2 months vs 10 minutes
    /// - 3 months vs 15 minutes
    /// - 6 months vs 30 minutes
    /// - 1 year vs 1 hour
    ///
    /// 每天，sandbox环境下会自动续费6次，超过6次，就不会自动续费了，测试环境下请注意
    public let expires_date: String?

    /// [Optional]订阅到期意图
    /// 针对已过期订阅，解释订阅过期的原因。
    /// ”1“- 顾客取消订阅。
    /// ”2“- 账单错误;例如，顾客的付款信息不再有效。
    /// “3”- 顾客不同意近期提价。
    /// “4”- 在续期时，产品暂无供应。
    /// “5”- 未知错误。
    /// * 此 Key 仅适用于包含已过期自动续期订阅的收据。您可以使用此值决定是否在您的 App 中显示适当的消息，以便顾客重新订阅。
    public let expiration_intent: String?

    /// [Optional]订阅重试旗标
    /// 针对已过期订阅，显示 Apple 是否仍尝试自动续期订阅。
    /// “1”- App Store 仍然尝试续期订阅。
    /// “0”- App Store 已停止尝试续期订阅。
    /// * 此 Key 仅适用于自动续期订阅收据。如果由于 App Store 无法完成交易导致顾客的订阅未能续期，此值 将反映 App Store 是否仍然尝试续期订阅。
    public let is_in_billing_retry_period: String?

    /// [Optional]订阅试用期
    /// 反映订阅是否处于 “免费试用” 期。
    /// 此 Key 仅适用于自动续期订阅收据。
    /// 当顾客的订阅目前处于免费试用期时，此 Key 的值为“true”，否则 为"false"。
    public let is_trial_period: String?

    /// [Optional]取消日期
    /// 针对由 Apple 顾客支持取消的交易，反映取消交易的时间和日期。
    /// * 对已取消的收据的处理方式与未进行任何交易时相同。
    /// * 注意: 取消的App内购买项目将无限期保留在收据中。仅在为非消耗型产品、自动续期订阅、 非续期订阅或免费订阅退款时适用。
    public let cancellation_date: String?

    /// [Optional]取消原因
    /// “1”- 顾客取消交易，因为您的 App 确实存在问题或顾客认为存在问题。
    /// “0”- 由于其他原因取消交易，例如顾客意外地进行了此次交易。 结合取消日期使用此值，确定您 App 内存在的可能导致顾客联系 Apple 顾客支持的问题。
    public let cancellation_reason: String?

    /// [Optional]是否在首次订阅优惠期
    /// 所有的自动续订的订阅，开发者都可以提供首次订阅的顾客一定的折扣优惠
    public let is_in_intro_offer_period: String?

    /// [Optional]网络订单行项目 ID
    /// 用于识别订阅购买项目的首要 Key。
    /// 此值是用于识别设备间购买事件(包括订阅续期购买事件)的唯一 ID。
    public let web_order_line_item_id: String?
  }
}

extension PBSPayment.IAP.ReceiptInApp {
  private var dateFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss VV"

    return formatter
  }

  public var expiresDate: Date? {
    if let expiresDateString = expires_date {
      return dateFormatter.date(from: expiresDateString)
    }

    return nil
  }
}
