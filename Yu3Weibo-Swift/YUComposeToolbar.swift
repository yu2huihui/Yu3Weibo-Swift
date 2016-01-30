//
//  YUComposeToolbar.swift
//  Yu3Weibo-Swift
//
//  Created by yu3 on 16/1/30.
//  Copyright © 2016年 yu3. All rights reserved.
//

import UIKit
enum YUComposeToolbarButtonType : Int {
    case Camera = 0
    case Picture = 1
    case Mention = 2
    case Trend = 3
    case Emotion = 4
}

protocol YUComposeToolbarDelegate : NSObjectProtocol {
    func composeToolbar(toolbar:YUComposeToolbar, didClickedButton:YUComposeToolbarButtonType)
}

class YUComposeToolbar: UIView {
    weak var delegate:YUComposeToolbarDelegate?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let buttonW = self.frame.size.width / CGFloat(self.subviews.count)
        let buttonH = self.frame.size.height
        for i in 0 ..< self.subviews.count {
            let btn = self.subviews[i] as! UIButton
            let buttonX = buttonW * CGFloat(i)
            btn.frame = CGRectMake(buttonX, 0, buttonW, buttonH)
        }
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(patternImage: UIImage.imageWithName("compose_toolbar_background"))
        
        self.addButtonWithIcon("compose_camerabutton_background", highIcon: "compose_camerabutton_background_highlighted", tag: .Camera)
        
        self.addButtonWithIcon("compose_toolbar_picture", highIcon: "compose_toolbar_picture_highlighted", tag: .Picture)
        
        self.addButtonWithIcon("compose_mentionbutton_background", highIcon: "compose_mentionbutton_background_highlighted", tag: .Mention)
        
        self.addButtonWithIcon("compose_trendbutton_background", highIcon: "compose_trendbutton_background_highlighted", tag: .Trend)
        
        self.addButtonWithIcon("compose_emoticonbutton_background", highIcon: "compose_emoticonbutton_background_highlighted", tag: .Emotion)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func addButtonWithIcon(icon:String, highIcon:String, tag:YUComposeToolbarButtonType) {
        let btn = UIButton()
        btn.tag = tag.rawValue
        btn.addTarget(self, action: Selector("buttonClick:"), forControlEvents: .TouchUpInside)
        btn.setImage(UIImage.imageWithName(icon), forState: .Normal)
        btn.setImage(UIImage.imageWithName(highIcon), forState: .Highlighted)
        self.addSubview(btn)
    }
    
    /**
    *  监听按钮点击
    */
    func buttonClick(btn:UIButton) {
        if ((self.delegate?.respondsToSelector(Selector("composeToolbar:"))) != nil) {
            self.delegate!.composeToolbar(self, didClickedButton: YUComposeToolbarButtonType(rawValue: btn.tag)!)
        }
    }
}
