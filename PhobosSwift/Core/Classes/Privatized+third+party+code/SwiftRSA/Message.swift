//
//  Message.swift
//  SwiftyRSA
//
//  Created by Loïs Di Qual on 9/19/16.
//  Copyright © 2016 Scoop. All rights reserved.
//

import Foundation

/// Message Protocol
///
/// need to implementation of data, base64string
public protocol Message {
  /// data
  var data: Data { get }

  /// base64String
  var base64String: String { get }

  /// init with data
  init(data: Data)

  /// init with base64 string
  init(base64Encoded base64String: String) throws
}

/// Enhanced features of Message protocol is implemented in this extension
extension Message {
  /// Base64-encoded string of the message data
  public var base64String: String {
    data.base64EncodedString()
  }

  /// Creates an encrypted message with a base64-encoded string.
  ///
  /// - Parameter base64String: Base64-encoded data of the encrypted message
  /// - Throws: SwiftyRSAError
  public init(base64Encoded base64String: String) throws {
    guard let data = Data(base64Encoded: base64String) else {
      throw SwiftyRSAError.invalidBase64String
    }
    self.init(data: data)
  }
}
