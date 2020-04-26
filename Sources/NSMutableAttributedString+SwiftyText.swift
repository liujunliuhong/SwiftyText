//
//  NSMutableAttributedString+SwiftyText.swift
//  SwiftyText
//
//  Created by apple on 2020/4/24.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation
import UIKit
import CoreText

/*
 * font
 * paragraphStyle         // NSParagraphStyle, default defaultParagraphStyle
 * foregroundColor        // UIColor, default blackColor
 * backgroundColor        // UIColor, default nil: no background
 * ligature               // NSNumber containing integer, default 1: default ligatures, 0: no ligatures
 * kern                   // NSNumber containing floating point value, in points; amount to modify default kerning. 0 means                         kerning is disabled.
 * strikethroughStyle     // NSNumber containing integer, default 0: no strikethrough
 * underlineStyle         // NSNumber containing integer, default 0: no underline
 * strokeColor            // UIColor, default nil: same as foreground color
 * strokeWidth            // NSNumber containing floating point value, in percent of font point size, default 0: no stroke;                         positive for stroke alone, negative for stroke and fill (a typical value for outlined text                             would be 3.0)
 * shadow                 // NSShadow, default nil: no shadow
 * textEffect             // NSString, default nil: no text effect
 * attachment             // NSTextAttachment, default nil
 * link                   // NSURL (preferred) or NSString
 * baselineOffset         // NSNumber containing floating point value, in points; offset from baseline, default 0
 * underlineColor         // UIColor, default nil: same as foreground color
 * strikethroughColor     // UIColor, default nil: same as foreground color
 * obliqueness            // NSNumber containing floating point value; skew to be applied to glyphs, default 0: no skew
 * expansion              // NSNumber containing floating point value; log of expansion factor to be applied to glyphs,                             default 0: no expansion
 * writingDirection       // NSArray of NSNumbers representing the nested levels of writing direction overrides as defined                          by Unicode LRE, RLE, LRO, and RLO characters.  The control characters can be obtained by                               masking NSWritingDirection and NSWritingDirectionFormatType values.
 LRE: NSWritingDirectionLeftToRight|NSWritingDirectionEmbedding,
 RLE: NSWritingDirectionRightToLeft|NSWritingDirectionEmbedding,
 LRO: NSWritingDirectionLeftToRight|NSWritingDirectionOverride,
 RLO: NSWritingDirectionRightToLeft|NSWritingDirectionOverride,
 * verticalGlyphForm      // An NSNumber containing an integer value.  0 means horizontal text.  1 indicates vertical text.                         If not specified, it could follow higher-level vertical orientation settings.  Currently on                            iOS, it's always horizontal.  The behavior for any other value is undefined.
 */

// MARK: - Common Attribute
extension NSMutableAttributedString {
    // font
    public func st_add(font: UIFont?, range: NSRange? = nil) {
        let _range = (range == nil) ? NSRange(location: 0, length: self.length) : range!
        st_addAttribute(key: .font, value: font, range: _range)
    }
    
    // foregroundColor
    public func st_add(textColor: UIColor?, range: NSRange? = nil) {
        let _range = (range == nil) ? NSRange(location: 0, length: self.length) : range!
        st_addAttribute(key: kCTForegroundColorAttributeName as NSAttributedString.Key, value: textColor?.cgColor, range: _range)
        st_addAttribute(key: .foregroundColor, value: textColor, range: _range)
    }
    
    // backgroundColor
    public func st_add(backgroundColor: UIColor?, range: NSRange? = nil) {
        let _range = (range == nil) ? NSRange(location: 0, length: self.length) : range!
        st_addAttribute(key: .backgroundColor, value: backgroundColor, range: _range)
    }
    
    // ligature
    public func st_add(ligature: NSNumber?, range: NSRange? = nil) {
        let _range = (range == nil) ? NSRange(location: 0, length: self.length) : range!
        st_addAttribute(key: .ligature, value: ligature, range: _range)
    }
    
    // kern
    public func st_add(kern: NSNumber?, range: NSRange? = nil) {
        let _range = (range == nil) ? NSRange(location: 0, length: self.length) : range!
        st_addAttribute(key: .kern, value: kern, range: _range)
    }
    
    // strikethroughStyle
    public func st_add(strikethroughStyle: NSUnderlineStyle?, range: NSRange? = nil) {
        let _range = (range == nil) ? NSRange(location: 0, length: self.length) : range!
        st_addAttribute(key: .strikethroughStyle, value: strikethroughStyle, range: _range)
    }
    
