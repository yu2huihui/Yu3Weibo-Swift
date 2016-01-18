//
//  YUTitleButton.swift
//  Yu3Weibo-Swift
//
//  Created by yu3 on 16/1/18.
//  Copyright © 2016年 yu3. All rights reserved.
//

import UIKit

class YUTitleButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.adjustsImageWhenHighlighted = false
        self.titleLabel?.font = UIFont.boldSystemFontOfSize(19)
        self.imageView?.contentMode = .Center
        self.titleLabel?.textAlignment = .Right
        self.setBackgroundImage(UIImage.resizedImageWithName("navigationbar_filter_background_highlighted"), forState: .Highlighted)
        self.setTitleColor(UIColor.blackColor(), forState: .Normal)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func imageRectForContentRect(contentRect: CGRect) -> CGRect {
        let imageY:CGFloat = 0
        let imageW:CGFloat = 20
        let imageX = contentRect.size.width - imageW
        let imageH = contentRect.size.height
        return CGRectMake(imageX, imageY, imageW, imageH)
    }
    
    override func titleRectForContentRect(contentRect: CGRect) -> CGRect {
        let titleY:CGFloat = 0
        let titleX:CGFloat = 0
        let titleW = contentRect.size.width - 20
        let titleH = contentRect.size.height
        return CGRectMake(titleX, titleY, titleW, titleH)
    }
    
    


}
