//
//  MockRateModuleInterface.swift
//  MovieRecTests
//
//  Created by Yujin Cho on 10/21/17.
//  Copyright © 2017 Yujin Cho. All rights reserved.
//

import Foundation
@testable import MovieRec

class MockRateViewInterface : RateViewInterface {
    var presentCurrentMovieCalled : Bool = false
    var processRatingCalled : Bool = false
    
    func showCurrentMovie(title: String, photoUrl: String) {
        presentCurrentMovieCalled = true
    }
}
