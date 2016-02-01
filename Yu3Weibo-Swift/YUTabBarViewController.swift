//
//  YUTabBarViewController.swift
//  Yu3Weibo-Swift
//
//  Created by yu3 on 16/1/17.
//  Copyright © 2016年 yu3. All rights reserved.
//

import UIKit


class YUTabBarViewController: UITabBarController, YUTabBarDelegate {
    weak var myTabBar:YUTabBar!
    let home = YUHomeViewController()
    let message = YUMessageViewController()
    let discover = YUDiscoverViewController()
    let me = YUMeViewController()

    func tabBarDidSelected(tabBar:YUTabBar, from:Int, to:Int) {
        self.selectedIndex = to
        if from == to && to == 0 { //首页被点，需要刷新数据
            home.header.beginRefreshing()
        }
    }

    func tabBarDidClickedPlusButton(tabBar: YUTabBar) {
        self.presentViewController(YUNavigationController(rootViewController: YUComposeViewController()), animated: true, completion: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        for child in self.tabBar.subviews {
            if ((child as? UIControl) != nil) {
                child.removeFromSuperview()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTabBar()
        self.setupAllChildViewControllers()
        // 定时检查未读数
        let timer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: Selector("checkUnreadCount"), userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
    }
    
    func checkUnreadCount() {
        let param = UserUnreadCountParam()
        param.uid = Int(YUAccountTool.account()!.uid as! String)!
        YUUserInfoTool.userUnreadCountWithParam(param) { (result, error) -> Void in
            if error == nil {
                self.home.tabBarItem.badgeValue = "\(result!.status!)"
                self.message.tabBarItem.badgeValue = "\(result!.messageCount())"
                // 3.3.我
                self.me.tabBarItem.badgeValue = "\(result!.follower!)"
                // 3.4.设置应用图标右上角的数字
                let version = Float(UIDevice.currentDevice().systemVersion)
                if version >= 8.0 {
                    // 在IOS8中要想设置applicationIconBadgeNumber，需要用户的授权，在IOS8中，需要加上下面的代码：
                    let settings = UIUserNotificationSettings(forTypes: .Badge, categories: nil)
                    UIApplication.sharedApplication().registerUserNotificationSettings(settings)
                    // 注册消息推送
                    //UIApplication.sharedApplication().registerForRemoteNotifications()
                }
                UIApplication.sharedApplication().applicationIconBadgeNumber = result!.totalCount()
            } else {
                print("发送请求失败\(error)")
            }
        }
    }
    
    func setupTabBar() {
        let myTabBar = YUTabBar()
        myTabBar.frame = self.tabBar.bounds
        myTabBar.delegate = self
        self.tabBar.addSubview(myTabBar)
        self.myTabBar = myTabBar
    }
    
    func setupAllChildViewControllers() {
        self.setupChildViewController(home, title: "首页", imageName: "tabbar_home", selectedImage: "tabbar_home_selected")
        self.setupChildViewController(message, title: "消息", imageName: "tabbar_message_center", selectedImage: "tabbar_message_center_selected")
        self.setupChildViewController(discover, title: "发现", imageName: "tabbar_discover", selectedImage: "tabbar_discover_selected")
        self.setupChildViewController(me, title: "我", imageName: "tabbar_profile", selectedImage: "tabbar_profile_selected")
    }
   
    func setupChildViewController(childVc:UIViewController, title:String, imageName:String, selectedImage:String) {
        childVc.title = title
        childVc.tabBarItem.image = UIImage.imageWithName(imageName)
        let selectImage = UIImage.imageWithName(selectedImage).imageWithRenderingMode(.AlwaysOriginal)
        //print("\(selectedImage)\(selectImage)")
        childVc.tabBarItem.selectedImage = selectImage
        self.addChildViewController(YUNavigationController(rootViewController: childVc))
        self.myTabBar.addTabBarButtonWithItem(childVc.tabBarItem)
    }
}
