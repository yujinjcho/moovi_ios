//
//  RecommendPresenterTest.swift
//  MovieRecTests
//
//  Created by Yujin Cho on 10/30/17.
//  Copyright © 2017 Yujin Cho. All rights reserved.
//

import XCTest
import SwiftyJSON
@testable import MovieRec

class RecommendPresenterTest: XCTestCase {
    var presenter = RecommendPresenter()
    var interactor = MockRecommendInteractor()
    var interface: MockRecommendViewInterface = MockRecommendViewInterface()
    
    override func setUp() {
        super.setUp()
        presenter.recommendInteractor = interactor
        presenter.userInterface = interface
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testUpdateView() {
        presenter.updateView()
        XCTAssertTrue(interactor.refreshRecommendationsCalled, "should call refreshRecommendations")
    }
    
    func testShowNewRecommendations() {
        let data = JSON(["status":"completed"])
        presenter.showNewRecommendations(data: data)
        XCTAssertTrue(interface.refreshTableCalled, "should call refreshTable")
    }
}
