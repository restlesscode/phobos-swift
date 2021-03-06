//
//  AppleSystemLogDestination.swift
//  XCGLogger: https://github.com/DaveWoodCom/XCGLogger
//
//  Created by Dave Wood on 2014-06-06.
//  Copyright © 2014 Dave Wood, Cerebral Gardens.
//  Some rights reserved: https://github.com/DaveWoodCom/XCGLogger/blob/master/LICENSE.txt
//

import Dispatch
import Foundation

// MARK: - AppleSystemLogDestination

/// A standard destination that outputs log details to the Apple System Log using NSLog instead of print
open class AppleSystemLogDestination: BaseQueuedDestination {
  // MARK: - Properties

  /// Option: whether or not to output the date the log was created (Always false for this destination)
  override open var showDate: Bool {
    get {
      false
    }
    set {
      // ignored, NSLog adds the date, so we always want showDate to be false in this subclass
    }
  }

  // MARK: - Overridden Methods

  /// Print the log to the Apple System Log facility (using NSLog).
  ///
  /// - Parameters:
  ///     - message:   Formatted/processed message ready for output.
  ///
  /// - Returns:  Nothing
  ///
  override open func write(logDetails: LogDetails, message: String) {
    NSLog("%@", message)
  }
}
