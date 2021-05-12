//
//
//  PhobosSwiftCore.swift
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

let kInternalBuildVersion = "InternalBuildVersion"

///
@objcMembers
public class PhobosSwiftCore: NSObject {
    public static var codebaseInfoPath = "Phobos-Service-Info.plist"
    
    ///
    public static var shared = PhobosSwiftCore()
    
    public static var isRunningTest:Bool {
        return NSClassFromString("XCTest") != nil
    }
    
    /// 上次安装时 InternalBuildVersion
    public private(set) var previousInternalBuildVersion:String
    
    /// 当前 InternalBuildVersion
    public var currentInternalBuildVersion:String {
        /// 在获取当前安装时，InternalBuildVersion
        return codebaseInfo.internalBuildVersion
    }
    
    private let appDelegateSwizzler = PhobosSwiftCoreAppDelegateSwizzler()

    private override init() {
        self.previousInternalBuildVersion = UserDefaults.standard.string(forKey: kInternalBuildVersion) ?? "0.0.0"

        super.init()
        loadInfoPlist()
        appDelegateSwizzler.load(withDefaultCore: self)
    }
    
    deinit {
        appDelegateSwizzler.unload()
    }
    
    public var codebaseInfo: CodebaseInfo!
    
    public func checkInternalVersion(internalBuildVersion: (
        _ isUpgraded:Bool,
        _ previousVersion:String,
        _ currentVersion:String) -> Void) {

        let isUpgraded = currentInternalBuildVersion.pbs_laterVersionThan(previousInternalBuildVersion)
        internalBuildVersion(isUpgraded, previousInternalBuildVersion, currentInternalBuildVersion)
    }
    
    private func loadInfoPlist() {
        guard let infoPlistPath = Bundle.main.url(forResource: Self.codebaseInfoPath, withExtension: nil) else {
            fatalError("File \(Self.codebaseInfoPath) not exist, please add this file to Supporting Files")
        }
        
        guard let data = try? Data(contentsOf: infoPlistPath) else {
            fatalError("Data in \(Self.codebaseInfoPath) loaded in error")
        }
        
        guard let codebaseInfo = data.pbs_model(modelType: CodebaseInfo.self, decoderType: .propertyList) else {
            fatalError("Data in \(Self.codebaseInfoPath) loaded in error")
        }
        
        self.codebaseInfo = codebaseInfo
    }
    
}
