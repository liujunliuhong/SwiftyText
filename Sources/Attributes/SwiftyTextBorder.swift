//
//  SwiftyTextBorder.swift
//  SwiftyText
//
//  Created by apple on 2020/4/23.
//  Copyright © 2020 yinhe. All rights reserved.
//

import UIKit

public class SwiftyTextBorder: NSObject {
    public var innerLineStyle: SwiftyTextLineStyle = .none
    public var outerLineStyle: SwiftyTextLineStyle = .none
    public var fillColor: UIColor? = nil
    public var cornerRadius: CGFloat = 1.5
    public var insets: UIEdgeInsets = .zero
    public var lineSpace: CGFloat = 1.0
    
    public override init() {
        super.init()
    }
    
    public init(fillColor: UIColor?, cornerRadius: CGFloat, insets: UIEdgeInsets = .zero) {
        super.init()
        self.fillColor = fillColor
        self.cornerRadius = cornerRadius
        self.insets = insets
    }
}
