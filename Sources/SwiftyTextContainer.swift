//
//  SwiftyTextContainer.swift
//  SwiftyText
//
//  Created by apple on 2020/4/24.
//  Copyright © 2020 yinhe. All rights reserved.
//

import UIKit

/*
 size
 exclusionPaths
 numberOfLines
 truncationType
 truncationToken
 */
public class SwiftyTextContainer: NSObject {
    private lazy var lock: DispatchSemaphore = DispatchSemaphore(value: 1)
    
    private var _size: CGSize = .zero
    public var size: CGSize {
        set {
            lock.wait()
            _size = newValue
            lock.signal()
        }
        get {
            lock.wait()
            let s = _size
            lock.signal()
            return s
        }
    }
    
    
    
    private var _exclusionPaths: [UIBezierPath] = []
    public var exclusionPaths: [UIBezierPath] {
        set {
            lock.wait()
            _exclusionPaths = newValue
            lock.signal()
        }
        get {
            lock.wait()
            let p = _exclusionPaths
            lock.signal()
            return p
        }
    }
    
    
    
    private var _numberOfLines: Int = 0
    public var numberOfLines: Int {
        set {
            lock.wait()
            _numberOfLines = newValue
            lock.signal()
        }
        get {
            lock.wait()
            let n = _numberOfLines
            lock.signal()
            return n
        }
    }
    
    
    private var _truncationType: SwiftyTextTruncationType = .end
    public var truncationType: SwiftyTextTruncationType {
        set {
            lock.wait()
            _truncationType = newValue
            lock.signal()
        }
        get {
            lock.wait()
            let t = _truncationType
            lock.signal()
            return t
        }
    }
    
    
    
    private var _truncationToken: NSAttributedString?
    public var truncationToken: NSAttributedString? {
        set {
            lock.wait()
            _truncationToken = newValue
            lock.signal()
        }
        get {
            lock.wait()
            let t = _truncationToken
            lock.signal()
            return t
        }
    }
    
    public override init() {
        super.init()
    }
    
    public class func container(with size: CGSize) -> SwiftyTextContainer {
        let c = SwiftyTextContainer()
        c.size = size
        return c
    }
}

extension SwiftyTextContainer: NSCopying {
    public func copy(with zone: NSZone? = nil) -> Any {
        let c = SwiftyTextContainer()
        lock.wait()
        c._size = _size
        c._exclusionPaths = _exclusionPaths
        c._numberOfLines = _numberOfLines
        c._truncationType = _truncationType
        c.truncationToken = _truncationToken
        lock.signal()
        return c
    }
}
