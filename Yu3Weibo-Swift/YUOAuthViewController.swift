//
//  YUOAuthViewController.swift
//  Yu3Weibo-Swift
//
//  Created by yu3 on 16/1/19.
//  Copyright © 2016年 yu3. All rights reserved.
//

import UIKit
import Alamofire

class YUOAuthViewController: UIViewController, UIWebViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        let webView = UIWebView()
        webView.frame = self.view.bounds
        webView.delegate = self
        self.view.addSubview(webView)
        let url =  NSURL(string: "https://api.weibo.com/oauth2/authorize?client_id=1421524559&response_type=code&redirect_uri=http://www.cnblogs.com/yu3-/")!
        webView.loadRequest(NSURLRequest(URL: url))
    }

    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        let urlStr = request.URL?.absoluteString
        let range = urlStr?.rangeOfString("code=")
        if range?.count > 0 {
            let code = urlStr?.substringFromIndex((range?.endIndex)!)
            self.accessTokenWithCode(code!)
        }
        return true
    }
    
    func accessTokenWithCode(code:String) {
        let params = [
            "client_id":"1421524559",
            "client_secret" : "997bdcb2d1eafc1c9890f64acdd9844d",
            "code" : "\(code)",
            "grant_type" : "authorization_code",
            "redirect_uri" : "http://www.cnblogs.com/yu3-/"
        ]
        Alamofire.request(.POST, "https://api.weibo.com/oauth2/access_token", parameters: params, encoding: .URL, headers: nil).responseJSON { (response) -> Void in
            let result = response.result
            if result.error != nil {
                print(result.error)
            } else {
                // 字典转模型
                let dict = result.value as! Dictionary<String, AnyObject>
                let account = YUAccount(dic: dict)
                // 存储模型数据
                YUAccountTool.saveAccount(account)
                //后续页面: 新特性 or 首页?
                YUWeiboTool.chooseRootController()
            }
        }
    }
}