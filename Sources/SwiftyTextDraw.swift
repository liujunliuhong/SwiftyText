//
//  SwiftyTextDraw.swift
//  SwiftyText
//
//  Created by apple on 2020/4/24.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation
import UIKit
import CoreText

internal struct SwiftyTextDraw {
    
}

// MARK: - Draw Text
extension SwiftyTextDraw {
    internal static func drawText(layout: SwiftyTextLayout, context: CGContext, size: CGSize, point: CGPoint, cancel: (() -> Bool)? = nil) {
        if layout.lines.count <= 0 {
            return
        }
        if !layout.isNeedDrawText {
            return
        }
        if let cancel = cancel, cancel() {
            return
        }
        let lines = layout.lines
        for index in 0..<lines.count {
            var line: SwiftyTextLine = lines[index]
            if let truncatedLine = layout.truncatedLine, truncatedLine.index == line.index {
                line = truncatedLine
            }
            
            if line.line == nil {
                continue
            }
            
            let posX: CGFloat = line.position.x
            let posY: CGFloat = size.height - line.position.y
            
            let runs: CFArray = CTLineGetGlyphRuns(line.line!)
            let runCount: CFIndex = CFArrayGetCount(runs)
            
            for i in 0..<runCount {
                let run: CTRun = unsafeBitCast(CFArrayGetValueAtIndex(runs, i), to: CTRun.self)
                context.saveGState()
                context.textMatrix = .identity
                context.textPosition = CGPoint(x: posX, y: posY)
                context.translateBy(x: point.x, y: point.y)
                context.translateBy(x: 0, y: size.height)
                context.scaleBy(x: 1, y: -1)
                SwiftyTextDraw.drawRun(line: line, run: run, context: context, size: size)
                context.restoreGState()
            }
        }
    }
    
    internal static func drawRun(line: SwiftyTextLine, run: CTRun, context: CGContext, size: CGSize) {
        CTRunDraw(run, context, CFRangeMake(0, 0)) // draw run
    }
}

// MARK: - Draw Attachment
extension SwiftyTextDraw {
    internal static func drawAttachment(layout: SwiftyTextLayout, context: CGContext?, size: CGSize, point: CGPoint, targetView: UIView?, targetLayer: CALayer?, cancel: (() -> Bool)? = nil) {
        if layout.lines.count <= 0 {
            return
        }
        if !layout.isNeedDrawAttachment {
            return
        }
        if let cancel = cancel, cancel() {
            return
        }
        
        let lines = layout.lines
        for index in 0..<lines.count {
            let line: SwiftyTextLine = lines[index]
            if line.line == nil {
                continue
            }
            
            for j in 0..<line.attachments.count {
                let attachment = line.attachments[j]
                if attachment.content == nil {
                    continue
                }
                var attachmentImage: UIImage?
                var attachmentView: UIView?
                var attachmentLayer: CALayer?
                
                var aSize: CGSize = .zero
                if let image = attachment.content as? UIImage, let _ = context {
                    attachmentImage = image
                    aSize = image.size // This explains why the size of the attachment must be set
                } else if let view = attachment.content as? UIView, let _ = targetView {
                    attachmentView = view
                    aSize = view.frame.size // This explains why the size of the attachment must be set
                } else if let layer = attachment.content as? CALayer, let _ = targetLayer {
                    attachmentLayer = layer
                    aSize = layer.frame.size // This explains why the size of the attachment must be set
                }
                if attachmentImage == nil && attachmentView == nil && attachmentLayer == nil {
                    continue
                }
                if attachmentImage != nil && context == nil {
                    continue
                }
                if attachmentView != nil && targetView == nil {
                    continue
                }
                if attachmentLayer != nil && targetLayer == nil {
                    continue
                }
                
                var attachmentRect = line.attachmentRects[j]
                attachmentRect = SwiftyTextUtilities.attachmentRectFit(rect: attachmentRect, size: aSize, mode: attachment.contentMode)
                attachmentRect = attachmentRect.standardized
                attachmentRect.origin.x += point.x
                attachmentRect.origin.y += point.y
                if let image = attachmentImage, let cgImage = image.cgImage {
                    context?.saveGState()
                    context?.translateBy(x: 0, y: attachmentRect.maxY + attachmentRect.minY)
                    context?.scaleBy(x: 1, y: -1)
                    context?.draw(cgImage, in: attachmentRect)
                    context?.restoreGState()
                } else if let view = attachmentView {
                    view.frame = attachmentRect
                    targetView?.addSubview(view)
                } else if let layer = attachmentLayer {
                    layer.frame = attachmentRect
                    targetLayer?.addSublayer(layer)
                }
            }
        }
    }
}

