//
//  model.swift
//  Yu3Weibo-Swift
//
//  Created by yu3 on 16/1/19.
//  Copyright © 2016年 yu3. All rights reserved.
//

import Foundation

class YUStatus: NSObject {
    /** 微博的内容(文字) */
    var text:String?
    /** 微博的来源 */
    var source:String?
    /** 微博的ID */
    var idstr:String?
    /** 微博的转发数 */
    var reposts_count:Int?
    /** 微博的评论数 */
    var comments_count:Int?
    /** 微博的作者 */
    var user:YUUser?
    
    init(dic:NSDictionary) {
        super.init()
        self.text = dic["text"] as? String
        self.source = dic["source"] as? String
        self.idstr = dic["idstr"] as? String
        self.reposts_count = dic["reposts_count"] as? Int
        self.comments_count = dic["comments_count"] as? Int
        self.user = YUUser(dic: dic["user"] as! NSDictionary)
    }
}

class YUUser: NSObject {
    /** 用户的ID */
    var idstr:String?
    /** 用户的昵称 */
    var name:String?
    /** 用户的头像 */
    var profile_image_url:String?
    
    init(dic:NSDictionary) {
        super.init()
        self.idstr = dic["idstr"] as? String
        self.name = dic["name"] as? String
        self.profile_image_url = dic["profile_image_url"] as? String
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