//
//  YUStatusCell.swift
//  Yu3Weibo-Swift
//
//  Created by yu3 on 16/1/21.
//  Copyright © 2016年 yu3. All rights reserved.
//

import UIKit

class YUStatusCell: UITableViewCell {
    /** 顶部的view */
    weak var topView:YUStatusTopView?
    /** 微博的工具条 */
    weak var statusToolbar:YUStatusToolbar?
    
    class func cellWithTableView(tableView:UITableView) -> YUStatusCell {
        let yu3 = "status"
        var cell = tableView.dequeueReusableCellWithIdentifier(yu3) as? YUStatusCell
        if (cell == nil) {
            cell = YUStatusCell(style: .Subtitle, reuseIdentifier: yu3)
        }
        return cell!;
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // 1.设置cell选中时的背景
        self.selectedBackgroundView = UIView()
        // 2 添加顶部的view
        let topView = YUStatusTopView()
        self.contentView.addSubview(topView)
        self.topView = topView
        // 3.添加微博的工具条
        let statusToolbar = YUStatusToolbar()
        self.contentView.addSubview(statusToolbar)
        self.statusToolbar = statusToolbar
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var statusFrame:YUStatusFrame? {
        didSet {
            // 1.topView
            self.topView!.frame = statusFrame!.topViewF
            self.topView!.statusFrame = statusFrame!
            // 2.微博工具条
            self.statusToolbar!.frame = statusFrame!.statusToolbarF
            self.statusToolbar!.status = statusFrame!.status
        }
    }
}
