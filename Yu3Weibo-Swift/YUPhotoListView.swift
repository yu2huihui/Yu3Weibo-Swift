//
//  YUPhotoListView.swift
//  Yu3Weibo-Swift
//
//  Created by yu3 on 16/1/24.
//  Copyright © 2016年 yu3. All rights reserved.
//

import UIKit

class YUPhotoListView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // 初始化9个子控件
        for i in 0 ..< 9 {
            let photoView = YUPhotoView(frame: CGRectZero)
            photoView.userInteractionEnabled = true
            photoView.tag = i
            photoView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector("photoTap:")))
            self.addSubview(photoView)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func photoTap(recognizer:UITapGestureRecognizer) {
        let count = self.photos.count
        // 1.封装图片数据
        var photoAry = [MJPhoto]()
        for i in 0 ..< count {
            let photo = MJPhoto()
            photo.srcImageView = self.subviews[i] as! UIImageView
            let yuphoto = self.photos[i]
            let photoURL = yuphoto.thumbnail_pic?.stringByReplacingOccurrencesOfString("thumbnail", withString: "bmiddle")
            photo.url = NSURL(string: photoURL!)
            photoAry.append(photo)
        }
        // 2.显示相册
        let browser = MJPhotoBrowser()
        browser.currentPhotoIndex = UInt(recognizer.view!.tag) // 弹出相册时显示的第一张图片是？
        browser.photos = photoAry // 设置所有的图片
        browser.show()
    }

    /**
    *  需要展示的图片
    */
    var photos = [YUPhoto]() {
        didSet {
            for i in 0 ..< self.subviews.count {
                // 取出i位置对应的imageView
                let photoView = self.subviews[i] as! YUPhotoView
                
                // 判断这个imageView是否需要显示数据
                if i < photos.count {
                    // 显示图片
                    photoView.hidden = false
                    // 传递模型数据
                    photoView.photo = photos[i]
                    
                    // 设置子控件的frame
                    let maxColumns = (photos.count == 4) ? 2 : 3;
                    let col = i % maxColumns;
                    let row = i / maxColumns;
                    let photoX = CGFloat(col) * (YUPhotoW + YUPhotoMargin);
                    let photoY = CGFloat(row) * (YUPhotoH + YUPhotoMargin);
                    photoView.frame = CGRectMake(photoX, photoY, YUPhotoW, YUPhotoH);
                    
                    // Aspect : 按照图片的原来宽高比进行缩
                    // UIViewContentModeScaleAspectFit : 按照图片的原来宽高比进行缩放(一定要看到整张图片)
                    // UIViewContentModeScaleAspectFill :  按照图片的原来宽高比进行缩放(只能图片最中间的内容)
                    // UIViewContentModeScaleToFill : 直接拉伸图片至填充整个imageView
                    if (photos.count == 1) {
                        photoView.contentMode = .ScaleAspectFit;
                        photoView.clipsToBounds = false
                    } else {
                        photoView.contentMode = .ScaleAspectFill;
                        photoView.clipsToBounds = true
                    }
                } else { // 隐藏imageView
                    photoView.hidden = true
                }
            }
        }
    }
    
    
    class func photosViewSizeWithPhotosCount(count:Int) -> CGSize {
        // 一行最多有3列
        let maxColumns = (count == 4) ? 2 : 3;
        //  总行数
        let rows = (count + maxColumns - 1) / maxColumns;
        // 高度
        let photosH = CGFloat(rows) * YUPhotoH + CGFloat(rows - 1) * YUPhotoMargin;
        // 总列数
        let cols = (count >= maxColumns) ? maxColumns : count;
        // 宽度
        let photosW = CGFloat(cols) * YUPhotoW + CGFloat(cols - 1) * YUPhotoMargin;
        return CGSizeMake(photosW, photosH);
    }
    
}
