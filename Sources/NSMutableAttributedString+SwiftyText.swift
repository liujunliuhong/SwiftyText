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
 * paragraphStyle         // NSParagraphStyle,
                             default defaultParagraphStyle
 * foregroundColor        // UIColor,
                             default blackColor
 * backgroundColor        // UIColor,
                             default nil: no background
 * ligature               // NSNumber containing integer,
                             default 1: default ligatures,
                             0: no ligatures
 * kern                   // NSNumber containing floating point value, in points;
                             amount to modify default kerning.
                             0 means kerning is disabled.
 * strikethroughStyle     // NSNumber containing integer,
                             default 0: no strikethrough
 * underlineStyle         // NSNumber containing integer,
                             default 0: no underline
 * strokeColor            // UIColor,
                             default nil: same as foreground color
 * strokeWidth            // NSNumber containing floating point value,
                             in percent of font point size,
                             default 0: no stroke;
                             positive for stroke alone, negative for stroke and fill (a typical value for outlined text would be 3.0)
 * shadow                 // NSShadow, default nil: no shadow
 * textEffect             // NSString, default nil: no text effect
 * attachment             // NSTextAttachment, default nil
 * link                   // NSURL (preferred) or NSString
 * baselineOffset         // NSNumber containing floating point value, in points;
                             offset from baseline, default 0
 * underlineColor         // UIColor, default nil:
                             same as foreground color
 * strikethroughColor     // UIColor, default nil:
                             same as foreground color
 * obliqueness            // NSNumber containing floating point value;
                             skew to be applied to glyphs,
                             default 0: no skew
 * expansion              // NSNumber containing floating point value;
                             log of expansion factor to be applied to glyphs,
                             default 0: no expansion
 * writingDirection       // NSArray of NSNumbers representing the nested levels of writing direction overrides as defined by Unicode LRE, RLE, LRO, and RLO characters.
                             The control characters can be obtained by masking NSWritingDirection and NSWritingDirectionFormatType values.
                             LRE: NSWritingDirectionLeftToRight|NSWritingDirectionEmbedding,
                             RLE: NSWritingDirectionRightToLeft|NSWritingDirectionEmbedding,
                             LRO: NSWritingDirectionLeftToRight|NSWritingDirectionOverride,
                             RLO: NSWritingDirectionRightToLeft|NSWritingDirectionOverride,
 * verticalGlyphForm      // An NSNumber containing an integer value.
                             0 means horizontal text.
                             1 indicates vertical text.
                             If not specified, it could follow higher-level vertical orientation settings.
                             Currently on iOS, it's always horizontal.
                             The behavior for any other value is undefined.
 */

// MARK: - Common Attribute
/*
 `SwiftyTextBorder` replace `backgroundColor`
 `SwiftyTextUnderLine` replace `underlineStyle` and `underlineColor`
 `SwiftyTextStrikethrough` replace `strikethroughStyle` and `strikethroughColor`
 */
extension NSMutableAttributedString {
    // font
    public func st_add(font: UIFont?, range: NSRange? = nil) {
        st_addAttribute(key: .font, value: font, range: range)
    }
    
    // foregroundColor
    public func st_add(textColor: UIColor?, range: NSRange? = nil) {
        st_addAttribute(key: kCTForegroundColorAttributeName as NSAttributedString.Key, value: textColor?.cgColor, range: range)
        st_addAttribute(key: .foregroundColor, value: textColor, range: range)
    }
    
    // ligature
    public func st_add(ligature: NSNumber?, range: NSRange? = nil) {
        st_addAttribute(key: .ligature, value: ligature, range: range)
    }
    
    // kern
    public func st_add(kern: NSNumber?, range: NSRange? = nil) {
        st_addAttribute(key: .kern, value: kern, range: range)
    }
    
    // strokeColor
    public func st_add(strokeColor: UIColor?, range: NSRange? = nil) {
        st_addAttribute(key: kCTStrokeColorAttributeName as NSAttributedString.Key, value: strokeColor?.cgColor, range: range)
        st_addAttribute(key: .strokeColor, value: strokeColor, range: range)
    }
    
    // strokeWidth
    public func st_add(strokeWidth: NSNumber?, range: NSRange? = nil) {
        st_addAttribute(key: .strokeWidth, value: strokeWidth, range: range)
    }
    
    // shadow
    public func st_add(shadow: NSShadow?, range: NSRange? = nil) {
        st_addAttribute(key: .shadow, value: shadow, range: range)
    }
    
    // textEffect
    public func st_add(textEffect: String?, range: NSRange? = nil) {
        st_addAttribute(key: .textEffect, value: textEffect, range: range)
    }
    
