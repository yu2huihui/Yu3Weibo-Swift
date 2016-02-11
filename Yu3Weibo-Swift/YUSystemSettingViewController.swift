//
//  YUSystemSettingViewController.swift
//  Yu3Weibo-Swift
//
//  Created by yu3 on 16/2/11.
//  Copyright © 2016年 yu3. All rights reserved.
//

import UIKit

class YUSystemSettingViewController: YUSettingViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "设置"
        
        self.setGroup0()
        self.setGroup1()
        self.setGroup2()
        self.setFooter()
    }
    
    func setFooter() {
        // 按钮
        let logoutButton = UIButton()
        let logoutX:CGFloat = 0
        let logoutY:CGFloat = 10
        let logoutW = self.tableView.frame.size.width;
        let logoutH:CGFloat = 40
        logoutButton.frame = CGRectMake(logoutX, logoutY, logoutW, logoutH)
        // 背景和文字
        logoutButton.setBackgroundImage(UIImage.resizedImageWithName("common_card_middle_background"), forState: .Normal)
        logoutButton.setBackgroundImage(UIImage.resizedImageWithName("common_card_middle_background_highlighted"), forState: .Highlighted)
        logoutButton.setTitle("退出当前帐号", forState: .Normal)
        logoutButton.setTitleColor(UIColor.redColor(), forState: .Normal)
        logoutButton.titleLabel!.font = UIFont.systemFontOfSize(14)
        
        // footer
        let footer = UIView()
        let footerH = logoutH
        footer.frame = CGRectMake(0, 0, 0, footerH)
        self.tableView.tableFooterView = footer
        footer.addSubview(logoutButton)
    }

    func setGroup0() {
        let group = self.addGroup()
        let account = SettingArrowItem(title: "帐号管理")
        let safe = SettingArrowItem(title: "帐号安全")
        group.items = [account, safe]
    }
    
    func setGroup1() {
        let group = self.addGroup()
        let notice = SettingArrowItem(title: "通知")
        let safe = SettingArrowItem(title: "隐私与安全")
        let general = SettingArrowItem(title: "通用设置", destVcClass: YUGeneralViewController())
        group.items = [notice, safe, general]

    }
    
    func setGroup2() {
        let group = self.addGroup()
        let clearCache = SettingArrowItem(title: "清除缓存")
        // 计算缓存文件夹的大小
        let mgr = NSFileManager.defaultManager()
        let cachePath = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true).last! as NSString
        let subPaths = mgr.subpathsAtPath(cachePath as String)
        var totalSize:Int64 = 0
        for subPath in subPaths! {
            let fullPath = cachePath.stringByAppendingPathComponent(subPath)
            var isdir:ObjCBool = false
            mgr.fileExistsAtPath(fullPath, isDirectory: &isdir)
            if isdir.boolValue == false { //文件
                totalSize += try! mgr.attributesOfItemAtPath(fullPath)[NSFileSize]!.longLongValue!
            }
            let size = Double(totalSize)/1024.0/1024.0
            if size > 1 {
                clearCache.subtitle = String(format: "%.0fM", size)
            } else {
                clearCache.subtitle = String(format: "%.2fM", size)
            }
            clearCache.operation = {
                MBProgressHUD.showMessage("正在清理中...")
                // 执行清除缓存
                try! mgr.removeItemAtPath(cachePath as String)
                
                MBProgressHUD.hideHUD()
                self.tableView.reloadData()
            }
            let opinion = SettingArrowItem(title: "意见反馈")
            let about = SettingArrowItem(title: "关于微博")
            group.items = [clearCache, opinion, about]
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
    }
}
