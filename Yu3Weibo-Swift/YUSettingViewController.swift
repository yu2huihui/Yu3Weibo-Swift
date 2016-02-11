//
//  YUSettingViewController.swift
//  Yu3Weibo-Swift
//
//  Created by yu3 on 16/2/10.
//  Copyright © 2016年 yu3. All rights reserved.
//

import UIKit

class YUSettingViewController: UITableViewController {
    var groups = [SettingGroup]()
    func addGroup() -> SettingGroup {
        let group = SettingGroup()
        self.groups.append(group)
        return group
    }
    
    init() {
        super.init(style: .Grouped)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.separatorStyle = .None
        
        self.tableView.sectionHeaderHeight = 5
        self.tableView.sectionFooterHeight = 0
        self.tableView.contentInset = UIEdgeInsetsMake(-30, 0, 0, 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.groups.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.groups[section].items.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = YUSettingCell.cellWithTableView(tableView)
        let group = self.groups[indexPath.section]
        cell.item = group.items[indexPath.row];
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let group = self.groups[section]
        return group.header
    }
    
    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        let group = self.groups[section]
        return group.footer
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        // 1.取出模型
        let group = self.groups[indexPath.section]
        let item = group.items[indexPath.row]
        
        // 2.操作
        if ((item.operation) != nil) {
            item.operation!()
        }
        
        // 3.跳转
        if ((item as? SettingArrowItem) != nil) {
            let arrowItem = item as! SettingArrowItem
            if ((arrowItem.destVcClass) != nil) {
                let destVc = arrowItem.destVcClass
                destVc!.title = arrowItem.title;
                self.navigationController?.pushViewController(destVc!, animated: true)
            }
        }
    }
}
