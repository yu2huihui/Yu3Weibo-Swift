//
//  YUHomeViewController.swift
//  Yu3Weibo-Swift
//
//  Created by yu3 on 16/1/17.
//  Copyright © 2016年 yu3. All rights reserved.
//

import UIKit
import Kingfisher

class YUHomeViewController: UITableViewController {
    let titleButton = YUTitleButton()
    var statusFrames = [YUStatusFrame]()
    weak var footer:MJRefreshFooter!
    weak var header:MJRefreshHeader!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBar()
        self.setRefreshView()
    }
    
    func setRefreshView() {
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: Selector("loadNewData"))
        header.beginRefreshing()
        self.tableView.addSubview(header)
        self.header = header
        
        let footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: Selector("loadMoreData"))
        self.tableView.addSubview(footer)
        self.footer = footer
    }
    
    /** 发送请求获得用户信息 */
    func setUserName() {
        let param = UserInfoParam()
        param.uid = Int(YUAccountTool.account()!.uid as! String)!
        YUUserInfoTool.userInfoWithParam(param) { (user, error) -> Void in
            if error == nil {
                self.titleButton.setTitle(user!.name!, forState: .Normal)
                // 保存昵称
                let account = YUAccountTool.account()
                account!.name = user!.name;
                YUAccountTool.saveAccount(account!)
            } else {
                print("请求失败：\(error)")
                MBProgressHUD.showError("获取用户信息失败")
                self.titleButton.setTitle("首页", forState: .Normal)
            }
        }
    }
    
    /** 发送请求加载新的微博数据 */
    func loadNewData() {
        self.tabBarItem.badgeValue = nil
        // 装配参数
        let param = HomeStatusesParam()
        param.count = 10
        if self.statusFrames.count > 0 {
            let statusFrame = self.statusFrames[0]
            param.since_id = Int(statusFrame.status!.idstr!)!
        }
        // 获取微博信息
        YUStatusTool.homeStatusesWithParam(param) { (statuses, error) -> Void in
            if error == nil {
                var statusFrames = [YUStatusFrame]()
                for status in statuses! {
                    let statusFrame = YUStatusFrame()
                    statusFrame.status = status
                    statusFrames.append(statusFrame)
                }
                // 插入数据到前面
                self.statusFrames.insertContentsOf(statusFrames, at: 0)
                // 结束刷新状态
                self.header.endRefreshing()
                // 刷新数据
                self.tableView.reloadData()
                // 显示最新微博的数量(给用户一些友善的提示)
                self.showNewStatusCount(statusFrames.count)
            } else {
                print("请求失败：\(error)")
                // 结束刷新状态
                self.header.endRefreshing()
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
        let param = HomeStatusesParam()
        param.count = 5
        if self.statusFrames.count > 0 {
            let statusFrame = self.statusFrames.last
            param.max_id = Int(statusFrame!.status!.idstr!)! - 1
        }
        YUStatusTool.homeStatusesWithParam(param) { (statuses, error) -> Void in
            if error == nil {
                for status in statuses! {
                    let statusFrame = YUStatusFrame()
                    statusFrame.status = status
                    self.statusFrames.append(statusFrame)
                }
                self.footer.endRefreshing()
                self.tableView.reloadData()
            } else {
                print("请求失败：\(error)")
                self.header.endRefreshing()
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
            self.setUserName()
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