//
//  Yu3Weibo_SwiftUITests.swift
//  Yu3Weibo-SwiftUITests
//
//  Created by yu3 on 16/1/17.
//  Copyright © 2016年 yu3. All rights reserved.
//

import XCTest

class Yu3Weibo_SwiftUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        let app = XCUIApplication()
        
        let tabBarsQuery = app.tabBars
        tabBarsQuery.buttons["tabbar compose icon add os7"].tap()
        
        app.navigationBars["发微博"].buttons["取消"].tap()
        
    }
    
}
