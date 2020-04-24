//
//  NSParagraphStyle+SwiftyText.swift
//  SwiftyText
//
//  Created by apple on 2020/4/24.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation
import CoreText
import UIKit

extension NSParagraphStyle {
    /// CTParagraphStyle -> NSParagraphStyle
    /// - Parameter ctStyle: CTParagraphStyle
    public static func st_convert(ctStyle: CTParagraphStyle) -> NSParagraphStyle {
        let style: NSMutableParagraphStyle = NSMutableParagraphStyle.default as! NSMutableParagraphStyle
        
        
        // alignment
        var alignment: NSTextAlignment = .left
        if CTParagraphStyleGetValueForSpecifier(ctStyle,
                                                .alignment,
                                                MemoryLayout<NSTextAlignment>.size,
                                                UnsafeMutableRawPointer(&alignment)) {
            style.alignment = alignment
        }
        
        // firstLineHeadIndent
        var firstLineHeadIndent:CGFloat = 0.0
        if CTParagraphStyleGetValueForSpecifier(ctStyle,
                                                .firstLineHeadIndent,
                                                MemoryLayout<CGFloat>.size,
                                                UnsafeMutableRawPointer(&firstLineHeadIndent)) {
            style.firstLineHeadIndent = firstLineHeadIndent
        }
        
        // headIndent
        var headIndent:CGFloat = 0.0
        if CTParagraphStyleGetValueForSpecifier(ctStyle,
                                                .headIndent,
                                                MemoryLayout<CGFloat>.size,
                                                UnsafeMutableRawPointer(&headIndent)) {
            style.headIndent = headIndent
        }
        
        // tailIndent
        var tailIndent:CGFloat = 0.0
        if CTParagraphStyleGetValueForSpecifier(ctStyle,
                                                .tailIndent,
                                                MemoryLayout<CGFloat>.size,
                                                UnsafeMutableRawPointer(&tailIndent)) {
            style.tailIndent = tailIndent
        }
        
        // tabStops
        var tabStops: CFArray = [] as CFArray
        if CTParagraphStyleGetValueForSpecifier(ctStyle,
                                                .tabStops,
                                                MemoryLayout<CFArray>.size,
                                                UnsafeMutableRawPointer(&tabStops)) {
            var tabs: [NSTextTab] = []
            for (_, obj) in (tabStops as NSArray).enumerated() {
                let ctTab: CTTextTab = obj as! CTTextTab
                let tab = NSTextTab(textAlignment: NSTextAlignment(CTTextTabGetAlignment(ctTab)), location: CGFloat(CTTextTabGetLocation(ctTab)), options: CTTextTabGetOptions(ctTab) as! [NSTextTab.OptionKey : Any])
                tabs.append(tab)
            }
            if tabs.count > 0 {
                style.tabStops = tabs
            }
        }
        
        // defaultTabInterval
        var defaultTabInterval:CGFloat = 0.0
        if CTParagraphStyleGetValueForSpecifier(ctStyle,
                                                .defaultTabInterval,
                                                MemoryLayout<CGFloat>.size,
                                                UnsafeMutableRawPointer(&defaultTabInterval)) {
            style.defaultTabInterval = defaultTabInterval
        }
        
        // lineBreakMode
        var lineBreakMode:CTLineBreakMode = .byTruncatingTail
        if CTParagraphStyleGetValueForSpecifier(ctStyle,
                                                .lineBreakMode,
                                                MemoryLayout<CTLineBreakMode>.size,
                                                UnsafeMutableRawPointer(&lineBreakMode)) {
            var _lineBreakMode: NSLineBreakMode = .byTruncatingTail
            switch lineBreakMode {
            case .byCharWrapping:
                _lineBreakMode = .byCharWrapping
            case .byClipping:
                _lineBreakMode = .byClipping
            case .byTruncatingHead:
                _lineBreakMode = .byTruncatingHead
            case .byTruncatingMiddle:
                _lineBreakMode = .byTruncatingMiddle
            case .byTruncatingTail:
                _lineBreakMode = .byTruncatingTail
            case .byWordWrapping:
                _lineBreakMode = .byWordWrapping
            @unknown default:
                _lineBreakMode = .byTruncatingTail
            }
            style.lineBreakMode = _lineBreakMode
        }
        
        
        // lineHeightMultiple
        var lineHeightMultiple:CGFloat = 0.0
        if CTParagraphStyleGetValueForSpecifier(ctStyle,
                                                .lineHeightMultiple,
                                                MemoryLayout<CGFloat>.size,
                                                UnsafeMutableRawPointer(&lineHeightMultiple)) {
            style.lineHeightMultiple = lineHeightMultiple
        }
        
        // maximumLineHeight
        var maximumLineHeight:CGFloat = 0.0
        if CTParagraphStyleGetValueForSpecifier(ctStyle,
                                                .maximumLineHeight,
                                                MemoryLayout<CGFloat>.size,
                                                UnsafeMutableRawPointer(&maximumLineHeight)) {
            style.maximumLineHeight = maximumLineHeight
        }
        
        // minimumLineHeight
        var minimumLineHeight:CGFloat = 0.0
        if CTParagraphStyleGetValueForSpecifier(ctStyle,
                                                .minimumLineHeight,
                                                MemoryLayout<CGFloat>.size,
                                                UnsafeMutableRawPointer(&minimumLineHeight)) {
            style.minimumLineHeight = minimumLineHeight
        }
        
        
        // paragraphSpacing
        var paragraphSpacing:CGFloat = 0.0
        if CTParagraphStyleGetValueForSpecifier(ctStyle,
                                                .paragraphSpacing,
                                                MemoryLayout<CGFloat>.size,
                                                UnsafeMutableRawPointer(&paragraphSpacing)) {
            style.paragraphSpacing = paragraphSpacing
        }
        
        // paragraphSpacingBefore
        var paragraphSpacingBefore:CGFloat = 0.0
        if CTParagraphStyleGetValueForSpecifier(ctStyle,
                                                .paragraphSpacingBefore,
                                                MemoryLayout<CGFloat>.size,
                                                UnsafeMutableRawPointer(&paragraphSpacingBefore)) {
            style.paragraphSpacingBefore = paragraphSpacingBefore
        }
        
        // baseWritingDirection
        var baseWritingDirection:CTWritingDirection = .leftToRight
        if CTParagraphStyleGetValueForSpecifier(ctStyle,
                                                .baseWritingDirection,
                                                MemoryLayout<CTWritingDirection>.size,
                                                UnsafeMutableRawPointer(&baseWritingDirection)) {
            var _baseWritingDirection: NSWritingDirection = .leftToRight
            switch baseWritingDirection {
            case .leftToRight:
                _baseWritingDirection = .leftToRight
            case .natural:
                _baseWritingDirection = .natural
            case .rightToLeft:
                _baseWritingDirection = .rightToLeft
            @unknown default:
                _baseWritingDirection = .leftToRight
            }
            style.baseWritingDirection = _baseWritingDirection
        }
        
        
        var lineSpacing:CGFloat = 0.0
        if CTParagraphStyleGetValueForSpecifier(ctStyle,
                                                .lineSpacingAdjustment,
                                                MemoryLayout<CGFloat>.size,
                                                UnsafeMutableRawPointer(&lineSpacing)) {
            style.lineSpacing = lineSpacing
        }
        
        return style
        
    }
    
    
    
