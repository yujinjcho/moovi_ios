//
//  AppDependenciesTest.swift
//  MovieRecTests
//
//  Created by Yujin Cho on 10/18/17.
//  Copyright © 2017 Yujin Cho. All rights reserved.
//

import XCTest
import UIKit
@testable import MovieRec

class AppDependenciesTest: XCTestCase {
    var appDependencies : AppDependencies = AppDependencies()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testAppDependencyHasRateWireFrameOnInit() {
        XCTAssertNotNil(appDependencies.rateWireframe, "appDependencies should have rateWireFrame initialized")
    }
    
    func testThatShowsRateViewControllerIsRoot() {
        let window = UIWindow()
        let navController = UINavigationController()
        window.rootViewController = navController
        
        appDependencies.installRootViewControllerIntoWindow(window)
        
        if let rootViewController = window.rootViewController as? UINavigationController {
            if let rateViewController = rootViewController.viewControllers.first {
                XCTAssertNotNil(rateViewController as? RateViewController, "must be a rate view controller")
            } else {
                XCTFail("first view controller must be a view controller")
            }
        } else {
            XCTFail("window must have a rootViewController that is a navigation controller")
        }
    }
    
}
