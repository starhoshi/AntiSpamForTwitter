//
//  ParsedTwitterAppHTML.swift
//  AntiSpamForTwitter
//
//  Created by Kensuke Hoshikawa on 2015/03/21.
//  Copyright (c) 2015年 star__hoshi. All rights reserved.
//

import Foundation

class Twitter{
    
    let html:String!
    
    init(twitterAppHtml:String){
        html = twitterAppHtml
    }
    
    
    /**
    TwitterのHTMLをParseする
    
    :param: html <#html description#>
    */
    func parseHtml() -> [[String:Any]]{
        var err : NSError?
        let option = CInt(HTML_PARSE_NOERROR.value | HTML_PARSE_RECOVER.value)
        let parser     = HTMLParser(html: html, encoding: NSUTF8StringEncoding, option: option, error: &err)
        if err != nil {
            println(err)
            exit(1)
        }
        
        let bodyNode   = parser.body
        var applicationDetail = [String:Any]()
        var application:[[String:Any]] = [[:]]

        if let path = bodyNode?.xpath("//div[@class='stream-item oauth-application ']") {
            for node in path {
                applicationDetail = getApplicationData(node)
                application.append(applicationDetail)
            }
        }
        return application
    }


    /**
    Twitter の Applicationデータ を取得する

    :param: node <#node description#>

    :returns: <#return value description#>
    */
    private func getApplicationData(node: HTMLNode) -> [String:Any]{
        var applicationDetail = [String:Any]()
        var metadata: String
        
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
        
        return applicationDetail
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
    
}