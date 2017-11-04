//
//  RateDataManagerTest.swift
//  MovieRecTests
//
//  Created by Yujin Cho on 10/21/17.
//  Copyright © 2017 Yujin Cho. All rights reserved.
//

import XCTest
@testable import MovieRec

class RateDataManagerTest: XCTestCase {
    var dataManager = RateDataManager()
    var loadDataManager = RateDataManager()
    let fileManager = FileManager()
    var movieStoreURL : URL?
    var ratingStoreURL : URL?
    
    override func setUp() {
        super.setUp()
        setStorePath(dataManager: dataManager, moviePath: "testMovieStore", ratingPath: "testRatingStore")
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testLoadMovies() {
        XCTAssertEqual(dataManager.moviesToRate.count, 0, "should not have any to rate")
        let expect = expectation(description: "fetch 50 movies")

        dataManager.loadMovies(completion: { (currentMovie: MovieModel) -> Void in
            XCTAssert(self.dataManager.moviesToRate.count > 0, "should load movies")
            expect.fulfill()
        })
        
        waitForExpectations(timeout: 3) { error in
            if let error = error {
                XCTFail("waitForExpectation timeout")
            }
        }
    }
    
    func testRemoveFirstMovie() {
        let movie = MovieModel(title: "test_movie", photoUrl: "http://www.test.com", movieId: "1")
        dataManager.moviesToRate = [movie]
        XCTAssertEqual(dataManager.moviesToRate.count, 1)
        dataManager.removeFirstMovie()
        XCTAssertEqual(dataManager.moviesToRate.count, 0, "should remove the Movie")
    }
    
    func testloadCurrentMovie() {
        let movie = MovieModel(title: "test_movie", photoUrl: "http://www.test.com", movieId: "1")
        dataManager.moviesToRate = [movie]
    
        if let currentMovie = dataManager.currentMovie {
            XCTAssertEqual(currentMovie.title, movie.title, "titles should be equal")
            XCTAssertEqual(currentMovie.photoUrl, movie.photoUrl, "photoUrls should be equal")
            XCTAssertEqual(currentMovie.movieId, movie.movieId, "movieIds should be equal")
        } else {
            XCTFail("Should return a movie")
        }
    }
    
    func testLoadCurrentUser() {
        XCTAssertNotNil(dataManager.currentUser, "should have a user")
    }
    
    func testStoreRating() {
        let movie = MovieModel(title: "test_movie", photoUrl: "http://www.test.com", movieId: "1")
        dataManager.moviesToRate = [movie]
        dataManager.storeRating(rating: "1")
        XCTAssertEqual(dataManager.ratings.count, 1, "Should have one rating now")
    }
    
    func testloadRatings() {
        XCTAssertEqual(dataManager.ratings.count, 0, "should not have any ratings initially")
        let ratingsStore = [RatingStore(movieID: "2", rating: "1", userID: "1")]
        if let ratingStoreURL = ratingStoreURL {
            NSKeyedArchiver.archiveRootObject(ratingsStore, toFile: ratingStoreURL.path)
        }
        dataManager.loadRatings()
        XCTAssertEqual(dataManager.ratings.count, 1, "should have 1 rating")
    }
    
    func testGetNewMoviesToRate() {
        XCTAssertEqual(dataManager.ratings.count, 0, "should not have any ratings initially")

        let expect = expectation(description: "fetch movies")
        dataManager.getNewMoviesToRate(completion: {
            () -> Void in
            XCTAssertEqual(self.dataManager.moviesToRate.count, 25, "should fetch 25 movies")
            expect.fulfill()
        })

        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail("waitForExpectation timeout")
            }
        }
    }
    
    private func setStorePath(dataManager: RateDataManager, moviePath: String, ratingPath: String) {
        let DocumentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let movieArchiveURL = DocumentsDirectory.appendingPathComponent(moviePath)
        let ratingArchiveURL = DocumentsDirectory.appendingPathComponent(ratingPath)
        
        movieStoreURL = movieArchiveURL
        ratingStoreURL = ratingArchiveURL
        
        if let movieStoreURL = movieStoreURL, let ratingStoreURL = ratingStoreURL {
            dataManager.moviesStorePath = movieStoreURL.path
            dataManager.ratingsStorePath = ratingStoreURL.path
        }
    }
}