    // baselineOffset
    public func st_add(baselineOffset: NSNumber?, range: NSRange? = nil) {
        st_addAttribute(key: .baselineOffset, value: baselineOffset, range: range)
    }
    
    // obliqueness
    public func st_add(obliqueness: NSNumber?, range: NSRange? = nil) {
        st_addAttribute(key: .obliqueness, value: obliqueness, range: range)
    }
    
    // expansion
    public func st_add(expansion: NSNumber?, range: NSRange? = nil) {
        st_addAttribute(key: .expansion, value: expansion, range: range)
    }
}

// MARK: - ParagraphStyle
extension NSMutableAttributedString {
    // paragraphStyle
    public func st_add(paragraphStyle: NSParagraphStyle, range: NSRange? = nil) {
        st_addAttribute(key: .paragraphStyle, value: paragraphStyle, range: range)
    }
    
    // alignment
    public func st_add(alignment: NSTextAlignment, range: NSRange? = nil) {
        st_paragraphStyleSet(range: range) { (style) in
            style.alignment = alignment
        }
    }
    
    // lineSpacing
    public func st_add(lineSpacing: CGFloat, range: NSRange? = nil) {
        st_paragraphStyleSet(range: range) { (style) in
            style.lineSpacing = lineSpacing
        }
    }
    
    // lineBreakMode（此方法慎用）
    // 如果忽略`SwiftyLabel`中的`lineBreakMode`属性，而直接通过该方法设置富文本的`lineBreakMode`，最后只会显示一行
    // 原因是`lineBreakMode`最后是设置到富文本的`NSParagraphStyle`段落样式的属性中。
    // 当富文本中的`NSParagraphStyle`属性中的`lineBreakMode`值有意义，那么用`CTFramesetter`创建的`CTLine`就只会有一行
    public func st_add(lineBreakMode: NSLineBreakMode, range: NSRange? = nil) {
        st_paragraphStyleSet(range: range) { (style) in
            style.lineBreakMode = lineBreakMode
        }
    }
    
    // paragraphSpacingBefore
    public func st_add(paragraphSpacingBefore: CGFloat, range: NSRange? = nil) {
        st_paragraphStyleSet(range: range) { (style) in
            style.paragraphSpacingBefore = paragraphSpacingBefore
        }
    }
    
    // paragraphSpacing
    public func st_add(paragraphSpacing: CGFloat, range: NSRange? = nil) {
        st_paragraphStyleSet(range: range) { (style) in
            style.paragraphSpacing = paragraphSpacing
        }
    }
    
    // firstLineHeadIndent
    public func st_add(firstLineHeadIndent: CGFloat, range: NSRange? = nil) {
        st_paragraphStyleSet(range: range) { (style) in
            style.firstLineHeadIndent = firstLineHeadIndent
        }
    }
    
    // headIndent
    public func st_add(headIndent: CGFloat, range: NSRange? = nil) {
        st_paragraphStyleSet(range: range) { (style) in
            style.headIndent = headIndent
        }
    }
    
    // tailIndent
    public func st_add(tailIndent: CGFloat, range: NSRange? = nil) {
        st_paragraphStyleSet(range: range) { (style) in
            style.tailIndent = tailIndent
        }
    }
    
    // minimumLineHeight
    public func st_add(minimumLineHeight: CGFloat, range: NSRange? = nil) {
        st_paragraphStyleSet(range: range) { (style) in
            style.minimumLineHeight = minimumLineHeight
        }
    }
    
    // maximumLineHeight
    public func st_add(maximumLineHeight: CGFloat, range: NSRange? = nil) {
        st_paragraphStyleSet(range: range) { (style) in
            style.maximumLineHeight = maximumLineHeight
        }
    }
    
    // lineHeightMultiple
    public func st_add(lineHeightMultiple: CGFloat, range: NSRange? = nil) {
        st_paragraphStyleSet(range: range) { (style) in
            style.lineHeightMultiple = lineHeightMultiple
        }
    }
    
    // hyphenationFactor
    public func st_add(hyphenationFactor: Float, range: NSRange? = nil) {
        st_paragraphStyleSet(range: range) { (style) in
            style.hyphenationFactor = hyphenationFactor
        }
    }
    
    // defaultTabInterval
    public func st_add(defaultTabInterval: CGFloat, range: NSRange? = nil) {
        st_paragraphStyleSet(range: range) { (style) in
            style.defaultTabInterval = defaultTabInterval
        }
    }
    
