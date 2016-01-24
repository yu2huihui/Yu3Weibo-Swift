//
//  FrameModel.swift
//  Yu3Weibo-Swift
//
//  Created by yu3 on 16/1/21.
//  Copyright © 2016年 yu3. All rights reserved.
//

import UIKit
/** 昵称的字体 */
let YUStatusNameFont = UIFont.systemFontOfSize(15)
/** 被转发微博作者昵称的字体 */
let YURetweetStatusNameFont = YUStatusNameFont
/** 时间的字体 */
let YUStatusTimeFont = UIFont.systemFontOfSize(12)
/** 来源的字体 */
let YUStatusSourceFont = YUStatusTimeFont
/** 正文的字体 */
let YUStatusContentFont = UIFont.systemFontOfSize(13)
/** 被转发微博正文的字体 */
let YURetweetStatusContentFont = YUStatusContentFont
/** cell的边框宽度 */
let YUStatusCellBorder:CGFloat = 10

class YUStatusFrame : NSObject {
    /** 顶部的view */
    var topViewF:CGRect = CGRectZero
     /** 头像 () */
    var iconViewF:CGRect = CGRectZero
    /** 会员图标 */
    var vipViewF:CGRect = CGRectZero
    /** 配图 */
    var  photoViewF:CGRect = CGRectZero
    /** 昵称 */
    var  nameLabelF:CGRect = CGRectZero
    /** 时间 */
    var  timeLabelF:CGRect = CGRectZero
    /** 来源 */
    var  sourceLabelF:CGRect = CGRectZero
    /** 正文\内容 */
    var  contentLabelF:CGRect = CGRectZero
    /** 被转发微博的view(父控件) */
    var  retweetViewF:CGRect = CGRectZero
    /** 被转发微博作者的昵称 */
    var  retweetNameLabelF:CGRect = CGRectZero
    /** 被转发微博的正文\内容 */
    var  retweetContentLabelF:CGRect = CGRectZero
    /** 被转发微博的配图 */
    var  retweetPhotoViewF:CGRect = CGRectZero
    /** 微博的工具条 */
    var  statusToolbarF:CGRect = CGRectZero
    /** cell的高度 */
    var  cellHeight:CGFloat = 0.0
    
