//
//  YUBrowserImageView.swift
//  Yu3Weibo-Swift
//
//  Created by yu3 on 16/1/23.
//  Copyright © 2016年 yu3. All rights reserved.
//

import UIKit

let PhotoBrowserBackgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.95)
let WaitingViewProgressMode:SDWaitingViewMode = .PieDiagram

class YUBrowserImageView: UIImageView, UIGestureRecognizerDelegate {
    var progress:CGFloat = 0.05 {
        didSet {
            waitingView.progress = self.progress
        }
    }
    var isScaled:Bool {
        return  1.0 != totalScale
    }
    var hasLoadedImage:Bool = false
    
    private var waitingView = YUWaitingView()
    private var didCheckSize:Bool = false
    private var scroll:UIScrollView?
    private var scrollImageView = UIImageView()
    private var zoomingScroolView:UIScrollView?
    private var zoomingImageView:UIImageView?
    private var totalScale:CGFloat = 1.0
    convenience init() {
        self.init(frame:CGRectZero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        userInteractionEnabled = true
        contentMode = .ScaleAspectFit
        // 捏合手势缩放图片
        let pinch = UIPinchGestureRecognizer(target: self, action: Selector("zoomImage:"))
        pinch.delegate = self
        self.addGestureRecognizer(pinch)
        self.addSubview(waitingView)
    }

    override func layoutSubviews() {
            let imageSize = self.image?.size
        if imageSize != nil {
            if (self.bounds.size.width * (imageSize!.height / imageSize!.width) > self.bounds.size.height) {
                if scroll == nil {
                    let scrollView = UIScrollView()
                    scrollView.backgroundColor = UIColor.whiteColor()
                    let imageView = UIImageView()
                    imageView.image = self.image
                    scrollImageView = imageView
                    scrollView.backgroundColor = PhotoBrowserBackgroundColor
                    scroll = scrollView
                    self.addSubview(scrollView)
                    self.bringSubviewToFront(scrollView)
                    
                }
                scroll!.frame = self.bounds
                let imageViewH = self.bounds.size.width * (imageSize!.height / imageSize!.width)
                scrollImageView.bounds = CGRectMake(0, 0, scroll!.frame.size.width, imageViewH)
                scrollImageView.center = CGPointMake(scroll!.frame.size.width * 0.5, scrollImageView.frame.size.height * 0.5);
                scroll!.contentSize = CGSizeMake(0, scrollImageView.bounds.size.height)
                
            } else {
                if scroll != nil {
                    scroll!.removeFromSuperview() //防止旋转时适配的scrollView的影响
                }
            }
        }
    }
    
    func setImageWithURL(url:NSURL,placeholder:UIImage?) {
        waitingView.center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5)
        waitingView.bounds = CGRectMake(0, 0, 100, 100)
        waitingView.mode = .PieDiagram
        
       // weak var imageViewWeak = self
        self.kf_setImageWithURL(url, placeholderImage: placeholder, optionsInfo: .None, progressBlock: { (receivedSize, totalSize) -> () in
            self.progress = CGFloat(receivedSize / totalSize)
            }) { (image, error, cacheType, imageURL) -> () in
            self.waitingView.removeFromSuperview()
            if (error != nil) {
                let label = UILabel()
                label.bounds = CGRectMake(0, 0, 160, 30)
                label.center = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5)
                label.text = "图片加载失败"
                label.font = UIFont.systemFontOfSize(16)
                label.textColor = UIColor.whiteColor()
                label.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
                label.layer.cornerRadius = 5
                label.clipsToBounds = true
                label.textAlignment = .Center
                self.addSubview(label)
            } else {
                self.scrollImageView.image = image
                self.addSubview(self.scrollImageView)
                self.scrollImageView.setNeedsDisplay()
            }
        }

    }
    
    func zoomImage(recognizer:UIPinchGestureRecognizer) {
        self.prepareForImageViewScaling()
        let scale = recognizer.scale
        let temp = totalScale + (scale - 1);
        self.setupTotalScale(temp)
        recognizer.scale = 1.0
    }
    
    func setupTotalScale(newValue:CGFloat) {
        if ((totalScale < 0.5 && newValue < totalScale) || (totalScale > 2.0 && newValue > totalScale)) {return}
        // 最大缩放 2倍,最小0.5倍
        self.zoomWithScale(newValue)
    }
    
    func zoomWithScale(scale:CGFloat) {
        totalScale = scale
        zoomingImageView!.transform = CGAffineTransformMakeScale(scale, scale)
        if (scale > 1) {
            let contentW = zoomingImageView!.frame.size.width
            let contentH = max(zoomingImageView!.frame.size.height, self.frame.size.height);
            
            zoomingImageView!.center = CGPointMake(contentW * 0.5, contentH * 0.5)
            zoomingScroolView!.contentSize = CGSizeMake(contentW, contentH)
            
            var offset = zoomingScroolView!.contentOffset
            offset.x = (contentW - zoomingScroolView!.frame.size.width) * 0.5
            //        offset.y = (contentH - _zoomingImageView.frame.size.height) * 0.5;
            zoomingScroolView!.contentOffset = offset
            
        } else {
            zoomingScroolView!.contentSize = zoomingScroolView!.frame.size
            zoomingScroolView!.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
            zoomingImageView!.center = zoomingScroolView!.center
        }
    }
    
    func doubleTapToZommWithScale(scale:CGFloat) {
        self.prepareForImageViewScaling()
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.zoomWithScale(scale)
            }) { (finished) -> Void in
                if scale == 1 {
                    self.clear()
                }
        }
    }
    
    func prepareForImageViewScaling() {
        if zoomingScroolView == nil {
            zoomingScroolView = UIScrollView(frame: self.bounds)
            zoomingScroolView!.backgroundColor = PhotoBrowserBackgroundColor
            zoomingScroolView!.contentSize = self.bounds.size
            zoomingImageView = UIImageView(image: self.image)
            let imageSize = zoomingImageView!.image!.size
            var imageViewH = self.bounds.size.height
            if (imageSize.width > 0) {
                imageViewH = self.bounds.size.width * (imageSize.height / imageSize.width);
            }
            zoomingImageView!.bounds = CGRectMake(0, 0, self.bounds.size.width, imageViewH);
            zoomingImageView!.center = zoomingScroolView!.center;
            zoomingImageView!.contentMode = .ScaleAspectFit
            zoomingScroolView!.addSubview(zoomingImageView!)
            self.addSubview(zoomingScroolView!)
        }
    }
    
    func scaleImage(scale:CGFloat) {
        self.prepareForImageViewScaling()
        self.setupTotalScale(scale)
    }

    
    // 清除缩放
    func eliminateScale() {
        self.clear()
        totalScale = 1.0
    }
    
    func clear() {
        zoomingScroolView!.removeFromSuperview()
        zoomingScroolView = nil
        zoomingImageView = nil
    }

    
}
