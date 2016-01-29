//
//  YUTextView.swift
//  Yu3Weibo-Swift
//
//  Created by yu3 on 16/1/29.
//  Copyright © 2016年 yu3. All rights reserved.
//

import UIKit

class YUTextView: UITextView {
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        placeholderLabel.textColor = placeholderColor
        placeholderLabel.hidden = true
        placeholderLabel.numberOfLines = 0
        placeholderLabel.backgroundColor = UIColor.clearColor()
        placeholderLabel.font = self.font
        self.insertSubview(placeholderLabel, atIndex: 0)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("textDidChange"), name: UITextViewTextDidChangeNotification, object: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    var placeholder = "" {
        didSet {
            placeholderLabel.text = placeholder
            if (placeholder != "") { // 需要显示
                self.placeholderLabel.hidden = false
                
                // 计算frame
                let placeholderX:CGFloat = 5
                let placeholderY:CGFloat = 7
                let maxW = self.frame.size.width - 2 * placeholderX
                let maxH = self.frame.size.height - 2 * placeholderY
                let placeholderStr = placeholder as NSString
                let placeholderSize = placeholderStr.boundingRectWithSize(CGSizeMake(maxW, maxH), options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName : self.placeholderLabel.font], context: nil).size
                self.placeholderLabel.frame = CGRectMake(placeholderX, placeholderY, placeholderSize.width, placeholderSize.height)
            } else {
                self.placeholderLabel.hidden = true
            }

        }
    }
    var placeholderColor = UIColor.lightGrayColor() {
        didSet {
            placeholderLabel.textColor = placeholderColor
        }
    }

    private var placeholderLabel = UILabel()
        
    override var font: UIFont? {
        didSet {
            placeholderLabel.font  = font
        }
    }
    
    func textDidChange() {
        self.placeholderLabel.hidden = (self.text.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) != 0);
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}