// MARK: - Draw Background Border
extension SwiftyTextDraw {
    internal static func drawBackgroundBorder(layout: SwiftyTextLayout, context: CGContext, size: CGSize, point: CGPoint, cancel: (() -> Bool)? = nil) {
        if layout.lines.count <= 0 {
            return
        }
        if !layout.isNeedDrawBackgroundBorder {
            return
        }
        if let cancel = cancel, cancel() {
            return
        }
        
        let lines = layout.lines
        for index in 0..<lines.count {
            var line: SwiftyTextLine = lines[index]
            if let truncatedLine = layout.truncatedLine, truncatedLine.index == line.index {
                line = truncatedLine
            }
            
            if line.line == nil {
                continue
            }
            
            let runs: CFArray = CTLineGetGlyphRuns(line.line!)
            let runCount: CFIndex = CFArrayGetCount(runs)
            if runCount <= 0 {
                return
            }
            
            var tmpRunRects: [CGRect] = []
            for i in 0..<runCount {
                let run: CTRun = unsafeBitCast(CFArrayGetValueAtIndex(runs, i), to: CTRun.self)
                if let runAttributes = CTRunGetAttributes(run) as? [NSAttributedString.Key : Any],
                    CTRunGetGlyphCount(run) > 0,
                    let backgroundBorder = runAttributes[.stBackgroundBorderAttributeName] as? SwiftyTextBorder {
                    var runRect = line.runRects[i]
                    runRect.origin.x += point.x
                    runRect.origin.y += point.y
                    
                    tmpRunRects.append(runRect)
                    
                    if i <= runCount - 1 - 1 {
                        let afterRun: CTRun = unsafeBitCast(CFArrayGetValueAtIndex(runs, i + 1), to: CTRun.self)
                        let afterRunAttributes = CTRunGetAttributes(afterRun) as? [NSAttributedString.Key : Any]
                        let afterBackgroundBorder: SwiftyTextBorder? = afterRunAttributes?[.stBackgroundBorderAttributeName] as? SwiftyTextBorder
                        
                        // 后面一个索引的border和当前的border不相等
                        if backgroundBorder != afterBackgroundBorder {
                            SwiftyTextDraw.drawBackgroundBorderRects(context: context, border: backgroundBorder, rects: tmpRunRects)
                            tmpRunRects.removeAll()
                        }
                    } else {
                        SwiftyTextDraw.drawBackgroundBorderRects(context: context, border: backgroundBorder, rects: tmpRunRects)
                        tmpRunRects.removeAll()
                    }
                }
            }
        }
    }
    
