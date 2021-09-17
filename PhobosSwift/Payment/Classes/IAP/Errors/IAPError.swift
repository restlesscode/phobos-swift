//
//
//  IAPError.swift
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
import StoreKit

/// PBSIAPErrorDomain
public let PBSIAPErrorDomain = "PBSIAPErrorDomain"

extension PBSPayment.IAP {
  public class IAPError: Error {
    private var code: Code

    public init(code: Code) {
      self.code = code
    }

    public enum Code: Int {
      public typealias ErrorType = PBSPayment.IAP.ReceiptError

      case unknown /// 对应SKError.unknown
      case clientInvalid /// 对应SKError.clientInvalid
      case cloudServiceRevoked /// 对应SKError.cloudServiceRevoked
      case cloudServicePermissionDenied /// 对应SKError.cloudServicePermissionDenied
      case paymentCancelled /// 对应SKError.paymentCancelled
      case paymentInvalid /// 对应SKError.paymentInvalid
      case paymentNotAllowed /// 对应SKError.paymentNotAllowed
      case storeProductNotAvailable /// 对应SKError.storeProductNotAvailable
      case cloudServiceNetworkConnectionFailed /// 对应SKError.cloudServiceNetworkConnectionFailed
      case privacyAcknowledgementRequired /// 对应SKError.privacyAcknowledgementRequired
      case unauthorizedRequestData /// 对应SKError.unauthorizedRequestData
      case invalidOfferIdentifier /// 对应SKError.invalidOfferIdentifier
      case invalidSignature /// 对应SKError.invalidSignature
      case missingOfferParams /// 对应SKError.missingOfferParams
      case invalidOfferPrice /// 对应SKError.invalidOfferPrice
      case overlayCancelled /// 对应SKError.overlayCancelled
      case overlayInvalidConfiguration /// 对应SKError.overlayInvalidConfiguration
      case overlayTimeout /// 对应SKError.overlayTimeout
      case ineligibleForOffer /// 对应SKError.ineligibleForOffer
      case unsupportedPlatform /// 对应SKError.unsupportedPlatform
      case overlayPresentedInBackgroundScene /// 对应SKError.overlayPresentedInBackgroundScene
    }

    private var message: String {
      let code = IAPError.Code(rawValue: errorCode) ?? .unknown

      switch code {
      case .unknown:
        return SKError(.unknown).localizedDescription
      case .clientInvalid:
        return "Client Invalid"
      case .cloudServiceRevoked:
        return "Cloud Service Revoked"
      case .cloudServicePermissionDenied:
        return "Cloud Service Permission Denied"
      case .paymentCancelled:
        return "Payment Cancelled（用户在支付时取消了）"
      case .paymentInvalid:
        return "Payment Invalid"
      case .paymentNotAllowed:
        return "Payment Not Allowed"
      case .storeProductNotAvailable:
        return "Store Product Not Available"
      case .cloudServiceNetworkConnectionFailed:
        return "Cloud Service Network Connection Failed"
      case .privacyAcknowledgementRequired:
        return "Privacy Acknowledgement Required"
      case .unauthorizedRequestData:
        return "Unauthorized Request Data"
      case .invalidOfferIdentifier:
        return "InvalidOfferIdentifier"
      case .invalidSignature:
        return "Invalid Signature"
      case .missingOfferParams:
        return "Missing Offer Params"
      case .invalidOfferPrice:
        return "Invalid Offer Price"
      case .overlayCancelled:
        return "OverlayCancelled"
      case .overlayInvalidConfiguration:
        return "Overlay Invalid Configuration"
      case .overlayTimeout:
        return "Overlay Timeout"
      case .ineligibleForOffer:
        return "Ineligible For Offer"
      case .unsupportedPlatform:
        return "Unsupported Platform"
      case .overlayPresentedInBackgroundScene:
        return "Overlay Presented In Background Scene"
      }
    }
  }
}

extension PBSPayment.IAP.IAPError: CustomNSError {
  public static var errorDomain: String {
    PBSIAPErrorDomain
  }

  public var errorCode: Int {
    code.rawValue
  }

  public var errorUserInfo: [String: Any] {
    [String: Any]()
  }
}

extension PBSPayment.IAP.IAPError: LocalizedError {
  public var localizedDescription: String {
    message
  }

  /// A localized message describing what error occurred.
  public var errorDescription: String? {
    message
  }
}
