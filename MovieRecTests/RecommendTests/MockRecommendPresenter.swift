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
    
    func showNewRecommendations(data: JSON) {
        showNewRecommendationsCalled = true
    }
}
