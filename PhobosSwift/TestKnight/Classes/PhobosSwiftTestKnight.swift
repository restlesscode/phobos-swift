//
//
//  PhobosSwiftTestKnight.swift
//  PhobosSwiftTestKnight
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
import PhobosSwiftCore
import PhobosSwiftLog

extension Bundle {
  static var bundle: Bundle {
    Bundle.pbs.bundle(with: PhobosSwiftTestKnight.self)
  }

  static var bundleName: String {
    Bundle.main.infoDictionary?["CFBundleName"] as? String ?? "Test Knight"
  }
}

extension String {
  var localized: String {
    pbs.localized(inBundle: Bundle.bundle)
  }
}

///
extension PhobosSwift where Base == String {
  ///
  public var tkString: String {
    "\(PBSTestKnight.shared.configuration.name).\(self)"
  }
}

extension PBSLogger {
  static var logger = PBSLogger.shared
}

extension UIImage {
  static func image(named name: String) -> UIImage {
    let emptyImage = UIImage.pbs.makeImage(from: .clear)
    return UIImage(named: name, in: Bundle.bundle, compatibleWith: nil) ?? emptyImage
  }
}

struct Resource {
  struct Image {
    static let kDebug = UIImage.image(named: "debug")
    static let kStaging = UIImage.image(named: "staging")
    static let kPreproduction = UIImage.image(named: "preproduction")
    static let kRelease = UIImage.image(named: "release")
  }
}

struct Strings {
  static let kWelcomTitle = "Welcome to Test \n\(Bundle.bundleName)"
  static let kStartTesting = "Start Testing"
  static let kDebug = "Development"
  static let kStaging = "Staging"
  static let kPreproduction = "Preproduction"
  static let kRelease = "Production"
  static let kDebugDescription = "Current enviornment will be connected to `Development`"
  static let kStagingDescription = "Current enviornment will be connected to `Staging`"
  static let kPreproductionDescription = "Current enviornment will be connected to `Preproduction`"
  static let kReleaseDescription = "Current enviornment will be connected to `Production`"
}

extension PhobosSwift where Base == UserDefaults {
  /**
   -objectForKey: will search the receiver's search list for a default with the key 'defaultName' and return it. If another process has changed defaults in the search list, NSUserDefaults will automatically update to the latest values. If the key in question has been marked as ubiquitous via a Defaults Configuration File, the latest value may not be immediately available, and the registered value will be returned instead.
   */
  public func tk_object(forKey defaultName: String) -> Any? {
    let key = "\(PBSTestKnight.shared.configuration.name).\(defaultName)"
    return base.object(forKey: key)
  }

  /**
   -setObject:forKey: immediately stores a value (or removes the value if nil is passed as the value) for the provided key in the search list entry for the receiver's suite name in the current user and any host, then asynchronously stores the value persistently, where it is made available to other processes.
   */
  public func tk_set(_ value: Any?, forKey defaultName: String) {
    let key = "\(PBSTestKnight.shared.configuration.name).\(defaultName)"
    base.set(value, forKey: key)
  }

  /// -removeObjectForKey: is equivalent to -[... setObject:nil forKey:defaultName]
  public func tk_removeObject(forKey defaultName: String) {
    let key = "\(PBSTestKnight.shared.configuration.name).\(defaultName)"
    base.removeObject(forKey: key)
  }

  /// -stringForKey: is equivalent to -objectForKey:, except that it will convert NSNumber values to their NSString representation. If a non-string non-number value is found, nil will be returned.
  func tk_string(forKey defaultName: String) -> String? {
    let key = "\(PBSTestKnight.shared.configuration.name).\(defaultName)"
    return base.string(forKey: key)
  }

  /// -arrayForKey: is equivalent to -objectForKey:, except that it will return nil if the value is not an NSArray.
  public func tk_array(forKey defaultName: String) -> [Any]? {
    let key = "\(PBSTestKnight.shared.configuration.name).\(defaultName)"
    return base.array(forKey: key)
  }

  /// -dictionaryForKey: is equivalent to -objectForKey:, except that it will return nil if the value is not an NSDictionary.
  public func tk_dictionary(forKey defaultName: String) -> [String: Any]? {
    let key = "\(PBSTestKnight.shared.configuration.name).\(defaultName)"
    return base.dictionary(forKey: key)
  }

