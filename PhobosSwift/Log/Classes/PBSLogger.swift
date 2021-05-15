//
//
//  PBSLog.swift
//  PhobosSwiftLog
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

extension PBSLogger {
  /// Log Mode
  public enum Mode {
    /// Log to file
    case file
    /// Log to icloud
    case icloud(containerIdentifier: String? = nil)
    /// Log to memory
    case memory
  }
}

extension PBSLogger {
  public enum Level {
    /// disables logging
    case none

    /// this is the default log level
    case info

    /// will also show debug log messages
    case verbose
  }
}

public class PBSLogger {
  private let configuration: Configuration
  private let logger: XCGLogger?

  public static var shared = PBSLogger(configuration: Configuration.default)

  /// Set the configuration of shared logger
  public static func configure(identifier: String, level: Level = .verbose, mode: Mode = .memory) {
    PBSLogger.Configuration.makeConfiguration(identifier: identifier, level: level, mode: mode, onComplete: {
      PBSLogger.shared = PBSLogger(configuration: $0)
    })
  }

  public var logFilePath: URL? {
    configuration.logFilePath
  }

  public init(configuration: Configuration) {
    self.configuration = configuration

    guard configuration.level != .none else {
      logger = nil
      return
    }

    let logger = XCGLogger(identifier: configuration.identifier, includeDefaultDestinations: false)

    self.logger = logger

    logger.dateFormatter = configuration.dateFormatter

    logger.add(destination: configuration.consoleDestination)

    if configuration.writeToAppleSystemLog {
      logger.add(destination: configuration.appleSystemLogDestination)
    }

    if configuration.writeToFile {
      logger.add(destination: configuration.fileDestination)
    }

    // Add basic app info, version info etc, to the start of the logs
    logger.logAppDetails()
  }

  public func debug(message: String, context: String, functionName: StaticString = #function, fileName: StaticString = #file, lineNumber: Int = #line) {
    logger?.debug("[\(context)] " + "🛠 " + message, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
  }

  public func info(message: String, context: String, functionName: StaticString = #function, fileName: StaticString = #file, lineNumber: Int = #line) {
    logger?.info("[\(context)] " + "ℹ️ " + message, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
  }

  public func warning(message: String, context: String, functionName: StaticString = #function, fileName: StaticString = #file, lineNumber: Int = #line) {
    logger?.warning("[\(context)] " + "⚠️ " + message, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
  }

  public func error(message: String, context: String, functionName: StaticString = #function, fileName: StaticString = #file, lineNumber: Int = #line) {
    logger?.error("[\(context)] " + "❌ " + message, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
  }

  public func logResponse(payload: Data?, functionName: StaticString = #function, fileName: StaticString = #file, lineNumber: Int = #line) {
    guard let payload = payload else { return }
    guard configuration.shouldLogResponse else { return }
    logger?.debug("[Response] " + "🛠 " + getStringFrom(data: payload), functionName: functionName, fileName: fileName, lineNumber: lineNumber)
  }

  private func getStringFrom(data: Data) -> String {
    String(data: data, encoding: String.Encoding.utf8) ?? ""
  }
}
