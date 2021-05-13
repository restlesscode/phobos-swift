//
//
//  FBSVersion.swift
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

/// Version for major.minor.patch
public struct FBSVersion {
  public var major: Int32 = 0
  public var minor: Int32 = 0
  public var patch: Int32 = 0
  
  public init(major: Int32, minor: Int32, patch: Int32) {
    self.major = major
    self.minor = minor
    self.patch = patch
  }
  
  public static func makeVersion(from version: String?) -> FBSVersion {
    guard let v = version?.split(separator: Character(".")) else {
      return .zero
    }
    
    let major = Int32(v[0]) ?? 0
    let minor = Int32(v[1]) ?? 0
    let patch = Int32(v[2]) ?? 0
    
    return FBSVersion(major: major, minor: minor, patch: patch)
  }
  
  public static var zero = FBSVersion(major: 0, minor: 0, patch: 0)
  
  public var string: String {
    return "\(major).\(minor).\(patch)"
  }
}

/// 对比版本号，判断是否 lhs > rhs 版本号
public func > (lhs: FBSVersion, rhs: FBSVersion) -> Bool {
  return lhs.string.compare(rhs.string, options: .numeric) == ComparisonResult.orderedDescending
}

/// 对比版本号，判断是否 lhs < rhs 版本号
public func < (lhs: FBSVersion, rhs: FBSVersion) -> Bool {
  return lhs.string.compare(rhs.string, options: .numeric) == ComparisonResult.orderedAscending
}

/// 对比版本号，判断是否 lhs == rhs 版本号
public func == (lhs: FBSVersion, rhs: FBSVersion) -> Bool {
  return lhs.string == rhs.string
}
