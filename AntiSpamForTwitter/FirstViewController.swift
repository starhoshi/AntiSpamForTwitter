//
//  FirstViewController.swift
//  AntiSpamForTwitter
//
//  Created by Kensuke Hoshikawa on 2015/03/12.
//  Copyright (c) 2015年 star__hoshi. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        var web = TwitterWebView(frame:self.view.bounds)
        web.createWebView()
        self.view.addSubview(web)

        let barHeight: CGFloat = UIApplication.sharedApplication().statusBarFrame.size.height
        let navBarHeight: CGFloat? = self.navigationController?.navigationBar.frame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        let frame = CGRect(x: 0, y: barHeight + navBarHeight!, width: displayWidth, height: displayHeight - barHeight - navBarHeight!)

        var table = TwitterAppTableView(frame:frame,style:UITableViewStyle.Plain)
        table.createTableView()
        self.view.addSubview(table)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}