    // tabStops
    public func st_add(tabStops: [NSTextTab]?, range: NSRange? = nil) {
        st_paragraphStyleSet(range: range) { (style) in
            style.tabStops = tabStops
        }
    }
    
    // baseWritingDirection
    public func st_add(baseWritingDirection: NSWritingDirection, range: NSRange? = nil) {
        st_paragraphStyleSet(range: range) { (style) in
            style.baseWritingDirection = baseWritingDirection
        }
    }
    
    /// set paragraph style
    /// - Parameters:
    ///   - range: range
    ///   - closure: closure
    private func st_paragraphStyleSet(range: NSRange? ,closure: (NSMutableParagraphStyle)->()) {
        let _range = (range == nil) ? NSRange(location: 0, length: self.length) : range!
        self.enumerateAttribute(.paragraphStyle, in: _range, options: .longestEffectiveRangeNotRequired) { (value, subRange, _) in
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

// MARK: - Get Attribute
extension NSAttributedString {
    
    public func st_attributes(index: Int = 0) -> [NSAttributedString.Key: Any]? {
        return self.st_getAttributes(index: index)
    }
    
    public func st_font(index: Int = 0) -> UIFont? {
        return self.st_getAttribute(attributeName: .font, index: index) as? UIFont
    }
    
    public func st_textColor(index: Int = 0) -> UIColor? {
        var color = self.st_getAttribute(attributeName: .foregroundColor, index: index) as? UIColor
        if color == nil {
            if let tmpColor = st_getAttribute(attributeName: kCTForegroundColorAttributeName as NSAttributedString.Key, index: index) {
                color = UIColor(cgColor: tmpColor as! CGColor)
            }
        }
        return color
    }
    
    public func st_ligature(index: Int = 0) -> NSNumber? {
        return self.st_getAttribute(attributeName: .ligature, index: index) as? NSNumber
    }
    
    public func st_kern(index: Int = 0) -> NSNumber? {
        return self.st_getAttribute(attributeName: .kern, index: index) as? NSNumber
    }
    
    public func st_strikethroughStyle(index: Int = 0) -> NSUnderlineStyle? {
        return self.st_getAttribute(attributeName: .strikethroughStyle, index: index) as? NSUnderlineStyle
    }
    
    public func st_underlineStyle(index: Int = 0) -> NSUnderlineStyle? {
        return self.st_getAttribute(attributeName: .underlineStyle, index: index) as? NSUnderlineStyle
    }
    
    public func st_strokeColor(index: Int = 0) -> UIColor? {
        var color = self.st_getAttribute(attributeName: .strokeColor, index: index) as? UIColor
        if color == nil {
            if let tmpColor = st_getAttribute(attributeName: kCTStrokeColorAttributeName as NSAttributedString.Key, index: index) {
                color = UIColor(cgColor: tmpColor as! CGColor)
            }
        }
        return color
    }
    
    public func st_strokeWidth(index: Int = 0) -> NSNumber? {
        return self.st_getAttribute(attributeName: .strokeWidth, index: index) as? NSNumber
    }
    
    public func st_shadow(index: Int = 0) -> NSShadow? {
        return self.st_getAttribute(attributeName: .shadow, index: index) as? NSShadow
    }
    
    public func st_textEffect(index: Int = 0) -> String? {
        return self.st_getAttribute(attributeName: .textEffect, index: index) as? String
    }
    
    public func st_baselineOffset(index: Int = 0) -> NSNumber? {
        return self.st_getAttribute(attributeName: .baselineOffset, index: index) as? NSNumber
    }
    
    public func st_underlineColor(index: Int = 0) -> UIColor? {
        var color = self.st_getAttribute(attributeName: .underlineColor, index: index) as? UIColor
        if color == nil {
            if let tmpColor = st_getAttribute(attributeName: kCTUnderlineColorAttributeName as NSAttributedString.Key, index: index) {
                color = UIColor(cgColor: tmpColor as! CGColor)
            }
        }
        return color
    }
    
    public func st_strikethroughColor(index: Int = 0) -> UIColor? {
        return self.st_getAttribute(attributeName: .strikethroughColor, index: index) as? UIColor
    }
    
    public func st_obliqueness(index: Int = 0) -> NSNumber? {
        return self.st_getAttribute(attributeName: .obliqueness, index: index) as? NSNumber
    }
    
    public func st_expansion(index: Int = 0) -> NSNumber? {
        return self.st_getAttribute(attributeName: .expansion, index: index) as? NSNumber
    }
    
    public func st_paragraphStyle(index: Int = 0) -> NSParagraphStyle? {
        var style = self.st_getAttribute(attributeName: .paragraphStyle, index: index) as? NSParagraphStyle
        if let s = style {
            if CFGetTypeID(s) == CTParagraphStyleGetTypeID() {
                style = NSParagraphStyle.st_convert(ctStyle: style as! CTParagraphStyle)
            }
        }
        return style
    }
    
    public func st_alignment(index: Int = 0) -> NSTextAlignment {
        let style = self.st_paragraphStyle(index: index) ?? NSParagraphStyle.default
        return style.alignment
    }
    
    public func st_lineSpacing(index: Int = 0) -> CGFloat {
        let style = self.st_paragraphStyle(index: index) ?? NSParagraphStyle.default
        return style.lineSpacing
    }
    
    public func st_lineBreakMode(index: Int = 0) -> NSLineBreakMode {
        let style = self.st_paragraphStyle(index: index) ?? NSParagraphStyle.default
        return style.lineBreakMode
    }
    
    public func st_paragraphSpacingBefore(index: Int = 0) -> CGFloat {
        let style = self.st_paragraphStyle(index: index) ?? NSParagraphStyle.default
        return style.paragraphSpacingBefore
    }
    
    public func st_paragraphSpacing(index: Int = 0) -> CGFloat {
        let style = self.st_paragraphStyle(index: index) ?? NSParagraphStyle.default
        return style.paragraphSpacing
    }
    
    public func st_firstLineHeadIndent(index: Int = 0) -> CGFloat {
        let style = self.st_paragraphStyle(index: index) ?? NSParagraphStyle.default
        return style.firstLineHeadIndent
    }
    
    public func st_headIndent(index: Int = 0) -> CGFloat {
        let style = self.st_paragraphStyle(index: index) ?? NSParagraphStyle.default
        return style.headIndent
    }
    
    public func st_tailIndent(index: Int = 0) -> CGFloat {
        let style = self.st_paragraphStyle(index: index) ?? NSParagraphStyle.default
        return style.tailIndent
    }
    
    public func st_minimumLineHeight(index: Int = 0) -> CGFloat {
        let style = self.st_paragraphStyle(index: index) ?? NSParagraphStyle.default
        return style.minimumLineHeight
    }
    
    public func st_maximumLineHeight(index: Int = 0) -> CGFloat {
        let style = self.st_paragraphStyle(index: index) ?? NSParagraphStyle.default
        return style.maximumLineHeight
    }
    
    public func st_lineHeightMultiple(index: Int = 0) -> CGFloat {
        let style = self.st_paragraphStyle(index: index) ?? NSParagraphStyle.default
        return style.lineHeightMultiple
    }
    
    public func st_hyphenationFactor(index: Int = 0) -> CGFloat {
        let style = self.st_paragraphStyle(index: index) ?? NSParagraphStyle.default
        return CGFloat(style.hyphenationFactor)
    }
    
    public func st_defaultTabInterval(index: Int = 0) -> CGFloat {
        let style = self.st_paragraphStyle(index: index) ?? NSParagraphStyle.default
        return style.defaultTabInterval
    }
    
    public func st_tabStops(index: Int = 0) -> [NSTextTab] {
        let style = self.st_paragraphStyle(index: index) ?? NSParagraphStyle.default
        return style.tabStops
    }
    
    public func st_baseWritingDirection(index: Int = 0) -> NSWritingDirection {
        let style = self.st_paragraphStyle(index: index) ?? NSParagraphStyle.default
        return style.baseWritingDirection
    }
    
    public func st_backgroundColor(index: Int = 0) -> UIColor? {
        let b = self.st_getAttribute(attributeName: .stBackgroundBorderAttributeName, index: index) as? SwiftyTextBorder
        return b?.fillColor
    }
    
    public func st_underline(index: Int = 0) -> SwiftyTextUnderLine? {
        return self.st_getAttribute(attributeName: .stUnderlineAttributeName, index: index) as? SwiftyTextUnderLine
    }
    
    public func st_strikethrough(index: Int = 0) -> SwiftyTextStrikethrough? {
        return self.st_getAttribute(attributeName: .stStrikethroughAttributeName, index: index) as? SwiftyTextStrikethrough
    }
    
    public func st_plainText(range: NSRange? = nil) -> String {
        let _range = (range == nil) ? NSRange(location: 0, length: self.length) : range!
        
        var result = ""
        if _range.length == 0 {
            return result
        }
        let string = self.string
        enumerateAttribute(.stRePlaceAttributeName, in: _range, options: .longestEffectiveRangeNotRequired, using: { value, range, _ in
            if let replace = value as? SwiftyTextReplace {
                result += replace.replaceString
            } else {
                result += (string as NSString).substring(with: range)
            }
        })
        return result
    }
}

// MARK: - Replace
extension NSMutableAttributedString {
    public func st_add(replaceString: String, range: NSRange? = nil) {
        st_addAttribute(key: .stRePlaceAttributeName, value: replaceString, range: range)
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
        st_addAttribute(key: .stHighlightAttributeName, value: highlight, range: range)
    }
}

// MARK: - BackgroundBorder
extension NSMutableAttributedString {
    public func st_add(backgroundBorder: SwiftyTextBorder?, range: NSRange? = nil) {
        // remove `NSAttributedString.Key.backgroundColor` attributes
        let _range = (range == nil) ? NSRange(location: 0, length: self.length) : range!
        self.removeAttribute(.backgroundColor, range: _range)
        // set `SwiftyTextBorder`
        st_addAttribute(key: .stBackgroundBorderAttributeName, value: backgroundBorder, range: range)
    }
}

// MARK: - Underline
extension NSMutableAttributedString {
    public func st_add(underline: SwiftyTextUnderLine?, range: NSRange? = nil) {
        // remove
        let _range = (range == nil) ? NSRange(location: 0, length: self.length) : range!
        self.removeAttribute(.underlineColor, range: _range)
        self.removeAttribute(.underlineStyle, range: _range)
        // set `SwiftyTextUnderLine`
        st_addAttribute(key: .stUnderlineAttributeName, value: underline, range: range)
    }
}

// MARK: - Strikethrough
extension NSMutableAttributedString {
    public func st_add(strikethrough: SwiftyTextStrikethrough?, range: NSRange? = nil) {
        // remove
        let _range = (range == nil) ? NSRange(location: 0, length: self.length) : range!
        self.removeAttribute(.strikethroughColor, range: _range)
        self.removeAttribute(.strikethroughStyle, range: _range)
        // set `SwiftyTextStrikethrough`
        st_addAttribute(key: .stStrikethroughAttributeName, value: strikethrough, range: range)
    }
}

// MARK: - Base
extension NSMutableAttributedString {
    /// set attribute
    /// - Parameters:
    ///   - key: key
    ///   - value: value
    ///   - range: range
    public func st_addAttribute(key: NSAttributedString.Key, value: Any?, range: NSRange? = nil) {
        let _range = (range == nil) ? NSRange(location: 0, length: self.length) : range!
        removeAttribute(key, range: _range)
        if let value = value {
            addAttribute(key, value: value, range: _range)
        }
    }
    
    /// set attributes
    /// - Parameters:
    ///   - attributes: attributes
    ///   - range: range
    public func st_addAttributes(attributes: [NSAttributedString.Key: Any]?, range: NSRange? = nil) {
        let _range = (range == nil) ? NSRange(location: 0, length: self.length) : range!
        guard let attributes = attributes else { return }
        self.setAttributes([:], range: _range)
        for atr in attributes {
            self.st_addAttribute(key: atr.key, value: atr.value, range: _range)
        }
    }
    
    
    /// insert string
    /// - Parameters:
    ///   - string: string
    ///   - location: location
    public func st_insert(string: String?, location: Int) {
        guard let string = string else { return }
        var location = location
        if location > self.length {
            location = self.length
        } else if location < 0 {
            location = 0
        }
        self.replaceCharacters(in: NSRange(location: location, length: 0), with: string)
        self.st_removeDiscontinuousAttributes(range: NSRange(location: location, length: string.count))
    }
    
    
    /// append string
    /// - Parameter string: string
    public func st_append(string: String?) {
        self.st_insert(string: string, location: self.length)
    }
}

extension NSAttributedString {
    /// get attribute
    /// - Parameters:
    ///   - attributeName: attributeName
    ///   - index: index
    public func st_getAttribute(attributeName: NSAttributedString.Key?, index: Int) -> Any? {
        guard let attributeName = attributeName else { return nil }
        if index > self.length || self.length == 0 {
            return nil
        }
        var idx = index
        if self.length > 0 && index == self.length {
            idx -= 1
        }
        return self.attribute(attributeName, at: idx, effectiveRange: nil)
    }
    
    
    /// get attributes
    /// - Parameter index: index
    public func st_getAttributes(index: Int) -> [NSAttributedString.Key: Any]? {
        if index > self.length || self.length == 0 {
            return nil
        }
        var idx = index
        if self.length > 0 && index == self.length {
            idx -= 1
        }
        return self.attributes(at: idx, effectiveRange: nil)
    }
}
