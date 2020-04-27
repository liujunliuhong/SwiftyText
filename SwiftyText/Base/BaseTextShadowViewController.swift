//
//  BaseTextShadowViewController.swift
//  SwiftyText
//
//  Created by apple on 2020/4/27.
//  Copyright © 2020 yinhe. All rights reserved.
//

import UIKit

class BaseTextShadowViewController: BasePageViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension BaseTextShadowViewController {
    override func makeUI() {
        let frame1 = CGRect(x: 40.0, y: UIApplication.shared.statusBarFrame.height + 44.0 + 20, width: UIScreen.main.bounds.width - 40.0 - 40.0, height: 180)
        
        let label1 = SwiftyLabel()
        label1.backgroundColor = .orange
        label1.frame = frame1
        label1.numberOfLines = 0
        label1.verticalAlignment = .center
        self.view.addSubview(label1)

        let atr1 = NSMutableAttributedString(string: BasePageExampleChineseText)
        atr1.st_add(font: UIFont.systemFont(ofSize: 20))

        let shadow = NSShadow()
        shadow.shadowColor = UIColor.red
        shadow.shadowOffset = CGSize(width: 0, height: 3)
        shadow.shadowBlurRadius = 0.9
        atr1.st_add(shadow: shadow)

        label1.attributedText = atr1
        
        
        
        
        
        let frame2 = CGRect(x: frame1.origin.x, y: frame1.maxY + 25.0, width: frame1.width, height: 180)
        
        let label2 = SwiftyLabel()
        label2.backgroundColor = .orange
        label2.text = BasePageExampleChineseText
        label2.font = UIFont.systemFont(ofSize: 20)
        label2.frame = frame2
        label2.numberOfLines = 0
        label2.verticalAlignment = .center
        label2.shadowBlurRadius = 0.9
        label2.shadowOffset = CGSize(width: 0, height: 3)
        label2.shadowColor = UIColor.red
        self.view.addSubview(label2)
        
        
        
        
        
        // 与`YYLabel`对比
        let frame3 = CGRect(x: frame2.origin.x, y: frame2.maxY + 25.0, width: frame2.width, height: 180)

        let label3 = YYLabel()
        label3.backgroundColor = .orange
        label3.frame = frame3
        label3.numberOfLines = 0
        label3.textVerticalAlignment = .center
        self.view.addSubview(label3)

        let atr3 = NSMutableAttributedString(string: BasePageExampleChineseText)
        atr3.yy_setFont(UIFont.systemFont(ofSize: 20), range: NSRange(location: 0, length: atr3.length))


        let shadow3 = NSShadow()
        shadow3.shadowColor = UIColor.red
        shadow3.shadowOffset = CGSize(width: 0, height: 3)
        shadow3.shadowBlurRadius = 0.9
        atr3.yy_setShadow(shadow3, range: NSRange(location: 0, length: atr3.length))

        label3.attributedText = atr3
    }
}
