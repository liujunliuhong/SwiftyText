//
//  SwiftyTextLine.swift
//  SwiftyText
//
//  Created by apple on 2020/4/23.
//  Copyright © 2020 yinhe. All rights reserved.
//

import UIKit
import CoreText

public class SwiftyTextLine: NSObject {
    
    
    private var _line: CTLine?
    public private(set) var line: CTLine? {
        get {
            return _line
        }
        set {
            if _line != newValue {
                _line = newValue
            }
        }
    }
    
    public private(set) var position: CGPoint = .zero
    public private(set) var width: CGFloat = 0.0
    public private(set) var ascent: CGFloat = 0.0
    public private(set) var descent: CGFloat = 0.0
    public private(set) var leading: CGFloat = 0.0
    public private(set) var range: NSRange = NSMakeRange(0, 0)
    public private(set) var trailingWhitespaceWidth: CGFloat = 0.0
    public private(set) var rect: CGRect = .zero
    
    public private(set) var firstRunFirstGlyphPosition: CGFloat = 0.0
    
    public private(set) var attachments: [YHTextAttachment] = []
    public private(set) var attachmentRanges: [NSRange] = []
    public private(set) var attachmentRects: [CGRect] = []
    
    public private(set) var runs: [CTRun] = []
    public private(set) var runRects: [CGRect] = []
    
    
    public var index: Int = 0
    public var row: Int = 0
    
    
    private override init() {
        super.init()
    }
    
    
    public class func line(with ctLine: CTLine, position: CGPoint) -> SwiftyTextLine {
        let line = SwiftyTextLine()
        line.line = ctLine
        line.position = position
        return line
    }
}

extension SwiftyTextLine {
    
}

extension SwiftyTextLine {
    
}
