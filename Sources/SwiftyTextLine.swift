//
//  SwiftyTextLine.swift
//  SwiftyText
//
//  Created by apple on 2020/4/23.
//  Copyright © 2020 yinhe. All rights reserved.
//

import UIKit
import CoreText

/// CTLine wraped
public class SwiftyTextLine: NSObject {
    
    private var _line: CTLine?
    public private(set) var line: CTLine? {
        get {
            return _line
        }
        set {
            if _line != newValue {
                _line = newValue
                self.setLine(line: newValue)
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
    
    public private(set) var attachments: [SwiftyTextAttachment] = []
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
        line.position = position
        line.line = ctLine
        return line
    }
}

extension SwiftyTextLine {
    private func setLine(line: CTLine?) {
        if let line = line {
            self.width = CGFloat(CTLineGetTypographicBounds(line, &self.ascent, &self.descent, &self.leading))
            // 获取一行未尾字符后空格的像素长度。如果："abc  "后面有两个空格，返回的就是这两个空格占有的像素长度
            self.trailingWhitespaceWidth = CGFloat(CTLineGetTrailingWhitespaceWidth(line))
            
            let lineRange: CFRange = CTLineGetStringRange(line)
            self.range = NSMakeRange(lineRange.location, lineRange.length)
            
            let glyphCount: CFIndex = CTLineGetGlyphCount(line) // line的字数
            
            // 获取当前Line的第一个run的第一个String的位置
            if glyphCount > 0 {
                let runs: CFArray = CTLineGetGlyphRuns(line)
                let firstRunPointer: UnsafeRawPointer = CFArrayGetValueAtIndex(runs, 0)
                let firstRun: CTRun = unsafeBitCast(firstRunPointer, to: CTRun.self)
                var firstRunFirstGlyphPosition: CGPoint = .zero
                CTRunGetPositions(firstRun, CFRange(location: 0, length: 1), &firstRunFirstGlyphPosition)
                self.firstRunFirstGlyphPosition = firstRunFirstGlyphPosition.x
            }
        } else {
            self.trailingWhitespaceWidth = 0.0
            self.firstRunFirstGlyphPosition = 0.0
            self.leading = 0.0
            self.ascent = 0.0
            self.descent = 0.0
            self.width = 0.0
            self.range = NSRange(location: 0, length: 0)
        }
        self.caculateRect()
        self.caculateRuns()
    }
}

extension SwiftyTextLine {
    private func caculateRect()  {
        var rect = CGRect(x: self.position.x, y: self.position.y - self.ascent, width: self.width, height: self.ascent + self.descent)
        rect.origin.x += self.firstRunFirstGlyphPosition
        self.rect = rect
    }
    
    private func caculateRuns() {
        self.runs.removeAll()
        self.runRects.removeAll()
        self.attachments.removeAll()
        self.attachmentRanges.removeAll()
        self.attachmentRects.removeAll()
        
        guard let line = self.line else { return }
        let runs: CFArray = CTLineGetGlyphRuns(line)
        let runCount: CFIndex = CFArrayGetCount(runs)
        
        if runCount == 0 {
            return
        }
        
        for index in 0..<runCount {
            let runPointer: UnsafeRawPointer = CFArrayGetValueAtIndex(runs, index)
            let run: CTRun = unsafeBitCast(runPointer, to: CTRun.self)
            
            let glyphCount: CFIndex = CTRunGetGlyphCount(run)
            if glyphCount == 0 {
                continue
            }
            
            var ascent: CGFloat = 0.0
            var descent: CGFloat = 0.0
            var leading: CGFloat = 0.0
            var position: CGPoint = .zero
            
            CTRunGetPositions(run, CFRangeMake(0, 1), &position)
            
            let runRange: CFRange = CTRunGetStringRange(run)
            
            let width: CGFloat = CGFloat(CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, &leading))
            
            
            position.x = self.position.x + position.x
            position.y = self.position.y - position.y
            
            let rect: CGRect = CGRect(x: position.x, y: position.y - ascent, width: width, height: ascent + descent)
            
            self.runs.append(run)
            self.runRects.append(rect)
            
            // attachment
            if let runAttributes = CTRunGetAttributes(run) as? [NSAttributedString.Key : Any],
            let attachment = runAttributes[NSMutableAttributedString.Key.stAttachmentAttributeName] as? SwiftyTextAttachment {
                self.attachments.append(attachment)
                self.attachmentRanges.append(NSRange(location: runRange.location, length: runRange.length))
                self.attachmentRects.append(rect)
            }
        }
    }
}
