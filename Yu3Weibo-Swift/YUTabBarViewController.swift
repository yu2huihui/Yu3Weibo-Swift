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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTabBar()
        self.setupAllChildViewControllers()
    }
    
    func setupTabBar() {
        let myTabBar = YUTabBar()
        myTabBar.frame = self.tabBar.bounds
        myTabBar.delegate = self
        self.tabBar.addSubview(myTabBar)
        self.myTabBar = myTabBar
    }
    
    func tabBarDidSelected(tabBar:YUTabBar, from:Int, to:Int) {
        self.selectedIndex = to
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        for child in self.tabBar.subviews {
            if ((child as? UIControl) != nil) {
                child.removeFromSuperview()
            }
        }
    }
    
    func setupAllChildViewControllers() {
        let home = YUHomeViewController()
        self.setupChildViewController(home, title: "首页", imageName: "tabbar_home", selectedImage: "tabbar_home_selected")
        //home.tabBarItem.badgeValue = "99"
        let message = YUMessageViewController()
        self.setupChildViewController(message, title: "消息", imageName: "tabbar_message_center", selectedImage: "tabbar_message_center_selected")
        let discover = YUDiscoverViewController()
        self.setupChildViewController(discover, title: "发现", imageName: "tabbar_discover", selectedImage: "tabbar_discover_selected")
        let me = YUMeViewController()
        self.setupChildViewController(me, title: "我", imageName: "tabbar_profile", selectedImage: "tabbar_profile_selected")
        me.tabBarItem.badgeValue = "3"
        //message.tabBarItem.badgeValue = "23"
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
