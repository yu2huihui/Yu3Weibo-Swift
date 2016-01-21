//
//  YUStatusCell.swift
//  Yu3Weibo-Swift
//
//  Created by yu3 on 16/1/21.
//  Copyright © 2016年 yu3. All rights reserved.
//

import UIKit
import Kingfisher

class YUStatusCell: UITableViewCell {
    /** 顶部的view */
    weak var topView:UIImageView?
    /** 头像 */
    weak var iconView:UIImageView?
    /** 会员图标 */
    weak var vipView:UIImageView?
    /** 配图 */
    weak var photoView:UIImageView?
    /** 昵称 */
    weak var nameLabel:UILabel?
    /** 时间 */
    weak var timeLabel:UILabel?
    /** 来源 */
    weak var sourceLabel:UILabel?
    /** 正文\内容 */
    weak var contentLabel:UILabel?
    /** 被转发微博的view(父控件) */
    weak var retweetView:UIImageView?
    /** 被转发微博作者的昵称 */
    weak var retweetNameLabel:UILabel?
    /** 被转发微博的正文\内容 */
    weak var retweetContentLabel:UILabel?
    /** 被转发微博的配图 */
    weak var retweetPhotoView:UIImageView?
    /** 微博的工具条 */
    weak var statusToolbar:UIImageView?
    
    class func cellWithTableView(tableView:UITableView) -> YUStatusCell {
        let yu3 = "status"
        var cell = tableView.dequeueReusableCellWithIdentifier(yu3) as? YUStatusCell
        if (cell == nil) {
            cell = YUStatusCell(style: .Subtitle, reuseIdentifier: yu3)
        }
        return cell!;
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // 1.添加原创微博内部的子控件
        self.setupOriginalSubviews()
        // 2.添加被转发微博内部的子控件
        self.setupRetweetSubviews()
        // 3.添加微博的工具条
        self.setupStatusToolBar()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupOriginalSubviews() {
        // 0.设置cell选中时的背景
        self.selectedBackgroundView = UIView()
        
        /** 1.顶部的view */
        let topView = UIImageView()
        topView.image = UIImage.resizedImageWithName("timeline_card_top_background")
        topView.highlightedImage = UIImage.resizedImageWithName("timeline_card_top_background_highlighted")
        self.contentView.addSubview(topView)
        self.topView = topView
        
        /** 2.头像 */
        let iconView = UIImageView()
        topView.addSubview(iconView)
        self.iconView = iconView
        
        /** 3.会员图标 */
        let vipView = UIImageView()
        vipView.contentMode = .Center
        topView.addSubview(vipView)
        self.vipView = vipView;
        
        /** 4.配图 */
        let photoView = UIImageView()
        topView.addSubview(photoView)
        self.photoView = photoView
        
        /** 5.昵称 */
        let nameLabel = UILabel()
        nameLabel.font = YUStatusNameFont
        nameLabel.backgroundColor = UIColor.clearColor()
        topView.addSubview(nameLabel)
        self.nameLabel = nameLabel
        
        /** 6.时间 */
        let timeLabel = UILabel()
        timeLabel.font = YUStatusTimeFont
        timeLabel.textColor = UIColor.colorWithRed(240, green: 140, blue: 19)
        timeLabel.backgroundColor = UIColor.clearColor()
        topView.addSubview(timeLabel)
        self.timeLabel = timeLabel
        
        /** 7.来源 */
        let sourceLabel = UILabel()
        sourceLabel.font = YUStatusSourceFont
        sourceLabel.textColor = UIColor.colorWithRed(135, green: 135, blue: 135)
        sourceLabel.backgroundColor = UIColor.clearColor()
        topView.addSubview(sourceLabel)
        self.sourceLabel = sourceLabel
        
        /** 8.正文\内容 */
        let contentLabel = UILabel()
        contentLabel.numberOfLines = 0
        contentLabel.textColor = UIColor.colorWithRed(39, green: 39, blue: 39)
        contentLabel.font = YUStatusContentFont
        contentLabel.backgroundColor = UIColor.clearColor()
        topView.addSubview(contentLabel)
        self.contentLabel = contentLabel
    }
    
    func setupRetweetSubviews() {
        /** 1.被转发微博的view(父控件) */
        let retweetView = UIImageView()
        retweetView.image = UIImage.resizedImageWithName("timeline_retweet_background", left: 0.9, top: 0.5)
        self.topView!.addSubview(retweetView)
        self.retweetView = retweetView
        
        /** 2.被转发微博作者的昵称 */
        let retweetNameLabel = UILabel()
        retweetNameLabel.font = YURetweetStatusNameFont
        retweetNameLabel.textColor = UIColor.colorWithRed(67, green: 107, blue: 163)
        retweetNameLabel.backgroundColor = UIColor.clearColor()
        retweetView.addSubview(retweetNameLabel)
        self.retweetNameLabel = retweetNameLabel
        
        /** 3.被转发微博的正文\内容 */
        let retweetContentLabel = UILabel()
        retweetContentLabel.font = YURetweetStatusContentFont
        retweetContentLabel.backgroundColor = UIColor.clearColor()
        retweetContentLabel.numberOfLines = 0
        retweetContentLabel.textColor = UIColor.colorWithRed(90, green: 90, blue: 90)
        retweetView.addSubview(retweetContentLabel)
        self.retweetContentLabel = retweetContentLabel
        
        /** 4.被转发微博的配图 */
        let retweetPhotoView = UIImageView()
        retweetView.addSubview(retweetPhotoView)
        self.retweetPhotoView = retweetPhotoView
    }
    
