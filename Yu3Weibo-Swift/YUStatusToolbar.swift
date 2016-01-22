//
//  YUStatusToolbar.swift
//  Yu3Weibo-Swift
//
//  Created by yu3 on 16/1/22.
//  Copyright © 2016年 yu3. All rights reserved.
//

import UIKit

class YUStatusToolbar: UIImageView {
    var btns = [UIButton]()
    var dividers = [UIImageView]()
    weak var reweetBtn:UIButton?
    weak var commentBtn:UIButton?
    weak var attitudeBtn:UIButton?
    
    var status:YUStatus? {
        didSet {
            self.setupBtn(self.reweetBtn!, originalTitle: "转发", count: self.status!.reposts_count!)
            self.setupBtn(self.commentBtn!, originalTitle: "评论", count: self.status!.comments_count!)
            self.setupBtn(self.attitudeBtn!, originalTitle: "赞", count: self.status!.attitudes_count!)
        }
    }
    
    func setupBtn(btn:UIButton, originalTitle:String, count:Int) {
        /**
        0 -> @"转发"
        <10000  -> 完整的数量, 比如个数为6545,  显示出来就是6545
        >= 10000
        * 整万(10100, 20326, 30000 ....) : 1万, 2万
        * 其他(14364) : 1.4万
        */
        if count > 0 {
            var title = ""
            if count < 10000 {
                title = "\(count)"
            } else {
                let countDouble = Double(count) / 10000.0
                title = String(format: "%.1f万", countDouble)
                title = title.stringByReplacingOccurrencesOfString(".0", withString: "")
            }
            btn.setTitle(title, forState: .Normal)
        } else {
            btn.setTitle(originalTitle, forState: .Normal)
        }
    }
    
    convenience init() {
        self.init(frame: CGRectZero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // 1.设置图片
        self.userInteractionEnabled = true
        self.image = UIImage.resizedImageWithName("timeline_card_bottom_background")
        self.highlightedImage = UIImage.resizedImageWithName("timeline_card_bottom_background_highlighted")
        // 2.添加按钮
        self.reweetBtn = self.setupBtnWithTitle("转发", image: "timeline_icon_retweet", bgImage: "timeline_card_leftbottom_highlighted")
        self.commentBtn = self.setupBtnWithTitle("评论", image: "timeline_icon_comment", bgImage: "timeline_card_middlebottom_highlighted")
        self.attitudeBtn = self.setupBtnWithTitle("赞", image: "timeline_icon_unlike", bgImage: "timeline_card_rightbottom_highlighted")
        // 3.添加两条分割线
        self.setupDivider()
        self.setupDivider()
    }
    
    func setupDivider() {
        let divider = UIImageView()
        divider.image = UIImage.imageWithName("timeline_card_bottom_line")
        self.addSubview(divider)
        self.dividers.append(divider)
    }
    
    func setupBtnWithTitle(title:String, image:String, bgImage:String) -> UIButton {
        let btn = UIButton()
        btn.setImage(UIImage.imageWithName(image), forState: .Normal)
        btn.setTitleColor(UIColor.grayColor(), forState: .Normal)
        btn.titleLabel?.font = UIFont.systemFontOfSize(13)
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0)
        btn.adjustsImageWhenHighlighted = false
        btn.setBackgroundImage(UIImage.imageWithName(bgImage), forState: .Highlighted)
        self.addSubview(btn)
        self.btns.append(btn)
        return btn
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // 1.设置按钮的frame
        let dividerCount = self.dividers.count // 分割线的个数
        let dividerW:CGFloat = 2 // 分割线的宽度
        let btnCount = self.btns.count
        let btnW = (self.frame.size.width - CGFloat(dividerCount) * dividerW) / CGFloat(btnCount)
        let btnH = self.frame.size.height
        let btnY:CGFloat = 0
        for i in 0 ..< btnCount {
            let btn = self.btns[i]
            // 设置frame
            let btnX = CGFloat(i) * (btnW + dividerW)
            btn.frame = CGRectMake(btnX, btnY, btnW, btnH)
        }
        // 2.设置分割线的frame
        let dividerH = btnH
        let dividerY:CGFloat = 0
        for i in 0 ..< dividerCount {
            let divider = self.dividers[i]
            // 设置frame
            let btn = self.btns[i]
            let dividerX = CGRectGetMaxX(btn.frame)
            divider.frame = CGRectMake(dividerX, dividerY, dividerW, dividerH)
        }
    }
}
