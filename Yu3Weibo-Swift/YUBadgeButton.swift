//
//  YUBadgeButton.swift
//  Yu3Weibo-Swift
//
//  Created by yu3 on 16/1/17.
//  Copyright © 2016年 yu3. All rights reserved.
//

import UIKit

class YUBadgeButton: UIButton {
    var badgeValue:String? {
        willSet {
            if newValue != nil {
                if Int(newValue!) > 0 {
                    self.hidden = false;
                    self.setTitle(newValue, forState: .Normal)
                    // 设置frame
                    var frame = self.frame
                    let badgeH = self.currentBackgroundImage!.size.height
                    var badgeW = self.currentBackgroundImage!.size.width
                    if (NSString(string: newValue!).length > 1) {
                        // 文字的尺寸
                        let badgeSize = NSString(string: newValue!).sizeWithAttributes(["NSFontAttributeName":self.titleLabel!.font])
                        badgeW = badgeSize.width + 10;
                    }
                    frame.size.width = badgeW
                    frame.size.height = badgeH
                    self.frame = frame
                }
            } else {
                self.hidden = true
            }
        }
    }
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.hidden = true
        self.userInteractionEnabled = false
        self.setBackgroundImage(UIImage.resizedImageWithName("main_badge"), forState: .Normal)
        self.titleLabel!.font = UIFont.systemFontOfSize(11)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}