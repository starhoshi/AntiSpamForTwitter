//
//  FirstViewController.swift
//  AntiSpamForTwitter
//
//  Created by Kensuke Hoshikawa on 2015/03/12.
//  Copyright (c) 2015年 star__hoshi. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController,UIWebViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        var web = TwitterWebView(frame:self.view.bounds)
        var table = TwitterAppTableView(frame:self.view.bounds,style:UITableViewStyle.Plain)
        web.createWebView()
        self.view.addSubview(web)

        table.createTableView()
        self.view.addSubview(table)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}


