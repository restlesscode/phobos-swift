//
//
//  FileManager.swift
//  PhobosSwiftCore
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
import PhobosSwiftLog

extension FileManager: PhobosSwiftCompatible {}

extension PhobosSwift where Base: FileManager {
  /// 返回Libary中的path
  ///
  public static func path(inLibrary name: String, withExtension: String) -> URL? {
    FileManager.pbs.userLibraryUrl?.appendingPathComponent("\(name).\(withExtension)")
  }

  /// 返回Documents中的path
  ///
  public static func path(inDocuments name: String, withExtension: String) -> URL? {
    FileManager.pbs.userDocumentsUrl?.appendingPathComponent("\(name).\(withExtension)")
  }

  /// 返回MainBundle的path
  ///
  public static func path(inBundle bundle: Bundle = .main, name: String, withExtension: String) -> URL? {
    bundle.url(forResource: name, withExtension: withExtension)
  }

  /// documents path
  public static var userDocumentsUrl: URL? {
    var url: URL?
    do {
      url = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
    } catch {
      PBSLogger.logger.error(message: error.localizedDescription, context: "Get User Documents Path")
    }

    return url
  }

  /// get app library path
  public static var userLibraryUrl: URL? {
    var url: URL?
    do {
      url = try FileManager.default.url(for: .libraryDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
    } catch {
      PBSLogger.logger.error(message: error.localizedDescription, context: "Get App Library Path")
    }

    return url
  }
}
