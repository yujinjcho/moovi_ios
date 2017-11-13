//
//  RecommendViewControllerTest.swift
//  MovieRecTests
//
//  Created by Yujin Cho on 11/6/17.
//  Copyright © 2017 Yujin Cho. All rights reserved.
//

import XCTest
@testable import MovieRec


class RecommendViewControllerTest: XCTestCase {
    
    var recommendViewController: RecommendViewController?
    var mockRecommendEventHandler = MockRecommendEventHandler()
    var navController: UINavigationController?
    
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(withIdentifier: "RecommendViewController") as! RecommendViewController
        viewController.eventHandler = mockRecommendEventHandler
        recommendViewController = viewController
        
        let window = UIWindow()
        navController = UINavigationController()
        window.rootViewController = navController
        
        navController?.viewControllers = [recommendViewController!]

        let _ = recommendViewController?.view
        let _ = navController?.view
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testViewControllerExists() {
        XCTAssertNotNil(recommendViewController, "viewController should exist")
    }
    
    func testEventHandlerExists() {
        XCTAssertNotNil(recommendViewController?.eventHandler, "eventHandler should exist")
    }
    
    func testRefreshTable() {
        let testRecommendations = ["Rec1", "Rec2"]
        
        recommendViewController?.refreshTable(newRecommendations: testRecommendations)
        let title = recommendViewController?.recommendations[0]
        XCTAssertEqual(title, "Rec1", "titles should equal in table")
        
        // How do I test viewController.tableView.reloadData ? 
    }

    func testDidTapRefreshButton() {
        recommendViewController?.didTapRefreshButton()
        XCTAssertTrue(mockRecommendEventHandler.updateViewCalled, "should call updateView")
    }
    
}
