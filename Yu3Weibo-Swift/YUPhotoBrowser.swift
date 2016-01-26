//
//  YUPhotoBrowser.swift
//  Yu3Weibo-Swift
//
//  Created by yu3 on 16/1/23.
//  Copyright © 2016年 yu3. All rights reserved.
//

import UIKit
import Kingfisher

let PhotoBrowserImageViewMargin:CGFloat = 10
@objc protocol YUPhotoBrowserDelegate : NSObjectProtocol {

func photoBrowser(browser:YUPhotoBrowser, index:Int) -> UIImage?

optional func photoBrowserHighQualityImage(browser:YUPhotoBrowser, index:Int) -> String?
}

class YUPhotoBrowser: UIView, UIScrollViewDelegate {
    weak var sourceImagesContainerView:UIView?
    var currentImageIndex:Int = 0
    var imageCount:Int = 0
    weak var delegate:YUPhotoBrowserDelegate?
    
    private var scrollView = UIScrollView()
    private var hasShowedFistView:Bool = false
    private var indexLabel = UILabel()
    private var saveButton = UIButton()
    private var indicatorView = UIActivityIndicatorView()
    private var willDisappear:Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = PhotoBrowserBackgroundColor
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    deinit {
        UIApplication.sharedApplication().keyWindow!.removeObserver(self, forKeyPath: "frame")
    }
    
    override func didMoveToSuperview() {
        self.setupScrollView()
        self.setupToolbars()
    }
    
