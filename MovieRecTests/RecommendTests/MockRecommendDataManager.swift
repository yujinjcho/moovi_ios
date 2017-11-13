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

    override func fetchRatings() -> [RatingModel] {
        fetchRatingsCalled = true
        let testRating = RatingModel(movieID: "test", rating: "1", userID: "testUser")
        return [testRating]
    }
    
//    override func uploadRatings(ratings: [RatingModel], @escaping completion: () -> Void) {
//
//    }
    override func uploadRatings(ratings: [RatingModel], completion: @escaping (String) -> Void) {
        uploadRatingsCalled = true
    }
    
    override func fetchJobStatus(jobID: String, completion: @escaping (Data) -> Void) {
        fetchJobStatusCalled = true
    }
    
//    override var currentMovie : MovieModel? {
//        return MovieModel(title: "test_movie", photoUrl: "http://www.test.com", movieId: "1")
//    }
//
//    override func storeRating(rating: String) {
//        storeRatingCalled = true
//    }
//
//    override func removeFirstMovie() {
//        removeFirstMovieCalled = true
//    }
//
//
//    override func loadRatings() {
//        loadRatingsCalled = true
//    }
//
//    override func loadMovies(completion: @escaping (MovieModel) -> Void) {
//        loadMoviesCalled = true
//        if let movie = currentMovie {
//            completion(movie)
//        }
//    }
//
//    override func getNewMoviesToRate(completion: (() -> Void)? = nil) {
//        getNewMoviesToRateCalled = true
//    }
}
