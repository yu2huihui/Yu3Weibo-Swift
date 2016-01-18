//
//  YUHomeViewController.swift
//  Yu3Weibo-Swift
//
//  Created by yu3 on 16/1/17.
//  Copyright © 2016年 yu3. All rights reserved.
//

import UIKit

class YUHomeViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.leftBarButtonItem = UIBarButtonItem.itemWith("navigationbar_friendsearch", highIcon: "navigationbar_friendsearch_highlighted", target: self, action: Selector("findFriend"))
        
        // 右边按钮
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
        return 20
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let yu3 = "cell"
        let cell = UITableViewCell(style: .Subtitle, reuseIdentifier: yu3)
        // 2.设置cell的数据
        cell.textLabel!.text = "yu3"
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
