//
//  YUComposePhotosView.swift
//  Yu3Weibo-Swift
//
//  Created by yu3 on 16/1/30.
//  Copyright © 2016年 yu3. All rights reserved.
//

import UIKit

class YUComposePhotosView: UIView {
    
    func addImage(image:UIImage) {
        self.addSubview(UIImageView(image: image))
    }
    
    func totalImages() -> [UIImage] {
        var result = [UIImage]()
        for view in self.subviews {
            let imageView = view as! UIImageView
            result.append(imageView.image!)
        }
        return result
    }
    
    override func layoutSubviews() {
        let count = self.subviews.count
        let imageViewW = CGFloat(70)
        let imageViewH = imageViewW
        let maxColumns = 4 // 一行最多显示4张图片
        let margin = (self.frame.size.width - CGFloat(maxColumns) * imageViewW) / CGFloat(maxColumns + 1);
        for i in 0 ..< count {
            let imageView = self.subviews[i] as! UIImageView
            let imageViewX = margin + CGFloat(i % maxColumns) * (imageViewW + margin)
            let imageViewY = CGFloat(i / maxColumns) * (imageViewH + margin)
            imageView.frame = CGRectMake(imageViewX, imageViewY, imageViewW, imageViewH)
        }
    }
   
}