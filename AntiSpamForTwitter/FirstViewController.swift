//
//  FirstViewController.swift
//  AntiSpamForTwitter
//
//  Created by Kensuke Hoshikawa on 2015/03/12.
//  Copyright (c) 2015年 star__hoshi. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController,UIWebViewDelegate {
    @IBOutlet weak var twitterWebView: UIWebView!

    let PC_CHROME_UA = "Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/28.0.1500.63 Safari/537.36"
    var defalutUA:String!

    override func viewDidLoad() {
        super.viewDidLoad()

        defalutUA = getDefaultUA()
        changeUserAgent()
        loadTwitterWebView(TwitterUrls.APPLICATIONS.rawValue)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // 初期状態のUAを保存しておく
    func getDefaultUA() -> String{
        let webView:UIWebView = UIWebView()
        webView.frame = CGRectZero
        let userAgent:String! = webView.stringByEvaluatingJavaScriptFromString("navigator.userAgent")
        return userAgent
    }

    // UA書き換え
    func changeUserAgent(){
        let userAgentStr = PC_CHROME_UA
        let dic:NSDictionary = ["UserAgent":userAgentStr]
        NSUserDefaults.standardUserDefaults().registerDefaults(dic)
    }

    // webview load
    func loadTwitterWebView(loadUrl: String){
        twitterWebView.delegate = self
        let url: NSURL = NSURL(string: loadUrl)!
        let request: NSURLRequest = NSURLRequest(URL: url)
        twitterWebView.loadRequest(request)
    }

    // Pageがすべて読み込み終わった時呼ばれる
    func webViewDidFinishLoad(webView: UIWebView!) {
        println("webViewDidFinishLoad")
        println(webView.request?.URL)
        let js = "document.body.innerHTML"
        let body = webView.stringByEvaluatingJavaScriptFromString(js)
        parseHtml(body!)
    }

    // ログアウト
    func logoutTwitter(){
        let myWebView : UIWebView = UIWebView()
        let logoutId = "document.getElementById('signout-button').click();"
        myWebView.stringByEvaluatingJavaScriptFromString(logoutId)
    }

    // Pageがloadされ始めた時、呼ばれる
    func webViewDidStartLoad(webView: UIWebView!) {
        println("webViewDidStartLoad")
        println(webView.request?.URL)

    }

    func parseHtml(html: String){

        var err : NSError?
        let option = CInt(HTML_PARSE_NOERROR.value | HTML_PARSE_RECOVER.value)
        var parser     = HTMLParser(html: html, encoding: NSUTF8StringEncoding, option: option, error: &err)
        if err != nil {
            println(err)
            exit(1)
        }

        var bodyNode   = parser.body

//        if let inputNodes = bodyNode?.findChildTags("b") {
//            for node in inputNodes {
//                println("Contents: \(node.contents)")
//                println("Raw contents: \(node.rawContents)")
//            }
//        }
//
//        if let inputNodes = bodyNode?.findChildTags("a") {
//            for node in inputNodes {
//                println("Contents: \(node.contents)")
//                println("Raw contents: \(node.rawContents)")
//                println(node.getAttributeNamed("href"))
//            }
//        }
//
//        println(bodyNode?.findChildTagAttr("div", attrName: "class", attrValue: "val")?.contents)
//        
//        if let inputNodes = bodyNode?.findChildTagsAttr("div", attrName: "class", attrValue: "val") {
//            for node in inputNodes {
//                println("Contents: \(node.contents)")
//                println("Raw contents: \(node.rawContents)")
//            }
//        }

        
        if let path = bodyNode?.xpath("//div[@class='box']") {
            for node in path {
                println(node.tagName)
                println(node.xpath("//h2")?[0].contents)
            }
        }

    }


}


private enum TwitterUrls: String {
    case LOGIN = "https://mobile.twitter.com/login"
    case INDEX = "https://mobile.twitter.com"
    case APPLICATIONS = "https://twitter.com/settings/applications"
}
