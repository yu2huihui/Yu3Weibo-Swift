//
//  Yu3Weibo_SwiftTests.swift
//  Yu3Weibo-SwiftTests
//
//  Created by yu3 on 16/1/17.
//  Copyright © 2016年 yu3. All rights reserved.
//

import ObjectMapper
import Alamofire
import AlamofireObjectMapper
import XCTest
@testable import Yu3Weibo_Swift

class Yu3Weibo_SwiftTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    class Person: Mappable {
        var name: String?
        var spouse: Person?
        var children: [String : Person]?
        
        required init?(_ map: Map) {
            
        }
        
        func mapping(map: Map) {
            name		<- map["name"]
            spouse		<- map["spouse"]
            children	<- map["children"]
        }
    }
    
    func testMapper() {
        let name = "ASDF"
        let spouseName = "HJKL"
        let JSONString = "{\"name\" : \"\(name)\", \"spouse\" : {\"name\" : \"\(spouseName)\"}}"
        
        let mappedObject = Mapper<Person>().map(JSONString)
        
        XCTAssertNotNil(mappedObject)
        XCTAssertEqual(mappedObject?.name, name)
        XCTAssertEqual(mappedObject?.spouse?.name, spouseName)
    }
    
    class WeatherResponse: Mappable {
        var location: String?
        var threeDayForecast: [Forecast]?
        
        required init?(_ map: Map){
            
        }
        
        func mapping(map: Map) {
            location <- map["location"]
            threeDayForecast <- map["three_day_forecast"]
        }
    }
    
    class Forecast: Mappable {
        var day: String?
        var temperature: Int?
        var conditions: String?
        
        required init?(_ map: Map){
            
        }
        
        func mapping(map: Map) { 
            day <- map["day"]
            temperature <- map["temperature"]
            conditions <- map["conditions"]
        }
    }
    
    func testPerformanceExample() {
        let URL = "https://raw.githubusercontent.com/tristanhimmelman/AlamofireObjectMapper/d8bb95982be8a11a2308e779bb9a9707ebe42ede/sample_json"
        let expectation = expectationWithDescription("\(URL)")
        
        Alamofire.request(.GET, URL).responseObject { (response: Response<WeatherResponse, NSError>) in
            expectation.fulfill()
            
            let mappedObject = response.result.value
            
            XCTAssertNotNil(mappedObject, "Response should not be nil")
            XCTAssertNotNil(mappedObject?.location, "Location should not be nil")
            XCTAssertNotNil(mappedObject?.threeDayForecast, "ThreeDayForcast should not be nil")
            
            for forecast in mappedObject!.threeDayForecast! {
                XCTAssertNotNil(forecast.day, "day should not be nil")
                XCTAssertNotNil(forecast.conditions, "conditions should not be nil")
                XCTAssertNotNil(forecast.temperature, "temperature should not be nil")
            }
        }
        
        waitForExpectationsWithTimeout(10) { (error: NSError?) -> Void in
            XCTAssertNil(error, "\(error)")
        }
    }
    
}
