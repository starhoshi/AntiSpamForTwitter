//
//  TwitterAppView.swift
//  AntiSpamForTwitter
//
//  Created by Kensuke Hoshikawa on 2015/03/20.
//  Copyright (c) 2015年 star__hoshi. All rights reserved.
//

import UIKit

class TwitterAppTableView: UITableView,UITableViewDelegate,UITableViewDataSource {

    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame,style:style)
        self.delegate = self
        self.dataSource = self
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // Tableで使用する配列を設定する
    let myItems: NSArray = ["TEST1", "TEST2", "TEST3"]

    func createTableView() -> UITableView{
        // Cell名の登録をおこなう.
        self.registerClass(UITableViewCell.self, forCellReuseIdentifier: "MyCell")

        return self

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
