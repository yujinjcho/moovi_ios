//
//  MockRateDataManager.swift
//  MovieRecTests
//
//  Created by Yujin Cho on 10/21/17.
//  Copyright © 2017 Yujin Cho. All rights reserved.
//

import Foundation
@testable import MovieRec

class MockRateDataManager: RateDataManager {
    var storeRatingCalled : Bool = false
    var removeFirstMovieCalled : Bool = false
    var loadCurrentMovieCalled : Bool = false
    var loadRatingsCalled : Bool = false
    var loadMoviesCalled : Bool = false
    var getNewMoviesToRateCalled : Bool = false
    
    override var currentMovie : MovieModel? {
        return MovieModel(title: "test_movie", photoUrl: "http://www.test.com", movieId: "1")
    }
    
    override func storeRating(rating: String) {
        storeRatingCalled = true
    }
    
    override func removeFirstMovie() {
        removeFirstMovieCalled = true
    }
    

    override func loadRatings() {
        loadRatingsCalled = true
    }
    
    override func loadMovies(completion: @escaping (MovieModel) -> Void) {
        loadMoviesCalled = true
        if let movie = currentMovie {
            completion(movie)
        }
    }
    
    override func getNewMoviesToRate(completion: (() -> Void)? = nil) {
        getNewMoviesToRateCalled = true
    }
}
