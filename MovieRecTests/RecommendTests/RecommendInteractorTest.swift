//
//  RecommendInteractorTest.swift
//  MovieRecTests
//
//  Created by Yujin Cho on 11/6/17.
//  Copyright © 2017 Yujin Cho. All rights reserved.
//

import XCTest
import SwiftyJSON
@testable import MovieRec

class RecommendInteractorTest: XCTestCase {
    let recommendDataManager = MockRecommendDataManager()
    let recommendInteractor = RecommendInteractor()
    let recommendPresenter = MockRecommendPresenter()
    
    override func setUp() {
        super.setUp()
        recommendInteractor.recommendDataManager = recommendDataManager
        recommendInteractor.output = recommendPresenter
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testRefreshRecommendations() {
        recommendInteractor.refreshRecommendations()
        XCTAssertTrue(recommendDataManager.fetchRatingsCalled, "should call fetchRatings")
        XCTAssertTrue(recommendDataManager.uploadRatingsCalled, "should call uploadRatings")
    }
    
    func testStartPolling() {
        recommendInteractor.startPolling(jobID: "test123")
        XCTAssertNotNil(recommendInteractor.timer, "timer should not be null")
        sleep(7)
        XCTAssertTrue(recommendDataManager.fetchJobStatusCalled)
    }
    
    func testCheckJobStatus() {
        recommendInteractor.checkJobStatus(data: Data())
    XCTAssertFalse(recommendPresenter.showNewRecommendationsCalled, "showNewRecommendations should not be called")
        
        let jobStatus = JSON(["status":"completed", "results":["1","2"]])
        let optData = try? jobStatus.rawData()
        guard let data = optData else {
            return
        }
        recommendInteractor.checkJobStatus(data: data)
        XCTAssertTrue(recommendPresenter.showRecommendationsCalled, "showNewRecommendations should be called")
    }
}
