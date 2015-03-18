//
//  TwitterWebView.swift
//  AntiSpamForTwitter
//
//  Created by Kensuke Hoshikawa on 2015/03/18.
//  Copyright (c) 2015年 star__hoshi. All rights reserved.
//

import UIKit


class TwitterWebView: UIWebView,UIWebViewDelegate {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */


    override init(frame: CGRect) {
        super.init(frame: frame)
        self.delegate = self
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func createWebView() -> UIWebView{
        let url: NSURL = NSURL(string: "https://mobile.twitter.com/login/")!
        let request: NSURLRequest = NSURLRequest(URL: url)
        self.loadRequest(request)

        return self
    }

    // Pageがloadされ始めた時、呼ばれる
    func webViewDidStartLoad(webView: UIWebView!) {
        println("webViewDidStartLoad")
        println(webView.request?.URL)
    }


}

