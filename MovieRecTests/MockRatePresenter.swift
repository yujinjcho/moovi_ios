//
//  MockRatePresenter.swift
//  MovieRecTests
//
//  Created by Yujin Cho on 10/21/17.
//  Copyright © 2017 Yujin Cho. All rights reserved.
//

import Foundation
@testable import MovieRec

class MockRatePresenter : RateInteractorOutput {
    var presentCurrentMovieCalled: Bool = false
    
    func presentCurrentMovie(currentMovie: MovieModel) {
        presentCurrentMovieCalled = true
    }
}

//protocol RateInteractorOutput {
//    func presentCurrentMovie(currentMovie: MovieModel)
//}

//class RatePresenter : NSObject, RateModuleInterface, RateInteractorOutput,
//RecommendModuleDelegate {
//    var rateInteractor : RateInteractorInput?
//    var rateWireframe : RateWireFrame?
//    var userInterface : RateViewInterface?
//
//    func loadedView() {
//        rateInteractor?.initializeDataManager()
//    }
//
//    func processRating(ratingType: String) {
//        rateInteractor?.storeRating(ratingType: ratingType)
//    }
//
//    func presentCurrentMovie(currentMovie: MovieModel) {
//        userInterface?.showCurrentMovie(title: currentMovie.title, photoUrl: currentMovie.photoUrl)
//    }
//}
