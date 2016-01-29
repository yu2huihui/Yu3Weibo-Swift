//
//  YUPhotoView.swift
//  Yu3Weibo-Swift
//
//  Created by yu3 on 16/1/29.
//  Copyright © 2016年 yu3. All rights reserved.
//

import UIKit

class YUPhotoView: UIImageView {
    var photo:YUPhoto? {
        didSet {
            // 控制gifView的可见性
            self.gifView.hidden = ((photo?.thumbnail_pic?.hasSuffix("gif")) == false)
            // 下载图片
            self.kf_setImageWithURL(NSURL(string: photo!.thumbnail_pic!)!, placeholderImage: UIImage.imageWithName("timeline_image_placeholder"))
        }
    }
    var gifView = UIImageView(image: UIImage.imageWithName("timeline_image_gif"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(gifView)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        gifView.layer.anchorPoint = CGPointMake(1, 1)
        gifView.layer.position = CGPointMake(self.frame.size.width, self.frame.size.height)
    }
}
