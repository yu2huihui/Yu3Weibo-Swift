//
//  YUPhotoListView.swift
//  Yu3Weibo-Swift
//
//  Created by yu3 on 16/1/24.
//  Copyright © 2016年 yu3. All rights reserved.
//

import UIKit

class YUPhotoListView: UIView, YUPhotoBrowserDelegate {
    /**
    *  需要展示的图片
    */
    var photos = [YUPhoto]() {
        didSet {
            for view in self.subviews {
                view.removeFromSuperview()
            }
            for idx in 0 ..< photos.count {
                let btn = UIButton()
                let photo = photos[idx]
                btn.kf_setBackgroundImageWithURL(NSURL(string: photo.thumbnail_pic!)!, forState: .Normal)
                btn.tag = idx
                btn.addTarget(self, action: Selector("buttonClick:"), forControlEvents: .TouchUpInside)
                self.addSubview(btn)
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let count = self.photos.count
        // 一行最多有3列
        let maxColumns = (count == 4) ? 2 : 3
        // 总列数
        let cols = (count >= maxColumns) ? maxColumns : count
        let w = YUOnlyPhotoW
        let h = YUOnlyPhotoH
        var x = YUPhotoMargin
        var y:CGFloat = 0
        
        for idx in 0 ..< self.subviews.count {
            let btn = self.subviews[idx]
            if cols == 1 {
                btn.frame = CGRectMake(x, y, w, h)
            } else {
                let rowIndex:Int = idx / maxColumns
                let columnIndex:Int = idx % maxColumns
                x = CGFloat(columnIndex) * (YUPhotoW + YUPhotoMargin)
                y = CGFloat(rowIndex) * (YUPhotoH + YUPhotoMargin)
                btn.frame = CGRectMake(x, y, YUPhotoW, YUPhotoH)
            }
        }
    }
    
    func buttonClick(btn:UIButton) {
        let browser = YUPhotoBrowser()
        browser.sourceImagesContainerView = self // 原图的父控件
        browser.imageCount = self.photos.count // 图片总数
        browser.currentImageIndex = btn.tag
        browser.delegate = self
        browser.show()
    }
    class func photosViewSizeWithPhotosCount(count:Int) -> CGSize {
        // 一行最多有3列
        let maxColumns = (count == 4) ? 2 : 3
        // 总列数
        let cols = (count >= maxColumns) ? maxColumns : count;
        if (cols == 1) {
            return CGSizeMake(YUOnlyPhotoW, YUOnlyPhotoH)
        } else {
            //  总行数
            let rows:Int = (count + maxColumns - 1) / maxColumns
            // 高度
            let photosH = CGFloat(rows) * YUPhotoH + (CGFloat(rows) - 1) * YUPhotoMargin
            // 宽度
            let photosW = CGFloat(cols) * YUPhotoW + (CGFloat(cols) - 1) * YUPhotoMargin;
            return CGSizeMake(photosW, photosH)
        }
    }
    
    func photoBrowser(browser: YUPhotoBrowser, index: Int) -> UIImage? {
        let btn = self.subviews[index] as! UIButton
        return btn.currentBackgroundImage
    }
    
    func photoBrowserHighQualityImage(browser: YUPhotoBrowser, index: Int) -> String? {
        //print(index)
        //print(self.photos[index].thumbnail_pic!.stringByReplacingOccurrencesOfString("thumbnail", withString: "bmiddle"))
        return self.photos[index].thumbnail_pic?.stringByReplacingOccurrencesOfString("thumbnail", withString: "bmiddle")
    }
}
