//
//  SwiftyTextLayout.swift
//  SwiftyText
//
//  Created by apple on 2020/4/24.
//  Copyright © 2020 yinhe. All rights reserved.
//

import UIKit
import CoreText

public class SwiftyTextLayout: NSObject {
    public private(set) var attributedText: NSAttributedString?
    public private(set) lazy var textContainer: SwiftyTextContainer = SwiftyTextContainer()
    
    public private(set) var ctFramesetter: CTFramesetter!
    public private(set) var ctFrame: CTFrame!
    public private(set) var textRect: CGRect = .zero
    public private(set) var textSize: CGSize = .zero
    public private(set) var lines: [SwiftyTextLine] = []
    public private(set) var truncatedLine: SwiftyTextLine?
    
    public private(set) var attachments: [SwiftyTextAttachment] = []
    public private(set) var attachmentSet: NSMutableSet = NSMutableSet(array: [])
    
    public private(set) var rowCount: Int = 0
    public private(set) var visibleRange: NSRange = NSRange(location: 0, length: 0)
    
    public private(set) var isContainHighlight: Bool = false
    public private(set) var isNeedDrawText = false
    public private(set) var isNeedDrawBackgroundBorder = false
    public private(set) var isNeedDrawAttachment = false
    public private(set) var isNeedDrawStrikethrough = false
    public private(set) var isNeedDrawUnderline = false
    
    deinit {
        
    }
    
    private override init() {
        super.init()
    }
}

extension SwiftyTextLayout: NSCopying {
    public func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}

extension SwiftyTextLayout {
    public static func layout(containerSize: CGSize, attributedText: NSAttributedString?) -> SwiftyTextLayout? {
        let container = SwiftyTextContainer.container(with: containerSize)
        return SwiftyTextLayout.layout(container: container, attributedText: attributedText)
    }
    
