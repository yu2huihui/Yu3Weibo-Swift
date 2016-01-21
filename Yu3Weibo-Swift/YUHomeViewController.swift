//
//  YUHomeViewController.swift
//  Yu3Weibo-Swift
//
//  Created by yu3 on 16/1/17.
//  Copyright © 2016年 yu3. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher

class YUHomeViewController: UITableViewController {
    var statusFrames:[YUStatusFrame]?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBar()
        self.setStatuses()
    }
    
    func setStatuses() {
        self.tableView.separatorStyle = .None//去掉cell之间的分割线
        let access_token = YUAccountTool.account()?.access_token
        let params = ["access_token": access_token!] as Dictionary<String,AnyObject>
        let urlStr = "https://api.weibo.com/2/statuses/home_timeline.json"
        Alamofire.request(.GET, urlStr, parameters: params, encoding: .URL, headers: nil).responseJSON { (response) -> Void in
            if response.result.error != nil {
                print("请求失败：\(response.result.error)")
            } else {
                let status = response.result.value as? NSDictionary
                let statusAry = status!["statuses"] as? NSArray
                var statusFrames = [YUStatusFrame]()
                for statusDic in statusAry! {
                    //将字典封装成模型
                    let statusFrame = YUStatusFrame()
                    statusFrame.status = YUStatus(dic: statusDic as! NSDictionary)
                    statusFrames.append(statusFrame)
                }
                self.statusFrames = statusFrames
                self.tableView.reloadData()
            }
            
        }
    }
    
    func setNavigationBar() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.itemWith("navigationbar_friendsearch", highIcon: "navigationbar_friendsearch_highlighted", target: self, action: Selector("findFriend"))
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.itemWith("navigationbar_pop", highIcon: "navigationbar_pop_highlighted", target: self, action: Selector("pop"))
        let titleButton = YUTitleButton()
        titleButton.setImage(UIImage.imageWithName("navigationbar_arrow_down"), forState: .Normal)
        titleButton.setTitle("huihui", forState: .Normal)
        
        titleButton.frame = CGRectMake(0, 0, 100, 40);
        //    titleButton.tag = TitleButtonDownTag;
        titleButton.addTarget(self, action: Selector("titleClick:"), forControlEvents: .TouchUpInside)
        self.navigationItem.titleView = titleButton
    }
    
    func titleClick(titleButton:YUTitleButton) {
        if titleButton.currentImage == UIImage.imageWithName("navigationbar_arrow_up") {
            titleButton.setImage(UIImage.imageWithName("navigationbar_arrow_down"), forState: .Normal)
        } else {
            titleButton.setImage(UIImage.imageWithName("navigationbar_arrow_up"), forState: .Normal)
        }
    }
    
    func findFriend() {
        print("findFriend")
    }
    
    func pop() {
        print("pop")
    }

    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (self.statusFrames) != nil ? self.statusFrames!.count : 0
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // 1.创建cell
        let cell = YUStatusCell.cellWithTableView(tableView)
        // 2.传递frame模型
        cell.statusFrame = self.statusFrames![indexPath.row]
        return cell
    }
    

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.statusFrames![indexPath.row].cellHeight
    }
   
}