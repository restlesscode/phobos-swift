//
//
//  DispatchQueue.swift
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

///
extension DispatchQueue {
    private static var _onceTracker = [String]()
    
    /// 封装了dispatch_once
    public class func pbs_once(file: String = #file, function: String = #function, line: Int = #line, block:() -> Void) {
        let token = file + ":" + function + ":" + String(line)
        DispatchQueue.pbs_once(token: token, block: block)
    }
    
    /// Executes a block of code, associated with a unique token, only once.  The code is thread safe and will
    /// only execute the code once even in the presence of multithreaded calls.
    ///
    /// - parameter token: A unique reverse DNS style name such as com.vectorform.<name> or a GUID
    /// - parameter block: Block to execute once
    public class func pbs_once(token: String, block:() -> Void) {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        
        
        if _onceTracker.contains(token) {
            return
        }
        
        _onceTracker.append(token)
        block()
    }
}



public struct Mutex<Base> {
    
    /// Base object to extend.
    public var base: Base
    /// Creates extensions with base object.
    ///
    /// - parameter base: Base object.
    public init(_ base: Base) {
        self.base = base
    }
    
    public func nonatomic(_ token: String) -> Self.MutexDispatch {
        return Self.MutexDispatch(token: token, atomic: false)
    }
    
    public func atomic(_ token: String) -> Self.MutexDispatch {
        return Self.MutexDispatch(token: token, atomic: false)
    }
    
    public struct MutexDispatch {
        private let token: String
        private let atomic: Bool
        
        public init(token:String, atomic:Bool) {
            self.token = token
            self.atomic = atomic
        }
        
        public var concurrent: Self.MutexQueque {
            let queue = DispatchQueue(label: token, attributes: .concurrent)
            return Self.MutexQueque(atomic: self.atomic, queue: queue)
        }
        
        public var serial: Self.MutexQueque {
            let queue = DispatchQueue(label: token)
            return Self.MutexQueque(atomic: self.atomic, queue: queue)
        }
        
        public struct MutexQueque {
            private let queue: DispatchQueue
            private let atomic: Bool
            
            init(atomic: Bool, queue: DispatchQueue) {
                self.atomic = atomic
                self.queue = queue
            }
            
            public func async(handler: @escaping () -> Void) {
                if self.atomic {
                    queue.async(flags: .barrier, execute: handler)
                } else {
                    queue.async(execute: handler)
                }
            }
            
            public func sync(handler: @escaping () -> Void) {
                if self.atomic {
                    queue.sync(flags: .barrier, execute: handler)
                } else {
                    queue.sync(execute: handler)
                }
            }
        }
    }

}

/// A type that has reactive extensions.
public protocol MutexCompatible {
    
    /// Extended type
    associatedtype MutexBase
    
    /// Mutex extensions.
    static var mux: Mutex<Self.MutexBase>.Type { get set }
    
    /// Reactive extensions.
    var mux: Mutex<Self.MutexBase> { get set }
}

extension MutexCompatible {
    
    /// Mutex extensions.
    public static var mux: Mutex<Self>.Type {
        get {
            return Mutex<Self>.self
        }
        set { }
    }
    
    /// Mutex extensions.
    public var mux: Mutex<Self> {
        get {
            return Mutex(self)
        }
        set { }
    }
}

extension NSObject: MutexCompatible { }

extension Array: MutexCompatible { }

extension Dictionary: MutexCompatible { }

extension String: MutexCompatible { }

extension Double: MutexCompatible { }

extension Int: MutexCompatible { }

/// Example
/*
 *
 let str = "hello"
 
 let token = UUID().uuidString
 str.mux.nonatomic(token).serial.async {
     
 }
 */



