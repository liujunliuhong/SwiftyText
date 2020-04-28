//
//  SwiftyTextUtilities.swift
//  SwiftyText
//
//  Created by apple on 2020/4/24.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation
import UIKit
import CoreText

internal struct SwiftyTextUtilities {
    static var screenScale = UIScreen.main.scale
    
    
}

extension SwiftyTextUtilities {
    internal static func attachmentRectFit(rect: CGRect, size: CGSize, mode: UIView.ContentMode) -> CGRect {
        var rect = rect
        var size = size
        rect = rect.standardized
        
        let center = CGPoint(x: rect.midX, y: rect.midY)
        
        switch mode {
        case .scaleAspectFit,
             .scaleAspectFill:
            if rect.size.width < 0.01 ||
                rect.size.height < 0.01 ||
                size.width < 0.01 ||
                size.height < 0.01 {
                rect.origin = center
                rect.size = .zero
            } else {
                var scale: CGFloat = 1.0
                if mode == .scaleAspectFit {
                    if size.width / size.height < rect.size.width / rect.size.height {
                        scale = rect.size.height / size.height
                    } else {
                        scale = rect.size.width / size.width
                    }
                } else {
                    if size.width / size.height < rect.size.width / rect.size.height {
                        scale = rect.size.width / size.width
                    } else {
                        scale = rect.size.height / size.height
                    }
                }
                size.width = size.width * scale
                size.height = size.height * scale
                rect.size = size
                rect.origin = CGPoint(x: center.x - size.width * 0.5, y: center.y - size.height * 0.5)
            }
        case .center:
            rect.size = size
            rect.origin = CGPoint(x: center.x - size.width * 0.5, y: center.y - size.height * 0.5)
        case .top:
            rect.origin.x = center.x - size.width * 0.5
            rect.size = size
        case .bottom:
            rect.origin.x = center.x - size.width * 0.5
            rect.origin.y += rect.size.height - size.height
            rect.size = size
            break
        case .left:
            rect.origin.y = center.y - size.height * 0.5
            rect.size = size
        case .right:
            rect.origin.y = center.y - size.height * 0.5
            rect.origin.x += rect.size.width - size.width
            rect.size = size
        case .topLeft:
            rect.size = size
        case .topRight:
            rect.origin.x += rect.size.width - size.width
            rect.size = size
        case .bottomLeft:
            rect.origin.y += rect.size.height - size.height
            rect.size = size
        case .bottomRight:
            rect.origin.x += rect.size.width - size.width
            rect.origin.y += rect.size.height - size.height
            rect.size = size
        default:
            rect = CGRect(x: rect.origin.x, y: rect.origin.y, width: rect.size.width, height: rect.size.height)
            break
        }
        return rect
    }
}

extension SwiftyTextUtilities {
    public static func st_allDiscontinuousAttributeKeys() -> [NSAttributedString.Key] {
        var keys = [NSAttributedString.Key]()
        keys.append(NSAttributedString.Key(kCTSuperscriptAttributeName as String))
        keys.append(NSAttributedString.Key(kCTRunDelegateAttributeName as String))
        keys.append(.stRePlaceAttributeName)
        keys.append(.stAttachmentAttributeName)
        keys.append(NSAttributedString.Key(kCTRubyAnnotationAttributeName as String))
        keys.append(NSAttributedString.Key.attachment)
        return keys
    }
}


extension NSMutableAttributedString {
    public func st_removeDiscontinuousAttributes(range: NSRange? = nil) {
        let _range = (range == nil) ? NSRange(location: 0, length: self.length) : range!
        for key in SwiftyTextUtilities.st_allDiscontinuousAttributeKeys() {
            self.removeAttribute(key, range: _range)
        }
    }
    
    public func st_range() -> NSRange {
        return NSRange(location: 0, length: self.length)
    }
}
