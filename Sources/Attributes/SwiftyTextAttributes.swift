//
//  SwiftyTextAttributes.swift
//  SwiftyText
//
//  Created by apple on 2020/4/23.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation
import UIKit


public typealias SwiftyTextAction = (UIView?, NSAttributedString?, NSRange, [String: Any]?) -> ()


public let SwiftyTextMaxSize: CGSize = CGSize(width: 0x100000, height: 0x100000)
public let SwiftyTextAttachmentToken: String = "\u{FFFC}" // empty text
public let SwiftyTextTruncationToken: String = "\u{2026}" // ...


public enum SwiftyTextTruncationType {
    case none
    case start
    case middle
    case end
}

public enum SwiftyTextVerticalAlignment {
    case top
    case center
    case bottom
}

public enum SwiftyTextLineStyle {
    case none
    case single(strokeWidth: CGFloat = .zero, strokeColor: UIColor? = nil, lineJoin: CGLineJoin = .round, lineCap: CGLineCap = .butt)
    case dash(strokeWidth: CGFloat = .zero, strokeColor: UIColor? = nil, lineJoin: CGLineJoin? = nil, lineCap: CGLineCap = .butt, lengths: [CGFloat] = [5, 3])
}
