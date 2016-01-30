//
//  YUComposeViewController.swift
//  Yu3Weibo-Swift
//
//  Created by yu3 on 16/1/29.
//  Copyright © 2016年 yu3. All rights reserved.
//

import UIKit

class YUComposeViewController: UIViewController, UITextViewDelegate, YUComposeToolbarDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    var textView = YUTextView()
    var toolbar = YUComposeToolbar()
    var photosView = YUComposePhotosView()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if textView.text.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 0 {
            //如果把下面这一句写在ViewDidLoad中，disabled的item颜色没有效果
            self.navigationItem.rightBarButtonItem?.enabled = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setNavBar()
        self.setTextView()
        self.setPhotos()
        self.setToolBar()
    }
    
    func setToolBar() {
        toolbar.delegate = self
        let toolbarH:CGFloat = 44
        let toolbarW = self.view.frame.size.width;
        let toolbarX:CGFloat = 0;
        let toolbarY = self.view.frame.size.height - toolbarH;
        toolbar.frame = CGRectMake(toolbarX, toolbarY, toolbarW, toolbarH);
        self.view.addSubview(toolbar)
    }
    
    func composeToolbar(toolbar: YUComposeToolbar, didClickedButton: YUComposeToolbarButtonType) {
        switch(didClickedButton) {
            case .Camera:
                let ipc = UIImagePickerController()
                ipc.sourceType = .Camera
                ipc.delegate = self
                self.presentViewController(ipc, animated: true, completion: nil)
            case .Picture:
                let ipc = UIImagePickerController()
                ipc.sourceType = .PhotoLibrary
                ipc.delegate = self
                self.presentViewController(ipc, animated: true, completion: nil)
            default: break
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        self.dismissViewControllerAnimated(true, completion: nil)
        self.photosView.addImage(image)
    }
    
    func setPhotos() {
        let photosW = self.textView.frame.size.width
        let photosH = self.textView.frame.size.height
        let photosY = CGFloat(80)
        photosView.frame = CGRectMake(0, photosY, photosW, photosH);
        self.textView.addSubview(photosView)
    }

    func setTextView() {
        textView.font = UIFont.systemFontOfSize(15)
        textView.frame = self.view.bounds
        textView.placeholder = "分享新鲜事..."
        self.view.addSubview(textView)
        textView.becomeFirstResponder()
        
        // 监听textView文字改变的通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("textDidChange"), name: UITextViewTextDidChangeNotification, object: textView)
        
        // 监听键盘的通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    /**
    *  键盘即将显示的时候调用
    */
    func keyboardWillShow(note:NSNotification) {
        // 1.取出键盘的frame
        let keyboardF = note.userInfo![UIKeyboardFrameEndUserInfoKey]!.CGRectValue
        
        // 2.取出键盘弹出的时间
        let duration = note.userInfo![UIKeyboardAnimationDurationUserInfoKey]!.doubleValue
    
        // 3.执行动画
        UIView.animateWithDuration(duration) { () -> Void in
            self.toolbar.transform = CGAffineTransformMakeTranslation(0, -keyboardF.size.height)
        }
    }
    
    /**
    *  键盘即将退出的时候调用
    */
    func keyboardWillHide(note:NSNotification) {
        let duration = note.userInfo![UIKeyboardAnimationDurationUserInfoKey]!.doubleValue
        UIView.animateWithDuration(duration) { () -> Void in
            self.toolbar.transform = CGAffineTransformIdentity
        }
    }
   
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.view.endEditing(true)
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
        //self.navigationItem.rightBarButtonItem!.enabled = false //ViewDidLoad中，disabled的item颜色没有效果
        self.title = "发微博"
    }
    
    func cancel() {
        self .dismissViewControllerAnimated(true, completion: nil)
    }
    
    func send() {
        if (self.photosView.totalImages().count != 0) { // 有图片
            self.sendWithImage()
        } else { // 没有图片
            self.sendWithoutImage()
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func sendWithImage() {
        let params = [
            "status": "\(textView.text)",
            "access_token" : "\(YUAccountTool.account()!.access_token!)"
        ]
        let urlStr = "https://upload.api.weibo.com/2/statuses/upload.json"
        // 封装文件参数
        var formDataArray = [YUFormData]()
        let images = self.photosView.totalImages()
        for image in images {
            var formData = YUFormData()
            formData.data = UIImageJPEGRepresentation(image, 0.5)!;
            formData.name = "pic"
            formData.mimeType = "image/jpeg"
            formDataArray.append(formData)
        }
        
        YUHttpTool.uploadWithPOST(urlStr, params: params, formDataArray: formDataArray) { (response) -> Void in
            let result = response.result
            if result.error != nil {
                print("请求失败：\(result.error)")
                MBProgressHUD.showError("发送失败")
            } else {
                print("上传成功：\(result.value)")
                MBProgressHUD.showSuccess("发送成功")
            }
        }
    }
    
    func sendWithoutImage() {
        let params = [
            "status": "\(textView.text)",
            "access_token" : "\(YUAccountTool.account()!.access_token!)"
        ]
        let urlStr = "https://api.weibo.com/2/statuses/update.json"
        YUHttpTool.postWithURL(urlStr, params: params) { (response) -> Void in
            let result = response.result
            if result.error != nil {
                print("请求失败：\(result.error)")
                MBProgressHUD.showError("发送失败")
            } else {
                print("发送成功：\(result.value)")
                MBProgressHUD.showSuccess("发送成功")
            }
        }
    }
}
