//
//  Example4ViewController.swift
//  ZLSwiftRefresh
//
//  Created by 张磊 on 15-3-23.
//  Copyright (c) 2015年 com.zixue101.www. All rights reserved.
//

import UIKit
import ZLSwiftRefresh

class Example4ViewController: UITableViewController {
    
    // default datas
    var datas:Int = 10
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weak var weakSelf = self as Example4ViewController
        
        
        var animationImages = [UIImage]()
        for i in 0..<73{
            var str = "PullToRefresh_00\(i)"
            if (i > 9){
                str = "PullToRefresh_0\(i)"
            }
            let image = UIImage(named: str)
            animationImages.append(image!)
        }
        // 上拉动画
        self.tableView.headerViewRefreshAnimationStatus(.headerViewRefreshPullAnimation, images: animationImages)
        
        // 加载动画
        var loadAnimationImages = [UIImage]()
        for i in 73..<141{
            var str = "PullToRefresh_0\(i)"
            if (i > 99){
                str = "PullToRefresh_\(i)"
            }
            let image = UIImage(named: str)
            loadAnimationImages.append(image!)
        }
        self.tableView.headerViewRefreshAnimationStatus(.headerViewRefreshLoadingAnimation, images: loadAnimationImages)
        
        
        // 上啦加载更多
        self.tableView.toLoadMoreAction({ () -> () in
            print("toLoadMoreAction success")
            if (weakSelf?.datas < 60){
                weakSelf?.datas += 20
                weakSelf?.tableView.reloadData()
                weakSelf?.tableView.doneRefresh()
            }else{
                weakSelf?.tableView.endLoadMoreData()
            }
        })
        
        // 及时上拉刷新
        self.tableView.nowRefresh({ () -> Void in
            weakSelf?.delay(2.0, closure: { () -> () in})
            weakSelf?.delay(2.0, closure: { () -> () in
                print("nowRefresh success")
                weakSelf?.datas += 20
                weakSelf?.tableView.reloadData()
                weakSelf?.tableView.doneRefresh()
            })
        })
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.datas;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : UITableViewCell! = tableView.dequeueReusableCellWithIdentifier("cell")
        
        if cell != nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: "cell")
        }
        
        cell.textLabel?.text = "测试数据 - \(indexPath.row)"
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.navigationController?.pushViewController(Example1ViewController(), animated: true)
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
}
