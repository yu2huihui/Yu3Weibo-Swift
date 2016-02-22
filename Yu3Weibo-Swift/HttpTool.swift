//
//  Tool.swift
//  Yu3Weibo-Swift
//
//  Created by yu3 on 16/1/19.
//  Copyright © 2016年 yu3. All rights reserved.
//

import Alamofire
import AlamofireObjectMapper

//MARK: 用来封装文件数据的模型
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

//MARK: 用来发送网络请求的工具
struct YUHttpTool {
    //MARK:发送一条post请求并上传文件
    static func uploadWithPOST(urlStr:String, params:[String : String], formDataArray:[YUFormData], completionHandler: (AnyObject?, NSError?) -> Void) {
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
                            completionHandler(response.result.value, response.result.error)
                        }
                    case .Failure(let encodingError):
                        print("上传失败")
                        print(encodingError)
                        completionHandler(nil, NSError(domain: "上传失败", code: 1, userInfo: ["上传失败" : String(encodingError)]))
                }
        }
    }
    
    //MARK: 发送一条post请求--Response<AnyObject, NSError>
    static func postWithURL(urlStr:String, params:[String : AnyObject], completionHandler: Response<AnyObject, NSError> -> Void) {
        Alamofire.request(.POST, urlStr, parameters: params, encoding: .URL, headers: nil).responseJSON { (response) -> Void in
            completionHandler(response)
        }
    }
    
    //MARK: 发送一条get请求--Response<AnyObject, NSError>
    static func getWithURL(urlStr:String, params:[String : AnyObject], completionHandler: Response<AnyObject, NSError> -> Void) {
        Alamofire.request(.GET, urlStr, parameters: params, encoding: .URL, headers: nil).responseJSON { (response) -> Void in
            completionHandler(response)
        }
    }
    
    //MARK:发送一条post请求发带图片的微博--Response<YUStatus, NSError>
    static func postImageStatusWithURL(urlStr:String, params:[String : String], formDataArray:[YUFormData], completionHandler: (YUStatus?, NSError?) -> Void) {
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
                        upload.responseObject(completionHandler: { (response : Response<YUStatus, NSError>) -> Void in
                            completionHandler(response.result.value, response.result.error)
                        })
                    case .Failure(let encodingError):
                        print("上传失败")
                        print(encodingError)
                        completionHandler(nil, NSError(domain: "上传失败", code: 1, userInfo: ["上传失败" : String(encodingError)]))
                }
        }
    }

    //MARK: 发送一条post请求发一条微博--Response<YUStatus, NSError>
    static func postStatusWithURL(urlStr:String, params:[String : AnyObject], completionHandler: Response<YUStatus, NSError> -> Void) {
        Alamofire.request(.POST, urlStr, parameters: params, encoding: .URL, headers: nil).responseObject { (response: Response<YUStatus, NSError>) -> Void in
            completionHandler(response)
        }
    }
    
    //MARK: 发送一条get请求直接获取微博对象数组--Response<[YUStatus], NSError>
    static func getStatusesWithURL(urlStr:String, params:[String : AnyObject], completionHandler: Response<[YUStatus], NSError> -> Void) {
        Alamofire.request(.GET, urlStr, parameters: params, encoding: .URL, headers: nil).responseArray("statuses") { (response: Response<[YUStatus], NSError>) -> Void in
            completionHandler(response)
        }
    }
}

