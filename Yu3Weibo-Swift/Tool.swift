//
//  Tool.swift
//  Yu3Weibo-Swift
//
//  Created by yu3 on 16/1/19.
//  Copyright © 2016年 yu3. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

/** 用来封装文件数据的模型 */
struct YUFormData {
    /** 文件数据 */
    var data = NSData()
    /** 参数名 */
    var name = ""
    /** 文件名 */
    var fileName = ""
    /** 文件类型 */
    var mimeType = ""
}

/** 用来发送网路请求的工具 */
struct YUHttpTool {
    /** 发送一条post请求并上传文件 */
    static func uploadWithPOST(urlStr:String, params:[String : String], formDataArray:[YUFormData], completionHandler: Response<AnyObject, NSError> -> Void) {
        Alamofire.upload(.POST, urlStr, headers: params, multipartFormData: { (multipartFormData) -> Void in
            let access_token = params["access_token"]!
            multipartFormData.appendBodyPart(data: access_token.dataUsingEncoding(NSUTF8StringEncoding)!, name: "access_token")
            let status = params["status"]!
            multipartFormData.appendBodyPart(data: status.dataUsingEncoding(NSUTF8StringEncoding)!, name: "status")
            for formData in formDataArray {
                multipartFormData.appendBodyPart(data: formData.data, name: formData.name, fileName: formData.fileName, mimeType: formData.mimeType)
            }
            }, encodingMemoryThreshold: Manager.MultipartFormDataEncodingMemoryThreshold) { (encodingResult) -> Void in
                switch encodingResult {
                case .Success(let upload, _, _):
                    upload.responseJSON { response in
                        completionHandler(response)
                    }
                case .Failure(let encodingError):
                    print("上传失败")
                    print(encodingError)
                }
        }
    }
    /** 发送一条post请求 */
    static func postWithURL(urlStr:String, params:[String : AnyObject], completionHandler: Response<AnyObject, NSError> -> Void) {
        Alamofire.request(.POST, urlStr, parameters: params, encoding: .URL, headers: nil).responseJSON { (response) -> Void in
            completionHandler(response)
        }
    }
    /** 发送一条get请求 */
    static func getWithURL(urlStr:String, params:[String : AnyObject], completionHandler: Response<AnyObject, NSError> -> Void) {
        Alamofire.request(.GET, urlStr, parameters: params, encoding: .URL, headers: nil).responseJSON { (response) -> Void in
            completionHandler(response)
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