//
//  SwiftyTextStrikethrough.swift
//  SwiftyText
//
//  Created by apple on 2020/4/24.
//  Copyright © 2020 yinhe. All rights reserved.
//

import UIKit

public class SwiftyTextStrikethrough: NSObject {
    public var firstLineStyle: SwiftyTextLineStyle = .none
    public var secondLineStyle: SwiftyTextLineStyle = .none
    public var lineSpace: CGFloat = 1.0
    
    public override init() {
        super.init()
    }
}
