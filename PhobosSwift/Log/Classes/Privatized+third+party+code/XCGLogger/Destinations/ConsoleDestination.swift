//
//  ConsoleDestination.swift
//  XCGLogger: https://github.com/DaveWoodCom/XCGLogger
//
//  Created by Dave Wood on 2014-06-06.
//  Copyright © 2014 Dave Wood, Cerebral Gardens.
//  Some rights reserved: https://github.com/DaveWoodCom/XCGLogger/blob/master/LICENSE.txt
//

import Dispatch
import os.log

// MARK: - ConsoleDestination

/// A standard destination that outputs log details to the console
open class ConsoleDestination: BaseQueuedDestination {
  // MARK: - Overridden Methods

  static let customOSLog = OSLog(subsystem: Bundle.main.bundleIdentifier ?? String(describing: PhobosSwiftLog.self), category: String(describing: PhobosSwiftLog.self))

  /// Print the log to the console.
  ///
  /// - Parameters:
  ///     - message:   Formatted/processed message ready for output.
  ///
  /// - Returns:  Nothing
  ///
  override open func write(logDetails: LogDetails, message: String) {
    var type: OSLogType = .default
    switch logDetails.level {
    case .debug:
      type = .debug
    case .error:
      type = .error
    case .severe, .emergency:
      type = .fault
    case .verbose, .info, .notice, .warning, .alert:
      type = .info
    default:
      type = .default
    }

    os_log("%s", log: Self.customOSLog, type: type, message)
  }
}
