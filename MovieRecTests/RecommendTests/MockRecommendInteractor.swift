//
//  MockRecommendInteractor.swift
//  MovieRecTests
//
//  Created by Yujin Cho on 10/30/17.
//  Copyright © 2017 Yujin Cho. All rights reserved.
//

import Foundation
@testable import MovieRec

class MockRecommendInteractor : RecommendInteractor {
    var refreshRecommendationsCalled : Bool = false
    
    override func refreshRecommendations() {
        refreshRecommendationsCalled = true
    }
}
