//
//  Array+SwiftyText.swift
//  SwiftyText
//
//  Created by apple on 2020/4/24.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation
import CoreGraphics

internal extension Array where Element == CGRect {
    func st_rects_union() -> CGRect  {
        var unionRect: CGRect = .zero
        for (i, rect) in self.enumerated() {
            if i == 0 {
                unionRect = rect
            } else {
                unionRect = unionRect.union(rect)
            }
        }
        return unionRect
    }
}

internal extension Array where Element == NSRange {
    func st_ranges_union() -> NSRange  {
        var unionRange: NSRange = NSRange(location: 0, length: 0)
        for (i, range) in self.enumerated() {
            if i == 0 {
                unionRange = range
            } else {
                unionRange = unionRange.union(range)
            }
        }
        return unionRange
    }
}
