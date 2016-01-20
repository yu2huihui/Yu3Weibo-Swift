//
//  Extensions.swift
//  Yu3Weibo-Swift
//
//  Created by yu3 on 16/1/20.
//  Copyright © 2016年 yu3. All rights reserved.
//

import Foundation
import UIKit

extension UIBarButtonItem {
    class func itemWith(icon:String, highIcon:String, target:AnyObject?, action:Selector) -> UIBarButtonItem {
        let button = UIButton(type: .Custom)
        button.setBackgroundImage(UIImage.imageWithName(icon), forState: .Normal)
        button.setBackgroundImage(UIImage.imageWithName(highIcon), forState: .Highlighted)
        button.frame = CGRectMake(0, 0, (button.currentBackgroundImage?.size.width)!, (button.currentBackgroundImage?.size.height)!)
        button.addTarget(target, action: action, forControlEvents: .TouchUpInside)
        return UIBarButtonItem(customView: button)
    }
}

extension UIImage {
    class func imageWithName(name: String) -> UIImage {
        let newName = name + "_os7"
        var image:UIImage? = UIImage(named: newName)
        if image == nil {
            image = UIImage(named: name)
        }
        return image!
    }
    
    class func resizedImageWithName(name: String) -> UIImage {
        let image = UIImage.imageWithName(name)
        return image.stretchableImageWithLeftCapWidth(Int(image.size.width/2), topCapHeight: Int(image.size.height/2))
    }
}