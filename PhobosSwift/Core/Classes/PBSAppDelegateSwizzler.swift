//
//
//  PBSAppDelegateSwizzler.swift
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
import GoogleUtilities

/// GULAppDelegateInterceptorID: Type alias of String
public typealias GULAppDelegateInterceptorID = String

@objcMembers
open class PBSAppDelegateSwizzler: GULAppDelegateSwizzler {
    
    @discardableResult
    override open class func registerAppDelegateInterceptor(_ interceptor:UIApplicationDelegate) -> GULAppDelegateInterceptorID? {
        let interceptorID = super.registerAppDelegateInterceptor(interceptor)
        
        if interceptor.responds(to: #selector(interceptor.applicationWillTerminate(_:))) {
            NotificationCenter.default.addObserver(interceptor,
                                                   selector: #selector(interceptor.applicationWillTerminate(_:)),
                                                   name: UIApplication.willTerminateNotification,
                                                   object: nil)
        }
        
        if interceptor.responds(to: #selector(interceptor.applicationDidBecomeActive(_:))) {
            NotificationCenter.default.addObserver(interceptor,
                                                   selector: #selector(interceptor.applicationDidBecomeActive(_:)),
                                                   name: UIApplication.didBecomeActiveNotification,
                                                   object: nil)
        }
        
        if interceptor.responds(to: #selector(interceptor.applicationDidEnterBackground(_:))) {
            NotificationCenter.default.addObserver(interceptor,
                                                   selector: #selector(interceptor.applicationDidEnterBackground(_:)),
                                                   name: UIApplication.didEnterBackgroundNotification,
                                                   object: nil)
        }
        
        if interceptor.responds(to: #selector(interceptor.applicationWillResignActive(_:))) {
            NotificationCenter.default.addObserver(interceptor,
                                                   selector: #selector(interceptor.applicationWillResignActive(_:)),
                                                   name: UIApplication.willResignActiveNotification,
                                                   object: nil)
        }
        
        if interceptor.responds(to: #selector(interceptor.applicationWillEnterForeground(_:))) {
            NotificationCenter.default.addObserver(interceptor,
                                                   selector: #selector(interceptor.applicationWillEnterForeground(_:)),
                                                   name: UIApplication.willEnterForegroundNotification,
                                                   object: nil)
        }
        
        return interceptorID
    }
    
    override open class func unregisterAppDelegateInterceptor(withID interceptorID:GULAppDelegateInterceptorID) {
        if let interceptor = GULAppDelegateSwizzler.interceptor(withID: interceptorID) {
            NotificationCenter.default.removeObserver(interceptor)
        }
        super.unregisterAppDelegateInterceptor(withID: interceptorID)
    }
}

extension GULAppDelegateSwizzler {
    
    private static let kInterceptors = "interceptors"
    private static let kObject = "object"
    
    static func interceptor(withID interceptorID:String) -> UIApplicationDelegate? {
        let selector = Selector(Self.kInterceptors)
        
        if GULAppDelegateSwizzler.responds(to: selector) {
            guard let interceptorsMapping = GULAppDelegateSwizzler.perform(selector) else {
                return nil
            }
            
            if let gulDictionary = interceptorsMapping.takeUnretainedValue() as? GULMutableDictionary,
               let interceptor = gulDictionary.object(forKey: interceptorID) as? NSObject {
                return interceptor.value(forKey: Self.kObject) as? UIApplicationDelegate
            }
        }
        
        return nil
    }
 
}
