//
//  MixedViewController.swift
//  SwiftyText
//
//  Created by apple on 2020/4/27.
//  Copyright © 2020 yinhe. All rights reserved.
//

import UIKit

class MixedViewController: UIViewController {

    lazy var label: SwiftyLabel = {
        let label = SwiftyLabel()
        return label
    }()
    
    lazy var yyLabel: YYLabel = {
        let yyLabel = YYLabel()
        return yyLabel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.makeUI()
        makeYYLabel()
    }
}

extension MixedViewController {
    func makeUI() {
        
        let sumAtr = NSMutableAttributedString()
        
        do {
            let atr = NSMutableAttributedString(string: "哈哈哈😆但是")
            atr.st_add(font: UIFont.systemFont(ofSize: 17))
            atr.st_add(textColor: .red)
            sumAtr.append(atr)
        }
        do {
            let image = UIImage(named: "image1")
            let imageSize: CGSize = image?.size ?? CGSize(width: 50, height: 50)
            if let imageAtr = NSMutableAttributedString.st_attachmentString(content: image, contentMode: .scaleAspectFit, size: imageSize, font: UIFont.systemFont(ofSize: 20), verticalAlignment: .center) {
                sumAtr.append(imageAtr)
            }
        }
        do {
            let atr = NSMutableAttributedString(string: "洗啊黑色的JSDHFKJSD")
            atr.st_add(font: UIFont.boldSystemFont(ofSize: 20))
            atr.st_add(textColor: .cyan)
            sumAtr.append(atr)
        }
        do {
           let image = UIImage(named: "image2")
            let imageSize: CGSize = CGSize(width: 50, height: 50)
            if let imageAtr = NSMutableAttributedString.st_attachmentString(content: image, contentMode: .scaleToFill, size: imageSize, font: UIFont.systemFont(ofSize: 20), verticalAlignment: .center) {
                sumAtr.append(imageAtr)
            }
        }
        
        do {
            let atr = NSMutableAttributedString(string: "dsdjfhsdkhfksdhfkjsdhfhwehrhjkshfjkhdsjkfhksdjhfksd")
            atr.st_add(font: UIFont.boldSystemFont(ofSize: 25))
            atr.st_add(textColor: .purple)
            sumAtr.append(atr)
        }
        
        do {
            let atr = NSMutableAttributedString(string: "健身房聚划算的缴费👌😆d😝看到老师了😓🈶ad")
            atr.st_add(font: UIFont.systemFont(ofSize: 15))
            atr.st_add(textColor: .brown)
            sumAtr.append(atr)
        }
        
        do {
            let button = UIButton(type: .system)
            button.setTitle("Button", for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = .gray
            button.bounds = CGRect(origin: .zero, size: CGSize(width: 60, height: 30))
            if let imageAtr = NSMutableAttributedString.st_attachmentString(content: button, contentMode: .scaleToFill, size: button.bounds.size, font: UIFont.systemFont(ofSize: 20), verticalAlignment: .center) {
                sumAtr.append(imageAtr)
            }
        }
        
        var frame = CGRect(x: 40.0, y: UIApplication.shared.statusBarFrame.height + 44.0 + 20, width: UIScreen.main.bounds.width - 40.0 - 40.0, height: 0.0)
        
        
//        let layout = SwiftyTextLayout.layout(containerSize: CGSize(width: frame.width, height: CGFloat.greatestFiniteMagnitude), attributedText: sumAtr)
//        frame.size.height = layout?.textSize.height ?? 0.0
//
//        let label = SwiftyLabel()
//        label.frame = frame
//        label.numberOfLines = 0
//        label.lineBreakMode = .byCharWrapping
//        label.attributedText = sumAtr
//        label.backgroundColor = .orange
//        self.view.addSubview(label)
         
        self.label.verticalAlignment = .top
        self.label.frame = frame
        self.label.numberOfLines = 0
        self.label.lineBreakMode = .byCharWrapping
        self.label.attributedText = sumAtr
        self.label.backgroundColor = .orange
        self.view.addSubview(self.label)
        self.label.sizeToFit()
        
        let tmpFrame = self.label.frame
        frame.size.height = tmpFrame.height
        self.label.frame = frame
    }
    
    
    // 和`YYLabel`做对比
    func makeYYLabel() {
        let sumAtr = NSMutableAttributedString()
        
        do {
            let atr = NSMutableAttributedString(string: "哈哈哈😆但是")
            atr.yy_setFont(UIFont.systemFont(ofSize: 17), range: NSRange(location: 0, length: atr.length))
            atr.yy_setColor(.red, range: NSRange(location: 0, length: atr.length))
            sumAtr.append(atr)
        }
        
        do {
            let image = UIImage(named: "image1")
            let imageSize: CGSize = image?.size ?? CGSize(width: 50, height: 50)
            let imageAtr = NSMutableAttributedString.yy_attachmentString(withContent: image, contentMode: .scaleAspectFit, attachmentSize: imageSize, alignTo: UIFont.systemFont(ofSize: 20), alignment: .center)
            sumAtr.append(imageAtr)
        }
        
        do {
            let atr = NSMutableAttributedString(string: "洗啊黑色的JSDHFKJSD")
            atr.yy_setFont(UIFont.boldSystemFont(ofSize: 20), range: NSRange(location: 0, length: atr.length))
            atr.yy_setColor(.cyan, range: NSRange(location: 0, length: atr.length))
            sumAtr.append(atr)
        }
        
        do {
            let image = UIImage(named: "image2")
            let imageSize: CGSize = CGSize(width: 50, height: 50)
            let imageAtr = NSMutableAttributedString.yy_attachmentString(withContent: image, contentMode: .scaleToFill, attachmentSize: imageSize, alignTo: UIFont.systemFont(ofSize: 20), alignment: .center)
            sumAtr.append(imageAtr)
        }
        
        do {
            let atr = NSMutableAttributedString(string: "dsdjfhsdkhfksdhfkjsdhfhwehrhjkshfjkhdsjkfhksdjhfksd")
            atr.yy_setFont(UIFont.boldSystemFont(ofSize: 25), range: NSRange(location: 0, length: atr.length))
            atr.yy_setColor(.purple, range: NSRange(location: 0, length: atr.length))
            sumAtr.append(atr)
        }
        
        do {
            let atr = NSMutableAttributedString(string: "健身房聚划算的缴费👌😆d😝看到老师了😓🈶ad")
            atr.yy_setFont(UIFont.systemFont(ofSize: 15), range: NSRange(location: 0, length: atr.length))
            atr.yy_setColor(.brown, range: NSRange(location: 0, length: atr.length))
            sumAtr.append(atr)
        }
        
        do {
            let button = UIButton(type: .system)
            button.setTitle("Button", for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = .gray
            button.bounds = CGRect(origin: .zero, size: CGSize(width: 60, height: 30))
            
            let imageAtr = NSMutableAttributedString.yy_attachmentString(withContent: button, contentMode: .scaleToFill, attachmentSize: button.bounds.size, alignTo: UIFont.systemFont(ofSize: 20), alignment: .center)
            sumAtr.append(imageAtr)
        }
        
        var frame = CGRect(x: 40.0, y: self.label.frame.maxY + 20, width: UIScreen.main.bounds.width - 40.0 - 40.0, height: 0.0)
        
        let layout = YYTextLayout(containerSize: CGSize(width: frame.width, height: CGFloat.greatestFiniteMagnitude), text: sumAtr)
        frame.size.height = layout?.textBoundingSize.height ?? 0.0
        
        // 可以看出高度计算不准确，底部空出了一行的高度，原因还是在于`YYTextLayout`计算高度时
        self.yyLabel.frame = frame
        self.yyLabel.textVerticalAlignment = .top
        self.yyLabel.numberOfLines = 0
        self.yyLabel.lineBreakMode = .byCharWrapping
        self.yyLabel.attributedText = sumAtr
        self.yyLabel.backgroundColor = .orange
        self.view.addSubview(self.yyLabel)
    }
}
