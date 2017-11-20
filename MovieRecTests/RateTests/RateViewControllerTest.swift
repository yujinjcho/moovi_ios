//
//  RateViewControllerTest.swift
//  MovieRecTests
//
//  Created by Yujin Cho on 10/30/17.
//  Copyright © 2017 Yujin Cho. All rights reserved.
//

import XCTest
@testable import MovieRec

class RateViewControllerTest: XCTestCase {
    
    var rateViewController: RateViewController?
    var mockRateViewEventHandler = MockRateViewEventHandler()
    var navController: UINavigationController?
    
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(withIdentifier: "RateViewController") as! RateViewController
        viewController.eventHandler = mockRateViewEventHandler
        rateViewController = viewController
        
        let window = UIWindow()
        navController = UINavigationController()
        window.rootViewController = navController
        
        navController?.viewControllers = [rateViewController!]
        
        let _ = rateViewController?.view
        let _ = navController?.view
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testViewControllerExists() {
        XCTAssertNotNil(rateViewController, "viewController should exist")
    }
    
    func testEventHandlerExists() {
        XCTAssertNotNil(rateViewController?.eventHandler, "eventHandler should exist")
    }
    
    func testDidTapNavigateToRecommendItem() {
        rateViewController?.didTapNavigateToRecommendItem()
        XCTAssertTrue(mockRateViewEventHandler.presentRecommendViewCalled)
        
    }

    func testTitleNameLabelOutlet() {
        XCTAssertNotNil(rateViewController?.titleNameLabel, "titleNameLabel should exist")
    }
    
    func testShowCurrentMovie() {
        let expect = expectation(description: "sets title name label")

        rateViewController?.showCurrentMovie(title: "testTitle2", photoUrl: "testURL", completion: {
            () -> Void in
            XCTAssertEqual(self.rateViewController?.titleNameLabel.text, "testTitle2", "title should equal testTitle")
            expect.fulfill()
        })
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectation timeout")
            }
        }
    }
}
