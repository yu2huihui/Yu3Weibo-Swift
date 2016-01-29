//
//  Constants.swift
//  Yu3Weibo-Swift
//
//  Created by yu3 on 16/1/27.
//  Copyright © 2016年 yu3. All rights reserved.
//

import UIKit

// 账号相关
let AppKey = "1421524559"
let AppSecret = "997bdcb2d1eafc1c9890f64acdd9844d"
let RedirectURI = "http://www.cnblogs.com/yu3-/"
let LoginURLStr = "https://api.weibo.com/oauth2/authorize?client_id=\(AppKey)&response_type=code&redirect_uri=\(RedirectURI)"

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

// 图片浏览相关
let YUPhotoW:CGFloat = 100
let YUPhotoH:CGFloat = 100
let YUOnlyPhotoW:CGFloat = 200
let YUOnlyPhotoH:CGFloat = 200
let YUPhotoMargin:CGFloat =  (UIScreen.mainScreen().bounds.size.width - 3 * YUPhotoW) / 4