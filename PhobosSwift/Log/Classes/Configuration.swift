//
//
//  Configuration.swift
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

import CloudKit
import Foundation

extension PBSLogger {
  public struct Configuration {
    public static func makeConfiguration(identifier: String, level: Level) -> Configuration {
      var configuration = Configuration()
      configuration.identifier = identifier
      configuration.level = level

      return configuration
    }

    public static func makeConfiguration(identifier: String, level: Level, mode: Mode) -> Configuration {
      var configuration = Configuration()
      configuration.identifier = identifier
      configuration.level = level
      configuration.mode = mode
      return configuration
    }

    public static func makeConfiguration(identifier: String, level: Level, mode: Mode, onComplete: @escaping (Configuration) -> Void) {
      var configuration = makeConfiguration(identifier: identifier, level: level, mode: mode)
      switch mode {
      case let .icloud(containerIdentifier):
        DispatchQueue.global(qos: .userInitiated).async {
          configuration.urlForUbiquityContainerIdentifier = FileManager.default.url(forUbiquityContainerIdentifier: containerIdentifier)

          onComplete(configuration)
        }
      default:
        onComplete(configuration)
      }
    }

    public var identifier: String = Constants.kDefalutLogIdentifier

    private var modelPlistPath: String?

    public var level: Level = .info

    /// Determines the Mode - where should the log message to stored, ie, memory / file / icloud
    public var mode: Mode = .file

    /// Flag to log server response
    public var shouldLogResponse: Bool = false

    /// Determines if the identifier of the logger should be logged in a log message
    public var showLogIdentifier: Bool = false

    /// Determines if the name of the current method should be logged in a log message
    public var showFunctionName: Bool = true

    /// Determines if the name of the current thread should be logged in a log message
    public var showThreadName: Bool = true

    /// Determines if the log level should be logged in a log message
    public var showLevel: Bool = true

    /// Determines if the filename should be logged in a log message
    public var showFileNames: Bool = true

    /// Determines if the linenumber should be logged in a log message
    public var showLineNumbers: Bool = true

    /// Determines if the date should be logged in a log message
    public var showDate: Bool = true

    /// The path where the log file should be stored
    /// If no path is provided, no file is written
    /// The file is only written for release builds
    ///
    /// default is ```AutoRotatingFileDestination.defaultLogFolderURL```
    var logFileFolder: URL? {
      switch mode {
      case .file:
        return AutoRotatingFileDestination.defaultLogFolderURL
      case .icloud:
        guard let url = urlForUbiquityContainerIdentifier else {
          return nil
        }
        return url.appendingPathComponent(Constants.kDocuments)
      case .memory:
        return AutoRotatingFileDestination.defaultLogFolderURL
      case .icloudKit:
        return nil
      }
    }

    var logModel: PBSLoggerRecord? {
      nil
    }

    private var urlForUbiquityContainerIdentifier: URL?

    /// The name of the log file
    ///
    /// default is ```PAFLogs.log```
    var logFileName: String {
      "\(identifier).log"
    }

    /// Determines if the logs written to a file should be appended to an existing file
    /// This implies that for every app session a new file is written
    public var shouldAppendLogs: Bool = false

    /// The `TimeInterval` after which a new log file will be created (and the old one will be deleted)
    ///
    /// default is ```86400``` (1 day)
    public var maxTimeInterval: TimeInterval = 86_400

    /// The `DateFormatter` which is used to format the date displayed in the log messages
    public var dateFormatter: DateFormatter?

    /// Determines if the log messages should also be written to Apple System Log
    public var writeToAppleSystemLog: Bool = false

    /// Determines if the log messages should also be written to a file
    public var writeToFile: Bool {
      logFilePath != nil
    }

    /// Determines if the log message should also be save to cloudKit database
    public var writeToCloudKit: Bool {
      switch mode {
      case .icloudKit:
        return true
      default:
        return false
      }
    }

    /// The path of the logfile
    var logFilePath: URL? {
      logFileFolder?.appendingPathComponent(logFileName)
    }
  }
}

extension PBSLogger.Configuration {
  var fileDestination: AutoRotatingFileDestination {
    if let path = logFileFolder?.path, let url = logFileFolder?.absoluteURL {
      if !FileManager.default.fileExists(atPath: path, isDirectory: nil) {
        do {
          try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        } catch {
          // Error handling
          debugPrint(error)
        }
      }
    }

    // Create a file log destination
    let filePath = logFileFolder?.appendingPathComponent(logFileName)

    let destination = AutoRotatingFileDestination(writeToFile: filePath as Any,
                                                  identifier: identifier + ".autoRotatingFileDestination",
                                                  shouldAppend: shouldAppendLogs,
                                                  appendMarker: "-- ** logger \(identifier) initialised and now logging ** --",
                                                  maxTimeInterval: maxTimeInterval,
                                                  archiveSuffixDateFormatter: dateFormatter)

    configure(destination: destination)

    // delete the previous log files
    destination.purgeArchivedLogFiles()

    // when the rotation is successful, delete the old archived files
    destination.autoRotationCompletion = { success in
      if success {
        destination.purgeArchivedLogFiles()
      }
    }

    // Process this destination in the background
    destination.logQueue = XCGLogger.logQueue
    return destination
  }

  var consoleDestination: ConsoleDestination {
    // Create a destination for the standard console
    let destination = ConsoleDestination(identifier: "\(identifier).ConsoleDestination")

    configure(destination: destination)

    return destination
  }

  var appleSystemLogDestination: AppleSystemLogDestination {
    let destination = AppleSystemLogDestination(identifier: "\(identifier).appleSystemLogDestination")
    configure(destination: destination)

    return destination
  }

  var cloudKitDestination: CloudKitDestination {
    // create a destination for the cloudkit destination
    let cloudKitDestination = CloudKitDestination(identifier: "\(identifier).CloudKitDestination")

    switch mode {
    case let .icloudKit(uniqueIdentifier):
      cloudKitDestination.uuid = uniqueIdentifier
    default:
      cloudKitDestination.uuid = ""
    }

    configure(destination: cloudKitDestination)
    return cloudKitDestination
  }

  private func configure(destination: BaseQueuedDestination) {
    // set the configuration options from the given configuration
    switch level {
    case .info:
      destination.outputLevel = .info

    case .verbose:
      destination.outputLevel = .debug

    case .none:
      destination.outputLevel = .none
    }

    destination.showLogIdentifier = showLogIdentifier
    destination.showFunctionName = showFunctionName
    destination.showThreadName = showThreadName
    destination.showLevel = showLevel
    destination.showFileName = showFileNames
    destination.showLineNumber = showLineNumbers
    destination.showDate = showDate
  }
}

extension PBSLogger.Configuration {
  static var `default` = PBSLogger.Configuration.makeConfiguration(identifier: Bundle.main.bundleIdentifier ?? "PBSLogger", level: .verbose)
}
