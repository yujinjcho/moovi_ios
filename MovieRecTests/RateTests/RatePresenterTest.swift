//
//  RatePresenterTest.swift
//  MovieRecTests
//
//  Created by Yujin Cho on 10/21/17.
//  Copyright © 2017 Yujin Cho. All rights reserved.
//

import XCTest
@testable import MovieRec

class RatePresenterTest: XCTestCase {
    var presenter: RatePresenter = RatePresenter()
    var interactor: MockRateInteractor?
    var interface: MockRateViewInterface = MockRateViewInterface()
    
    override func setUp() {
        super.setUp()
        let dataManager: RateDataManager = RateDataManager()
        interactor = MockRateInteractor(dataManager: dataManager)
        presenter.rateInteractor = interactor
        presenter.userInterface = interface
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testloadedView() {
        presenter.loadedView()
        if let interactor = interactor {
            XCTAssertTrue(interactor.initializeDataManagerCalled)
        } else {
            XCTFail("interactor should be initialized")
        }
    }
    
    func testProcessRating() {
        let rating = "1"
        presenter.processRating(ratingType: rating)
        if let interactor = interactor {
            XCTAssertTrue(interactor.processRatingCalled, "should call processRating")
        } else {
            XCTFail("interactor should be initialized")
        }
    }
    
    func testThatPresentCurrentMovieCallsShowCurrentMovie() {
        let movie = Movie(title: "test_movie", photoUrl: "http://www.test.com", movieId: "1")
        presenter.presentCurrentMovie(currentMovie: movie)
        XCTAssertTrue(interface.presentCurrentMovieCalled, "should call presentCurrentMovie")
    }
    
    func testPresentRecommendView() {
        XCTFail("test this")
    }
}
