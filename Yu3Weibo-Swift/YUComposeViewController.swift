//
//  YUComposeViewController.swift
//  Yu3Weibo-Swift
//
//  Created by yu3 on 16/1/29.
//  Copyright © 2016年 yu3. All rights reserved.
//

import UIKit
import Alamofire

class YUComposeViewController: UIViewController {
    private var textView = YUTextView()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //如果把下面这一句写在ViewDidLoad中，disabled的item颜色没有效果
        self.navigationItem.rightBarButtonItem?.enabled = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setNavBar()
        self.setTextView()
    }

    func setTextView() {
        textView.font = UIFont.systemFontOfSize(15)
        textView.frame = self.view.bounds
        textView.placeholder = "分享新鲜事..."
        self.view.addSubview(textView)
        textView.becomeFirstResponder()
        
        // 监听textView文字改变的通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("textDidChange"), name: UITextViewTextDidChangeNotification, object: textView)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func textDidChange() {
        self.navigationItem.rightBarButtonItem?.enabled = (self.textView.text.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) != 0);
    }
    
    func setNavBar() {
        self.view.backgroundColor = UIColor.whiteColor()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: .Done, target: self, action: Selector("cancel"))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发送", style: .Done, target: self, action: Selector("send"))
        //self.navigationItem.rightBarButtonItem.enabled = false //ViewDidLoad中，disabled的item颜色没有效果
        self.title = "发微博"
    }
    
    func cancel() {
        self .dismissViewControllerAnimated(true, completion: nil)
        MBProgressHUD.showMessage("取消")
    }
    
    func send() {
        let params = [
            "status": "\(textView.text)",
            "access_token" : "\(YUAccountTool.account()!.access_token!)"
        ]
        let urlStr = "https://api.weibo.com/2/statuses/update.json"
        Alamofire.request(.POST, urlStr, parameters: params, encoding: .URL, headers: nil).responseJSON { (response) -> Void in
            let result = response.result
            if result.error != nil {
                print("请求失败：\(result.error)")
                MBProgressHUD.showError("发送失败")
            } else {
                print("发送成功：\(result.value)")
                MBProgressHUD.showSuccess("发送成功")
            }
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
