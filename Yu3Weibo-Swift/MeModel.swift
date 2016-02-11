//
//  MeModel.swift
//  Yu3Weibo-Swift
//
//  Created by yu3 on 16/2/10.
//  Copyright © 2016年 yu3. All rights reserved.
//

import Foundation

class SettingItem {
    var icon = ""
    var title = ""
    var subtitle = ""
    var badgeValue = ""
    var operation: (() -> Void)?
    
    init(icon:String, title:String) {
        self.icon = icon
        self.title = title
    }
    
    init(title:String) {
        self.title = title
    }
}

class SettingSwitchItem : SettingItem {
    
}

class SettingLabelItem: SettingItem {

}

class SettingArrowItem: SettingItem {
    var destVcClass:UIViewController?
    init(title: String, destVcClass:UIViewController?) {
        super.init(title: title)
        self.destVcClass = destVcClass
    }
    
    init(icon: String, title: String, destVcClass:UIViewController?) {
        super.init(icon: icon, title: title)
        self.destVcClass = destVcClass
    }
    
    override init(title:String) {
        super.init(title: title)
        self.destVcClass = nil
    }
}

class SettingGroup {
    var header = ""
    var footer = ""
    var items = [SettingItem]()
}