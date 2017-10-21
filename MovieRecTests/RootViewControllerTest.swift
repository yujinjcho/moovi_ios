//
//  RootViewControllerTest.swift
//  MovieRecTests
//
//  Created by Yujin Cho on 10/20/17.
//  Copyright © 2017 Yujin Cho. All rights reserved.
//

import XCTest
@testable import MovieRec

class RootViewControllerTest: XCTestCase {
    var rootWireframe = RootWireframe()
    var window = UIWindow()
    var rateViewController = RateViewController()
    var recommendViewController = RecommendViewController()
    
    override func setUp() {
        super.setUp()
        let navController = UINavigationController()
        window.rootViewController = navController
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testShowRootViewControllerWithRateViewController() {
        rootWireframe.showRootViewController(rateViewController, inWindow: window)
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
    
    func testShowRootViewControllerWithRecommendViewController() {
        rootWireframe.showRootViewController(recommendViewController, inWindow: window)
        if let rootViewController = window.rootViewController as? UINavigationController {
            if let recommendViewController = rootViewController.viewControllers.first {
                XCTAssertNotNil(recommendViewController as? RecommendViewController, "must be a recommend view controller")
            } else {
                XCTFail("first view controller must be a view controller")
            }
        } else {
            XCTFail("window must have a rootViewController that is a navigation controller")
        }
    }
    
    func testNavigationControllerFromWindow() {
        let navigationController = rootWireframe.navigationControllerFromWindow(window)
        XCTAssertNotNil(navigationController as? UINavigationController, "navigationControllerFromWindow should return UINavigationController")
    }
    
}
