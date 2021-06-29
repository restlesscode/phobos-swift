//
//  PBSLoggerRecord.swift
//  PhobosSwiftLog
//
//  Created by Wenda on 6/29/21.
//

import CloudKit
import Foundation

public class PBSLoggerModel: Codable {
  let ckRecord: PBSLoggerRecord
}

public class PBSLoggerRecord: Codable {
  let type: String
  let properties: [Column]

  var record: CKRecord {
    let record = CKRecord(recordType: type)
    return record
  }
}

public struct Column: Codable {
  let name: String
  let type: String
}
