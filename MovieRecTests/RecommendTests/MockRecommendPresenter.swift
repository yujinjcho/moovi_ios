//
//  MockRecommendPresenter.swift
//  MovieRecTests
//
//  Created by Yujin Cho on 11/6/17.
//  Copyright © 2017 Yujin Cho. All rights reserved.
//

import Foundation
import SwiftyJSON
@testable import MovieRec

class MockRecommendPresenter : RecommendInteractorOutput {
    var showNewRecommendationsCalled: Bool = false
    var showRecommendationsCalled: Bool = false
    
    func showRecommendations(recommendations: [Recommendation]) {
        showRecommendationsCalled = true
    }

    func showNewRecommendations(data: JSON) {
        showNewRecommendationsCalled = true
    }
}
