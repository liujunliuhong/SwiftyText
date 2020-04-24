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

public struct SwiftyTextDraw {
    
}

// MARK: - Draw Text
extension SwiftyTextDraw {
    public static func drawText(layout: SwiftyTextLayout, context: CGContext, size: CGSize, point: CGPoint, cancel: (() -> Bool)? = nil) {
        if layout.lines.count <= 0 {
            return
        }
        if !layout.isNeedDrawText {
            return
        }
        if let _cancel = cancel, _cancel() {
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
    
    public static func drawRun(line: SwiftyTextLine, run: CTRun, context: CGContext, size: CGSize) {
        context.saveGState()
        context.textMatrix = .identity
        CTRunDraw(run, context, CFRangeMake(0, 0))
        context.restoreGState()
    }
}

// MARK: - Draw Attachment
extension SwiftyTextDraw {
    public static func drawAttachment(layout: SwiftyTextLayout, context: CGContext?, size: CGSize, point: CGPoint, targetView: UIView?, targetLayer: CALayer?, cancel: (() -> Bool)? = nil) {
        if layout.lines.count <= 0 {
            return
        }
        if !layout.isNeedDrawAttachment {
            return
        }
        if let _cancel = cancel, _cancel() {
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

extension SwiftyTextDraw {
    
}

extension SwiftyTextDraw {
    
}

extension SwiftyTextDraw {
    
}
