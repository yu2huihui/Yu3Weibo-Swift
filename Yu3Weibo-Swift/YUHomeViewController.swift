//
//  YUHomeViewController.swift
//  Yu3Weibo-Swift
//
//  Created by yu3 on 16/1/17.
//  Copyright © 2016年 yu3. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher

class YUHomeViewController: UITableViewController {
    var statuses:[YUStatus]?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBar()
        self.setStatuses()
    }
    
    func setStatuses() {
        let access_token = YUAccountTool.account()?.access_token
        let params = ["access_token": access_token!] as Dictionary<String,AnyObject>
        let urlStr = "https://api.weibo.com/2/statuses/home_timeline.json"
        Alamofire.request(.GET, urlStr, parameters: params, encoding: .URL, headers: nil).responseJSON { (response) -> Void in
            if response.result.error != nil {
                print("请求失败：\(response.result.error)")
            } else {
                let status = response.result.value as? NSDictionary
                let statusAry = status!["statuses"] as? NSArray
                var statuses = [YUStatus]()
                for statusDic in statusAry! {
                    //将字典封装成模型
                    let status = YUStatus(dic: statusDic as! NSDictionary)
                    statuses.append(status)
                }
                self.statuses = statuses
                self.tableView.reloadData()
            }
            
        }
    }
    
    func setNavigationBar() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.itemWith("navigationbar_friendsearch", highIcon: "navigationbar_friendsearch_highlighted", target: self, action: Selector("findFriend"))
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.itemWith("navigationbar_pop", highIcon: "navigationbar_pop_highlighted", target: self, action: Selector("pop"))
        let titleButton = YUTitleButton()
        titleButton.setImage(UIImage.imageWithName("navigationbar_arrow_down"), forState: .Normal)
        titleButton.setTitle("huihui", forState: .Normal)
        
        titleButton.frame = CGRectMake(0, 0, 100, 40);
        //    titleButton.tag = TitleButtonDownTag;
        titleButton.addTarget(self, action: Selector("titleClick:"), forControlEvents: .TouchUpInside)
        self.navigationItem.titleView = titleButton
    }
    
    func titleClick(titleButton:YUTitleButton) {
        if titleButton.currentImage == UIImage.imageWithName("navigationbar_arrow_up") {
            titleButton.setImage(UIImage.imageWithName("navigationbar_arrow_down"), forState: .Normal)
        } else {
            titleButton.setImage(UIImage.imageWithName("navigationbar_arrow_up"), forState: .Normal)
        }
    }
    
    func findFriend() {
        print("findFriend")
    }
    
    func pop() {
        print("pop")
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc = UIViewController()
        vc.view.backgroundColor = UIColor.redColor()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (self.statuses) != nil ? self.statuses!.count : 0
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let yu3 = "cell"
        let cell = UITableViewCell(style: .Subtitle, reuseIdentifier: yu3)
        // 设置cell的数据
        let status = self.statuses?[indexPath.row]
        cell.detailTextLabel?.text = status?.text
        // 微博作者的昵称
        let user = status?.user
        cell.textLabel?.text = user?.name
        // 微博作者的头像
        cell.imageView?.kf_setImageWithURL(NSURL(string: (user?.profile_image_url)!)!, placeholderImage: UIImage.imageWithName("tabbar_compose_button"))
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
   
}