    // underlineStyle
    public func st_add(underlineStyle: NSUnderlineStyle?, range: NSRange? = nil) {
        let _range = (range == nil) ? NSRange(location: 0, length: self.length) : range!
        st_addAttribute(key: .underlineStyle, value: underlineStyle, range: _range)
    }
    
    // strokeColor
    public func st_add(strokeColor: UIColor?, range: NSRange? = nil) {
        let _range = (range == nil) ? NSRange(location: 0, length: self.length) : range!
        st_addAttribute(key: kCTStrokeColorAttributeName as NSAttributedString.Key, value: strokeColor?.cgColor, range: _range)
        st_addAttribute(key: .strokeColor, value: strokeColor, range: _range)
    }
    
    // strokeWidth
    public func st_add(strokeWidth: NSNumber?, range: NSRange? = nil) {
        let _range = (range == nil) ? NSRange(location: 0, length: self.length) : range!
        st_addAttribute(key: .strokeWidth, value: strokeWidth, range: _range)
    }
    
    // shadow
    public func st_add(shadow: NSShadow?, range: NSRange? = nil) {
        let _range = (range == nil) ? NSRange(location: 0, length: self.length) : range!
        st_addAttribute(key: .shadow, value: shadow, range: _range)
    }
    
    // textEffect
    public func st_add(textEffect: String?, range: NSRange? = nil) {
        let _range = (range == nil) ? NSRange(location: 0, length: self.length) : range!
        st_addAttribute(key: .textEffect, value: textEffect, range: _range)
    }
    
    // baselineOffset
    public func st_add(baselineOffset: NSNumber?, range: NSRange? = nil) {
        let _range = (range == nil) ? NSRange(location: 0, length: self.length) : range!
        st_addAttribute(key: .baselineOffset, value: baselineOffset, range: _range)
    }
    
    // underlineColor（suggest to use `SwiftyTextUnderLine`）
    public func st_add(underlineColor: UIColor?, range: NSRange? = nil) {
        let _range = (range == nil) ? NSRange(location: 0, length: self.length) : range!
        st_addAttribute(key: kCTUnderlineColorAttributeName as NSAttributedString.Key, value: underlineColor?.cgColor, range: _range)
        st_addAttribute(key: .underlineColor, value: underlineColor, range: _range)
    }
    
    // strikethroughColor（suggest to use `SwiftyTextStrikethrough`）
    public func st_add(strikethroughColor: UIColor?, range: NSRange? = nil) {
        let _range = (range == nil) ? NSRange(location: 0, length: self.length) : range!
        st_addAttribute(key: .strikethroughColor, value: strikethroughColor, range: _range)
    }
    
    // obliqueness
    public func st_add(obliqueness: NSNumber?, range: NSRange? = nil) {
        let _range = (range == nil) ? NSRange(location: 0, length: self.length) : range!
        st_addAttribute(key: .obliqueness, value: obliqueness, range: _range)
    }
    
    // expansion
    public func st_add(expansion: NSNumber?, range: NSRange? = nil) {
        let _range = (range == nil) ? NSRange(location: 0, length: self.length) : range!
        st_addAttribute(key: .expansion, value: expansion, range: _range)
    }
}

// MARK: - ParagraphStyle
extension NSMutableAttributedString {
    // paragraphStyle
    public func st_add(paragraphStyle: NSParagraphStyle, range: NSRange? = nil) {
        let _range = (range == nil) ? NSRange(location: 0, length: self.length) : range!
        st_addAttribute(key: .paragraphStyle, value: paragraphStyle, range: _range)
    }
    
    // alignment
    public func st_add(alignment: NSTextAlignment, range: NSRange? = nil) {
        let _range = (range == nil) ? NSRange(location: 0, length: self.length) : range!
        st_paragraphStyleSet(range: _range) { (style) in
            style.alignment = alignment
        }
    }
    
    // lineSpacing
    public func st_add(lineSpacing: CGFloat, range: NSRange? = nil) {
        let _range = (range == nil) ? NSRange(location: 0, length: self.length) : range!
        st_paragraphStyleSet(range: _range) { (style) in
            style.lineSpacing = lineSpacing
        }
    }
    
    // lineBreakMode（此方法慎用）
    // 如果忽略`SwiftyLabel`中的`lineBreakMode`属性，而直接通过该方法设置富文本的`lineBreakMode`，最后只会显示一行
    // 原因是`lineBreakMode`最后是设置到富文本的`NSParagraphStyle`段落样式的属性中。
    // 当富文本中的`NSParagraphStyle`属性中的`lineBreakMode`值有意义，那么用`CTFramesetter`创建的`CTLine`就只会有一行
    public func st_add(lineBreakMode: NSLineBreakMode, range: NSRange? = nil) {
        let _range = (range == nil) ? NSRange(location: 0, length: self.length) : range!
        st_paragraphStyleSet(range: _range) { (style) in
            style.lineBreakMode = lineBreakMode
        }
    }
    
