//
//  YUNavigationController.swift
//  Yu3Weibo-Swift
//
//  Created by yu3 on 16/1/18.
//  Copyright © 2016年 yu3. All rights reserved.
//

import UIKit

class YUNavigationController: UINavigationController {
    
    override func pushViewController(viewController: UIViewController, animated: Bool) {
        if self.viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: true)
    }
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override class func initialize() {
        // 导航栏按钮主题
        let item = UIBarButtonItem.appearance()
        let attr = [
            NSForegroundColorAttributeName : UIColor.orangeColor(),
            NSFontAttributeName : UIFont.systemFontOfSize(16)
        ]
        item.setTitleTextAttributes(attr, forState: .Normal)
        item.setTitleTextAttributes(attr, forState: .Highlighted)
        let disableAttr = [NSForegroundColorAttributeName : UIColor.lightGrayColor()]
        item.setTitleTextAttributes(disableAttr, forState: .Disabled)
        
        // 设置导航栏主题
        let navBar = UINavigationBar.appearance()
        let titleAttr = [
            NSForegroundColorAttributeName : UIColor.blackColor(),
            NSFontAttributeName : UIFont.systemFontOfSize(19)
        ]
        navBar.titleTextAttributes = titleAttr
    }
}
