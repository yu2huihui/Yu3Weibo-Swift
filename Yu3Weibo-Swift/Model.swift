//
//  model.swift
//  Yu3Weibo-Swift
//
//  Created by yu3 on 16/1/19.
//  Copyright © 2016年 yu3. All rights reserved.
//

import Foundation

class YUAccount: NSObject, NSCoding {
    var access_token:NSString?
    var expiresTime:NSDate? // 账号的过期时间
    // 服务器返回的数字可能会很大, 用String比较好
    var expires_in:NSNumber?
    var remind_in:NSString?
    var uid:NSString?
    
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