//
//  BaseTextColorViewController.swift
//  SwiftyText
//
//  Created by apple on 2020/4/27.
//  Copyright © 2020 yinhe. All rights reserved.
//

import UIKit

class BaseTextColorViewController: BasePageViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension BaseTextColorViewController {
    override func makeUI() {
        let frame1 = CGRect(x: 40.0, y: UIApplication.shared.statusBarFrame.height + 44.0 + 20, width: UIScreen.main.bounds.width - 40.0 - 40.0, height: 180)
        let label1 = SwiftyLabel()
        label1.frame = frame1
        label1.text = BasePageExampleChineseText
        label1.numberOfLines = 0
        label1.verticalAlignment = .center
        label1.font = UIFont.systemFont(ofSize: 20)
        label1.textColor = UIColor.black
        label1.backgroundColor = UIColor.orange
        self.view.addSubview(label1)
        
        let frame2 = CGRect(x: frame1.origin.x, y: frame1.maxY + 25.0, width: frame1.width, height: 180)
        let label2 = SwiftyLabel()
        label2.frame = frame2
        label2.text = BasePageExampleChineseText
        label2.numberOfLines = 0
        label2.verticalAlignment = .center
        label2.font = UIFont.systemFont(ofSize: 20)
        label2.textColor = .cyan
        label2.backgroundColor = UIColor.orange
        self.view.addSubview(label2)
        
        
        // 与`YYLabel`对比
        let frame3 = CGRect(x: frame2.origin.x, y: frame2.maxY + 25.0, width: frame2.width, height: 180)
        let label3 = YYLabel()
        label3.frame = frame3
        label3.text = BasePageExampleChineseText
        label3.numberOfLines = 0
        label3.textVerticalAlignment = .center
        label3.font = UIFont.systemFont(ofSize: 20)
        label3.textColor = .cyan
        label3.backgroundColor = UIColor.orange
        self.view.addSubview(label3)
    }
}
