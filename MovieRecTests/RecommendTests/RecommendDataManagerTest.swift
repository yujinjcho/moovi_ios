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
    let mockNetworkManager = MockNetworkManager()
    
    override func setUp() {
        super.setUp()
        recommendDataManager.rateDataManager = mockRateDataManager
        recommendDataManager.networkManager = mockNetworkManager
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testFetchRatings() {
        mockRateDataManager.ratings = [Rating(movieID: "testMovie", rating: "1", userID: "testUser")]
        
        let ratings = recommendDataManager.fetchRatings()
        XCTAssertEqual(ratings.count, 1, "should return 1 rating")
        XCTAssertEqual(ratings[0].movieID, "testMovie", "rating should be equal to 'testMovie'")
    }
    
    func testFetchJobStatus() {
        XCTAssertFalse(mockNetworkManager.getRequestCalled, "getRequest should not be called yet")
        recommendDataManager.fetchJobStatus(jobID: "testJobId1", completion: {_ in})
        XCTAssertTrue(mockNetworkManager.getRequestCalled, "getRequest should be called")
        
    }

    func testUploadRatings() {
        XCTAssertFalse(mockNetworkManager.postRequestCalled, "should not have called postRequest yet")
        let testRatings = [Rating(movieID: "testUpload", rating: "1", userID: "testUser")]
        recommendDataManager.uploadRatings(ratings: testRatings, completion:{_ in})
        XCTAssertTrue(mockNetworkManager.postRequestCalled, "should have called postRequest")
    }
    
    func testFormatPostData() {
        let testRatings = [Rating(movieID: "testUpload", rating: "1", userID: "testUser")]
        let uploadData = recommendDataManager.formatPostData(ratings: testRatings)
        XCTAssertNotNil(uploadData["user_id"], "result should have a user id")
        XCTAssertNotNil(uploadData["ratings"], "result should have a ratings")
        let uploadRatings = uploadData["ratings"] as? [[String: String]]
        
        if let uploadRatings = uploadRatings {
            XCTAssertEqual(uploadRatings[0]["movie_id"]!, "testUpload", "movieID should be 'testUpload'")
        } else {
            XCTFail("should unpack ratings")
        }
    }
}