    // paragraphSpacingBefore
    public func st_add(paragraphSpacingBefore: CGFloat, range: NSRange? = nil) {
        let _range = (range == nil) ? NSRange(location: 0, length: self.length) : range!
        st_paragraphStyleSet(range: _range) { (style) in
            style.paragraphSpacingBefore = paragraphSpacingBefore
        }
    }
    
    // firstLineHeadIndent
    public func st_add(firstLineHeadIndent: CGFloat, range: NSRange? = nil) {
        let _range = (range == nil) ? NSRange(location: 0, length: self.length) : range!
        st_paragraphStyleSet(range: _range) { (style) in
            style.firstLineHeadIndent = firstLineHeadIndent
        }
    }
    
    // headIndent
    public func st_add(headIndent: CGFloat, range: NSRange? = nil) {
        let _range = (range == nil) ? NSRange(location: 0, length: self.length) : range!
        st_paragraphStyleSet(range: _range) { (style) in
            style.headIndent = headIndent
        }
    }
    
    // tailIndent
    public func st_add(tailIndent: CGFloat, range: NSRange? = nil) {
        let _range = (range == nil) ? NSRange(location: 0, length: self.length) : range!
        st_paragraphStyleSet(range: _range) { (style) in
            style.tailIndent = tailIndent
        }
    }
    
    // minimumLineHeight
    public func st_add(minimumLineHeight: CGFloat, range: NSRange? = nil) {
        let _range = (range == nil) ? NSRange(location: 0, length: self.length) : range!
        st_paragraphStyleSet(range: _range) { (style) in
            style.minimumLineHeight = minimumLineHeight
        }
    }
    
    // maximumLineHeight
    public func st_add(maximumLineHeight: CGFloat, range: NSRange? = nil) {
        let _range = (range == nil) ? NSRange(location: 0, length: self.length) : range!
        st_paragraphStyleSet(range: _range) { (style) in
            style.maximumLineHeight = maximumLineHeight
        }
    }
    
    // lineHeightMultiple
    public func st_add(lineHeightMultiple: CGFloat, range: NSRange? = nil) {
        let _range = (range == nil) ? NSRange(location: 0, length: self.length) : range!
        st_paragraphStyleSet(range: _range) { (style) in
            style.lineHeightMultiple = lineHeightMultiple
        }
    }
    
    // hyphenationFactor
    public func st_add(hyphenationFactor: Float, range: NSRange? = nil) {
        let _range = (range == nil) ? NSRange(location: 0, length: self.length) : range!
        st_paragraphStyleSet(range: _range) { (style) in
            style.hyphenationFactor = hyphenationFactor
        }
    }
    
    // defaultTabInterval
    public func st_add(defaultTabInterval: CGFloat, range: NSRange? = nil) {
        let _range = (range == nil) ? NSRange(location: 0, length: self.length) : range!
        st_paragraphStyleSet(range: _range) { (style) in
            style.defaultTabInterval = defaultTabInterval
        }
    }
    
    // tabStops
    public func st_add(tabStops: [NSTextTab]?, range: NSRange? = nil) {
        let _range = (range == nil) ? NSRange(location: 0, length: self.length) : range!
        st_paragraphStyleSet(range: _range) { (style) in
            style.tabStops = tabStops
        }
    }
    
    // baseWritingDirection
    public func st_add(baseWritingDirection: NSWritingDirection, range: NSRange? = nil) {
        let _range = (range == nil) ? NSRange(location: 0, length: self.length) : range!
        st_paragraphStyleSet(range: _range) { (style) in
            style.baseWritingDirection = baseWritingDirection
        }
    }
    
    /// set paragraph style
    /// - Parameters:
    ///   - range: range
    ///   - closure: closure
    private func st_paragraphStyleSet(range: NSRange ,closure: (NSMutableParagraphStyle)->()) {
        self.enumerateAttribute(.paragraphStyle, in: range, options: .longestEffectiveRangeNotRequired) { (value, subRange, _) in
            var _style: NSMutableParagraphStyle?
            if var value = value as? NSParagraphStyle {
                if CFGetTypeID(value) == CTParagraphStyleGetTypeID() {
                    value = NSParagraphStyle.st_convert(ctStyle: value as! CTParagraphStyle)
                }
                _style = value.mutableCopy() as? NSMutableParagraphStyle
            } else {
                _style = NSMutableParagraphStyle.default.mutableCopy() as? NSMutableParagraphStyle
            }
            if let style = _style {
                closure(style)
                self.st_add(paragraphStyle: style, range: subRange)
            }
        }
    }
}

