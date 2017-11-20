//
//  RateWireFrameTest.swift
//  MovieRecTests
//
//  Created by Yujin Cho on 10/20/17.
//  Copyright © 2017 Yujin Cho. All rights reserved.
//

import XCTest
@testable import MovieRec

class RateWireFrameTest: XCTestCase {
    
    var rateWireframe = RateWireFrame()
    var recommendWireframe = MockRecommendWireframe()
    var ratePresenter = RatePresenter()
    var rootWireframe = RootWireframe()
    var rateViewController = RateViewController()
    let navigationController = UINavigationController()
    
    override func setUp() {
        super.setUp()
        rateWireframe.recommendWireframe = recommendWireframe
        rateWireframe.ratePresenter = ratePresenter
        rateWireframe.rootWireframe = rootWireframe
        rateWireframe.rateViewController = rateViewController
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testPresentRateInterfaceFromWindow() {
        let window = UIWindow()
        let navController = UINavigationController()
        window.rootViewController = navController
        
        rateWireframe.presentRateInterfaceFromWindow(window)
        
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
    
    func testPresentRecommendInterface() {        XCTAssertFalse(recommendWireframe.presentRecommendInterfaceFromViewControllerCalled, "presentRecommendInterfaceFromViewController should not be called")
            rateWireframe.presentRecommendInterface(navigationController: navigationController)
            XCTAssertTrue(recommendWireframe.presentRecommendInterfaceFromViewControllerCalled, "presentRecommendInterfaceFromViewController should be called")
    }
}
