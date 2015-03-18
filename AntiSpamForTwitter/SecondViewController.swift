//
//  SecondViewController.swift
//  AntiSpamForTwitter
//
//  Created by Kensuke Hoshikawa on 2015/03/12.
//  Copyright (c) 2015年 star__hoshi. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UIWebViewDelegate {

    let myWebView : UIWebView = UIWebView()


    override func viewDidLoad() {
        super.viewDidLoad()

        // Delegateを設定する.
        myWebView.delegate = self

        // WebViewのサイズを設定する.
        myWebView.frame = self.view.bounds

        // Viewに追加する.
        self.view.addSubview(myWebView)

        // URLを設定する.
        let url: NSURL = NSURL(string: "http://www.apple.com")!

        // リクエストを作成する.
        let request: NSURLRequest = NSURLRequest(URL: url)

        // リクエストを実行する.
        myWebView.loadRequest(request)

    }

    /*
    Pageがすべて読み込み終わった時呼ばれる
    */
    func webViewDidFinishLoad(webView: UIWebView!) {
        println("webViewDidFinishLoad")
    }

    /*
    Pageがloadされ始めた時、呼ばれる
    */
    func webViewDidStartLoad(webView: UIWebView!) {
        println("webViewDidStartLoad")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}