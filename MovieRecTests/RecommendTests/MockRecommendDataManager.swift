//
//  MockRecommendDataManager.swift
//  MovieRecTests
//
//  Created by Yujin Cho on 11/6/17.
//  Copyright © 2017 Yujin Cho. All rights reserved.
//

import Foundation
@testable import MovieRec

class MockRecommendDataManager: RecommendDataManager {
    var fetchRatingsCalled : Bool = false
    var uploadRatingsCalled : Bool = false
    var fetchJobStatusCalled : Bool = false

    override func fetchRatings() -> [Rating] {
        fetchRatingsCalled = true
        let testRating = Rating(movieID: "test", rating: "1", userID: "testUser")
        return [testRating]
    }
    
    override func uploadRatings(ratings: [Rating], completion: @escaping (String) -> Void) {
        uploadRatingsCalled = true
    }
    
    override func fetchJobStatus(jobID: String, completion: @escaping (Data) -> Void) {
        fetchJobStatusCalled = true
    }
}