    var status:YUStatus? {
        willSet {
            // cell的宽度
            let cellW = UIScreen.mainScreen().bounds.size.width
            
            // 1.topView
            let topViewW = cellW
            let topViewX:CGFloat = 0
            let topViewY:CGFloat = 0
            var topViewH:CGFloat = 0
            
            // 2.头像
            let iconViewWH:CGFloat = 35
            let iconViewX = YUStatusCellBorder
            let iconViewY = YUStatusCellBorder
            self.iconViewF = CGRectMake(iconViewX, iconViewY, iconViewWH, iconViewWH)
            
            // 3.昵称
            let nameLabelX = CGRectGetMaxX(self.iconViewF) + YUStatusCellBorder
            let nameLabelY = iconViewY
            let name = newValue!.user!.name! as NSString
            let nameLabelSize = name.sizeWithAttributes([NSFontAttributeName:YUStatusNameFont])
            self.nameLabelF = CGRectMake(nameLabelX, nameLabelY, nameLabelSize.width, nameLabelSize.height)
            
            // 4.会员图标
            if (newValue!.user?.mbtype != nil) {
                let vipViewW:CGFloat = 14
                let vipViewH = nameLabelSize.height
                let vipViewX = CGRectGetMaxX(self.nameLabelF) + YUStatusCellBorder
                let vipViewY = nameLabelY
                self.vipViewF = CGRectMake(vipViewX, vipViewY, vipViewW, vipViewH)
            }
            
            // 5.时间
            let timeLabelX = nameLabelX
            let timeLabelY = CGRectGetMaxY(self.nameLabelF) + YUStatusCellBorder * 0.5
            let createdTime = newValue!.created_at! as NSString
            let timeLabelSize = createdTime.sizeWithAttributes([NSFontAttributeName:YUStatusTimeFont])
            self.timeLabelF = CGRectMake(timeLabelX, timeLabelY, timeLabelSize.width, timeLabelSize.height)
            
            // 6.来源
            let sourceLabelX = CGRectGetMaxX(self.timeLabelF) + YUStatusCellBorder
            let sourceLabelY = timeLabelY
            let sourceStr = newValue!.source! as NSString
            let sourceLabelSize = sourceStr.sizeWithAttributes([NSFontAttributeName:YUStatusSourceFont])
            self.sourceLabelF = CGRectMake(sourceLabelX, sourceLabelY, sourceLabelSize.width, sourceLabelSize.height)
            
            // 7.微博正文内容
            let contentLabelX = iconViewX
            let contentLabelY = max(CGRectGetMaxY(self.timeLabelF), CGRectGetMaxY(self.iconViewF)) + YUStatusCellBorder * 0.5
            let contentLabelMaxW = topViewW - 2 * YUStatusCellBorder
            let textStr = newValue!.text! as NSString
            let contentLabelSize = textStr.boundingRectWithSize(CGSizeMake(contentLabelMaxW, CGFloat(MAXFLOAT)), options:.UsesLineFragmentOrigin, attributes: [NSFontAttributeName:YUStatusContentFont], context: nil)
            self.contentLabelF = CGRectMake(contentLabelX, contentLabelY, contentLabelSize.width, contentLabelSize.height)
            
            // 8.配图
            if (newValue!.pic_urls != nil) {
                let photosViewSize = YUPhotoListView.photosViewSizeWithPhotosCount(newValue!.pic_urls!.count)
                let photoViewX = contentLabelX
                let photoViewY = CGRectGetMaxY(self.contentLabelF) + YUStatusCellBorder
                self.photoViewF = CGRectMake(photoViewX, photoViewY, photosViewSize.width, photosViewSize.height)
            }
            
            // 9.被转发微博
            if (newValue!.retweeted_status != nil) {
                let retweetViewW = contentLabelMaxW
                let retweetViewX = contentLabelX
                let retweetViewY = CGRectGetMaxY(self.contentLabelF) + YUStatusCellBorder * 0.5
                var retweetViewH:CGFloat = 0
                
                // 10.被转发微博的昵称
                let retweetNameLabelX = YUStatusCellBorder
                let retweetNameLabelY = YUStatusCellBorder
                let retweetName = ("@" + (newValue!.retweeted_status?.user?.name)!) as NSString
                let retweetNameLabelSize = retweetName.sizeWithAttributes([NSFontAttributeName:YURetweetStatusNameFont])
                self.retweetNameLabelF = CGRectMake(retweetNameLabelX, retweetNameLabelY, retweetNameLabelSize.width, retweetNameLabelSize.height)
                
                // 11.被转发微博的正文
                let retweetContentLabelX = retweetNameLabelX
                let retweetContentLabelY = CGRectGetMaxY(self.retweetNameLabelF) + YUStatusCellBorder * 0.5
                let retweetContentLabelMaxW = retweetViewW - 2 * YUStatusCellBorder
                let retweetText = (newValue!.retweeted_status?.text)! as NSString
                let retweetContentLabelSize = retweetText.boundingRectWithSize(CGSizeMake(retweetContentLabelMaxW, CGFloat(MAXFLOAT)), options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName:YURetweetStatusContentFont], context: nil)
                self.retweetContentLabelF = CGRectMake(retweetContentLabelX, retweetContentLabelY, retweetContentLabelSize.width, retweetContentLabelSize.height)
                
                // 12.被转发微博的配图
                if(newValue!.retweeted_status?.pic_urls != nil) {
                    let retweetPhotosViewSize = YUPhotoListView.photosViewSizeWithPhotosCount(newValue!.retweeted_status!.pic_urls!.count)
                    let retweetPhotoViewX = retweetContentLabelX
                    let retweetPhotoViewY = CGRectGetMaxY(self.retweetContentLabelF) + YUStatusCellBorder
                    self.retweetPhotoViewF = CGRectMake(retweetPhotoViewX, retweetPhotoViewY, retweetPhotosViewSize.width, retweetPhotosViewSize.height)
                    retweetViewH = CGRectGetMaxY(self.retweetPhotoViewF)
                } else { // 没有配图
                    retweetViewH = CGRectGetMaxY(self.retweetContentLabelF)
                }
                retweetViewH += YUStatusCellBorder
                self.retweetViewF = CGRectMake(retweetViewX, retweetViewY, retweetViewW, retweetViewH)
                
                // 有转发微博时topViewH
                topViewH = CGRectGetMaxY(self.retweetViewF)
            } else { // 没有转发微博
                if (newValue!.pic_urls != nil) { // 有图
                    topViewH = CGRectGetMaxY(self.photoViewF)
                } else { // 无图
                    topViewH = CGRectGetMaxY(self.contentLabelF)
                }
            }
            topViewH += YUStatusCellBorder
            self.topViewF = CGRectMake(topViewX, topViewY, topViewW, topViewH)
            
            // 13.工具条
            let statusToolbarX = topViewX
            let statusToolbarY = CGRectGetMaxY(self.topViewF)
            let statusToolbarW = topViewW
            let statusToolbarH:CGFloat = 35
            self.statusToolbarF = CGRectMake(statusToolbarX, statusToolbarY, statusToolbarW, statusToolbarH)
            
            // 14.cell的高度
            self.cellHeight = CGRectGetMaxY(self.statusToolbarF) + 5
        }
    }
}