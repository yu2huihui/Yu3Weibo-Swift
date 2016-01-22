//
//  model.swift
//  Yu3Weibo-Swift
//
//  Created by yu3 on 16/1/19.
//  Copyright © 2016年 yu3. All rights reserved.
//

import Foundation

/** 微博模型 */
class YUStatus: NSObject {
    /** 微博的内容(文字) */
    var text:String?
    /** 微博的时间原始数据"EEE MMM dd HH:mm:ss Z yyyy" */
    var _created_at:String?
    /** 微博的时间 */
    var created_at:String? {
        //时间显示
        let fmt = NSDateFormatter()
        fmt.dateFormat = "EEE MMM dd HH:mm:ss Z yyyy"
        fmt.locale = NSLocale(localeIdentifier: "en_US")//设置识别英文格式的时间，若没有此句且设备语言不是英文，无法得到时间
        let createdDate = fmt.dateFromString(self._created_at!)
        // 2..判断微博发送时间 和 现在时间 的差距
        let calendar = NSCalendar.currentCalendar()
        //let componentHour = calendar.components(.Hour, fromDate: createdDate!, toDate: NSDate(), options: .WrapComponents)
        if createdDate!.isToday() { // 今天
            //print("\(componentHour.hour)hour")
            let createdDateHour = calendar.component(.Hour, fromDate: createdDate!)
            let currentHour = calendar.component(.Hour, fromDate: NSDate())
            if currentHour - createdDateHour >= 1 {
                return "\(currentHour - createdDateHour)小时前"
            } else {
                let createdDateMin = calendar.component(.Minute, fromDate: createdDate!)
                let currentMin = calendar.component(.Minute, fromDate: NSDate())
                if currentMin - createdDateMin < 1 {
                    return"刚刚"
                } else {
                    return "\(currentMin - createdDateMin)分钟前"
                }
            }
        } else if createdDate!.isYesterday() { // 昨天
            fmt.dateFormat = "昨天 HH:mm"
            return fmt.stringFromDate(createdDate!)
        } else if createdDate!.isThisYear() { // 今年(至少是前天)
            fmt.dateFormat = "MM-dd HH:mm"
            return fmt.stringFromDate(createdDate!)
        } else { // 非今年
            fmt.dateFormat = "yyyy-MM-dd HH:mm"
            return fmt.stringFromDate(createdDate!)
        }
    }
    /** 微博的来源原始html数据 */
    var _source:String?
    /** 微博的来源 */
    var source:String? {
        //来源显示
        let start = _source?.rangeOfString(">")?.startIndex.advancedBy(1)
        let end = _source?.rangeOfString("</")?.startIndex
        if start != nil && end != nil {
            let range = Range(start: start!, end: end!)
            let str = _source?.substringWithRange(range)
            return "来自\(str!)"
        } else {
            return _source
        }
    }
    /** 微博的ID */
    var idstr:String?
    /** 微博的单张配图 */
    var thumbnail_pic:String?
    /** 微博的转发数 */
    var reposts_count:Int?
    /** 微博的评论数 */
    var comments_count:Int?
    /** 微博的表态数(被赞数) */
    var attitudes_count:Int?
    /** 微博的作者 */
    var user:YUUser?
    /** 被转发的微博 */
    var retweeted_status:YUStatus?
    
    init(dic:NSDictionary) {
        super.init()
        self.text = dic["text"] as? String
        self._created_at = dic["created_at"] as? String
        self._source = dic["source"] as? String
        self.idstr = dic["idstr"] as? String
        self.thumbnail_pic = dic["thumbnail_pic"] as? String
        self.reposts_count = dic["reposts_count"] as? Int
        self.comments_count = dic["comments_count"] as? Int
        self.attitudes_count = dic["attitudes_count"] as? Int
        self.user = YUUser(dic: dic["user"] as! NSDictionary)
        let retweeted_status_dic = dic["retweeted_status"] as? NSDictionary
        if retweeted_status_dic != nil {
            self.retweeted_status = YUStatus(dic: retweeted_status_dic!)
        }
    }
}
/** 用户模型 */
class YUUser: NSObject {
    /** 用户的ID */
    var idstr:String?
    /** 用户的昵称 */
    var name:String?
    /** 用户的头像 */
    var profile_image_url:String?
    /** 会员等级 */
    var mbrank:Int?
    /** 会员类型 */
    var mbtype:Int?
    init(dic:NSDictionary) {
        super.init()
        self.idstr = dic["idstr"] as? String
        self.name = dic["name"] as? String
        self.profile_image_url = dic["profile_image_url"] as? String
        self.mbrank = dic["mbrank"] as? Int
        self.mbtype = dic["mbtype"] as? Int
    }
}

class YUAccount: NSObject, NSCoding {
    var access_token:NSString?
    var expires_in:NSNumber?
    var remind_in:NSString?
    var uid:NSString?
    var expiresTime:NSDate? // 账号的过期时间
    
    init(dic:Dictionary<String, AnyObject>) {
        super.init()
        self.setValuesForKeysWithDictionary(dic)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        self.access_token = (aDecoder.decodeObjectForKey("access_token") as? NSString)
        self.expires_in = aDecoder.decodeObjectForKey("expires_in") as? NSNumber
        self.remind_in = aDecoder.decodeObjectForKey("remind_in") as? NSString
        self.uid = aDecoder.decodeObjectForKey("uid") as? NSString
        self.expiresTime = aDecoder.decodeObjectForKey("expiresTime") as? NSDate
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.access_token, forKey: "access_token")
        aCoder.encodeObject(self.expires_in, forKey: "expires_in")
        aCoder.encodeObject(self.remind_in, forKey: "remind_in")
        aCoder.encodeObject(self.uid, forKey: "uid")
        aCoder.encodeObject(self.expiresTime, forKey: "expiresTime")
    }
}