//
//  SwiftyTextAttachment.swift
//  SwiftyText
//
//  Created by apple on 2020/4/23.
//  Copyright © 2020 yinhe. All rights reserved.
//

import UIKit

public class SwiftyTextAttachment: NSObject {
    public var content: Any?
    public var size: CGSize
    public var font: UIFont
    public var alignment: SwiftyTextVerticalAlignment
    public var contentMode: UIView.ContentMode = .scaleToFill
    public var userInfo: [String : Any]? = nil
    
    private override init() {
        self.size = .zero
        self.font = UIFont.systemFont(ofSize: 15)
        self.alignment = .center
        super.init()
    }
    
    public init(content: Any?,
                size: CGSize,
                font: UIFont,
                alignment: SwiftyTextVerticalAlignment = .center,
                contentMode: UIView.ContentMode = .scaleAspectFit,
                userInfo: [String: Any]? = nil) {
        self.content = content
        self.size = size
        self.font = font
        self.alignment = alignment
        self.contentMode = contentMode
        self.userInfo = userInfo
        super.init()
    }
}