    /// NSParagraphStyle -> CTParagraphStyle
    /// - Parameter paragraphStyle: NSParagraphStyle
    public static func st_convert(paragraphStyle: NSParagraphStyle) -> CTParagraphStyle {
        var settings = [CTParagraphStyleSetting]()
        
        var lineSpacing: CGFloat = paragraphStyle.lineSpacing
        settings.append(CTParagraphStyleSetting(spec: .lineSpacingAdjustment, valueSize: MemoryLayout<CGFloat>.size, value: &lineSpacing))
        
        var paragraphSpacing: CGFloat = paragraphStyle.paragraphSpacing
        settings.append(CTParagraphStyleSetting(spec: .paragraphSpacing, valueSize: MemoryLayout<CGFloat>.size, value: &paragraphSpacing))
        
        var alignment = CTTextAlignment(paragraphStyle.alignment)
        settings.append(CTParagraphStyleSetting(spec: .alignment, valueSize: MemoryLayout<CTTextAlignment>.size, value: &alignment))
        
        var firstLineHeadIndent: CGFloat = paragraphStyle.firstLineHeadIndent
        settings.append(CTParagraphStyleSetting(spec: .firstLineHeadIndent, valueSize: MemoryLayout<CGFloat>.size, value: &firstLineHeadIndent))
        
        var headIndent: CGFloat = paragraphStyle.headIndent
        settings.append(CTParagraphStyleSetting(spec: .headIndent, valueSize: MemoryLayout<CGFloat>.size, value: &headIndent))
        
        var tailIndent: CGFloat = paragraphStyle.tailIndent
        settings.append(CTParagraphStyleSetting(spec: .tailIndent, valueSize: MemoryLayout<CGFloat>.size, value: &tailIndent))
        
        var paraLineBreak = CTLineBreakMode(rawValue: UInt8(paragraphStyle.lineBreakMode.rawValue))
        settings.append(CTParagraphStyleSetting(spec: .lineBreakMode, valueSize: MemoryLayout<CTLineBreakMode>.size, value: &paraLineBreak))
        
        var minimumLineHeight: CGFloat = paragraphStyle.minimumLineHeight
        settings.append(CTParagraphStyleSetting(spec: .minimumLineHeight, valueSize: MemoryLayout<CGFloat>.size, value: &minimumLineHeight))
        
        var maximumLineHeight: CGFloat = paragraphStyle.maximumLineHeight
        settings.append(CTParagraphStyleSetting(spec: .maximumLineHeight, valueSize: MemoryLayout<CGFloat>.size, value: &maximumLineHeight))
        
        var paraWritingDirection = CTWritingDirection(rawValue: Int8(paragraphStyle.baseWritingDirection.rawValue))
        settings.append(CTParagraphStyleSetting(spec: .baseWritingDirection, valueSize: MemoryLayout<CTWritingDirection>.size, value: &paraWritingDirection))
        
        var lineHeightMultiple: CGFloat = paragraphStyle.lineHeightMultiple
        settings.append(CTParagraphStyleSetting(spec: .lineHeightMultiple, valueSize: MemoryLayout<CGFloat>.size, value: &lineHeightMultiple))
        
        var paragraphSpacingBefore: CGFloat = paragraphStyle.paragraphSpacingBefore
        settings.append(CTParagraphStyleSetting(spec: .paragraphSpacingBefore, valueSize: MemoryLayout<CGFloat>.size, value: &paragraphSpacingBefore))
        
        if paragraphStyle.responds(to: #selector(getter: self.tabStops)) {
            var tabs: [AnyHashable] = []
            
            let numTabs: Int = paragraphStyle.tabStops.count
            if numTabs != 0 {
                (paragraphStyle.tabStops as NSArray).enumerateObjects({ tab, idx, stop in
                    let tab_: NSTextTab = tab as! NSTextTab
                    
                    let ctTab = CTTextTabCreate(CTTextAlignment.init(tab_.alignment), Double(tab_.location), tab_.options as CFDictionary)
                    
                    tabs.append(ctTab)
                })
                var tabStops = tabs
                settings.append(CTParagraphStyleSetting(spec: .tabStops, valueSize: MemoryLayout<CFArray>.size, value: &tabStops))
            }
        }
        
        
        if paragraphStyle.responds(to: #selector(getter: paragraphStyle.defaultTabInterval)) {
            var defaultTabInterval: CGFloat = paragraphStyle.defaultTabInterval
            settings.append(CTParagraphStyleSetting(spec: .defaultTabInterval, valueSize: MemoryLayout<CGFloat>.size, value: &defaultTabInterval))
        }
        
        let style = CTParagraphStyleCreate(settings, settings.count)
        return style
    }
}
