//
//  SwiftyTextRunDelegate.swift
//  SwiftyText
//
//  Created by apple on 2020/4/24.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation
import CoreText

public struct SwiftyTextRunDelegate {
    public let ascent: CGFloat
    public let descent: CGFloat
    public let width: CGFloat
    public let userInfo: [String: Any]?
    
    public init(ascent: CGFloat, descent: CGFloat, width: CGFloat, userInfo: [String: Any]? = nil) {
        self.ascent = ascent
        self.descent = descent
        self.width = width
        self.userInfo = userInfo
    }
}

extension SwiftyTextRunDelegate {
    public func getRunDelegate() -> CTRunDelegate? {
        var callBacks = CTRunDelegateCallbacks(version: kCTRunDelegateCurrentVersion, dealloc: { (ref) in
            st_text_dealloc(ref: ref)
        }, getAscent: { (ref) -> CGFloat in
            return st_text_getAscent(ref: ref)
        }, getDescent: { (ref) -> CGFloat in
            return st_text_getDescent(ref: ref)
        }) { (ref) -> CGFloat in
            return st_text_getWidth(ref: ref)
        }
        // size:实际占用内存大小
        // stride:分配的内存大小
        // alignment:内存对齐参数
        let pointer = UnsafeMutableRawPointer.allocate(byteCount: MemoryLayout<SwiftyTextRunDelegate>.stride(ofValue: self), alignment: MemoryLayout<SwiftyTextRunDelegate>.alignment(ofValue: self))
        pointer.storeBytes(of: self, as: SwiftyTextRunDelegate.self)
        return CTRunDelegateCreate(&callBacks, pointer)
    }
}

private func st_text_getDescent(ref: UnsafeMutableRawPointer) -> CGFloat {
    let delegate: SwiftyTextRunDelegate = ref.load(as: SwiftyTextRunDelegate.self)
    return delegate.descent
}

private func st_text_getWidth(ref: UnsafeMutableRawPointer) -> CGFloat {
    let delegate: SwiftyTextRunDelegate = ref.load(as: SwiftyTextRunDelegate.self)
    return delegate.width
}

private func st_text_getAscent(ref: UnsafeMutableRawPointer) -> CGFloat {
    let delegate: SwiftyTextRunDelegate = ref.load(as: SwiftyTextRunDelegate.self)
    return delegate.ascent
}

private func st_text_dealloc(ref: UnsafeMutableRawPointer) {
    ref.deallocate()
}
