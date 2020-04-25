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
    public var contentMode: UIView.ContentMode = .scaleToFill
    public var userInfo: [String : Any]? = nil
    
    private override init() {
        super.init()
    }
    
    public init(content: Any?,
                contentMode: UIView.ContentMode = .scaleAspectFit,
                userInfo: [String: Any]? = nil) {
        self.content = content
        self.contentMode = contentMode
        self.userInfo = userInfo
        super.init()
    }
}
