//
//  ServiceTool.swift
//  Yu3Weibo-Swift
//
//  Created by yu3 on 16/2/1.
//  Copyright © 2016年 yu3. All rights reserved.
//

import Foundation

class BaseParam {
    /**
     *  采用OAuth授权方式为必填参数，其他授权方式不需要此参数，OAuth授权后获得
     */
    var access_token:String {
        return YUAccountTool.account()!.access_token! as String
    }
}

class UserInfoParam : BaseParam {
    /**
    *  需要查询的用户ID。
    */
    var uid:Int = 0
    
    /**
    *  需要查询的用户昵称。
    */
    var screen_name:String = ""
}

struct YUUserInfoTool {
    static func userInfoWithParam(param:UserInfoParam, completionHandler: (YUUser?, NSError?) -> Void) {
        var params = ["access_token": param.access_token] as Dictionary<String,AnyObject>
        if param.screen_name == "" {
            params["uid"] = param.uid
        } else {
            params["screen_name"] = param.screen_name
        }
        YUHttpTool.getWithURL("https://api.weibo.com/2/users/show.json", params: params) { (response) -> Void in
            if response.result.error != nil {
                completionHandler(nil, response.result.error)
            } else {
                let userDic = response.result.value as! NSDictionary
                let user = YUUser(dic: userDic)
                completionHandler(user, nil)
            }
        }
    }
}

class HomeStatusesParam : BaseParam {
    /**
    *  若指定此参数，则返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0。
    */
    var since_id:Int = 0
    
    /**
    *  若指定此参数，则返回ID小于或等于max_id的微博，默认为0。
    */
    var max_id:Int = 0
    
    /**
    *  单页返回的记录条数，最大不超过100，默认为20。
    */
    var count:Int = 20
}

class SendStatusParam : BaseParam {
    /** 要发布的微博文本内容，必须做URLencode，内容不超过140个汉字。 */
    var status = ""
    /** 要发送的图片 */
    var pictures = [UIImage]()
}

struct YUStatusTool {
    /** 发送一条微博 */
    static func sendStatusWithParam(param: SendStatusParam, completionHandler: (YUStatus?, NSError?) -> Void) {
        var params = ["access_token": param.access_token] as Dictionary<String,String>
        params["status"] = param.status
        if param.pictures.count > 0 {
            // 封装文件参数
            var formDataArray = [YUFormData]()
            for image in param.pictures {
                var formData = YUFormData()
                formData.data = UIImageJPEGRepresentation(image, 0.5)!;
                formData.name = "pic"
                formData.mimeType = "image/jpeg"
                formDataArray.append(formData)
            }
            // 发送请求并上传图片
            YUHttpTool.uploadWithPOST("https://upload.api.weibo.com/2/statuses/upload.json", params: params, formDataArray: formDataArray) { (response) -> Void in
                if response.result.error != nil {
                    completionHandler(nil, response.result.error)
                } else {
                    let statusDic = response.result.value as! NSDictionary
                    let status = YUStatus(dic: statusDic)
                    completionHandler(status, nil)
                }
            }
        } else {
            // 发送请求
            YUHttpTool.postWithURL("https://api.weibo.com/2/statuses/update.json", params: params, completionHandler: { (response) -> Void in
                if response.result.error != nil {
                    completionHandler(nil, response.result.error)
                } else {
                    let statusDic = response.result.value as! NSDictionary
                    let status = YUStatus(dic: statusDic)
                    completionHandler(status, nil)
                }
            })
        }
    }
    
    
    /** 获取首页微博信息 */
    static func homeStatusesWithParam(param: HomeStatusesParam, completionHandler: ([YUStatus]?, NSError?) -> Void) {
        var params = ["access_token": param.access_token] as Dictionary<String,AnyObject>
        params["count"] = param.count
        params["since_id"] = param.since_id
        params["max_id"] = param.max_id
        
        YUHttpTool.getWithURL("https://api.weibo.com/2/statuses/home_timeline.json", params: params) { (response) -> Void in
            if response.result.error != nil {
                completionHandler(nil, response.result.error)
            } else {
                let status = response.result.value as? NSDictionary
                let statusAry = status!["statuses"] as? NSArray
                var statuses = [YUStatus]()
                for statusDic in statusAry! {
                    //将字典封装成模型
                    let status = YUStatus(dic: statusDic as! NSDictionary)
                    statuses.append(status)
                }
                completionHandler(statuses, nil)
            }
        }
    }
}

struct YUWeiboTool {
    static func chooseRootController() {
        let application = UIApplication.sharedApplication()
        let key = "CFBundleVersion"
        let defaults = NSUserDefaults.standardUserDefaults()
        let lastVersion = defaults.valueForKey(key)
        //获得当前版本号
        let currentVersion = NSBundle.mainBundle().infoDictionary![key]
        if ((currentVersion?.isEqual(lastVersion)) == true) {
            application.statusBarHidden = false
            application.keyWindow!.rootViewController = YUTabBarViewController()
        } else {
            application.keyWindow!.rootViewController = YUNewFeatureController()
            defaults.setObject(currentVersion, forKey: key)
            defaults.synchronize()
        }
        
    }
}

struct YUAccountTool {
    static let accountFile = (NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).last! as NSString).stringByAppendingPathComponent("account.data")
    
    static func saveAccount(account:YUAccount) -> Void {
        // 计算账号过期时间
        let now = NSDate()
        account.expiresTime = now.dateByAddingTimeInterval(NSTimeInterval(account.expires_in!))
        NSKeyedArchiver.archiveRootObject(account, toFile: accountFile)
    }
    
    static func account() -> YUAccount? {
        let account = NSKeyedUnarchiver.unarchiveObjectWithFile(accountFile) as? YUAccount
        let now = NSDate()
        if account?.expiresTime != nil {
            if (now.compare(account!.expiresTime!)) == NSComparisonResult.OrderedAscending { // 还没有过期
                return account
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
}