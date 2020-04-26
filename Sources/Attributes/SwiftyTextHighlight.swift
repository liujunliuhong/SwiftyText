//
//  SwiftyTextHighlight.swift
//  SwiftyText
//
//  Created by apple on 2020/4/24.
//  Copyright © 2020 yinhe. All rights reserved.
//

import UIKit

public class SwiftyTextHighlight: NSObject {
    // highlight attributes
    public private(set) var highlightAttributes: [NSAttributedString.Key: Any] = [:]
    // user info
    public var userInfo: [String: Any]?
    // tap action
    public var tapAction: SwiftyTextAction?
    // long press action
    public var longPressAction: SwiftyTextAction?
    // backgroundBorder
    private var _backgroundBorder: SwiftyTextBorder?
    public var backgroundBorder: SwiftyTextBorder? {
        set {
            if _backgroundBorder == newValue {
                return
            }
            _backgroundBorder = newValue
            self.set(attributeKey: .stBackgroundBorderAttributeName, value: newValue)
        }
        get {
            return _backgroundBorder
        }
    }
    // textColor
    private var _textColor: UIColor?
    public var textColor: UIColor? {
        set {
            if _textColor == newValue {
                return
            }
            _textColor = newValue
            set(attributeKey: .foregroundColor, value: newValue)
            set(attributeKey: NSAttributedString.Key(kCTForegroundColorAttributeName as String), value: newValue)
        }
        get {
            return _textColor
        }
    }
    // font
    private var _font: UIFont?
    public var font: UIFont? {
        set {
            if _font == newValue {
                return
            }
            _font = newValue
            set(attributeKey: .font, value: newValue)
        }
        get {
            return _font
        }
    }
    // strike through
    private var _strikethrough: SwiftyTextStrikethrough?
    public var strikethrough: SwiftyTextStrikethrough? {
        set {
            if _strikethrough == newValue {
                return
            }
            _strikethrough = newValue
            set(attributeKey: .stStrikethroughAttributeName, value: newValue)
        }
        get {
            return _strikethrough
        }
    }
    // under line
    private var _underline: SwiftyTextUnderLine?
    public var underline: SwiftyTextUnderLine? {
        set {
            if _underline == newValue {
                return
            }
            _underline = newValue
            set(attributeKey: .stUnderlineAttributeName, value: newValue)
        }
        get {
            return _underline
        }
    }
    
    public override init() {
        super.init()
    }
}

extension SwiftyTextHighlight {
    public class func highlight(backgroundColor: UIColor?) -> SwiftyTextHighlight {
        let backgroundBorder = SwiftyTextBorder(fillColor: backgroundColor, cornerRadius: 1.5)
        let highlight = SwiftyTextHighlight()
        highlight.backgroundBorder = backgroundBorder
        return highlight
    }
}


extension SwiftyTextHighlight {
    private func set(attributeKey: NSAttributedString.Key, value: Any?) {
        if let value = value {
            self.highlightAttributes[attributeKey] = value
        } else {
            if self.highlightAttributes.keys.contains(attributeKey) {
                self.highlightAttributes.removeValue(forKey: attributeKey)
            }
        }
    }
}
