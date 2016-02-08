//
//  YUOAuthViewController.swift
//  Yu3Weibo-Swift
//
//  Created by yu3 on 16/1/19.
//  Copyright © 2016年 yu3. All rights reserved.
//

import UIKit

class YUOAuthViewController: UIViewController, UIWebViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        let webView = UIWebView()
        webView.frame = self.view.bounds
        webView.delegate = self
        self.view.addSubview(webView)
        let url =  NSURL(string: LoginURLStr)!
        webView.loadRequest(NSURLRequest(URL: url))
    }

    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        let urlStr = request.URL?.absoluteString
        let range = urlStr?.rangeOfString("code=")
        if range?.count > 0 {
            let code = urlStr?.substringFromIndex((range?.endIndex)!)
            self.accessTokenWithCode(code!)
            return false
        }
        return true
    }
    
    func accessTokenWithCode(code:String) {
        let params = [
            "client_id":AppKey,
            "client_secret" : AppSecret,
            "code" : "\(code)",
            "grant_type" : "authorization_code",
            "redirect_uri" : RedirectURI
        ]
        YUAccountTool.accessTokenWithParams(params) { (account, error) -> Void in
            if error != nil {
                print("请求失败：\(error)")
            } else {
                // 存储模型数据
                YUAccountTool.saveAccount(account!)
                //后续页面: 新特性 or 首页?
                YUWeiboTool.chooseRootController()
            }
        }
    }
}