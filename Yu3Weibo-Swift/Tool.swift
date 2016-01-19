//
//  Tool.swift
//  Yu3Weibo-Swift
//
//  Created by yu3 on 16/1/19.
//  Copyright © 2016年 yu3. All rights reserved.
//

import Foundation
import UIKit

class YUWeiboTool {
    static func chooseRootController() {
        let application = UIApplication.sharedApplication()
        let key = "CFBundleVersion"
        let defaults = NSUserDefaults.standardUserDefaults()
        let lastVersion = defaults.valueForKey(key)
        //获得当前版本号
        let currentVersion = NSBundle.mainBundle().infoDictionary![key]
        if ((currentVersion?.isEqual(lastVersion)) == true) {
            application.statusBarHidden = false
            application.keyWindow!.rootViewController = YUTabBarViewController()
        } else {
            application.keyWindow!.rootViewController = YUNewFeatureController()
            defaults.setObject(currentVersion, forKey: key)
            defaults.synchronize()
        }

    }
}

class YUAccountTool {
    static let accountFile = (NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).last! as NSString).stringByAppendingPathComponent("account.data")
    
    static func saveAccount(account:YUAccount) -> Void {
        // 计算账号过期时间
        let now = NSDate()
        account.expiresTime = now.dateByAddingTimeInterval(NSTimeInterval(account.expires_in!))
        NSKeyedArchiver.archiveRootObject(account, toFile: accountFile)
    }
    
    static func account() -> YUAccount? {
        let account = NSKeyedUnarchiver.unarchiveObjectWithFile(accountFile) as? YUAccount
        let now = NSDate()
        if account!.expiresTime != nil {
            if (now.compare(account!.expiresTime!)) == NSComparisonResult.OrderedAscending { // 还没有过期
                return account
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
}