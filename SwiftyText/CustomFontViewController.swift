//
//  CustomFontViewController.swift
//  SwiftyText
//
//  Created by apple on 2020/4/26.
//  Copyright © 2020 yinhe. All rights reserved.
//

import UIKit

class CustomFontViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = "Custom Font"
        
        self.show()
    }
}

extension CustomFontViewController {
    func show() {
        var frame = CGRect(x: 40, y: 100, width: UIScreen.main.bounds.size.width - 40.0 - 40.0, height: 500)
        let label = SwiftyLabel(frame: frame)
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingMiddle
        label.backgroundColor = .orange
        self.view.addSubview(label)
        
        let sumAtr = NSMutableAttributedString()
        do {
            let range = NSRange(location: 5, length: 5)
            let atr = NSMutableAttributedString(string: "QWERTYUIOPASDFGHJKLZXCVBNMqwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNMqwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNMqwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNMqwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNMqwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNMqwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGH 哈哈JKLZXCVBNM123  反倒是发送到斯蒂芬斯蒂芬是的发送到")
            atr.st_add(font: UIFont(name: "Futura-Medium", size: 17))
            //atr.st_add(font: UIFont.boldSystemFont(ofSize: 40), range: range)
            //atr.st_add(textColor: UIColor.red, range: range)
            sumAtr.append(atr)
        }
        
        label.attributedText = sumAtr
        
        label.sizeToFit()
        
        let height = SwiftyTextLayout.layout(containerSize: CGSize(width: frame.width, height: CGFloat.greatestFiniteMagnitude), attributedText: sumAtr)?.textSize.height ?? 0.0
        frame.size.height = height
        label.frame = frame
    }
}
