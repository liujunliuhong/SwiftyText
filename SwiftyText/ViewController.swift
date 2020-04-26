//
//  ViewController.swift
//  SwiftyText
//
//  Created by apple on 2020/4/23.
//  Copyright © 2020 yinhe. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.showLabel()
    }
}


extension ViewController {
    func showLabel() {
        let frame = CGRect(x: 40, y: 100, width: UIScreen.main.bounds.size.width - 40.0 - 40.0, height: 350)
        let label = SwiftyLabel(frame: frame)
        label.backgroundColor = .orange
        self.view.addSubview(label)
        
        
        let sumAtr = NSMutableAttributedString()
        
        do {
            let atr = NSMutableAttributedString(string: "HellomynameisLiuJunHellomynameisLiuJunHellomynameisLiuJunHellomynameisLiuJunHellomynameisLiuJunHellomynameisLiuJunHellomynameisLiuJunHellomynameisLiuJunHellomynameisLiuJunHellomynameisLiuJun")
            atr.st_add(font: UIFont.systemFont(ofSize: 17))
            atr.st_add(font: UIFont.boldSystemFont(ofSize: 40), range: NSRange(location: 5, length: 20))
            atr.st_add(textColor: UIColor.red, range: NSRange(location: 5, length: 20))
            
            sumAtr.append(atr)
        }
        
        label.attributedText = sumAtr
        
        
    }
}

