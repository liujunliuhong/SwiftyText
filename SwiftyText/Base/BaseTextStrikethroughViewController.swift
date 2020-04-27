//
//  BaseTextStrikethroughViewController.swift
//  SwiftyText
//
//  Created by apple on 2020/4/27.
//  Copyright © 2020 yinhe. All rights reserved.
//

import UIKit

class BaseTextStrikethroughViewController: BasePageViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension BaseTextStrikethroughViewController {
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
        
        let s1 = SwiftyTextStrikethrough()
        s1.firstLineStyle = SwiftyTextLineStyle.single(strokeWidth: 1, strokeColor: .cyan, lineJoin: .round, lineCap: .round)
        atr1.st_add(strikethrough: s1)
        label1.attributedText = atr1
        
        
        
        
        
        let frame2 = CGRect(x: frame1.origin.x, y: frame1.maxY + 25.0, width: frame1.width, height: 180)
        
        let label2 = SwiftyLabel()
        label2.backgroundColor = .orange
        label2.frame = frame2
        label2.numberOfLines = 0
        label2.verticalAlignment = .center
        self.view.addSubview(label2)
        
        let atr2 = NSMutableAttributedString(string: BasePageExampleChineseText)
        atr2.st_add(font: UIFont.systemFont(ofSize: 20))
        
        let s2 = SwiftyTextStrikethrough()
        s2.firstLineStyle = SwiftyTextLineStyle.single(strokeWidth: 1, strokeColor: .cyan, lineJoin: .round, lineCap: .round) // 第一条线
        s2.secondLineStyle = SwiftyTextLineStyle.single(strokeWidth: 1, strokeColor: .cyan, lineJoin: .round, lineCap: .round) // 第二条线
        s2.lineSpace = 1.0 // 两条线之间的间距
        atr2.st_add(strikethrough: s2)
        
        label2.attributedText = atr2
        
        
        
        
        
        // 与`YYLabel`对比
        let frame3 = CGRect(x: frame2.origin.x, y: frame2.maxY + 25.0, width: frame2.width, height: 180)
        
        let label3 = YYLabel()
        label3.backgroundColor = .orange
        label3.frame = frame3
        label3.numberOfLines = 0
        label3.textVerticalAlignment = .center
        self.view.addSubview(label3)
        
        let atr3 = NSMutableAttributedString(string: BasePageExampleChineseText)
        atr3.yy_setFont(UIFont.systemFont(ofSize: 20), range: NSRange(location: 0, length: atr2.length))
        
        let s3 = YYTextDecoration(style: .double)
        s3.color = .cyan
        s3.width = 1.0
        atr3.yy_setTextStrikethrough(s3, range: NSRange(location: 0, length: atr2.length))
        
        label3.attributedText = atr3
    }
}
