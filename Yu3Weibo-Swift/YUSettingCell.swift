//
//  YUSettingCell.swift
//  Yu3Weibo-Swift
//
//  Created by yu3 on 16/2/10.
//  Copyright © 2016年 yu3. All rights reserved.
//

import UIKit

class YUSettingCell: UITableViewCell {
    var item:SettingItem? {
        didSet {
            // 1.图标
            if (self.item?.icon != "") {
                self.imageView!.image = UIImage.imageWithName(self.item!.icon)
            }
            
            // 2.标题
            self.textLabel!.text = self.item?.title
            self.detailTextLabel!.text = self.item?.subtitle;
            
            if (self.item!.badgeValue != "") {
                self.badgeButton.badgeValue = self.item!.badgeValue;
                self.accessoryView = self.badgeButton;
            } else if ((self.item as? SettingSwitchItem) != nil) { // 右边是开关
                self.accessoryView = self.switchView;
            } else if ((self.item as? SettingArrowItem) != nil) { // 右边是箭头
                self.accessoryView = self.arrowView;
            } else { // 右边没有东西
                self.accessoryView = nil;
            }
        }
    }
    /** 箭头 */
    var arrowView = UIImageView(image: UIImage.imageWithName("common_icon_arrow"))
    /** 开关 */
    var switchView = UISwitch()
    /** 提醒数字 */
    var badgeButton = YUBadgeButton()
    
    class func cellWithTableView(tableView:UITableView) -> YUSettingCell {
        let id = "setting"
        var cell = tableView.dequeueReusableCellWithIdentifier(id) as? YUSettingCell
        if (cell == nil) {
            cell = YUSettingCell(style: .Value1, reuseIdentifier: id)
        }
        return cell!
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.textLabel!.backgroundColor = UIColor.clearColor()
        self.textLabel!.textColor = UIColor.blackColor()
        self.textLabel!.highlightedTextColor = self.textLabel!.textColor
        self.textLabel!.font = UIFont.boldSystemFontOfSize(16)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
