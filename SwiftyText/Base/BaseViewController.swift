//
//  BaseViewController.swift
//  SwiftyText
//
//  Created by apple on 2020/4/26.
//  Copyright © 2020 yinhe. All rights reserved.
//

import UIKit

fileprivate let cellID: String = "BaseCellID"

class BaseViewController: UIViewController {
    
    var dataSource: [String] {
        return ["font",
                "textColor",
                "backgroundColor",
                "ligature",
                "kern",
                "underline",
                "strikethrough",
                "shadow",
                "strokeColor + strokeWidth"]
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: cellID)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = "Base"
        
        if #available(iOS 11.0, *) {
            self.tableView.contentInsetAdjustmentBehavior = .always
        } else {
            self.automaticallyAdjustsScrollViewInsets = true
        }
        view.addSubview(tableView)
    }
}

extension BaseViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        cell.textLabel?.text = self.dataSource[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let title = self.dataSource[indexPath.row]
        
        if indexPath.row == 0 {
            let vc = BaseFontViewController(title: title)
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 1 {
            let vc = BaseTextColorViewController(title: title)
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 2 {
            let vc = BaseTextBackgroundColorViewController(title: title)
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 3 {
            let vc = BaseTextLigatureViewController(title: title)
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 4 {
            let vc = BaseTextKernViewController(title: title)
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 5 {
            let vc = BaseTextUnderlineStyleViewController(title: title)
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 6 {
            let vc = BaseTextStrikethroughViewController(title: title)
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 7 {
            let vc = BaseTextShadowViewController(title: title)
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 8 {
            let vc = BaseTextStrokeViewController(title: title)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
