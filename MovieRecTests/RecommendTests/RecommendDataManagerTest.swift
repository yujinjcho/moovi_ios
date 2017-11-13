//
//  RecommendDataManager.swift
//  MovieRecTests
//
//  Created by Yujin Cho on 11/6/17.
//  Copyright © 2017 Yujin Cho. All rights reserved.
//

import XCTest
@testable import MovieRec

class RecommendDataManagerTest: XCTestCase {
    let mockRateDataManager = MockRateDataManagerForRecommendDM()
    let recommendDataManager = RecommendDataManager()
    
    override func setUp() {
        super.setUp()
        recommendDataManager.rateDataManager = mockRateDataManager

    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testFetchRatings() {
        mockRateDataManager.ratings = [RatingModel(movieID: "testMovie", rating: "1", userID: "testUser")]
        
        let ratings = recommendDataManager.fetchRatings()
        XCTAssertEqual(ratings.count, 1, "should return 1 rating")
        XCTAssertEqual(ratings[0].movieID, "testMovie", "rating should be equal to 'testMovie'")
    }


    
    func testFetchJobStatus() {
        XCTFail("test fetchJobStatus")
        //TODO: use network manager object instead of static class
        // then you can just check if methods have been called
        
        //TODO: refactor in other data manager
    }
//
//    func testUploadRatings() {
//        XCTFail("test uploadRatings")
//    }
//    
//    func testFormatPostData() {
//        XCTFail("test formatPostData")
//    }
    
}
