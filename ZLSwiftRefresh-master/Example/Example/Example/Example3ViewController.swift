//
//  Example3ViewController.swift
//  ZLSwiftRefresh
//
//  Created by 张磊 on 15-3-12.
//  Copyright (c) 2015年 com.zixue101.www. All rights reserved.
//

import UIKit
import ZLSwiftRefresh

class Example3ViewController: UIViewController,UIWebViewDelegate {

    var webView:UIWebView = UIWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        
        self.view.backgroundColor = UIColor.whiteColor()
        self.webView.backgroundColor = UIColor.whiteColor()
        
        // 立马进去就刷新
        self.webView.scrollView.nowRefresh({
            if self.webView.loading == false{
                self.webView.reload()
            }
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupUI(){
        let webView = UIWebView(frame: self.view.frame)
        webView.delegate = self
        self.view.addSubview(webView)
        webView.loadRequest(NSURLRequest(URL: NSURL(string: "http://weibo.com/makezl")!, cachePolicy: .ReturnCacheDataElseLoad, timeoutInterval: 10))
        self.webView = webView
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        // stop Refresh
        self.webView.scrollView.doneRefresh()
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        print("网络有问题..")
        self.webView.scrollView.doneRefresh()
    }
    
}
