//
//  RecommendWireFrameTest.swift
//  MovieRecTests
//
//  Created by Yujin Cho on 10/23/17.
//  Copyright © 2017 Yujin Cho. All rights reserved.
//

import XCTest
@testable import MovieRec

class RecommendWireFrameTest: XCTestCase {
    var recommendWireframe = RecommendWireframe()
    var recommendPresenter = RecommendPresenter()
    
    override func setUp() {
        super.setUp()
        recommendWireframe.recommendPresenter = recommendPresenter
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testPresentRecommendInterfaceFromViewController() {
        let window = UIWindow()
        let navController = UINavigationController()
        window.rootViewController = navController

        recommendWireframe.presentRecommendInterfaceFromViewController(navController)
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
}


