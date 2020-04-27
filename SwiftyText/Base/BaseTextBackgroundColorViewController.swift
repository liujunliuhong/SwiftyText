//
//  BaseTextBackgroundColorViewController.swift
//  SwiftyText
//
//  Created by apple on 2020/4/27.
//  Copyright © 2020 yinhe. All rights reserved.
//

import UIKit

class BaseTextBackgroundColorViewController: BasePageViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension BaseTextBackgroundColorViewController {
    override func makeUI() {
        let frame1 = CGRect(x: 40.0, y: UIApplication.shared.statusBarFrame.height + 44.0 + 20, width: UIScreen.main.bounds.width - 40.0 - 40.0, height: 180)
        
        let label1 = SwiftyLabel()
        label1.backgroundColor = .white
        label1.frame = frame1
        label1.numberOfLines = 0
        label1.verticalAlignment = .center
        self.view.addSubview(label1)
        
        let atr1 = NSMutableAttributedString(string: BasePageExampleChineseText)
        
        let b = SwiftyTextBorder(fillColor: .red, cornerRadius: 0)
        atr1.st_add(backgroundBorder: b)
        
        atr1.st_add(font: UIFont.systemFont(ofSize: 20))
        label1.attributedText = atr1
        
        
        
        
        
        // 与`YYLabel`对比（在iPhone 7 Plues手机，13.3系统上，设置`backgroundColor`无效，网上查找资料，发现这可能是系统bug，因此框架使用`SwiftyTextBorder`来解决该问题）
        let frame2 = CGRect(x: frame1.origin.x, y: frame1.maxY + 25.0, width: frame1.width, height: 180)
        
        let label2 = YYLabel()
        label2.backgroundColor = .white
        label2.frame = frame2
        label2.numberOfLines = 0
        label2.textVerticalAlignment = .center
        self.view.addSubview(label2)
        
        let atr2 = NSMutableAttributedString(string: BasePageExampleChineseText)
        atr2.yy_setBackgroundColor(.purple, range: NSRange(location: 0, length: atr2.length))
        atr2.yy_setFont(UIFont.systemFont(ofSize: 20), range: NSRange(location: 0, length: atr2.length))
        label2.attributedText = atr2   
    }
}