    private static func drawBackgroundBorderRects(context: CGContext, border: SwiftyTextBorder, rects: [CGRect]) {
        if rects.count <= 0 {
            return
        }
        var drawRect: CGRect = rects.st_rects_union()
        drawRect = drawRect.inset(by: border.insets)
        
        // path
        let path = UIBezierPath(roundedRect: drawRect, cornerRadius: border.cornerRadius)
        path.close()
        
        // fill color
        if let color = border.fillColor {
            context.saveGState()
            context.setFillColor(color.cgColor)
            context.addPath(path.cgPath)
            context.fillPath()
            context.restoreGState()
        }
        
        // inner line
        var innerStrokeWidth: CGFloat = .zero
        switch border.innerLineStyle {
        case .single(let strokeWidth, let strokeColor, let lineJoin, let lineCap):
            guard let strokeColor = strokeColor else { break }
            guard !strokeWidth.isLessThanOrEqualTo(.zero) else { break }
            innerStrokeWidth = strokeWidth
            context.saveGState()
            let inset: CGFloat = -strokeWidth * 0.5
            let drawRect = drawRect.insetBy(dx: inset, dy: inset)
            let path = UIBezierPath(roundedRect: drawRect, cornerRadius: border.cornerRadius)
            path.close()
            context.addPath(path.cgPath)
            context.setStrokeColor(strokeColor.cgColor)
            context.setLineWidth(strokeWidth)
            context.setLineCap(lineCap)
            context.setLineJoin(lineJoin)
            context.strokePath()
            context.restoreGState()
        case .dash(let strokeWidth, let strokeColor, let lineJoin, let lineCap, let lengths):
            guard let strokeColor = strokeColor else { break }
            guard !strokeWidth.isLessThanOrEqualTo(.zero) else { break }
            innerStrokeWidth = strokeWidth
            context.saveGState()
            let inset: CGFloat = -strokeWidth * 0.5
            let drawRect = drawRect.insetBy(dx: inset, dy: inset)
            let path = UIBezierPath(roundedRect: drawRect, cornerRadius: border.cornerRadius)
            path.close()
            context.addPath(path.cgPath)
            context.setStrokeColor(strokeColor.cgColor)
            context.setLineWidth(strokeWidth)
            context.setLineDash(phase: 0, lengths: lengths)
            context.setLineCap(lineCap)
            context.setLineJoin(lineJoin)
            context.strokePath()
            context.restoreGState()
        default:
            break
        }
        
        if innerStrokeWidth.isLessThanOrEqualTo(.zero) {
            return
        }
        
        // outer line
        switch border.outerLineStyle {
        case .single(let strokeWidth, let strokeColor, let lineJoin, let lineCap):
            guard let strokeColor = strokeColor else { break }
            guard !strokeWidth.isLessThanOrEqualTo(.zero) else { break }
            context.saveGState()
            let inset: CGFloat = -border.lineSpace - strokeWidth * 0.5 - innerStrokeWidth * 0.5
            let drawRect = drawRect.insetBy(dx: inset, dy: inset)
            let path = UIBezierPath(roundedRect: drawRect, cornerRadius: border.cornerRadius)
            path.close()
            context.addPath(path.cgPath)
            context.setStrokeColor(strokeColor.cgColor)
            context.setLineWidth(strokeWidth)
            context.setLineCap(lineCap)
            context.setLineJoin(lineJoin)
            context.strokePath()
            context.restoreGState()
        case .dash(let strokeWidth, let strokeColor, let lineJoin, let lineCap, let lengths):
            guard let strokeColor = strokeColor else { break }
            guard !strokeWidth.isLessThanOrEqualTo(.zero) else { break }
            context.saveGState()
            let inset: CGFloat = -border.lineSpace - strokeWidth * 0.5 - innerStrokeWidth * 0.5
            let drawRect = drawRect.insetBy(dx: inset, dy: inset)
            let path = UIBezierPath(roundedRect: drawRect, cornerRadius: border.cornerRadius)
            path.close()
            context.addPath(path.cgPath)
            context.setStrokeColor(strokeColor.cgColor)
            context.setLineWidth(strokeWidth)
            context.setLineDash(phase: 0, lengths: lengths)
            context.setLineCap(lineCap)
            context.setLineJoin(lineJoin)
            context.strokePath()
            context.restoreGState()
        default:
            break
        }
    }
}

// MARK: - Draw Underline
extension SwiftyTextDraw {
    internal static func drawUnderline(layout: SwiftyTextLayout, context: CGContext, size: CGSize, point: CGPoint, cancel: (() -> Bool)? = nil) {
        if layout.lines.count <= 0 {
            return
        }
        if !layout.isNeedDrawUnderline {
            return
        }
        if let cancel = cancel, cancel() {
            return
        }
        let lines = layout.lines
        for index in 0..<lines.count {
            var line: SwiftyTextLine = lines[index]
            if let truncatedLine = layout.truncatedLine, truncatedLine.index == line.index {
                line = truncatedLine
            }
            
            if line.line == nil {
                continue
            }
            
            let runs: CFArray = CTLineGetGlyphRuns(line.line!)
            let runCount: CFIndex = CFArrayGetCount(runs)
            if runCount <= 0 {
                return
            }
            var tmpRunRects: [CGRect] = []
            for i in 0..<runCount {
                let run: CTRun = unsafeBitCast(CFArrayGetValueAtIndex(runs, i), to: CTRun.self)
                if let runAttributes = CTRunGetAttributes(run) as? [NSAttributedString.Key : Any],
                    CTRunGetGlyphCount(run) > 0,
                    let textUnderline = runAttributes[.stUnderlineAttributeName] as? SwiftyTextUnderLine{
                    var runRect = line.runRects[i]
                    runRect.origin.x += point.x
                    runRect.origin.y += point.y
                    
                    tmpRunRects.append(runRect)
                    
                    if i <= runCount - 1 - 1 {
                        let afterRun: CTRun = unsafeBitCast(CFArrayGetValueAtIndex(runs, i + 1), to: CTRun.self)
                        let afterRunAttributes = CTRunGetAttributes(afterRun) as? [NSAttributedString.Key : Any]
                        let afterTextUnderline: SwiftyTextUnderLine? = afterRunAttributes?[.stUnderlineAttributeName] as? SwiftyTextUnderLine
                        
                        // 后面一个索引的`underLine`和当前的`underLine`不相等
                        if textUnderline != afterTextUnderline {
                            let unionRects = tmpRunRects.st_rects_union()
                            let positionX: CGFloat = unionRects.origin.x
                            let positionY: CGFloat = line.position.y + point.y // base on baseLine
                            
                            SwiftyTextDraw.drawUnderlineRects(context: context, underLine: textUnderline, position: CGPoint(x: positionX, y: positionY), rects: tmpRunRects)
                            tmpRunRects.removeAll()
                        }
                    } else {
                        let unionRects = tmpRunRects.st_rects_union()
                        let positionX: CGFloat = unionRects.origin.x
                        let positionY: CGFloat = line.position.y + point.y // base on baseLine
                        
                        SwiftyTextDraw.drawUnderlineRects(context: context, underLine: textUnderline, position: CGPoint(x: positionX, y: positionY), rects: tmpRunRects)
                        tmpRunRects.removeAll()
                    }
                }
            }
        }
    }
    