// MARK: - Attachment
extension NSAttributedString {
    public class func st_attachmentString(content: Any?,
                                          contentMode: UIView.ContentMode,
                                          size: CGSize,
                                          font: UIFont,
                                          verticalAlignment: SwiftyTextVerticalAlignment,
                                          userInfo: [String: Any]? = nil) -> NSMutableAttributedString? {
        
        let atr = NSMutableAttributedString(string: SwiftyTextAttachmentToken)
        let range = NSRange(location: 0, length: atr.length)
        
        let attachment = SwiftyTextAttachment(content: content, contentMode: contentMode, userInfo: userInfo)
        
        atr.st_addAttribute(key: .stAttachmentAttributeName, value: attachment, range: range)
        
        let width = size.width
        var ascent: CGFloat = .zero
        var descent: CGFloat = .zero
        
        switch verticalAlignment {
        case .top:
            ascent = font.ascender
            descent = size.height - font.ascender
            if descent.isLessThanOrEqualTo(.zero) {
                descent = .zero
                ascent = size.height
            }
        case .center:
            let fontHeight: CGFloat = font.ascender - font.descender
            let yOffset = font.ascender - fontHeight * 0.5
            ascent = size.height * 0.5 + yOffset
            descent = size.height - ascent
            if descent.isLessThanOrEqualTo(.zero) {
                descent = .zero
                ascent = size.height
            }
        case .bottom:
            ascent = size.height + font.descender
            descent = -font.descender
            if ascent.isLessThanOrEqualTo(.zero) {
                ascent = .zero
                descent = size.height
            }
        }
        
        let textRunDelegate = SwiftyTextRunDelegate(ascent: ascent, descent: descent, width: width, userInfo: attachment.userInfo)
        
        guard let runDelegate = textRunDelegate.getRunDelegate() else { return nil }
        
        atr.st_addAttribute(key: kCTRunDelegateAttributeName as NSAttributedString.Key, value: runDelegate, range: range)
        
        return atr
    }
}

// MARK: - Highlight
extension NSMutableAttributedString {
    public func st_highlight(with range: NSRange, backgroundColor: UIColor?, highlightTextColor: UIColor?, userInfo: [String: Any]? = nil, tapAction: SwiftyTextAction? = nil, longPressAction: SwiftyTextAction? = nil) {
        let highlight = SwiftyTextHighlight.highlight(backgroundColor: backgroundColor)
        highlight.userInfo = userInfo
        highlight.tapAction = tapAction
        highlight.longPressAction = longPressAction
        highlight.textColor = highlightTextColor
        st_add(highlight: highlight, range: range)
    }
    
    public func st_add(highlight: SwiftyTextHighlight, range: NSRange? = nil) {
        let _range = (range == nil) ? NSRange(location: 0, length: self.length) : range!
        st_addAttribute(key: .stHighlightAttributeName, value: highlight, range: _range)
    }
}

// MARK: - BackgroundBorder
extension NSMutableAttributedString {
    public func st_add(backgroundBorder: SwiftyTextBorder?, range: NSRange? = nil) {
        let _range = (range == nil) ? NSRange(location: 0, length: self.length) : range!
        st_addAttribute(key: .stBackgroundBorderAttributeName, value: backgroundBorder, range: _range)
    }
}

// MARK: - Underline
extension NSMutableAttributedString {
    public func st_add(underline: SwiftyTextUnderLine?, range: NSRange? = nil) {
        let _range = (range == nil) ? NSRange(location: 0, length: self.length) : range!
        st_addAttribute(key: .stUnderlineAttributeName, value: underline, range: _range)
    }
}

// MARK: - Strikethrough
extension NSMutableAttributedString {
    public func st_add(underline: SwiftyTextStrikethrough?, range: NSRange? = nil) {
        let _range = (range == nil) ? NSRange(location: 0, length: self.length) : range!
        st_addAttribute(key: .stStrikethroughAttributeName, value: underline, range: _range)
    }
}

// MARK: - Base
extension NSMutableAttributedString {
    /// set attribute
    /// - Parameters:
    ///   - key: key
    ///   - value: value
    ///   - range: range
    public func st_addAttribute(key: NSAttributedString.Key, value: Any?, range: NSRange) {
        removeAttribute(key, range: range)
        if let value = value {
            addAttribute(key, value: value, range: range)
        }
    }
}

