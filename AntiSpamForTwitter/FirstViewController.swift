//
//  FirstViewController.swift
//  AntiSpamForTwitter
//
//  Created by Kensuke Hoshikawa on 2015/03/12.
//  Copyright (c) 2015年 star__hoshi. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate {
    
    let myItems: NSArray = ["TEST1", "TEST2", "TEST3"]
    let PC_CHROME_UA = "Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/28.0.1500.63 Safari/537.36"
    var defalutUA:String!
    var application:[[String:Any]] = [[:]]
    let myWebView : UIWebView = UIWebView()
    var myTable : UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        defalutUA = getDefaultUA()
        setWebViewParams()
        self.view.addSubview(myWebView)
        
        setTableViewParams()
        self.view.addSubview(myTable)
    }
    
    func setTableViewParams(){
        myTable.dataSource = self
        myTable.delegate = self
        let frame = getWindowSize()
        myTable = UITableView(frame: frame)
        
        // Cell名の登録をおこなう.
        myTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
    }
    
    func setWebViewParams(){
        myWebView.delegate = self
        myWebView.frame = self.view.bounds
        let url: NSURL = NSURL(string: TwitterUrls.LOGIN.rawValue)!
        let request: NSURLRequest = NSURLRequest(URL: url)
        myWebView.loadRequest(request)
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
    
    func getWindowSize() -> CGRect{
        let barHeight: CGFloat = UIApplication.sharedApplication().statusBarFrame.size.height
        let navBarHeight: CGFloat? = self.navigationController?.navigationBar.frame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        let frame = CGRect(x: 0, y: barHeight + navBarHeight! + 300, width: displayWidth, height: displayHeight - barHeight - navBarHeight!)
        
        return frame
    }
    
    // UA書き換え
    func changeUserAgent(){
        let userAgentStr = PC_CHROME_UA
        let dic:NSDictionary = ["UserAgent":userAgentStr]
        NSUserDefaults.standardUserDefaults().registerDefaults(dic)
    }
    
    // Pageがすべて読み込み終わった時呼ばれる
    func webViewDidFinishLoad(webView: UIWebView!) {
        println("webViewDidFinishLoad")
        let js = "document.body.innerHTML"
        let body = webView.stringByEvaluatingJavaScriptFromString(js)
        let parsedTwitterAppHTML = ParsedTwitterAppHTML(twitterAppHtml: body!)
        parsedTwitterAppHTML.parseHtml()
        if let currentUrl = webView.request?.URL.absoluteString {
            println(currentUrl)
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
        //        twitterWebView.stringByEvaluatingJavaScriptFromString(logoutId)
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
    
    /*
    Cellが選択された際に呼び出される.
    */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("Num: \(indexPath.row)")
        println("Value: \(myItems[indexPath.row])")
    }
    
    /*
    Cellの総数を返す.
    */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myItems.count
    }
    
    /*
    Cellに値を設定する.
    */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Cellの.を取得する.
        let cell = tableView.dequeueReusableCellWithIdentifier("MyCell", forIndexPath: indexPath) as UITableViewCell
        
        // Cellに値を設定する.
        cell.textLabel!.text = "\(myItems[indexPath.row])"
        
        return cell
    }
    
}

private enum TwitterUrls: String {
    case LOGIN = "https://mobile.twitter.com/login/"
    case INDEX = "https://mobile.twitter.com/"
    case LOGIN_PC = "https://twitter.com/login/"
    case INDEX_PC = "https://twitter.com/"
    case APPLICATIONS = "https://twitter.com/settings/applications/"
}