    func setupToolbars() {
        indexLabel.bounds = CGRectMake(0, 0, 80, 30)
        indexLabel.textAlignment = .Center
        indexLabel.textColor = UIColor.whiteColor()
        indexLabel.font = UIFont.boldSystemFontOfSize(20)
        indexLabel.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
        indexLabel.layer.cornerRadius = indexLabel.bounds.size.height * 0.5
        indexLabel.clipsToBounds = true
        if self.imageCount > 1 {
            indexLabel.text = "1/\(imageCount)"
        }
        self.addSubview(indexLabel)
        
        saveButton.setTitle("保存", forState: .Normal)
        saveButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        saveButton.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.9)
        saveButton.layer.cornerRadius = 5
        saveButton.clipsToBounds = true
        saveButton.addTarget(self, action: Selector("saveImage"), forControlEvents: .TouchUpInside)
        self.addSubview(saveButton)
    }
    
    func saveImage() {
        let index = Int(scrollView.contentOffset.x / scrollView.bounds.size.width)
        let currentImageView = scrollView.subviews[index] as! UIImageView
        UIImageWriteToSavedPhotosAlbum(currentImageView.image!, self, Selector("image:didFinishSavingWithError:contextInfo:"), nil)
        indicatorView.activityIndicatorViewStyle = .WhiteLarge
        indicatorView.center = self.center
        UIApplication.sharedApplication().keyWindow?.addSubview(indicatorView)
        indicatorView.startAnimating()
    }
    
    func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: AnyObject) {
        indicatorView.removeFromSuperview()
        let label = UILabel()
        label.textColor = UIColor.whiteColor()
        label.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.9)
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        label.bounds = CGRectMake(0, 0, 150, 30)
        label.center = self.center
        label.textAlignment = .Center
        label.font = UIFont.boldSystemFontOfSize(17)
        UIApplication.sharedApplication().keyWindow?.addSubview(label)
        UIApplication.sharedApplication().keyWindow?.bringSubviewToFront(label)
        if error == nil {
            label.text = "保存成功"
        } else {
            label.text = "保存失败"
        }
        label.performSelector(Selector("removeFromSuperview"), withObject: nil, afterDelay: 1)
    }
   
    func setupScrollView() {
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.pagingEnabled = true
        self.addSubview(scrollView)
        
        for i in 0 ..< imageCount {
            let imageView = YUBrowserImageView()
            imageView.userInteractionEnabled = true
            imageView.tag = i
            let singleTap = UITapGestureRecognizer(target: self, action: Selector("photoClick:"))
            let doubleTap = UITapGestureRecognizer(target: self, action: Selector("photoDoubleClick:"))
            doubleTap.numberOfTapsRequired = 2
            self.addGestureRecognizer(doubleTap)
            singleTap.requireGestureRecognizerToFail(doubleTap)
            imageView.addGestureRecognizer(singleTap)
            imageView.addGestureRecognizer(doubleTap)
            scrollView.addSubview(imageView)
        }
        self.setupImageOfImageViewForIndex(currentImageIndex)
    }
    // 加载图片
    func setupImageOfImageViewForIndex(index:Int) {
        let imageView = scrollView.subviews[index] as? YUBrowserImageView
        currentImageIndex = index
        if imageView?.hasLoadedImage == true {return}
        if self.highQualityImageURLForIndex(index) != nil {
            imageView?.setImageWithURL(NSURL(string:self.highQualityImageURLForIndex(index)!)!, placeholder: self.placeholderImageForIndex(index))
        } else {
            imageView?.image = self.placeholderImageForIndex(index)
        }
        imageView!.hasLoadedImage = true
    }
    
    func photoClick(recognizer:UITapGestureRecognizer) {
        scrollView.hidden = true
        willDisappear = true
        let currentImageView = recognizer.view as? YUBrowserImageView
        let currentIndex = currentImageView?.tag
        let sourceView = self.sourceImagesContainerView?.subviews[currentIndex!]
        if sourceView != nil {
            let targetTemp = self.sourceImagesContainerView?.convertRect(sourceView!.frame, toView: self)
            let tempView = UIImageView()
            tempView.contentMode = sourceView!.contentMode
            tempView.clipsToBounds = true
            tempView.image = currentImageView!.image
            var h = self.bounds.size.height
            if currentImageView!.image != nil {
                h = (self.bounds.size.width / currentImageView!.image!.size.width) * currentImageView!.image!.size.height
            }
            tempView.bounds = CGRectMake(0, 0, self.bounds.size.width, h)
            tempView.center = self.center
            self.addSubview(tempView)
            saveButton.hidden = true
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                tempView.frame = targetTemp!
                self.backgroundColor = UIColor.clearColor()
                self.indexLabel.alpha = 0.1
                }) { (finished) -> Void in
                    self.removeFromSuperview()
            }
        }
    }
    
    func photoDoubleClick(recognizer:UIGestureRecognizer) {
        let imageView = recognizer.view as! YUBrowserImageView
        var scale:CGFloat
        if imageView.isScaled == true {
            scale = 1
        } else {
            scale = 2
        }
        imageView.doubleTapToZommWithScale(scale)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var rect = self.bounds
        rect.size.width += PhotoBrowserImageViewMargin * 2
        
        scrollView.bounds = rect
        scrollView.center = self.center
        
        let y:CGFloat = 0
        let w = scrollView.frame.size.width - PhotoBrowserImageViewMargin * 2
        let h = scrollView.frame.size.height
        
        for (index, view) in scrollView.subviews.enumerate() {
            let obj = view as? YUBrowserImageView
            if obj != nil {
                let x = PhotoBrowserImageViewMargin + CGFloat(index) * (PhotoBrowserImageViewMargin * 2 + w)
                obj!.frame = CGRectMake(x, y, w, h)
            }
        }
        scrollView.contentSize = CGSizeMake(CGFloat(scrollView.subviews.count) * scrollView.frame.size.width, 0)
        scrollView.contentOffset = CGPointMake(CGFloat(self.currentImageIndex) * scrollView.frame.size.width, 0)
        
        if (hasShowedFistView == false) {
            self.showFirstImage()
        }
        
        indexLabel.center = CGPointMake(self.bounds.size.width * 0.5, 35)
        saveButton.frame = CGRectMake(30, self.bounds.size.height - 70, 50, 25)
    }
    
    func show() {
        let window = UIApplication.sharedApplication().keyWindow!
        self.frame = window.bounds
        window.addObserver(self, forKeyPath: "frame", options: .New, context: nil)
        window.addSubview(self)
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "frame" {
            self.frame = object!.bounds
            let currentImageView = scrollView.subviews[currentImageIndex]
            if currentImageView is YUBrowserImageView {
                let view = currentImageView as! YUBrowserImageView
                view.clear()
            }
        }
    }
    
    func showFirstImage() {
        var sourceView:UIView? = nil
        if sourceImagesContainerView is UICollectionView {
            let view = sourceImagesContainerView as! UICollectionView
            let path = NSIndexPath(forItem: currentImageIndex, inSection: 0)
            sourceView = view.cellForItemAtIndexPath(path)
        } else {
            sourceView = self.sourceImagesContainerView!.subviews[self.currentImageIndex]
        }
        
        let rect = sourceImagesContainerView!.convertRect(sourceView!.frame, toView: self)
        let tempView = UIImageView()
        tempView.image = self.placeholderImageForIndex(currentImageIndex)
        self.addSubview(tempView)
        
        let targetTemp = scrollView.subviews[currentImageIndex].bounds
        tempView.frame = rect
        tempView.contentMode = scrollView.subviews[currentImageIndex].contentMode
        scrollView.hidden = true
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            tempView.center = self.center
            tempView.bounds = CGRectMake(0, 0, targetTemp.size.width, targetTemp.size.height)
            }) { (finished) -> Void in
                self.hasShowedFistView = true
                tempView.removeFromSuperview()
                self.scrollView.hidden = false
        }
    }
    
    func placeholderImageForIndex(index:Int) -> UIImage? {
        if ((self.delegate?.respondsToSelector(Selector("photoBrowser:"))) != nil) {
            return self.delegate!.photoBrowser(self, index: index)
        } else {
            return nil
        }
    }
    
    func highQualityImageURLForIndex(index:Int) -> String? {
        if ((self.delegate?.respondsToSelector(Selector("photoBrowserHighQualityImage:"))) != nil) {
            return self.delegate!.photoBrowserHighQualityImage!(self, index: index)
        } else {
            return nil
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let index = Int((scrollView.contentOffset.x + scrollView.bounds.size.width * 0.5) / scrollView.bounds.size.width)
        
        // 有过缩放的图片在拖动一定距离后清除缩放
        let margin:CGFloat = 150;
        let x = scrollView.contentOffset.x
        if ((x - CGFloat(index) * self.bounds.size.width) > margin || (x - CGFloat(index) * self.bounds.size.width) < -margin) {
            let imageView = scrollView.subviews[index] as! YUBrowserImageView
            if (imageView.isScaled) {
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    imageView.transform = CGAffineTransformIdentity
                    }, completion: { (finished) -> Void in
                        imageView.eliminateScale()
                })
            }
        }
        
        if (willDisappear == false) {
            indexLabel.text = "\(index + 1)/\(imageCount)"
        }
        self.setupImageOfImageViewForIndex(index)
    }
}