    func setupStatusToolBar() {
        /** 1.微博的工具条 */
        let statusToolbar = UIImageView()
        statusToolbar.image = UIImage.resizedImageWithName("timeline_card_bottom_background")
        statusToolbar.highlightedImage = UIImage.resizedImageWithName("timeline_card_bottom_background_highlighted")
        self.contentView.addSubview(statusToolbar)
        self.statusToolbar = statusToolbar
    }
    
    var statusFrame:YUStatusFrame? {
        willSet {
            // 1.原创微博
            self.setupOriginalData(newValue!)
            // 2.被转发微博
            self.setupRetweetData(newValue!)
            // 3.微博工具条
            self.setupStatusToolbar(newValue!)
        }
    }
    
    func setupStatusToolbar(statusFrame:YUStatusFrame) {
        self.statusToolbar!.frame = statusFrame.statusToolbarF
    }
    
    func setupRetweetData(statusFrame:YUStatusFrame) {
        let retweetStatus = statusFrame.status!.retweeted_status
        let user = retweetStatus?.user;
        // 1.父控件
        if (retweetStatus != nil) {
            self.retweetView!.hidden = false
            self.retweetView!.frame = statusFrame.retweetViewF
            // 2.昵称
            self.retweetNameLabel!.text = "@" + user!.name!
            self.retweetNameLabel!.frame = statusFrame.retweetNameLabelF
            // 3.正文
            self.retweetContentLabel!.text = retweetStatus!.text
            self.retweetContentLabel!.frame = statusFrame.retweetContentLabelF
            // 4.配图
            if (retweetStatus!.thumbnail_pic != nil) {
                self.retweetPhotoView!.hidden = false
                self.retweetPhotoView!.frame = statusFrame.retweetPhotoViewF
                self.retweetPhotoView!.kf_setImageWithURL(NSURL(string: retweetStatus!.thumbnail_pic!)!, placeholderImage: UIImage.imageWithName("timeline_image_placeholder"))
            } else {
                self.retweetPhotoView!.hidden = true
            }
        } else {
            self.retweetView!.hidden = true
        }
    }
    
    func setupOriginalData(statusFrame:YUStatusFrame) {
        let status = statusFrame.status
        let user = status!.user!
        
        // 1.topView
        self.topView!.frame = statusFrame.topViewF
        
        // 2.头像
        self.iconView!.kf_setImageWithURL(NSURL(string: (user.profile_image_url)!)!, placeholderImage: UIImage.imageWithName("avatar_default_small"), options: .None, completionHandler: { (image, error, cacheType, imageURL) -> () in
            if image != nil {
                self.iconView!.image = UIImage.cutToCircle(image!)//裁剪头像为圆形
            }
            })
        self.iconView!.frame = statusFrame.iconViewF
        
        // 3.昵称
        self.nameLabel!.text = user.name
        self.nameLabel!.frame = statusFrame.nameLabelF
        
        // 4.vip
        if (user.mbtype != nil && user.mbrank! != 0) {
            self.vipView!.hidden = false
            self.vipView!.image = UIImage.imageWithName("common_icon_membership_level\(user.mbrank!)")
            self.vipView!.frame = statusFrame.vipViewF
            self.nameLabel!.textColor = UIColor.orangeColor()
        } else {
            self.nameLabel!.textColor = UIColor.blackColor()
            self.vipView!.hidden = true
        }
        
        // 5.时间
        self.timeLabel!.text = status!.created_at
        let timeLabelX = statusFrame.nameLabelF.origin.x
        let timeLabelY = CGRectGetMaxY(statusFrame.nameLabelF) + YUStatusCellBorder * 0.5
        let createdStr = status!.created_at! as NSString
        let timeLabelSize = createdStr.sizeWithAttributes([NSFontAttributeName:YUStatusTimeFont])
        self.timeLabel!.frame = CGRectMake(timeLabelX, timeLabelY, timeLabelSize.width, timeLabelSize.height)
        
        // 6.来源
        self.sourceLabel!.text = status!.source
        let sourceLabelX = CGRectGetMaxX(self.timeLabel!.frame) + YUStatusCellBorder
        let sourceLabelY = timeLabelY
        let sourceStr = status!.source! as NSString
        let sourceLabelSize = sourceStr.sizeWithAttributes([NSFontAttributeName:YUStatusSourceFont])
        self.sourceLabel!.frame = CGRectMake(sourceLabelX, sourceLabelY, sourceLabelSize.width, sourceLabelSize.height)
        
        // 7.正文
        self.contentLabel!.text = status!.text
        self.contentLabel!.frame = statusFrame.contentLabelF
        
        // 8.配图
        if (status!.thumbnail_pic != nil) {
            self.photoView!.hidden = false
            self.photoView!.frame = statusFrame.photoViewF
            self.photoView!.kf_setImageWithURL(NSURL(string: status!.thumbnail_pic!)!, placeholderImage: UIImage.imageWithName("timeline_image_placeholder"))
        } else {
            self.photoView!.hidden = true
        }
    }
}
