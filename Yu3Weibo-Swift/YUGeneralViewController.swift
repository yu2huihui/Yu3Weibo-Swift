//
//  YUGeneralViewController.swift
//  Yu3Weibo-Swift
//
//  Created by yu3 on 16/2/11.
//  Copyright © 2016年 yu3. All rights reserved.
//

import UIKit

class YUGeneralViewController: YUSettingViewController {
    
    
    override init() {
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setGroup0()
        self.setGroup1()
        self.setGroup2()
        self.setGroup3()
    }
    
    func setGroup0() {
        let group = self.addGroup()
        let read = SettingArrowItem(title: "阅读模式")
        let font = SettingArrowItem(title: "字号大小")
        let mark = SettingArrowItem(title: "显示备注")
        group.items = [read, font, mark]
    }
    
    func setGroup1() {
        let group = self.addGroup()
        let picture = SettingArrowItem(title: "图片浏览设置")
        group.items = [picture]
    }
    
    func setGroup3() {
        let group = self.addGroup()
        let language = SettingArrowItem(title: "多语言环境")
        group.items = [language]
    }
    
    func setGroup2() {
        let group = self.addGroup()
        let voice = SettingArrowItem(title: "声音")
        group.items = [voice]
    }
}
