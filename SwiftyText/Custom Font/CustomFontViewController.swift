//
//  CustomFontViewController.swift
//  SwiftyText
//
//  Created by apple on 2020/4/26.
//  Copyright © 2020 yinhe. All rights reserved.
//

import UIKit

fileprivate let customFontName = "Futura-Medium"

fileprivate let text =
"""
Stay hungry, stay foolish.Innovation distinguishes between a leader and a follower.Your time is limited, so don't waste it living someone else's life.
"""

class CustomFontViewController: UIViewController {
    
    lazy var label1: SwiftyLabel = {
        var frame = CGRect(x: 40, y: UIApplication.shared.statusBarFrame.height + 44.0 + 20, width: UIScreen.main.bounds.size.width - 40.0 - 40.0, height: 0)
        let label1 = SwiftyLabel(frame: frame)
        label1.numberOfLines = 0
        label1.backgroundColor = .orange
        return label1
    }()
    
    lazy var label2: SwiftyLabel = {
        let label2 = SwiftyLabel()
        label2.numberOfLines = 0
        label2.backgroundColor = .cyan
        return label2
    }()
    
    lazy var label3: YYLabel = {
        let label3 = YYLabel()
        label3.numberOfLines = 0
        label3.backgroundColor = .orange
        return label3
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = "Custom Font"
        
        self.showLabel1()
        self.showLabel2()
        self.showLabel3()
    }
}

extension CustomFontViewController {
    func showLabel1() {
        
        self.view.addSubview(self.label1)
        
        let atr = NSMutableAttributedString(string: text)
        atr.st_add(font: UIFont(name: customFontName, size: 20))
        self.label1.attributedText = atr
        
        var frame = self.label1.frame
        
        let height = SwiftyTextLayout.layout(containerSize: CGSize(width: frame.width, height: CGFloat.greatestFiniteMagnitude), attributedText: atr)?.textSize.height ?? 0.0
        frame.size.height = height
        self.label1.frame = frame
    }
    
    func showLabel2() {
        var frame: CGRect = .zero
        frame.origin.x = self.label1.frame.origin.x
        frame.origin.y = self.label1.frame.origin.y + self.label1.frame.height + 10
        frame.size.width = self.label1.frame.size.width
        
        self.label2.frame = frame
        
        self.view.addSubview(self.label2)
        
        let atr = NSMutableAttributedString(string: text)
        atr.st_add(font: UIFont(name: customFontName, size: 22))
        atr.st_add(textColor: .purple)
        
        self.label2.attributedText = atr
        self.label2.sizeToFit()
    }
    
    func showLabel3() {
        var frame: CGRect = .zero
        frame.origin.x = self.label2.frame.origin.x
        frame.origin.y = self.label2.frame.origin.y + self.label2.frame.height + 10
        frame.size.width = self.label2.frame.size.width
        frame.size.height = CGFloat.greatestFiniteMagnitude
        
        self.view.addSubview(self.label3)
        
        let atr = NSMutableAttributedString(string: text)
        atr.st_add(font: UIFont(name: customFontName, size: 22))
        atr.st_add(textColor: .black)
        
        self.label3.attributedText = atr
        self.label3.sizeToFit()
        
        
        let height = YYTextLayout(containerSize: CGSize(width: frame.width, height: CGFloat.greatestFiniteMagnitude), text: atr)?.textBoundingSize.height ?? 0.0
        frame.size.height = height
        self.label3.frame = frame
    }
}
