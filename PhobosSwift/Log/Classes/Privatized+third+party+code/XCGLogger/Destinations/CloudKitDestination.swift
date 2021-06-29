//
//  CloudKitDestination.swift
//  PhobosSwiftLog
//
//  Created by Wenda on 6/29/21.
//

import Foundation
import CloudKit

open class CloudKitDestination: BaseQueuedDestination {
  
  let dataBase = CKContainer.default().publicCloudDatabase
  
  let recordType = "Logs"
  
  var uuid: String = ""
  
  open override func write(logDetails: LogDetails, message: String) {
    writeToCloudKit(logDetails: logDetails, message: message)
  }
  
  private func writeToCloudKit(logDetails: LogDetails, message: String) {
    let recordNew = CKRecord(recordType: recordType)
    recordNew["message"] = message
    var type = ""
    switch logDetails.level {
    case .alert:
      type = "alert"
    case .debug:
      type = "debug"
    case .emergency:
      type = "emergency"
    case .error:
      type = "error"
    case .info:
      type = "info"
    case .notice:
      type = "notice"
    case .severe:
      type = "severe"
    case .verbose:
      type = "verbose"
    case .warning:
      type = "warning"
    case .none:
      type = "none"
    }
    recordNew["type"] = type
    recordNew["uuid"] = uuid
    DispatchQueue.global(qos: .utility).async {
      self.dataBase.save(recordNew, completionHandler: { record, error in
        if error != nil {
          print("save log to cloudkit error == \(error?.localizedDescription ?? "")")
        }
      })
    }
  }
}
