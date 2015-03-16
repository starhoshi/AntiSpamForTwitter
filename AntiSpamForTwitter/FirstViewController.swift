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
    var application:[[String:Any]] = [[:]]

    override func viewDidLoad() {
        super.viewDidLoad()

        defalutUA = getDefaultUA()
        //        changeUserAgent()
        loadTwitterWebView(TwitterUrls.LOGIN.rawValue)
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
        let js = "document.body.innerHTML"
        let body = webView.stringByEvaluatingJavaScriptFromString(js)
        parseHtml(body!)
        if let currentUrl = webView.request?.URL.absoluteString {
            if currentUrl == TwitterUrls.INDEX.rawValue {
                println("login true")
            }else{
                println("login false")
            }
        }
        //                logoutTwitter()
    }

    // ログアウト
    func logoutTwitter(){
        let logoutId = "document.getElementById('signout-button').click();"
        twitterWebView.stringByEvaluatingJavaScriptFromString(logoutId)
        var storage : NSHTTPCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in storage.cookies  as [NSHTTPCookie]{
            storage.deleteCookie(cookie)
        }

        NSUserDefaults.standardUserDefaults()
        //        var cookie: NSHTTPCookie = NSHTTPCookie()
        var cookieJar: NSHTTPCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in cookieJar.cookies as [NSHTTPCookie]{
            NSLog("%@", cookie)
        }
    }

    // Pageがloadされ始めた時、呼ばれる
    func webViewDidStartLoad(webView: UIWebView!) {
        println("webViewDidStartLoad")
        println(webView.request?.URL)

    }

    /**
    TwitterのHTMLをParseする

    :param: html <#html description#>
    */
    func parseHtml(html: String){
        var err : NSError?
        let option = CInt(HTML_PARSE_NOERROR.value | HTML_PARSE_RECOVER.value)
        var parser     = HTMLParser(html: html, encoding: NSUTF8StringEncoding, option: option, error: &err)
        if err != nil {
            println(err)
            exit(1)
        }

        var bodyNode   = parser.body
        var applicationDetail = [String:Any]()
        var metadata: String
        application = [[:]]

        if let path = bodyNode?.xpath("//div[@class='stream-item oauth-application ']") {
            for node in path {
                applicationDetail["name"] = node.findChildTag("strong")?.contents as String!
                applicationDetail["button_id"] = node.findChildTag("button")?.getAttributeNamed("id")
                applicationDetail["image"] = node.findChildTag("img")?.getAttributeNamed("src")
                applicationDetail["creater"] = node.findChildTagAttr("a", attrName: "class", attrValue: "oauth-organization")?.contents as String!
                applicationDetail["creater_href"] = node.findChildTagAttr("a", attrName: "class", attrValue: "oauth-organization")?.getAttributeNamed("href")
                applicationDetail["description"] = node.findChildTagAttr("p", attrName: "class", attrValue: "description")?.contents as String!
                applicationDetail["allow_date"] = node.findChildTagsAttr("small", attrName: "class", attrValue: "metadata")[1].contents as String!

                metadata = node.findChildTagsAttr("small", attrName: "class", attrValue: "metadata")[0].contents as String!
                applicationDetail["read"] = metadata.rangeOfString("読み")?.startIndex
                applicationDetail["write"] = metadata.rangeOfString("書き")?.startIndex
                applicationDetail["dm"] = metadata.rangeOfString("ダイレクトメッセージ")?.startIndex
                application.append(applicationDetail)
            }
        }
        println(application)
        //        let button_id = application[5]["button_id"] as String!
        //        println(button_id)
        //        let logoutId = "document.getElementById('\(button_id)').click();"
        //        twitterWebView.stringByEvaluatingJavaScriptFromString(logoutId)

    }

}


private enum TwitterUrls: String {
    case LOGIN = "https://mobile.twitter.com/login/"
    case INDEX = "https://mobile.twitter.com/"
    case LOGIN_PC = "https://twitter.com/login/"
    case INDEX_PC = "https://twitter.com/"
    case APPLICATIONS = "https://twitter.com/settings/applications/"
}
