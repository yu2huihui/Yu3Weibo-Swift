//
//  YUWaitingView.swift
//  Yu3Weibo-Swift
//
//  Created by yu3 on 16/1/23.
//  Copyright © 2016年 yu3. All rights reserved.
//

import Foundation
import UIKit

enum SDWaitingViewMode {
    case LoopDiagram // 环形
    case PieDiagram // 饼型
}

class YUWaitingView: UIView {
    let WaitingViewItemMargin:CGFloat = 10
    let WaitingViewBackgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
    var progress:CGFloat = 0.05 {
        didSet {
            //将重绘操作放在主线程，解决自动布局控制台报错的问题
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                self.setNeedsDisplay()
                if self.progress >= 1 {
                    self.removeFromSuperview()
                }
            }

        }
    }
    var mode:SDWaitingViewMode = .PieDiagram

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = WaitingViewBackgroundColor
        layer.cornerRadius = 5
        clipsToBounds = true
        mode = .LoopDiagram
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func drawRect(rect: CGRect) {
        let ctx = UIGraphicsGetCurrentContext()
        let xCenter = rect.size.width * 0.5
        let yCenter = rect.size.height * 0.5
        UIColor.whiteColor().set()
        
        switch (mode) {
            case .LoopDiagram:
                let radius = min(rect.size.width * 0.5, rect.size.height * 0.5) - WaitingViewItemMargin
                let w = radius * 2 + WaitingViewItemMargin
                let h = w
                let x = (rect.size.width - w) * 0.5
                let y = (rect.size.height - h) * 0.5
                CGContextAddEllipseInRect(ctx, CGRectMake(x, y, w, h))
                CGContextFillPath(ctx)
                
                WaitingViewBackgroundColor.set()
                CGContextMoveToPoint(ctx, xCenter, yCenter)
                CGContextAddLineToPoint(ctx, xCenter, 0)

                let to = -M_PI * 0.5 + Double(self.progress) * M_PI * 2 + 0.001// 初始值
                CGContextAddArc(ctx, xCenter, yCenter, radius, CGFloat(-M_PI * 0.5), CGFloat(to), 1)
                CGContextClosePath(ctx)
                CGContextFillPath(ctx)
            //break
            default :
                CGContextSetLineWidth(ctx, 15)
                CGContextSetLineCap(ctx, .Round)
                let to = -M_PI * 0.5 + Double(self.progress) * M_PI * 2 + 0.05// 初始值0.05
                let radius = min(rect.size.width, rect.size.height) * 0.5 - WaitingViewItemMargin
                CGContextAddArc(ctx, xCenter, yCenter, radius, CGFloat(-M_PI * 0.5), CGFloat(to), 0)
                CGContextStrokePath(ctx)
        }
    }
}
