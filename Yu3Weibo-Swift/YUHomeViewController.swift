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
import ZLSwiftRefresh

class YUHomeViewController: UITableViewController {
    let titleButton = YUTitleButton()
    var statusFrames = [YUStatusFrame]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBar()
        self.tableView.nowRefresh { () -> Void in
            self.loadNewData()
        }
        //上拉刷新
        self.tableView.toRefreshAction { () -> Void in
            self.loadNewData()
        }
        self.tableView.toLoadMoreAction { () -> Void in
            self.loadMoreData()
        }
        
    }
    
    /** 发送请求获得用户信息 */
    func getUserName() -> String? {
        let access_token = YUAccountTool.account()?.access_token
        var params = ["access_token": access_token!] as Dictionary<String,AnyObject>
        let urlStr = "https://api.weibo.com/2/users/show.json"
        params["uid"] = YUAccountTool.account()?.uid
        var result:String? = nil
        Alamofire.request(.GET, urlStr, parameters: params, encoding: .URL, headers: nil).responseJSON { (response) -> Void in
            if response.result.error != nil {
                print("请求失败：\(response.result.error)")
            } else {
                let userDic = response.result.value as! NSDictionary
                let user = YUUser(dic: userDic)
                // 设置标题文字
                self.titleButton.setTitle(user.name, forState: .Normal)
                // 保存昵称
                let account = YUAccountTool.account()
                account!.name = user.name;
                YUAccountTool.saveAccount(account!)
                result = user.name
            }
        }
        return result
    }
    
    /** 发送请求加载新的微博数据 */
    func loadNewData() {
        let access_token = YUAccountTool.account()?.access_token
        var params = ["access_token": access_token!] as Dictionary<String,AnyObject>
        let urlStr = "https://api.weibo.com/2/statuses/home_timeline.json"
        params["count"] = 10
        if (self.statusFrames.count > 0) {
            let statusFrame = self.statusFrames[0];
            // 加载ID比since_id大的微博
            params["since_id"] = statusFrame.status!.idstr;
        }
        
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
                // 插入数据到前面
                self.statusFrames.insertContentsOf(statusFrames, at: 0)
                // 结束刷新状态
                self.tableView.doneRefresh()
                self.tableView.reloadData()
                // 显示最新微博的数量(给用户一些友善的提示)
                self.showNewStatusCount(statusFrames.count)
            }
            
        }
    }
    
    /** 显示最新微博的数量 */
    func showNewStatusCount(count: Int) {
        // 1.创建一个按钮
        let btn = UIButton()
        // below : 下面  btn会显示在self.navigationController.navigationBar的下面
        self.navigationController?.view.insertSubview(btn, belowSubview: self.navigationController!.navigationBar)
        // 2.设置图片和文字
        btn.userInteractionEnabled = false
        btn.setBackgroundImage(UIImage.imageWithName("timeline_new_status_background"), forState: .Normal)
        btn.setTitleColor(UIColor.orangeColor(), forState: .Normal)
        btn.titleLabel!.font = UIFont.systemFontOfSize(14)
        if (count > 0) {
            btn.setTitle("\(count) 条新微博", forState: .Normal)
        } else {
            btn.setTitle("没有新的微博", forState: .Normal)
        }
        
        // 3.设置按钮的初始frame
        let btnH:CGFloat = 30
        let btnY = CGFloat(64) - btnH
        let btnX:CGFloat = 2
        let btnW = self.view.frame.size.width - 2 * btnX
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH)
        
        // 4.通过动画移动按钮(按钮向下移动 btnH)
        UIView.animateWithDuration(1, animations: { () -> Void in
            btn.transform = CGAffineTransformMakeTranslation(0, btnH)
            }) { (finished) -> Void in
                UIView.animateWithDuration(1, delay: 2, options: .CurveLinear, animations: { () -> Void in
                    btn.transform = CGAffineTransformIdentity
                    }, completion: { (finished) -> Void in
                        btn.removeFromSuperview()
                })
        }
    }
    
    /** 发送请求加载更多的微博数据 */
    func loadMoreData() {
        let access_token = YUAccountTool.account()?.access_token
        var params = ["access_token": access_token!] as Dictionary<String,AnyObject>
        params["count"] = 5
        if (self.statusFrames.count > 0) {
            let statusFrame = self.statusFrames.last
            // 加载ID <= max_id的微博
            let maxId = Int(statusFrame!.status!.idstr!)! - 1
            params["max_id"] = maxId
        }
        let urlStr = "https://api.weibo.com/2/statuses/home_timeline.json"
        Alamofire.request(.GET, urlStr, parameters: params, encoding: .URL, headers: nil).responseJSON { (response) -> Void in
            if response.result.error != nil {
                print("请求失败：\(response.result.error)")
            } else {
                let status = response.result.value as? NSDictionary
                let statusAry = status!["statuses"] as? NSArray
                for statusDic in statusAry! {
                    //将字典封装成模型
                    let statusFrame = YUStatusFrame()
                    statusFrame.status = YUStatus(dic: statusDic as! NSDictionary)
                    self.statusFrames.append(statusFrame)
                }
                self.tableView.doneRefresh()
                self.tableView.reloadData()
            }
            
        }
    }
    
    func setNavigationBar() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.itemWith("navigationbar_friendsearch", highIcon: "navigationbar_friendsearch_highlighted", target: self, action: Selector("findFriend"))
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.itemWith("navigationbar_pop", highIcon: "navigationbar_pop_highlighted", target: self, action: Selector("pop"))
        titleButton.setImage(UIImage.imageWithName("navigationbar_arrow_down"), forState: .Normal)
        // 位置和尺寸
        titleButton.frame = CGRectMake(0, 0, 0, 40);
        // 文字
        if (YUAccountTool.account()?.name != nil) {
            let name = YUAccountTool.account()!.name as! String
            titleButton.setTitle(name, forState: .Normal)
        } else {
            let name = self.getUserName()
            if name != nil {
                titleButton.setTitle(name, forState: .Normal)
            } else {
                titleButton.setTitle("首页", forState: .Normal)
            }
        }
        //    titleButton.tag = TitleButtonDownTag;
        titleButton.addTarget(self, action: Selector("titleClick:"), forControlEvents: .TouchUpInside)
        self.navigationItem.titleView = titleButton
        self.tableView.separatorStyle = .None//去掉cell之间的分割线
        self.tableView.backgroundColor = UIColor.colorWithRed(226, green: 226, blue: 226)
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
        return self.statusFrames.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // 1.创建cell
        let cell = YUStatusCell.cellWithTableView(tableView)
        // 2.传递frame模型
        cell.statusFrame = self.statusFrames[indexPath.row]
        return cell
    }
    

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.statusFrames[indexPath.row].cellHeight
    }
   
}