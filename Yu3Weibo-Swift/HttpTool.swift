//
//  Tool.swift
//  Yu3Weibo-Swift
//
//  Created by yu3 on 16/1/19.
//  Copyright © 2016年 yu3. All rights reserved.
//

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

/** 用来发送网络请求的工具 */
struct YUHttpTool {
    /** 发送一条post请求并上传文件 */
    static func uploadWithPOST(urlStr:String, params:[String : String], formDataArray:[YUFormData], completionHandler: Response<AnyObject, NSError> -> Void) {
        Alamofire.upload(.POST, urlStr, multipartFormData: { (multipartFormData) -> Void in
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

