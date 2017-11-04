//
//  MockRatePresenter.swift
//  MovieRecTests
//
//  Created by Yujin Cho on 10/21/17.
//  Copyright © 2017 Yujin Cho. All rights reserved.
//

import Foundation
@testable import MovieRec

class MockRateInteractorOutput : RateInteractorOutput {
    var presentCurrentMovieCalled: Bool = false
    
    func presentCurrentMovie(currentMovie: MovieModel) {
        presentCurrentMovieCalled = true
    }
}
