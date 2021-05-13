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

import PhobosSwiftCore

private let kDefalutLogIdentifier = "defalutLogIdentifier"
private let kDefaultDirectoryDocuments = "Documents"
private let kDefaultAppMakerString = "-- Relauched App --"

/// Log Mode
public enum LogMode {
  /// Log to file
  case file
  /// Log to icloud
  case iCloud
  /// Log to memory
  case memory
}

@objcMembers
open class PBSLog: XCGLogger {
  /// Default Log, take it as singleton
  public static let defalut = PBSLog(identifier: kDefalutLogIdentifier, level: .debug, mode: .file)

  /// 初始化方法
  /// - Parameters:
  ///     - identifier: 不同的BU使用不同的identifier，开启日志文件后也会以identifier为文件名，以便区分
  ///     - level: 决定log实例的级别，只有小于等于该level的log会被打印
  public init(identifier: String? = nil, level: Level = .debug, mode: LogMode = .file) {
    self.mode = mode

    let _identifier = identifier ?? kDefalutLogIdentifier
    super.init(identifier: _identifier, includeDefaultDestinations: false)

    add(destination: AppleSystemLogDestination(identifier: "\(_identifier).appleSystemLogDestination"))
    outputLevel = level
    logAppDetails()

    switch self.mode {
    case .file,
         .iCloud:
      add(destination: autoRotatingFileDestination)
      logAppDetails()
    case .memory:
      remove(destinationWithIdentifier: "\(_identifier).autoRotatingFileDestination")
    }
  }

  /// maxFileSize, default is 1 megabyte
  /// maxTimeInterval, default is 1 day
  /// targetMaxLogFiles, default is 10, max is 255
  private lazy var autoRotatingFileDestination: AutoRotatingFileDestination = {
    var logPath = AutoRotatingFileDestination.defaultLogFolderURL.appendingPathComponent("\(identifier).log")

    if let documentsPath: URL = self.iCloudDocumentURL, mode == .iCloud {
      logPath = documentsPath.appendingPathComponent("\(identifier).log")
    }

    let logConfigure = loadInfoPlist()
    let autoRotatingFileDestination = AutoRotatingFileDestination(writeToFile: logPath,
                                                                  identifier: "\(identifier).autoRotatingFileDestination",
                                                                  shouldAppend: true,
                                                                  attributes: [.protectionKey: FileProtectionType.completeUntilFirstUserAuthentication],
                                                                  maxFileSize: logConfigure?.maxFileSize ?? 1024 * 1024,
                                                                  maxTimeInterval: logConfigure?.maxTimeInterval ?? 60 * 60 * 24,
                                                                  targetMaxLogFiles: logConfigure?.maxLogFiles ?? 10)

    // Optionally set some configuration options
    autoRotatingFileDestination.outputLevel = self.outputLevel
    autoRotatingFileDestination.showThreadName = true
    autoRotatingFileDestination.appendMarker = kDefaultAppMakerString
    // Process this destination in the background
    autoRotatingFileDestination.logQueue = XCGLogger.logQueue
    return autoRotatingFileDestination
  }()

  /// iCloudDocument url, only once
  private lazy var iCloudDocumentURL: URL? = {
    guard let iCloudContainerIdentifier = PBSCore.shared.serviceInfo.log?.iCloudContainerIdentifier else {
      return nil
    }

    guard let url = FileManager.default.url(forUbiquityContainerIdentifier: iCloudContainerIdentifier) else {
      return nil
    }

    return url.appendingPathComponent(kDefaultDirectoryDocuments)
  }()

  /// 决定是否存入日志文件
  private var mode: LogMode

  /// 决定是否开始Emoji符号，方便查看
  open var enableEmoji: Bool = false {
    didSet {
      if enableEmoji {
        // You can use emoji to highlight log levels (you probably just want to use one of these methods at a time).
        let emojiLogFormatter = PrePostFixLogFormatter()
        emojiLogFormatter.apply(prefix: "🗯🗯🗯 ", postfix: " 🗯🗯🗯", to: .verbose)
        emojiLogFormatter.apply(prefix: "🔹🔹🔹 ", postfix: " 🔹🔹🔹", to: .debug)
        emojiLogFormatter.apply(prefix: "ℹ️ℹ️ℹ️ ", postfix: " ℹ️ℹ️ℹ️", to: .info)
        emojiLogFormatter.apply(prefix: "⚠️⚠️⚠️ ", postfix: " ⚠️⚠️⚠️", to: .warning)
        emojiLogFormatter.apply(prefix: "‼️‼️‼️ ", postfix: " ‼️‼️‼️", to: .error)
        emojiLogFormatter.apply(prefix: "💣💣💣 ", postfix: " 💣💣💣", to: .severe)
        formatters = [emojiLogFormatter]
      } else {
        formatters = nil
      }
    }
  }

  func loadInfoPlist() -> PhobosLogInfo? {
    PBSCore.shared.serviceInfo.log
  }
}
