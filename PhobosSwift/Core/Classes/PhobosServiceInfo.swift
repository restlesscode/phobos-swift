//
//
//  PhobosServiceInfo.swift
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

import UIKit

public struct PBSPushSDKTypes: OptionSet, Codable {
    public let rawValue: UInt8
    
    public init(rawValue: UInt8) {
        self.rawValue = rawValue
    }
    
    public static let server = PBSPushSDKTypes(rawValue: 1 << 0)
    public static let umeng = PBSPushSDKTypes(rawValue: 1 << 1)
    public static let firebase = PBSPushSDKTypes(rawValue: 1 << 2)
    public static let aliyun = PBSPushSDKTypes(rawValue: 1 << 3)
    public static let all: PBSPushSDKTypes = [.server, .umeng, .firebase, .aliyun]
}

public struct DefaultServer: Codable {
    public let url:String?
    enum CodingKeys: String, CodingKey {
        case url = "URL"
    }
    var type:PBSPushSDKTypes {
        return .server
    }
}

public struct UMeng: Codable {
    public let appkey:String?
    enum CodingKeys: String, CodingKey {
        case appkey = "AppKey"
    }
    var type:PBSPushSDKTypes {
        return .umeng
    }
}

public struct Firebase: Codable {
    public let appkey:String?
    enum CodingKeys: String, CodingKey {
        case appkey = "AppKey"
    }
    var type:PBSPushSDKTypes {
        return .firebase
    }
}

public struct Aliyun: Codable {
    public let appkey:String?
    public let appSecret:String?
    enum CodingKeys: String, CodingKey {
        case appkey = "AppKey"
        case appSecret = "AppSecret"
    }
    var type:PBSPushSDKTypes {
        return .aliyun
    }
}

public struct CodebasePushInfo: Codable {
    public let defaultServer:DefaultServer?
    public let umeng:UMeng?
    public let firebase:Firebase?
    public let aliyun:Aliyun?
    
    enum CodingKeys: String, CodingKey {
        case defaultServer = "DefaultServer"
        case umeng = "UMeng"
        case firebase = "Firebase"
        case aliyun = "Aliyun"
    }
}

public struct CodebaseLogInfo: Codable {
    public let maxFileSize:UInt64
    public let maxTimeInterval:TimeInterval
    public let maxLogFiles:UInt8
    public let iCloudContainerIdentifier:String?
    
    enum CodingKeys: String, CodingKey {
        case maxFileSize = "MaxFileSize"
        case maxTimeInterval = "MaxTimeInterval"
        case maxLogFiles = "MaxLogFiles"
        case iCloudContainerIdentifier
    }
}

public struct BuglyInfo: Codable {
    public let appId: String
    
    enum CodingKeys: String, CodingKey {
        case appId = "AppId"
    }
}

public struct PgyerInfo: Codable {
    public let apiKey: String
    public let appKey: String

    enum CodingKeys: String, CodingKey {
        case apiKey = "ApiKey"
        case appKey = "AppKey"
    }
}

public struct CodebaseInfo: Codable {
    public let plistVersion: String
    public let internalBuildVersion: String
    public let codebaseLog: CodebaseLogInfo?
    public let codebasePush: CodebasePushInfo?
    public let bugly: BuglyInfo?
    public let pgyer: PgyerInfo?

    enum CodingKeys: String, CodingKey {
        case plistVersion = "PlistVersion"
        case internalBuildVersion = "InternalBuildVersion"
        case codebaseLog = "CodebaseLog"
        case codebasePush = "CodebasePush"
        case bugly = "Bugly"
        case pgyer = "Pgyer"
    }
}
