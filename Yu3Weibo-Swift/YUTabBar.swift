//
//  YUTabBar.swift
//  Yu3Weibo-Swift
//
//  Created by yu3 on 16/1/17.
//  Copyright © 2016年 yu3. All rights reserved.
//

import UIKit

@objc protocol YUTabBarDelegate:NSObjectProtocol {
    optional func tabBarDidSelected(tabBar:YUTabBar, from:Int, to:Int)
}


class YUTabBar: UIView {
    weak var delegate:YUTabBarDelegate?
    var tabBarButtons = [YUTabBarButton]()
    weak var plusButton:UIButton!
    weak var selectedButton:YUTabBarButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // 添加一个加号按钮
        let plusButton = UIButton(type: .Custom)
        plusButton.setBackgroundImage(UIImage.imageWithName("tabbar_compose_button"), forState:.Normal)
        plusButton.setBackgroundImage(UIImage.imageWithName("tabbar_compose_button_highlighted"), forState:.Highlighted)
        plusButton.setImage(UIImage.imageWithName("tabbar_compose_icon_add"), forState:.Normal)
        plusButton.setImage(UIImage.imageWithName("tabbar_compose_icon_add_highlighted"), forState:.Highlighted)
        
        plusButton.bounds = CGRectMake(0, 0, plusButton.currentBackgroundImage!.size.width, plusButton.currentBackgroundImage!.size.height)
        self.addSubview(plusButton)
        self.plusButton = plusButton
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func addTabBarButtonWithItem(item:UITabBarItem) {
        let button = YUTabBarButton()
        //去除点击按钮时的高亮状态
        button.adjustsImageWhenHighlighted = false
        self.addSubview(button)
        self.tabBarButtons.append(button)
        button.item = item
        button.addTarget(self, action: Selector("buttonClick:"), forControlEvents: .TouchUpInside)
        if self.tabBarButtons.count == 1 {
            self.buttonClick(button)
        }
    }
    
    func buttonClick(button:YUTabBarButton) {
        if ((self.delegate?.respondsToSelector(Selector("tabBarDidSelected:"))) != nil) {
            if self.selectedButton != nil {
                self.delegate?.tabBarDidSelected?(self, from:self.selectedButton.tag, to: button.tag)
            }
        }
        self.selectedButton?.selected = false
        button.selected = true
        self.selectedButton = button
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // 调整加号按钮的位置
        let h = self.frame.size.height;
        let w = self.frame.size.width;
        self.plusButton.center = CGPointMake(w * 0.5, h * 0.5)
        
        // 按钮的frame数据
        let buttonH = h;
        let buttonW = w / CGFloat(self.subviews.count)
        let buttonY:CGFloat = 0;
        
        for (var index = 0; index < self.tabBarButtons.count; index++) {
            // 1.取出按钮
            let button = self.tabBarButtons[index]
            // 2.设置按钮的frame
            var buttonX = CGFloat(index) * buttonW
            if (index > 1) {
                buttonX += buttonW
            }
            button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH)
            // 3.绑定tag
            button.tag = index
        }

    }
   
}