    private static func drawUnderlineRects(context: CGContext, underLine: SwiftyTextUnderLine, position: CGPoint, rects: [CGRect]) {
        let unionRects = rects.st_rects_union()
        
        // first line
        var firstStrokeWidth: CGFloat = .zero
        switch underLine.firstLineStyle {
        case .single(let strokeWidth, let strokeColor, let lineJoin, let lineCap):
            guard let strokeColor = strokeColor else { break }
            guard !strokeWidth.isLessThanOrEqualTo(.zero) else { break }
            firstStrokeWidth = strokeWidth
            let position = CGPoint(x: position.x, y: position.y + strokeWidth * 0.5)
            context.saveGState()
            context.move(to: position)
            context.addLine(to: CGPoint(x: position.x + unionRects.width, y: position.y))
            context.setStrokeColor(strokeColor.cgColor)
            context.setLineWidth(strokeWidth)
            context.setLineCap(lineCap)
            context.setLineJoin(lineJoin)
            context.strokePath()
            context.restoreGState()
        case .dash(let strokeWidth, let strokeColor, let lineJoin, let lineCap, let lengths):
            guard let strokeColor = strokeColor else { break }
            guard !strokeWidth.isLessThanOrEqualTo(.zero) else { break }
            firstStrokeWidth = strokeWidth
            let position = CGPoint(x: position.x, y: position.y + strokeWidth * 0.5)
            context.saveGState()
            context.move(to: position)
            context.addLine(to: CGPoint(x: position.x + unionRects.width, y: position.y))
            context.setStrokeColor(strokeColor.cgColor)
            context.setLineWidth(strokeWidth)
            context.setLineDash(phase: 0, lengths: lengths)
            context.setLineCap(lineCap)
            context.setLineJoin(lineJoin)
            context.strokePath()
            context.restoreGState()
        default:
            break
        }
        
        if firstStrokeWidth.isLessThanOrEqualTo(.zero) {
            return
        }
        
        // second line
        switch underLine.secondLineStyle {
        case .single(let strokeWidth, let strokeColor, let lineJoin, let lineCap):
            guard let strokeColor = strokeColor else { break }
            guard !strokeWidth.isLessThanOrEqualTo(.zero) else { break }
            firstStrokeWidth = strokeWidth
            let position = CGPoint(x: position.x, y: position.y + firstStrokeWidth * 0.5 + underLine.lineSpace + strokeWidth * 0.5)
            context.saveGState()
            context.move(to: position)
            context.addLine(to: CGPoint(x: position.x + unionRects.width, y: position.y))
            context.setStrokeColor(strokeColor.cgColor)
            context.setLineWidth(strokeWidth)
            context.setLineCap(lineCap)
            context.setLineJoin(lineJoin)
            context.strokePath()
            context.restoreGState()
        case .dash(let strokeWidth, let strokeColor, let lineJoin, let lineCap, let lengths):
            guard let strokeColor = strokeColor else { break }
            guard !strokeWidth.isLessThanOrEqualTo(.zero) else { break }
            firstStrokeWidth = strokeWidth
            let position = CGPoint(x: position.x, y: position.y + firstStrokeWidth * 0.5 + underLine.lineSpace + strokeWidth * 0.5)
            context.saveGState()
            context.move(to: position)
            context.addLine(to: CGPoint(x: position.x + unionRects.width, y: position.y))
            context.setStrokeColor(strokeColor.cgColor)
            context.setLineWidth(strokeWidth)
            context.setLineDash(phase: 0, lengths: lengths)
            context.setLineCap(lineCap)
            context.setLineJoin(lineJoin)
            context.strokePath()
            context.restoreGState()
        default:
            break
        }
    }
}

