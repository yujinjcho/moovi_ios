//
//  MockRateViewEventHandler.swift
//  MovieRecTests
//
//  Created by Yujin Cho on 10/30/17.
//  Copyright © 2017 Yujin Cho. All rights reserved.
//

import Foundation
import UIKit
@testable import MovieRec

class MockRateViewEventHandler : RateModuleInterface {
    var loadedViewCalled = false
    var processRatingCalled = false
    var presentRecommendViewCalled = false
    
    func loadedView() {
        loadedViewCalled = true
    }
    
    func processRating(ratingType: String) {
        processRatingCalled = true
    }
    
    func presentRecommendView(navigationController: UINavigationController) {
        presentRecommendViewCalled = true
    }
}