  /// -dataForKey: is equivalent to -objectForKey:, except that it will return nil if the value is not an NSData.
  public func tk_data(forKey defaultName: String) -> Data? {
    let key = "\(PBSTestKnight.shared.configuration.name).\(defaultName)"
    return base.data(forKey: key)
  }

  /// -stringForKey: is equivalent to -objectForKey:, except that it will return nil if the value is not an NSArray<NSString *>. Note that unlike -stringForKey:, NSNumbers are not converted to NSStrings.
  public func tk_stringArray(forKey defaultName: String) -> [String]? {
    let key = "\(PBSTestKnight.shared.configuration.name).\(defaultName)"
    return base.stringArray(forKey: key)
  }

  /**
   -integerForKey: is equivalent to -objectForKey:, except that it converts the returned value to an NSInteger. If the value is an NSNumber, the result of -integerValue will be returned. If the value is an NSString, it will be converted to NSInteger if possible. If the value is a boolean, it will be converted to either 1 for YES or 0 for NO. If the value is absent or can't be converted to an integer, 0 will be returned.
   */
  public func tk_integer(forKey defaultName: String) -> Int {
    let key = "\(PBSTestKnight.shared.configuration.name).\(defaultName)"
    return base.integer(forKey: key)
  }

  /// -floatForKey: is similar to -integerForKey:, except that it returns a float, and boolean values will not be converted.
  public func tk_float(forKey defaultName: String) -> Float {
    let key = "\(PBSTestKnight.shared.configuration.name).\(defaultName)"
    return base.float(forKey: key)
  }

  /// -doubleForKey: is similar to -integerForKey:, except that it returns a double, and boolean values will not be converted.
  public func tk_double(forKey defaultName: String) -> Double {
    let key = "\(PBSTestKnight.shared.configuration.name).\(defaultName)"
    return base.double(forKey: key)
  }

  /**
   -boolForKey: is equivalent to -objectForKey:, except that it converts the returned value to a BOOL. If the value is an NSNumber, NO will be returned if the value is 0, YES otherwise. If the value is an NSString, values of "YES" or "1" will return YES, and values of "NO", "0", or any other string will return NO. If the value is absent or can't be converted to a BOOL, NO will be returned.

   */
  public func tk_bool(forKey defaultName: String) -> Bool {
    let key = "\(PBSTestKnight.shared.configuration.name).\(defaultName)"
    return base.bool(forKey: key)
  }

  /**
   -URLForKey: is equivalent to -objectForKey: except that it converts the returned value to an NSURL. If the value is an NSString path, then it will construct a file URL to that path. If the value is an archived URL from -setURL:forKey: it will be unarchived. If the value is absent or can't be converted to an NSURL, nil will be returned.
   */
  public func tk_url(forKey defaultName: String) -> URL? {
    let key = "\(PBSTestKnight.shared.configuration.name).\(defaultName)"
    return base.url(forKey: key)
  }

  /// -setInteger:forKey: is equivalent to -setObject:forKey: except that the value is converted from an NSInteger to an NSNumber.
  public func tk_set(_ value: Int, forKey defaultName: String) {
    let key = "\(PBSTestKnight.shared.configuration.name).\(defaultName)"
    base.set(value, forKey: key)
  }

  /// -setFloat:forKey: is equivalent to -setObject:forKey: except that the value is converted from a float to an NSNumber.
  public func tk_set(_ value: Float, forKey defaultName: String) {
    let key = "\(PBSTestKnight.shared.configuration.name).\(defaultName)"
    base.set(value, forKey: key)
  }

  /// -setDouble:forKey: is equivalent to -setObject:forKey: except that the value is converted from a double to an NSNumber.
  public func tk_set(_ value: Double, forKey defaultName: String) {
    let key = "\(PBSTestKnight.shared.configuration.name).\(defaultName)"
    base.set(value, forKey: key)
  }

  /// -setBool:forKey: is equivalent to -setObject:forKey: except that the value is converted from a BOOL to an NSNumber.
  public func tk_set(_ value: Bool, forKey defaultName: String) {
    let key = "\(PBSTestKnight.shared.configuration.name).\(defaultName)"
    base.set(value, forKey: key)
  }

  /// -setURL:forKey is equivalent to -setObject:forKey: except that the value is archived to an NSData. Use -URLForKey: to retrieve values set this way.
  public func tk_set(_ url: URL?, forKey defaultName: String) {
    let key = "\(PBSTestKnight.shared.configuration.name).\(defaultName)"
    base.set(url, forKey: key)
  }
}

class PhobosSwiftTestKnight: NSObject {}
