//
//  MockRateInteractor.swift
//  MovieRecTests
//
//  Created by Yujin Cho on 10/21/17.
//  Copyright © 2017 Yujin Cho. All rights reserved.
//

import Foundation
@testable import MovieRec

class MockRateInteractor : RateInteractor {
    var initializeMovieCalled : Bool = false
    var processRatingCalled : Bool = false
    
    override func initializeMovies() {
        initializeMovieCalled = true
    }
    
    override func storeRating(ratingType: String) {
        processRatingCalled = true
    }
}
