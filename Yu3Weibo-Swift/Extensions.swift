//
//  Extensions.swift
//  Yu3Weibo-Swift
//
//  Created by yu3 on 16/1/20.
//  Copyright © 2016年 yu3. All rights reserved.
//

import Foundation
import UIKit

extension NSDate {
    /**
    *  是否为今天
    */
    func isToday() -> Bool {
        let calendar = NSCalendar.currentCalendar()

        // 当前的年月日
        let currentYear = calendar.component(.Year, fromDate: NSDate())
        let currentMonth = calendar.component(.Month, fromDate: NSDate())
        let currentDay = calendar.component(.Day, fromDate: NSDate())
        
        // 获得self的年月日
        let year = calendar.component(.Year, fromDate: self)
        let month = calendar.component(.Month, fromDate: self)
        let day = calendar.component(.Day, fromDate: self)
        
        return (year == currentYear) && (month == currentMonth) && (day == currentDay)
    }
    
    func dateWithYMD() -> NSDate {
        let fmt = NSDateFormatter()
        fmt.dateFormat = "yyyy-MM-dd"
        let selfStr = fmt.stringFromDate(self)
        return fmt.dateFromString(selfStr)!
    }
    /**
    *  是否为昨天
    */
    func isYesterday() -> Bool {
        let nowDate = NSDate().dateWithYMD()
        let selfDate = self.dateWithYMD()
        
        // 获得nowDate和selfDate的差距
        let calendar = NSCalendar.currentCalendar()
        let cmps = calendar.components(.Day, fromDate: selfDate, toDate: nowDate, options: .WrapComponents)
        return cmps.day == 1
    }
    
    /**
    *  是否为今年
    */
    func isThisYear() -> Bool {
        let calendar = NSCalendar.currentCalendar()
        // 当前的年
        let currentYear = calendar.component(.Year, fromDate: NSDate())
        // 获得self的年
        let year = calendar.component(.Year, fromDate: self)
        return year == currentYear
    }
}

extension UIColor {
    class func colorWithRed(red:Int, green:Int, blue:Int) -> UIColor {
        return UIColor(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: 1.0)
    }
}

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
        return UIImage.resizedImageWithName(name, left: 0.5, top: 0.5)
    }
    
    class func resizedImageWithName(name:String, left:CGFloat, top:CGFloat) -> UIImage {
        let image = UIImage.imageWithName(name)
        return image.stretchableImageWithLeftCapWidth(Int(image.size.width * left), topCapHeight: Int(image.size.height * top))
    }
    
    class func cutToCircle(oldImage:UIImage) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(oldImage.size, false, 0.0)
        let ctx = UIGraphicsGetCurrentContext()
        CGContextAddEllipseInRect(ctx, CGRectMake(0, 0, oldImage.size.width, oldImage.size.height))
        CGContextClip(ctx)
        oldImage.drawInRect(CGRectMake(0, 0, oldImage.size.width, oldImage.size.height))
        let result = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return result;
    }
}