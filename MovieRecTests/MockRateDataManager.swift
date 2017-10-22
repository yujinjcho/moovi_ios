//
//  MockRateDataManager.swift
//  MovieRecTests
//
//  Created by Yujin Cho on 10/21/17.
//  Copyright © 2017 Yujin Cho. All rights reserved.
//

import Foundation
@testable import MovieRec

class MockRateDataManager: RateDataManager {
    var storeRatingCalled : Bool = false
    var removeFirstMovieCalled : Bool = false
    var loadCurrentMovieCalled : Bool = false
    var loadRatingsCalled : Bool = false
    var loadMoviesCalled : Bool = false
    
    override func storeRating(rating: String) {
        storeRatingCalled = true
    }
    
    override func removeFirstMovie() {
        removeFirstMovieCalled = true
    }
    
    override func loadCurrentMovie() -> MovieModel? {
        let movie = MovieModel(title: "test_movie", photoUrl: "http://www.test.com", movieId: "1")
        loadCurrentMovieCalled = true
        return movie
    }
    
    override func loadRatings() {
        loadRatingsCalled = true
    }
    
    override func loadMovies(completion: @escaping (MovieModel) -> Void) {
        loadMoviesCalled = true
        let movie = loadCurrentMovie()
        if let movie = movie {
            completion(movie)
        }
        //completion(currentMovie:)
    }
}

//func loadMovies(completion: @escaping (MovieModel) -> Void) {
//
//    let moviesFromDisk = loadMoviesFromDisk(path: moviesStorePath)
//    if let moviesFromDisk = moviesFromDisk, moviesFromDisk.count > 0 {
//        moviesToRate = moviesFromDisk.map { MovieModel(title:$0.title, photoUrl:$0.photoUrl, movieId:$0.movieId) }
//        print("Loaded \(moviesToRate.count) movie from disk")
//        completion(loadCurrentMovie()!)
//    } else {
//        print("making api call to get movies")
//        let url = "\(host)/api/start"
//        NetworkManager.getRequest(endPoint: url, completionHandler: storeFetchedMovies(completion: completion))
//    }
//}
//
//func storeRating(rating: String) {
//    let currentMovie = loadCurrentMovie()
//    let currentUser = loadCurrentUser()
//    if let currentMovie = currentMovie {
//        let rating = RatingModel(movieID: currentMovie.movieId, rating: rating, userID: currentUser)
//        ratings.append(rating)
//        print("Ratings size is now \(ratings.count)")
//
//        saveCurrentRatingsToDisk(path: ratingsStorePath)
//    }
//}
//
//func loadCurrentMovie() -> MovieModel? {
//    if (moviesToRate.count > 0) {
//        return moviesToRate.first
//    }
//    return nil
//}
//
//func removeFirstMovie() {
//    if (moviesToRate.count > 0) {
//        moviesToRate.remove(at: 0)
//        print("movies length is now \(moviesToRate.count)")
//        saveCurrentMoviesStateToDisk()
//    }
//}
//
//func loadCurrentUser() -> String {
//    if let userID = UserDefaults.standard.string(forKey: "userID") {
//        return userID
//    }   else {
//        return defaultUser
//    }
//}
//
//func loadRatings() {
//    if let ratingsFromDisk = loadRatingsFromDisk(path: ratingsStorePath) {
//        ratings = ratingsFromDisk.map { RatingModel(movieID: $0.movieID, rating: $0.rating, userID: $0.userID) }
//        print("loaded \(ratings.count) from disk")
//    } else {
//        print("Could not unpack ratings from disk")
//        return
//    }
//}

