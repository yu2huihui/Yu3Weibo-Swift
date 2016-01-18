//
//  YUNewFeatureController.swift
//  Yu3Weibo-Swift
//
//  Created by yu3 on 16/1/18.
//  Copyright © 2016年 yu3. All rights reserved.
//

import UIKit

class YUNewFeatureController: UIViewController, UIScrollViewDelegate {
    let NewfeatureImageCount = 3
    weak var pageControl:UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setScrollView()
        self.setPageControl()
    }

    func setScrollView() {
        let scrollView = UIScrollView()
        scrollView.frame = self.view.bounds
        scrollView.delegate = self;
        self.view.addSubview(scrollView)
        // 添加图片
        let imageW = scrollView.frame.size.width
        let imageH = scrollView.frame.size.height
        for i in 0 ..< NewfeatureImageCount {
            let imageView = UIImageView()
            imageView.image = UIImage.imageWithName("new_feature_\(i + 1)")
            let imageX = CGFloat(i) * imageW
            imageView.frame = CGRectMake(imageX, 0, imageW, imageH)
            scrollView.addSubview(imageView)
            if i == NewfeatureImageCount - 1 {
                self.setLastImageView(imageView)
            }
        }
        scrollView.contentSize = CGSizeMake(CGFloat(NewfeatureImageCount) * imageW, 0)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        scrollView.pagingEnabled = true
    }
    
    func setLastImageView(imageView:UIImageView) {
        imageView.userInteractionEnabled = true
        let startButton = UIButton()
        startButton.setBackgroundImage(UIImage.imageWithName("new_feature_finish_button"), forState: .Normal)
        startButton.setBackgroundImage(UIImage.imageWithName("new_feature_finish_button_highlighted"), forState: .Highlighted)
        let centerX = imageView.frame.size.width * 0.5
        let centerY = imageView.frame.size.height * 0.6
        startButton.center = CGPointMake(centerX, centerY)
        startButton.bounds = CGRectMake(0, 0, (startButton.currentBackgroundImage?.size.width)!, (startButton.currentBackgroundImage?.size.height)!)
        startButton.setTitle("开始微博", forState:.Normal)
        startButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        startButton.addTarget(self, action: Selector("start"), forControlEvents: .TouchUpInside)
        imageView.addSubview(startButton)
        
        // checkbox
        let checkbox = UIButton()
        checkbox.selected = true
        checkbox.setTitle("分享给大家", forState: .Normal)
        checkbox.setImage(UIImage.imageWithName("new_feature_share_false"), forState: .Normal)
        checkbox.setImage(UIImage.imageWithName("new_feature_share_true"), forState: .Selected)
        checkbox.bounds = CGRectMake(0, 0, 200, 50)
        let checkboxCenterX = centerX
        let checkboxCenterY = imageView.frame.size.height * 0.5
        checkbox.center = CGPointMake(checkboxCenterX, checkboxCenterY)
        checkbox.setTitleColor(UIColor.blackColor(), forState: .Normal)
        checkbox.titleLabel!.font = UIFont.systemFontOfSize(15)
        checkbox.addTarget(self, action: Selector("checkboxClick:"), forControlEvents: .TouchUpInside)
        //    checkbox.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0)
        checkbox.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10)
        //    checkbox.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10)
        imageView.addSubview(checkbox)
    }
    
    func checkboxClick(checkbox:UIButton) {
        checkbox.selected = !checkbox.selected;
    }
    
    func start() {
        // 显示状态栏
        UIApplication.sharedApplication().statusBarHidden = false
        // 切换窗口的根控制器
        self.view.window?.rootViewController = YUTabBarViewController()
    }
    
    func setPageControl() {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = NewfeatureImageCount
        let centerX = self.view.frame.size.width * 0.5
        let centerY = self.view.frame.size.height - 30
        pageControl.center = CGPointMake(centerX, centerY)
        pageControl.bounds = CGRectMake(0, 0, 100, 30)
        pageControl.userInteractionEnabled = false
        self.view.addSubview(pageControl)
        self.pageControl = pageControl
        
        pageControl.currentPageIndicatorTintColor = UIColor(red: 253/255, green: 98/255, blue: 42/255, alpha: 1)
        pageControl.pageIndicatorTintColor = UIColor(red: 189/255, green: 189/255, blue: 189/255, alpha: 1)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        let pageDouble = offsetX / scrollView.frame.size.width
        let page = (Int)(pageDouble + 0.5)
        self.pageControl.currentPage = page
    }
}
