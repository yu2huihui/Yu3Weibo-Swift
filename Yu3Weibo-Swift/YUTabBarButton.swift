//
//  YUTabBarButton.swift
//  Yu3Weibo-Swift
//
//  Created by yu3 on 16/1/17.
//  Copyright © 2016年 yu3. All rights reserved.
//

import UIKit

class YUTabBarButton: UIButton {
    weak var badgeButton:YUBadgeButton?
    var item:UITabBarItem! {
        didSet{
            // KVO 监听属性改变
            self.item.addObserver(self, forKeyPath: "badgeValue", options:.New, context: nil)
            self.item.addObserver(self, forKeyPath: "title", options:.New, context: nil)
            self.item.addObserver(self, forKeyPath: "image", options:.New, context: nil)
            self.item.addObserver(self, forKeyPath: "selectedImage", options:.New, context: nil)
            self.observeValueForKeyPath(nil, ofObject: nil, change: nil, context: nil)
        }
    }
    
    deinit {
        self.item.removeObserver(self, forKeyPath: "badgeValue")
        self.item.removeObserver(self, forKeyPath: "title")
        self.item.removeObserver(self, forKeyPath: "image")
        self.item.removeObserver(self, forKeyPath: "selectedImage")
    }
    
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        // 设置文字
        self.setTitle(self.item.title, forState: .Normal)
        self.setTitle(self.item.title, forState: .Selected)
        // 设置图片
        self.setImage(self.item.image, forState: .Normal)
        self.setImage(self.item.selectedImage, forState: .Selected)
        // 设置提醒数字
        self.badgeButton?.badgeValue = self.item.badgeValue
        
        // 设置提醒数字的位置
        let badgeY:CGFloat = 0
        //print(self.frame.size.width )
        let badgeX = self.badgeButton!.frame.size.width + 25
        var badgeF = self.badgeButton!.frame
        badgeF.origin.x = badgeX
        badgeF.origin.y = badgeY
        self.badgeButton!.frame = badgeF
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.imageView!.contentMode = .Center
        self.titleLabel!.textAlignment = .Center
        self.titleLabel!.font = UIFont.systemFontOfSize(13)
        self.setTitleColor(UIColor.blackColor(), forState: .Normal)
        self.setTitleColor(UIColor(colorLiteralRed: 234/255.0, green: 103/255.0, blue: 7/255.0, alpha: 1.0), forState: .Selected)
        // 添加一个提醒数字按钮
        let badgeButton = YUBadgeButton()
        //badgeButton.autoresizingMask = .FlexibleLeftMargin
        //badgeButton.autoresizingMask = .FlexibleBottomMargin
        self.addSubview(badgeButton)
        self.badgeButton = badgeButton
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // 内部图片的frame
    override func imageRectForContentRect(contentRect: CGRect) -> CGRect {
        let imageW = contentRect.size.width
        let imageH = contentRect.size.height * 0.6
        return CGRectMake(0, 0, imageW, imageH)
    }
    
    // 内部文字的frame
    override func titleRectForContentRect(contentRect: CGRect) -> CGRect {
        let titleY = contentRect.size.height * 0.6
        let titleW = contentRect.size.width
        let titleH = contentRect.size.height - titleY
        return CGRectMake(0, titleY, titleW, titleH)
    }
}
