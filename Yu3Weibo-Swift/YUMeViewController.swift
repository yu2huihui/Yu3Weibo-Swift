//
//  YUMeViewController.swift
//  Yu3Weibo-Swift
//
//  Created by yu3 on 16/1/17.
//  Copyright © 2016年 yu3. All rights reserved.
//

import UIKit

class YUMeViewController: YUSettingViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "设置", style: .Done, target: self, action: Selector("setting"))
        self.setGroup0()
        self.setGroup1()
        self.setGroup2()
        self.setGroup3()
    }

    func setting() {
        self.navigationController?.pushViewController(YUSystemSettingViewController(), animated: true)
    }
    
    func setGroup0() {
        let group = self.addGroup()
        let newFriend = SettingArrowItem(icon: "new_friend", title: "新的好友", destVcClass: nil)
        newFriend.badgeValue = "6"
        group.items = [newFriend];
    }
   
    func setGroup1() {
        let group = self.addGroup()
        let album = SettingArrowItem(icon: "album", title: "我的相册", destVcClass: nil)
        let collect = SettingArrowItem(icon: "collect", title: "我的点评", destVcClass: nil)
        let like = SettingArrowItem(icon: "like", title: "我的赞", destVcClass: nil)
        like.badgeValue = "3"
        group.items = [album, collect, like]
    }
    
    func setGroup2() {
        let group = self.addGroup()
        let pay = SettingArrowItem(icon: "pay", title: "微博支付", destVcClass: nil)
        let vip = SettingArrowItem(icon: "vip", title: "会员中心", destVcClass: nil)
        group.items = [pay, vip]
    }
    
    func setGroup3() {
        let group = self.addGroup()
        let card = SettingArrowItem(icon: "card", title: "我的名片", destVcClass: nil)
        let draft = SettingArrowItem(icon: "draft", title: "草稿箱", destVcClass: nil)
        group.items = [card, draft]
    }

}
