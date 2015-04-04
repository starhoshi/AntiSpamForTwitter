//
//  FirstViewController.swift
//  AntiSpamForTwitter
//
//  Created by Kensuke Hoshikawa on 2015/03/12.
//  Copyright (c) 2015年 star__hoshi. All rights reserved.
//

import UIKit
import SDWebImage
import UIColor_FlatColors
import Alamofire
import RJImageLoader

class FirstViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate{
    
    let myItems: NSArray = ["TEST1", "TEST2", "TEST3"]
    let PC_CHROME_UA = "Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/28.0.1500.63 Safari/537.36"
    var defalutUA:String!
    //    var bouncingBalls : PQFBouncingBalls!
    var myActivityIndicator: UIActivityIndicatorView!
    let myWebView : UIWebView = UIWebView()
    //    var myTable : UITableView!
    var application:[[String:Any]] = [[:]]
    var twitterAppView: UIWebView!
    
    @IBOutlet weak var TwitterWebView: UIWebView!
    @IBOutlet weak var TwitterTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        defalutUA = getDefaultUA()
        setWebViewParams()
        self.view.addSubview(TwitterWebView)
        //        createLoadingView()
        
        setIndicatorParams()
        self.view.addSubview(myActivityIndicator)
    }
    
    func setIndicatorParams(){
        myActivityIndicator = UIActivityIndicatorView()
        myActivityIndicator.frame = CGRectMake(0, 0, 50, 50)
        myActivityIndicator.center = self.view.center
        
        // アニメーションが停止している時もインジケータを表示させる.
        myActivityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        
    }
    
    func setTableViewParams(){
        TwitterTableView.delegate = self
        TwitterTableView.dataSource = self
        
        var nib  = UINib(nibName: "TwitterAppTableViewCell", bundle:nil)
        TwitterTableView.registerNib(nib, forCellReuseIdentifier:"TwitterAppCell")
        TwitterTableView.estimatedRowHeight = 200.0
        TwitterTableView.rowHeight = UITableViewAutomaticDimension
        
        TwitterTableView.reloadData()
    }
    
    func setWebViewParams(){
        TwitterWebView.frame = self.view.bounds
        TwitterWebView.scrollView.scrollsToTop = false
        let url: NSURL = NSURL(string: TwitterUrls.LOGIN.rawValue)!
        let request: NSURLRequest = NSURLRequest(URL: url)
        TwitterWebView.loadRequest(request)
    }
    
    // 初期状態のUAを保存しておく
    func getDefaultUA() -> String{
        let webView:UIWebView = UIWebView()
        webView.frame = CGRectZero
        webView.scrollView.scrollsToTop = false
        let userAgent:String! = webView.stringByEvaluatingJavaScriptFromString("navigator.userAgent")
        return userAgent
    }
    
    func getWindowSize() -> CGRect{
        let barHeight: CGFloat = UIApplication.sharedApplication().statusBarFrame.size.height
        let navBarHeight: CGFloat? = self.navigationController?.navigationBar.frame.size.height
        let tabBarHeight: CGFloat = self.tabBarController!.tabBar.frame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        let frame = CGRect(x: 0, y: barHeight + navBarHeight! , width: displayWidth, height: displayHeight - barHeight - navBarHeight! - tabBarHeight)
        
        return frame
    }
    
    // UA書き換え
    func changeUserAgentToPC(){
        let userAgentStr = PC_CHROME_UA
        let dic:NSDictionary = ["UserAgent":userAgentStr]
        NSUserDefaults.standardUserDefaults().registerDefaults(dic)
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        //        bouncingBalls.show()
        myActivityIndicator.startAnimating()
    }
    
    // Pageがすべて読み込み終わった時呼ばれる
    func webViewDidFinishLoad(webView: UIWebView!) {
        // 読み込み中の場合は処理を行わない
        if(webView.loading){
            return
        }
        println("webViewDidFinishLoad")
        let js = "document.body.innerHTML"
        let body = webView.stringByEvaluatingJavaScriptFromString(js)
        if let currentUrl = webView.request?.URL.absoluteString {
            println(currentUrl)
            switch currentUrl {
            case TwitterUrls.APPLICATIONS.rawValue :
                twitterAppView = webView
                let parsedTwitterAppHTML = Twitter(twitterAppHtml: body!)
                application = parsedTwitterAppHTML.parseHtml()
                println(application)
                
                myActivityIndicator.stopAnimating()
                setTableViewParams()
                self.view.addSubview(TwitterTableView)
                
            case TwitterUrls.INDEX.rawValue :
                accessApplicationURL()
            default:
                myActivityIndicator.stopAnimating()
                println("other")
                break
            }
        }
    }
    
    func createLoadingView(){
        //        bouncingBalls = PQFBouncingBalls(loaderOnView: self.view)
        //        bouncingBalls.jumpAmount = 50
        //        bouncingBalls.loaderColor = UIColor.flatOrangeColor()
        //        let loadingLabel: UILabel = UILabel(frame: CGRectMake(0,0,200,50))
        //        loadingLabel.text = "Data Loading..."
        //        bouncingBalls.label = loadingLabel
        //        bouncingBalls.backgroundColor = UIColor.flatBelizeHoleColor()
    }
    
    func accessApplicationURL(){
        changeUserAgentToPC()
        //        let myWeb: UIWebView = UIWebView()
        let url: NSURL = NSURL(string: TwitterUrls.APPLICATIONS.rawValue)!
        let request: NSURLRequest = NSURLRequest(URL: url)
        myWebView.delegate = self
        myWebView.frame = CGRectZero
        myWebView.scrollView.scrollsToTop = false
        myWebView.loadRequest(request)
        self.view.addSubview(myWebView)
    }
    
    /*
    Cellが選択された際に呼び出される.
    */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //        println("Num: \(indexPath.row)")
        //        println("Value: \(application[indexPath.row])")
    }
    
    /*
    Cellの総数を返す.
    */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return application.count
    }
    
    /*
    Cellに値を設定する.
    */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Cellの.を取得する.
        let cell = tableView.dequeueReusableCellWithIdentifier("TwitterAppCell", forIndexPath: indexPath) as TwitterAppTableViewCell
        
        // Cellに値を設定する.
        cell.titleLabel.text = application[indexPath.row]["name"] as String!
        cell.descriptionLabel.text = application[indexPath.row]["description"] as String!
        cell.dateLabel.text = application[indexPath.row]["allow_date"] as String!
        cell.revokeButton.addTarget(self, action: "buttonPressed:", forControlEvents: .TouchUpInside)
        cell.revokeButton.tag = indexPath.row;
        
        
        let url = NSURL(string: application[indexPath.row]["image"] as String!)
        cell.appImage.startLoaderWithTintColor(UIColor.flatNephritisColor())
        cell.appImage.sd_setImageWithURL(url, placeholderImage: nil, options: SDWebImageOptions.RefreshCached,
            progress: { (receivedSize: Int, expectedSize: Int) -> Void in
                let progress: CGFloat = CGFloat(receivedSize / expectedSize)
                cell.appImage.updateImageDownloadProgress(progress)
            },
            completed: {[weak self] (image, data, error, finished) in
                cell.appImage.reveal()
            }
        )
        cell.setNeedsLayout()
        
        return cell
    }
    
    func changeButtonLoading(sender: UIButton!){
        sender.setTitle("Loading", forState: UIControlState.Normal)
        let js = "document.body.innerHTML"
        let body = twitterAppView.stringByEvaluatingJavaScriptFromString(js)
        let appId = application[sender.tag]["app_id"] as String!
        Twitter(twitterAppHtml: body!).isRevokeTwitter(appId!)
        let twitterInfo = ["UIButton":sender]
        var timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "onUpdate:", userInfo: twitterInfo, repeats: true)
    }
    
    //NSTimerIntervalで指定された秒数毎に呼び出されるメソッド.
    func onUpdate(timer : NSTimer){
        let js = "document.body.innerHTML"
        let body = twitterAppView.stringByEvaluatingJavaScriptFromString(js)
        let revokeButton = timer.userInfo?["UIButton"] as UIButton
        let appId = application[revokeButton.tag]["app_id"] as String!
        if Twitter(twitterAppHtml: body!).isRevokeTwitter(appId){
            let btn = timer.userInfo?["UIButton"] as UIButton
            if application[revokeButton.tag]["is_revoke"] as Bool {
                application[revokeButton.tag]["is_revoke"] = false
                btn.setTitle("解除", forState: UIControlState.Normal)
            }else{
                application[revokeButton.tag]["is_revoke"] = true
                btn.setTitle("取消", forState: UIControlState.Normal)
            }
            timer.invalidate()
        }
    }
    
    func buttonPressed(sender: UIButton!){
        println(application[sender.tag])
        let buttonId = application[sender.tag]["button_id"] as String!
        let js = "document.getElementById('\(buttonId)').click();"
        let click = myWebView.stringByEvaluatingJavaScriptFromString(js)
        println(click)
        changeButtonLoading(sender)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

private enum TwitterUrls: String {
    case LOGIN = "https://mobile.twitter.com/login/"
    case INDEX = "https://mobile.twitter.com/"
    case LOGIN_PC = "https://twitter.com/login/"
    case INDEX_PC = "https://twitter.com/"
    case APPLICATIONS = "https://twitter.com/settings/applications"
}