    public static func layout(container: SwiftyTextContainer?, attributedText: NSAttributedString?) -> SwiftyTextLayout? {
        guard let container = container else {
            return nil
        }
        guard let attributedText = attributedText else {
            return nil
        }
        
        // check size
        if container.size.height.isEqual(to: CGFloat.greatestFiniteMagnitude) {
            container.size.height = SwiftyTextMaxSize.height
        }
        
        
        var cgPath: CGPath
        var cgPathBox = CGRect.zero
        var rowMaySeparated = false
        
        var textRect: CGRect = .zero
        
        var lines: [SwiftyTextLine] = []
        var lineOrigins: UnsafeMutablePointer<CGPoint>?
        var rowCount: Int = 0
        var lineCount: CFIndex = 0
        
        var isNeedTruncation: Bool = false
        var visibleRange: NSRange = NSRange(location: 0, length: 0)
        var truncationToken: NSAttributedString?
        var truncatedLine: SwiftyTextLine?
        
        let maximumNumberOfRows: Int = container.numberOfLines
        
        var attachments: [SwiftyTextAttachment] = []
        let attachmentSet: NSMutableSet = NSMutableSet(array: [])
        
        /*
         ┌────────────────┐
         │                │
         │      Path      │
         │                │
         └────────────────┘
         */
        if container.exclusionPaths.count == 0 {
            if container.size.width.isLessThanOrEqualTo(.zero) || container.size.height.isLessThanOrEqualTo(.zero) {
                lineOrigins?.deallocate()
                return nil
            }
            var rect: CGRect = CGRect(x: 0, y: 0, width: container.size.width, height: container.size.height)
            rect = rect.standardized
            cgPathBox = rect //
            rect = rect.applying(CGAffineTransform(scaleX: 1, y: -1))
            cgPath = CGPath(rect: rect, transform: nil) //
        } else {
            rowMaySeparated = true
            let rect: CGRect = CGRect(x: 0, y: 0, width: container.size.width, height: container.size.height)
            let path = CGPath(rect: rect, transform: nil)
            guard let mutablePath = path.mutableCopy() else {
                lineOrigins?.deallocate()
                return nil
            }
            // exclusionPaths
            for (_, exclusionPath) in container.exclusionPaths.enumerated() {
                mutablePath.addPath(exclusionPath.cgPath, transform: .identity)
            }
            cgPathBox = mutablePath.boundingBoxOfPath //
            var trans = CGAffineTransform(scaleX: 1, y: -1)
            guard let _cgPath = mutablePath.mutableCopy(using: &trans) else {
                lineOrigins?.deallocate()
                return nil
            }
            cgPath = _cgPath //
        }
        
        
        
        /*
         ┌────────────────┐
         │                │
         │   Core Text    │
         │                │
         └────────────────┘
         */
        let ctFramesetter: CTFramesetter = CTFramesetterCreateWithAttributedString(attributedText)
        let ctFrame: CTFrame = CTFramesetterCreateFrame(ctFramesetter, CFRange(location: 0, length: attributedText.length), cgPath, nil)
        let ctLines: CFArray = CTFrameGetLines(ctFrame)
        lineCount = CFArrayGetCount(ctLines)
        if lineCount <= 0 {
            lineOrigins?.deallocate()
            return nil
        }
        
        
        
        
        /*
         ┌────────────────┐
         │                │
         │  Line Origins  │
         │                │
         └────────────────┘
         */
        let _lineOrigins = UnsafeMutablePointer<CGPoint>.allocate(capacity: lineCount)
        CTFrameGetLineOrigins(ctFrame, CFRange(location: 0, length: 0), _lineOrigins)
        lineOrigins = _lineOrigins
        if lineOrigins == nil {
            lineOrigins?.deallocate()
            return nil
        }
        
        
        
        /*
         ┌────────────────┐
         │                │
         │   Basic Info   │
         │                │
         └────────────────┘
         */
        var lastLinePosition: CGPoint = CGPoint(x: 0, y: -CGFloat.greatestFiniteMagnitude)
        var lastLineRect: CGRect = CGRect(x: 0, y: -CGFloat.greatestFiniteMagnitude, width: 0, height: 0)
        var rowIndex: Int = -1
        var lineIndex: Int = 0
        
        for index in 0..<lineCount {
            let ctLine: CTLine = unsafeBitCast(CFArrayGetValueAtIndex(ctLines, index), to: CTLine.self)
            let ctRuns: CFArray = CTLineGetGlyphRuns(ctLine)
            if CFArrayGetCount(ctRuns) == 0 { continue }
            
            // CoreText coordinate system
            let ctLineOrigin: CGPoint = lineOrigins![index]
            
            // UIKit coordinate system
            var linePosition: CGPoint = .zero
            linePosition.x = cgPathBox.origin.x + ctLineOrigin.x
            linePosition.y = cgPathBox.size.height + cgPathBox.origin.y - ctLineOrigin.y
            
            let line: SwiftyTextLine = SwiftyTextLine.line(with: ctLine, position: linePosition)
            let lineRect: CGRect = line.rect
            
            var isNewRow: Bool = true
            if rowMaySeparated && linePosition.x != lastLinePosition.x {
                if lineRect.size.height > lastLineRect.size.height {
                    if lineRect.origin.y < lastLinePosition.y &&
                        lastLinePosition.y < lineRect.origin.y + lineRect.size.height {
                        isNewRow = false
                    }
                } else {
                    if lastLineRect.origin.y < linePosition.y &&
                        linePosition.y < lastLineRect.origin.y + lastLineRect.size.height {
                        isNewRow = false
                    }
                }
            }
            
            if isNewRow {
                rowIndex = rowIndex + 1 // If it's a new row, then add 1 to rowIndex
            }
            lastLineRect = lineRect
            lastLinePosition = linePosition
            
            line.index = lineIndex
            line.row = rowIndex
            lines.append(line)
            
            // rowCount <= lineCount
            rowCount = rowIndex + 1 // row count = rowIndex + 1
            lineIndex = lineIndex + 1 // line index + 1
            
            if index == 0 {
                textRect = lineRect
            } else {
                if maximumNumberOfRows == 0 || rowIndex < maximumNumberOfRows {
                    textRect = textRect.union(lineRect)
                }
            }
        }
        textRect.size.height += 1 // + 1    avoid bugs
        textRect = textRect.standardized
        
        if lines.count == 0 {
            lineOrigins?.deallocate()
            return nil
        }
        
        
        
        /*
         ┌────────────────────────────────────────────────────────────┐
         │                                                            │
         │   Intercept lines based on `numberOfLines` and` rowCount`  │
         │                                                            │
         └────────────────────────────────────────────────────────────┘
         */
        if rowCount > 0 {
            if maximumNumberOfRows > 0 {
                if rowCount > maximumNumberOfRows {
                    isNeedTruncation = true
                    rowCount = maximumNumberOfRows
                    while true {
                        let line = lines.last
                        if line == nil { break }
                        if line!.row < rowCount { break }
                        lines.removeLast()
                    }
                }
            }
            let lastLine: SwiftyTextLine = lines.last!
            if !isNeedTruncation &&
                lastLine.range.location + lastLine.range.length < attributedText.length {
                isNeedTruncation = true
            }
        }
        
        
        
        
        
        /*
         ┌─────────────────────────┐
         │                         │
         │   Visible String Range  │
         │                         │
         └─────────────────────────┘
         */
        let _visibleRange: CFRange = CTFrameGetVisibleStringRange(ctFrame)
        visibleRange = NSRange(location: _visibleRange.location, length: _visibleRange.length)
        
        
        
        
        /*
         ┌──────────────┐
         │              │
         │  Truncation  │
         │              │
         └──────────────┘
         */
        if isNeedTruncation {
            let lastLine: SwiftyTextLine = lines.last!
            let lastLineRange: NSRange = lastLine.range
            
            // If interception occurs, then reassign `visibleRange`
            visibleRange.length = lastLineRange.location + lastLineRange.length - visibleRange.location
            
            if container.truncationType != .none {
                var truncationTokenLine: CTLine?
                if let t = container.truncationToken {
                    // If `truncationToken` exists
                    truncationTokenLine = CTLineCreateWithAttributedString(t)
                    truncationToken = t
                } else {
                    let runs: CFArray = CTLineGetGlyphRuns(lastLine.line!)
                    var attributes: [NSAttributedString.Key: Any] = [:]
                    let runCount: CFIndex = CFArrayGetCount(runs)
                    if runCount > 0 {
                        // The last run attribute is assigned the property of `truncationToken`
                        let ctRun: CTRun = unsafeBitCast(CFArrayGetValueAtIndex(runs, runCount - 1), to: CTRun.self)
                        
                        if let runAttributes = CTRunGetAttributes(ctRun) as? [NSAttributedString.Key: Any] {
                            if let font = runAttributes[.font] {
                                attributes[.font] = font
                            } else {
                                attributes[.font] = UIFont.systemFont(ofSize: 12)
                            }
                            if let color = runAttributes[.foregroundColor] {
                                attributes[.foregroundColor] = color
                            } else {
                                attributes[.foregroundColor] = UIColor.black
                            }
                        }
                    } else {
                        attributes[.font] = UIFont.systemFont(ofSize: 12)
                        attributes[.foregroundColor] = UIColor.black
                    }
                    let c = NSAttributedString(string: SwiftyTextTruncationToken, attributes: attributes)
                    truncationTokenLine = CTLineCreateWithAttributedString(c)
                    truncationToken = c
                }
                
                
                if truncationTokenLine != nil && truncationToken != nil {
                    // truncationType
                    var type: CTLineTruncationType = .end
                    if container.truncationType == .start {
                        type = .start
                    } else if container.truncationType == .middle {
                        type = .middle
                    }
                    
                    // 拼接`truncationToken`
                    var lastLineAttributedText = NSMutableAttributedString(attributedString: attributedText.attributedSubstring(from: lastLine.range))
                    
                    if type == .start {
                        let newLastLineAttributedText = NSMutableAttributedString(attributedString: attributedText.attributedSubstring(from: NSRange(location: attributedText.length - lastLine.range.length, length: lastLine.range.length)))
                        newLastLineAttributedText.replaceCharacters(in: NSRange(location: 0, length: 1), with: truncationToken!)
                        lastLineAttributedText = newLastLineAttributedText
                    } else if type == .middle {
                        let newLastLineAttributedText = NSMutableAttributedString(attributedString: attributedText.attributedSubstring(from: NSRange(location: attributedText.length - lastLine.range.length, length: lastLine.range.length)))
                        let newTruncationToken = truncationToken!.mutableCopy() as! NSMutableAttributedString
                        let lastLineMiddleIndex = lastLine.range.length / 2
                        newLastLineAttributedText.insert(newTruncationToken, at: lastLineMiddleIndex)
                        lastLineAttributedText = newLastLineAttributedText
                    } else {
                        lastLineAttributedText.append(truncationToken!)
                    }
                    
                    let ctLastExtendLine: CTLine = CTLineCreateWithAttributedString(lastLineAttributedText)
                    var truncatedWidth: CGFloat = lastLine.width
                    
                    // Determine if `path` is a rectangle, if yes, assign the value of rectangle to `rect`
                    var rect: CGRect = .zero
                    if cgPath.isRect(&rect) {
                        truncatedWidth = rect.width
                    }
                    
                    // creat `truncatedLine`
                    if let ctTruncatedLine = CTLineCreateTruncatedLine(ctLastExtendLine, Double(truncatedWidth), type, truncationTokenLine!) {
                        let l = SwiftyTextLine.line(with: ctTruncatedLine, position: lastLine.position)
                        l.index = lastLine.index
                        l.row = lastLine.row
                        truncatedLine = l
                    }
                }
            }
        }
        
        
        
        
        
        /*
         ┌──────────────────┐
         │                  │
         │  Pre-calculated  │
         │                  │
         └──────────────────┘
         */
        var isNeedDrawText: Bool = false
        var isNeedDrawAttachment: Bool = false
        var isNeedDrawBackgroundBorder: Bool = false
        var isContainHighlight: Bool = false
        var isNeedDrawStrikethrough: Bool = false
        var isNeedDrawUnderline: Bool = false
        
        if visibleRange.length > 0 {
            isNeedDrawText = true
            let block: (([NSAttributedString.Key: Any], NSRange, UnsafeMutablePointer<ObjCBool>)->()) = { (attrs, _, _) in
                if let _ = attrs[.stAttachmentAttributeName] {
                    isNeedDrawAttachment = true
                }
                if let _ = attrs[.stBackgroundBorderAttributeName] {
                    isNeedDrawBackgroundBorder = true
                }
                if let _ = attrs[.stHighlightAttributeName] {
                    isContainHighlight = true
                }
                if let _ = attrs[.stStrikethroughAttributeName] {
                    isNeedDrawStrikethrough = true
                }
                if let _ = attrs[.stUnderlineAttributeName] {
                    isNeedDrawUnderline = true
                }
            }
            attributedText.enumerateAttributes(in: visibleRange, options: .longestEffectiveRangeNotRequired, using: block)
            if truncatedLine != nil && truncationToken != nil {
                truncationToken!.enumerateAttributes(in: NSRange(location: 0, length: truncationToken!.length), options: .longestEffectiveRangeNotRequired, using: block)
            }
        }
        
        
        /*
         ┌──────────────┐
         │              │
         │  Attachment  │
         │              │
         └──────────────┘
         */
        for index in 0..<lines.count {
            var line: SwiftyTextLine = lines[index]
            if truncatedLine != nil && truncatedLine!.index == index {
                line = truncatedLine!
            }
            if line.attachments.count > 0 {
                attachments.append(contentsOf: line.attachments)
                line.attachments.forEach { (attachment) in
                    if let content = attachment.content {
                        attachmentSet.add(content)
                    }
                }
            }
        }
        
        
        
        
        /*
         ┌─────────┐
         │         │
         │  Final  │
         │         │
         └─────────┘
         */
        let textLayout = SwiftyTextLayout()
        textLayout.attributedText = attributedText
        textLayout.textContainer = container
        textLayout.ctFramesetter = ctFramesetter
        textLayout.ctFrame = ctFrame
        textLayout.lines = lines
        textLayout.truncatedLine = truncatedLine
        textLayout.rowCount = rowCount
        textLayout.visibleRange = visibleRange
        textLayout.attachments = attachments
        textLayout.attachmentSet = attachmentSet
        
        textLayout.isNeedDrawText = isNeedDrawText
        textLayout.isNeedDrawAttachment = isNeedDrawAttachment
        textLayout.isNeedDrawBackgroundBorder = isNeedDrawBackgroundBorder
        textLayout.isNeedDrawStrikethrough = isNeedDrawStrikethrough
        textLayout.isNeedDrawUnderline = isNeedDrawUnderline
        textLayout.isContainHighlight = isContainHighlight
        
        textLayout.textRect = textRect
        textLayout.textSize = CGSize(width: ceil(textRect.size.width + textRect.origin.x), height: ceil(textRect.size.height + textRect.origin.y))
        
        lineOrigins?.deallocate()
        
        return textLayout
    }
}