// MARK: - Draw Strikethrough
extension SwiftyTextDraw {
    internal static func drawStrikethrough(layout: SwiftyTextLayout, context: CGContext, size: CGSize, point: CGPoint, cancel: (() -> Bool)? = nil) {
        if layout.lines.count <= 0 {
            return
        }
        if !layout.isNeedDrawStrikethrough {
            return
        }
        if let cancel = cancel, cancel() {
            return
        }
        let lines = layout.lines
        for index in 0..<lines.count {
            var line: SwiftyTextLine = lines[index]
            if let truncatedLine = layout.truncatedLine, truncatedLine.index == line.index {
                line = truncatedLine
            }
            
            if line.line == nil {
                continue
            }
            
            let runs: CFArray = CTLineGetGlyphRuns(line.line!)
            let runCount: CFIndex = CFArrayGetCount(runs)
            if runCount <= 0 {
                return
            }
            var tmpRunRects: [CGRect] = []
            for i in 0..<runCount {
                let run: CTRun = unsafeBitCast(CFArrayGetValueAtIndex(runs, i), to: CTRun.self)
                if let runAttributes = CTRunGetAttributes(run) as? [NSAttributedString.Key : Any],
                    CTRunGetGlyphCount(run) > 0,
                    let textStrikethrough: SwiftyTextStrikethrough = runAttributes[.stStrikethroughAttributeName] as? SwiftyTextStrikethrough{
                    var runRect = line.runRects[i]
                    runRect.origin.x += point.x
                    runRect.origin.y += point.y
                    
                    tmpRunRects.append(runRect)
                    
                    if i <= runCount - 1 - 1 {
                        let afterRun: CTRun = unsafeBitCast(CFArrayGetValueAtIndex(runs, i + 1), to: CTRun.self)
                        let afterRunAttributes = CTRunGetAttributes(afterRun) as? [NSAttributedString.Key : Any]
                        let afterTextStrikethrough: SwiftyTextStrikethrough? = afterRunAttributes?[.stStrikethroughAttributeName] as? SwiftyTextStrikethrough
                        
                        // 后面一个索引的`strikethrough`和当前的`strikethrough`不相等
                        if textStrikethrough != afterTextStrikethrough {
                            
                            let unionRects = tmpRunRects.st_rects_union()
                            let positionX: CGFloat = unionRects.origin.x
                            let positionY: CGFloat = unionRects.origin.y + unionRects.height * 0.5
                            
                            SwiftyTextDraw.drawStrikethroughRects(context: context, strikethrough: textStrikethrough, position: CGPoint(x: positionX, y: positionY), rects: tmpRunRects)
                            tmpRunRects.removeAll()
                        }
                    } else {
                        let unionRects = tmpRunRects.st_rects_union()
                        let positionX: CGFloat = unionRects.origin.x
                        let positionY: CGFloat = unionRects.origin.y + unionRects.height * 0.5
                        
                        SwiftyTextDraw.drawStrikethroughRects(context: context, strikethrough: textStrikethrough, position: CGPoint(x: positionX, y: positionY), rects: tmpRunRects)
                        tmpRunRects.removeAll()
                    }
                }
            }
        }
    }
    
