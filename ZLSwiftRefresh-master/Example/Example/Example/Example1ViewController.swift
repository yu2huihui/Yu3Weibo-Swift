//
//  Example1ViewController.swift
//  ZLSwiftRefresh
//
//  Created by 张磊 on 15-3-9.
//  Copyright (c) 2015年 com.zixue101.www. All rights reserved.
//

import UIKit
import ZLSwiftRefresh

class Example1ViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    
    // default datas
    var datas:Int = 10
    var tableView:UITableView = UITableView()

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weak var weakSelf = self as Example1ViewController
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        let tableView = UITableView(frame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height), style: .Plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(tableView)
        self.tableView = tableView
        
        // 及时上拉刷新
        tableView.nowRefresh({ () -> Void in
            weakSelf?.delay(2.0, closure: { () -> () in})
            weakSelf?.delay(2.0, closure: { () -> () in
                print("nowRefresh success")
                weakSelf?.datas += 10
                weakSelf?.tableView.reloadData()
                weakSelf?.tableView.doneRefresh()
            })
        })
        
        // 上啦加载更多
        tableView.toLoadMoreAction({ () -> Void in
            print("toLoadMoreAction success")
            if (weakSelf?.datas < 60){
                weakSelf?.datas += 20
                tableView.reloadData()
                tableView.doneRefresh()
            }else{
                tableView.endLoadMoreData()
            }
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.datas;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : UITableViewCell! = tableView.dequeueReusableCellWithIdentifier("cell")

        if cell != nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: "cell")
        }
        
        cell.textLabel?.text = "测试数据 - \(indexPath.row)"
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
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
