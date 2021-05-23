//
//
//  Realm+Ex.swift
//  PhobosSwiftPersistence
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
import MirrorRealmSwift
import PhobosSwiftCore
import PhobosSwiftLog

let kAppGroupId = "AppGroupId"
let kRealm = "realm"

extension PBSLogger {
  static let logger = PBSLogger.shared
}

/// Realm 数据库的类型
public enum RealmType {
  /// app buudle 中拖入的realm文件
  /// Just remember — the app’s bundle is read-only; you can’t add new files to it or modify existing ones.
  case appBundle
  /// 在document中创建realm文件
  case document
  /// 在library中创建realm文件
  case library
  /// 在extension和container app共享目录中
  case appGroup
  /// 在memory中创建realm
  case memory
}

/// CodebaseRealm 对Realm的拓展，为了方便调用
extension Realm {
  /// default Realm, document
  ///
  public static var pbs_default: Realm? = Realm.pbs_makeRealm()

  /// Realm
  ///
  /// - parameter
  public static func pbs_makeRealm(schemaVersion: UInt64 = 0, identifier realmIdentifier: String? = nil,
                                   in type: RealmType = .document,
                                   objectTypes: [Object.Type]? = nil,
                                   migrationBlock: MigrationBlock? = nil,
                                   password: String? = nil) -> Realm? {
    var fileUrl: URL?
    let realmIdentifier = realmIdentifier ?? Bundle.main.bundleIdentifier ?? "PhobosSwiftPersistenceRealm"

    do {
      switch type {
      case .document:
        fileUrl = FileManager.pbs_path(inDocuments: realmIdentifier, withExtension: kRealm)
      case .library:
        fileUrl = FileManager.pbs_path(inLibrary: realmIdentifier, withExtension: kRealm)
      case .appBundle:
        fileUrl = FileManager.pbs_path(inBundle: Bundle.main, name: realmIdentifier, withExtension: kRealm)
      case .appGroup:
        if let appGroupId = Bundle.main.object(forInfoDictionaryKey: kAppGroupId) as? String {
          fileUrl = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier:
            appGroupId)?.appendingPathComponent(realmIdentifier)
        }
      case .memory:
        return try Realm(configuration: Realm.Configuration(inMemoryIdentifier: realmIdentifier,
                                                            migrationBlock: migrationBlock,
                                                            objectTypes: objectTypes))
      }

      let documentsConfig = Realm.Configuration(fileURL: fileUrl,
                                                encryptionKey: password?.pbs.sha512,
                                                schemaVersion: schemaVersion,
                                                migrationBlock: migrationBlock,
                                                objectTypes: objectTypes)
      PBSLogger.logger.debug(message: "Documents-folder Realm in: \(documentsConfig.fileURL!)", context: "Realm")
      let realm = try Realm(configuration: documentsConfig)
      return realm
    } catch {
      PBSLogger.logger.error(message: error.localizedDescription, context: "Realm")
      return nil
    }
  }
}
