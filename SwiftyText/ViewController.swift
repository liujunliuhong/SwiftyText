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
        self.uikitLabel()
    }
}

// 😆♊️✌️🌥🦈🐉🎍🏒🏀🏑🧩🚜🚛🏍🕋🕍💒🏬🏡🗽🏯🏤🛵🛵🚊🚦🗺⚖🛢💎🗑⏰🖲🔓🔐🈲☢️☣️♏️☢️㊗️🚷㊙️🎵⤴️↘️🔺🔵⬛️⏏️🇸🇬🇸🇷🇵🇹🇵🇭🇵🇪🇷🇸🇰🇳🦅🐒🦜🦚🚄♒️
extension ViewController {
    func showLabel() {
        let frame = CGRect(x: 40, y: 100, width: UIScreen.main.bounds.size.width - 40.0 - 40.0, height: 100)
        let label = SwiftyLabel(frame: frame)
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingMiddle
        
        
//        let a = NSMutableAttributedString(string: "AAAAAAAAAAAAAAABBBBBB")
//        a.st_add(textColor: .cyan)
//        a.st_add(font: UIFont.systemFont(ofSize: 17))
//        label.truncationToken = a
        
        
        label.backgroundColor = .orange
        self.view.addSubview(label)
        
        let sumAtr = NSMutableAttributedString()
        do {
            let range = NSRange(location: 5, length: 5)
            let atr = NSMutableAttributedString(string: "QWERTYUIOPASDFGHJKLZXCVBNMqwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNMqwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNMqwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNMqwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNMqwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNMqwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNMqwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNMqwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNMqwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNMqwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNMqwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNMqwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNMqwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNMqwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNMqwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNMqwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNMqwertyuiopasdfghjklzxcvbnm123")
            atr.st_add(font: UIFont.systemFont(ofSize: 17))
//            atr.st_add(font: UIFont.boldSystemFont(ofSize: 40), range: range)
//            atr.st_add(textColor: UIColor.red, range: range)
            
            sumAtr.append(atr)
        }
        
        label.attributedText = sumAtr
        
        
        
        
        
    }
    
    func uikitLabel() {
        let frame = CGRect(x: 40, y: 250, width: UIScreen.main.bounds.size.width - 40.0 - 40.0, height: 100)
        let label = UILabel(frame: frame)
        label.numberOfLines = 0
        label.backgroundColor = .orange
        label.lineBreakMode = .byTruncatingHead
        self.view.addSubview(label)
        
        let sumAtr = NSMutableAttributedString()
        do {
            let range = NSRange(location: 5, length: 5)
            let atr = NSMutableAttributedString(string: "QWERTYUIOPASDFGHJKLZXCVBNMqwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNMqwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNMqwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNMqwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNMqwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNMqwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNMqwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNMqwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNMqwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNMqwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNMqwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNMqwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNMqwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNMqwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNMqwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNMqwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNMqwertyuiopasdfghjklzxcvbnm123")
            atr.st_add(font: UIFont.systemFont(ofSize: 17))
            sumAtr.append(atr)
        }
        
        label.attributedText = sumAtr
    }
}

