//
//  Example2ViewController.swift
//  ZLSwiftRefresh
//
//  Created by 张磊 on 15-3-9.
//  Copyright (c) 2015年 com.zixue101.www. All rights reserved.
//

import UIKit
import ZLSwiftRefresh

class Example2ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {

    var datas:Int = 10
    
    var collectionView:UICollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        self.setupUI()
        
        weak var weakSelf = self as Example2ViewController
        
        // 加载更多
        collectionView.toLoadMoreAction { () -> () in
            weakSelf?.delay(0.5, closure: { () -> () in})
            weakSelf?.delay(0.5, closure: { () -> () in
                print("toLoadMoreAction success")
                if weakSelf?.datas < 40 {
                    weakSelf?.datas += (Int)(arc4random_uniform(10)) + 1
                    weakSelf?.collectionView.reloadData()
                }else {
                    // 数据加载完毕
                    weakSelf?.collectionView.endLoadMoreData()
                }
                weakSelf?.collectionView.doneRefresh()
            })
        }
        
        // 立马进去就刷新
        collectionView.nowRefresh({ () -> Void in
            weakSelf?.delay(2.0, closure: { () -> () in})
            weakSelf?.delay(2.0, closure: { () -> () in
                print("nowRefresh success")
                weakSelf?.datas += (Int)(arc4random_uniform(10)) + 1
                weakSelf?.collectionView.reloadData()
                weakSelf?.collectionView.doneRefresh()
            })
        })
    }
    
    func setupUI(){
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 10
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.itemSize = CGSizeMake(80, 80)
        flowLayout.scrollDirection = .Vertical
        
        let collectionView = UICollectionView(frame: CGRectMake(20, 20, self.view.frame.width - 40, self.view.frame.height), collectionViewLayout: flowLayout)
        collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.dataSource = self as UICollectionViewDataSource
        collectionView.delegate = self as UICollectionViewDelegate
        collectionView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(collectionView)
        self.collectionView = collectionView
    }
    
    //MARK: <UICollectionViewDataSource>
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.datas
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let collectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) 

        collectionViewCell.backgroundColor = UIColor(red: CGFloat(CGFloat(arc4random_uniform(256))/255), green: CGFloat(CGFloat(arc4random_uniform(256))/255), blue: CGFloat(CGFloat(arc4random_uniform(256))/255.0), alpha: 1)
        
        return collectionViewCell
    }
    
    //MARK: <UICollectionViewDelegate>
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print("点击了\(indexPath.item)行")
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