extension SwiftyTextLayout {
    public static func draw(layout: SwiftyTextLayout?, context: CGContext?, size: CGSize) {
        SwiftyTextLayout.draw(layout: layout, context: context, size: size, point: .zero, view: nil, layer: nil, cancel: nil)
    }
    
    public static func draw(layout: SwiftyTextLayout?, context: CGContext?, size: CGSize, point: CGPoint, view: UIView?, layer: CALayer?, cancel: (() -> Bool)? = nil) {
        guard let layout = layout else { return }
        
        // draw backgound border
        if layout.isNeedDrawBackgroundBorder, let context = context {
            if let cancel = cancel, cancel() {
                return
            }
            SwiftyTextDraw.drawBackgroundBorder(layout: layout, context: context, size: size, point: point, cancel: cancel)
        }
        
        // draw under line
        if layout.isNeedDrawUnderline, let context = context {
            if let cancel = cancel, cancel() {
                return
            }
            SwiftyTextDraw.drawUnderline(layout: layout, context: context, size: size, point: point, cancel: cancel)
        }
        
        // draw text
        if layout.isNeedDrawText, let context = context {
            if let cancel = cancel, cancel() {
                return
            }
            SwiftyTextDraw.drawText(layout: layout, context: context, size: size, point: point, cancel: cancel)
        }
        
        // draw attachment
        if layout.isNeedDrawAttachment && (context != nil || view != nil || layer != nil) {
            if let cancel = cancel, cancel() {
                return
            }
            SwiftyTextDraw.drawAttachment(layout: layout, context: context, size: size, point: point, targetView: view, targetLayer: layer, cancel: cancel)
        }
        
        // draw strike through
        if layout.isNeedDrawStrikethrough, let context = context {
            if let cancel = cancel, cancel() {
                return
            }
            SwiftyTextDraw.drawStrikethrough(layout: layout, context: context, size: size, point: point, cancel: cancel)
        }
    }
}
