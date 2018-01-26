//
//  RateInteractorTest.swift
//  MovieRecTests
//
//  Created by Yujin Cho on 10/21/17.
//  Copyright © 2017 Yujin Cho. All rights reserved.
//

import XCTest
@testable import MovieRec

class RateInteractorTest: XCTestCase {
    
    var dataManager = MockRateDataManager()
    var interactor : RateInteractor?
    var output = MockRateInteractorOutput()
    
    override func setUp() {
        super.setUp()
        interactor = RateInteractor(dataManager: dataManager)
        if let interactor = interactor {
            interactor.output = output
        } else {
            XCTFail("interactor should be initialized")
        }
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testStoreRating() {
        if let interactor = interactor {
            interactor.storeRating(ratingType: "1")
            XCTAssertTrue(dataManager.storeRatingCalled, "should call storeRating")
            XCTAssertTrue(dataManager.removeFirstMovieCalled, "should call removeFirstMovie")
            XCTAssertTrue(output.presentCurrentMovieCalled, "should call presentCurrentMovie")
            
        } else {
            XCTFail("interactor should be initialized")
        }
    }
    
    func testShowCurrentMovie() {
        let movie = Movie(title: "test_movie", photoUrl: "http://www.test.com", movieId: "1", createdDate: Date())
        if let interactor = interactor {
            interactor.showCurrentMovie(currentMovie: movie)
            XCTAssertTrue(output.presentCurrentMovieCalled, "should call presentCurrentMovie")
        } else {
            XCTFail("interactor should be initialized")
        }
    }
    
    func testInitializeDataManager() {
        if let interactor = interactor {
            interactor.initializeDataManager()
            XCTAssertTrue(dataManager.loadRatingsCalled, "should call loadRatings")
            XCTAssertTrue(dataManager.loadMoviesCalled, "should call loadMovies")
            XCTAssertTrue(output.presentCurrentMovieCalled, "should call presentCurrentMovie")
        } else {
            XCTFail("interactor should be initialized")
        }
    }
    
    func testFetchNewMovies() {
        if let interactor = interactor {
            interactor.fetchNewMovies()
            XCTAssertTrue(dataManager.getNewMoviesToRateCalled)
        } else {
            XCTFail("interactor should be initialized")
        }
    }
}
