# ZLSwiftRefresh

#### Default Support Refresh (默认支持的动画)
![image](https://github.com/MakeZL/ZLSwiftRefresh/blob/master/refreshDemo1.gif)
![image](https://github.com/MakeZL/ZLSwiftRefresh/blob/master/refreshDemo6.gif)

#### UITableView Refresh
![image](https://github.com/MakeZL/ZLSwiftRefresh/blob/master/refreshDemo2.gif)

#### UICollectionView/UIWebView
![image](https://github.com/MakeZL/ZLSwiftRefresh/blob/master/refreshDemo3.gif)
![image](https://github.com/MakeZL/ZLSwiftRefresh/blob/master/refreshDemo4.gif)

#### Custom Animation View(自定义动画View)
![image](https://github.com/MakeZL/ZLSwiftRefresh/blob/master/refreshDemo5.gif)


This is Swift UITableView/CollectionView pull Refresh Lib.
-------
## Use
    // 下拉刷新(Pull to Refersh)
    self.tableView.toRefreshAction({ () -> () in
        println("toRefreshAction success")
    })

    // 上拉刷新(Pull to LoadMore)
    self.tableView.toLoadMoreAction({ () -> () in
        println("toLoadMoreAction success")
        // OK
        self.tableView.endLoadMoreData()
    })
    // 马上刷新(Now to Refresh)
    self.tableView.toLoadMoreAction({ () -> () in
        println("toLoadMoreAction success")
    })

Continue to update!