    private static func drawStrikethroughRects(context: CGContext, strikethrough: SwiftyTextStrikethrough, position: CGPoint, rects: [CGRect]) {
        let unionRects = rects.st_rects_union()
        
        // if second line exists
        // the second line can affects first line
        var secondStrokeWidth: CGFloat = .zero
        switch strikethrough.secondLineStyle {
        case .single(let strokeWidth, let strokeColor, _, _):
            guard let _ = strokeColor else { break }
            guard !strokeWidth.isLessThanOrEqualTo(.zero) else { break }
            secondStrokeWidth = strokeWidth
        case .dash(let strokeWidth, let strokeColor, _, _, _):
            guard let _ = strokeColor else { break }
            guard !strokeWidth.isLessThanOrEqualTo(.zero) else { break }
            secondStrokeWidth = strokeWidth
        default:
            break
        }
        
        
        // first line
        var firstStrokeWidth: CGFloat = .zero
        switch strikethrough.firstLineStyle {
        case .single(let strokeWidth, let strokeColor, let lineJoin, let lineCap):
            guard let strokeColor = strokeColor else { break }
            guard !strokeWidth.isLessThanOrEqualTo(.zero) else { break }
            firstStrokeWidth = strokeWidth
            
            var position: CGPoint = position
            if secondStrokeWidth.isLessThanOrEqualTo(.zero) {
                position = CGPoint(x: position.x, y: position.y - strokeWidth * 0.5)
            } else {
                position = CGPoint(x: position.x, y: position.y - strikethrough.lineSpace * 0.5 - strokeWidth * 0.5)
            }
            
            context.saveGState()
            context.move(to: position)
            context.addLine(to: CGPoint(x: position.x + unionRects.width, y: position.y))
            context.setStrokeColor(strokeColor.cgColor)
            context.setLineWidth(strokeWidth)
            context.setLineCap(lineCap)
            context.setLineJoin(lineJoin)
            context.strokePath()
            context.restoreGState()
        case .dash(let strokeWidth, let strokeColor, let lineJoin, let lineCap, let lengths):
            guard let strokeColor = strokeColor else { break }
            guard !strokeWidth.isLessThanOrEqualTo(.zero) else { break }
            firstStrokeWidth = strokeWidth
            
            var position: CGPoint = position
            if secondStrokeWidth.isLessThanOrEqualTo(.zero) {
                position = CGPoint(x: position.x, y: position.y - strokeWidth * 0.5)
            } else {
                position = CGPoint(x: position.x, y: position.y - strikethrough.lineSpace * 0.5 - strokeWidth * 0.5)
            }
            
            context.saveGState()
            context.move(to: position)
            context.addLine(to: CGPoint(x: position.x + unionRects.width, y: position.y))
            context.setStrokeColor(strokeColor.cgColor)
            context.setLineWidth(strokeWidth)
            context.setLineDash(phase: 0, lengths: lengths)
            context.setLineCap(lineCap)
            context.setLineJoin(lineJoin)
            context.strokePath()
            context.restoreGState()
        default:
            break
        }
        
        if firstStrokeWidth.isLessThanOrEqualTo(.zero) {
            return
        }
        
        
        // second line
        switch strikethrough.secondLineStyle {
        case .single(let strokeWidth, let strokeColor, let lineJoin, let lineCap):
            guard let strokeColor = strokeColor else { break }
            guard !strokeWidth.isLessThanOrEqualTo(.zero) else { break }
            firstStrokeWidth = strokeWidth
            let position = CGPoint(x: position.x, y: position.y + strikethrough.lineSpace * 0.5 + strokeWidth * 0.5)
            context.saveGState()
            context.move(to: position)
            context.addLine(to: CGPoint(x: position.x + unionRects.width, y: position.y))
            context.setStrokeColor(strokeColor.cgColor)
            context.setLineWidth(strokeWidth)
            context.setLineCap(lineCap)
            context.setLineJoin(lineJoin)
            context.strokePath()
            context.restoreGState()
        case .dash(let strokeWidth, let strokeColor, let lineJoin, let lineCap, let lengths):
            guard let strokeColor = strokeColor else { break }
            guard !strokeWidth.isLessThanOrEqualTo(.zero) else { break }
            firstStrokeWidth = strokeWidth
            let position = CGPoint(x: position.x, y: position.y + strikethrough.lineSpace * 0.5 + strokeWidth * 0.5)
            context.saveGState()
            context.move(to: position)
            context.addLine(to: CGPoint(x: position.x + unionRects.width, y: position.y))
            context.setStrokeColor(strokeColor.cgColor)
            context.setLineWidth(strokeWidth)
            context.setLineDash(phase: 0, lengths: lengths)
            context.setLineCap(lineCap)
            context.setLineJoin(lineJoin)
            context.strokePath()
            context.restoreGState()
        default:
            break
        }
    }
}
