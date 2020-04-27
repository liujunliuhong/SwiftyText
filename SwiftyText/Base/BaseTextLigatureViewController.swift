//
//  BaseTextLigatureViewController.swift
//  SwiftyText
//
//  Created by apple on 2020/4/27.
//  Copyright © 2020 yinhe. All rights reserved.
//

import UIKit

class BaseTextLigatureViewController: BasePageViewController {

    let ligatureText: String = "fifififififififififififififififififififififififififififgfgfllllllllliiiiiiilililiflflflflflfl"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension BaseTextLigatureViewController {
    override func makeUI() {
        let frame1 = CGRect(x: 40.0, y: UIApplication.shared.statusBarFrame.height + 44.0 + 20, width: UIScreen.main.bounds.width - 40.0 - 40.0, height: 180)
        
        let label1 = SwiftyLabel()
        label1.backgroundColor = .orange
        label1.frame = frame1
        label1.numberOfLines = 0
        label1.verticalAlignment = .center
        self.view.addSubview(label1)
        
        let atr1 = NSMutableAttributedString(string: ligatureText)
        atr1.st_add(font: UIFont(name: "futura", size: 20))
        atr1.st_add(ligature: NSNumber(value: 0))
        label1.attributedText = atr1
        
        
        
        
        
        let frame2 = CGRect(x: frame1.origin.x, y: frame1.maxY + 25.0, width: frame1.width, height: 180)
        
        let label2 = SwiftyLabel()
        label2.backgroundColor = .orange
        label2.frame = frame2
        label2.numberOfLines = 0
        label2.verticalAlignment = .center
        self.view.addSubview(label2)
        
        let atr2 = NSMutableAttributedString(string: ligatureText)
        atr2.st_add(font: UIFont(name: "futura", size: 20))
        atr2.st_add(ligature: NSNumber(value: 1))
        label2.attributedText = atr2
        
        
        
        
        
        // 与`YYLabel`对比
        let frame3 = CGRect(x: frame2.origin.x, y: frame2.maxY + 25.0, width: frame2.width, height: 180)
        
        let label3 = YYLabel()
        label3.backgroundColor = .orange
        label3.frame = frame3
        label3.numberOfLines = 0
        label3.textVerticalAlignment = .center
        self.view.addSubview(label3)
        
        let atr3 = NSMutableAttributedString(string: ligatureText)
        atr3.yy_setFont(UIFont(name: "futura", size: 20), range: NSRange(location: 0, length: atr2.length))
        atr3.yy_setLigature(NSNumber(value: 1.5), range: NSRange(location: 0, length: atr2.length))
        label3.attributedText = atr3
    }
}
