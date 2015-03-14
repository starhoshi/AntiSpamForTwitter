//
//  FirstViewController.swift
//  AntiSpamForTwitter
//
//  Created by Kensuke Hoshikawa on 2015/03/12.
//  Copyright (c) 2015年 star__hoshi. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    @IBOutlet var twitterWebView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let url: NSURL = NSURL(string: "http://twitter.com")!

        let request: NSURLRequest = NSURLRequest(URL: url)

        twitterWebView.loadRequest(request)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

