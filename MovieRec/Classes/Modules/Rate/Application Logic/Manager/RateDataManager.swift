//
//  RateDataManager.swift
//  MovieRec
//
//  Created by Yujin Cho on 10/8/17.
//  Copyright © 2017 Yujin Cho. All rights reserved.
//

import os.log
import Foundation
import CloudKit
import Kingfisher

class RateDataManager : NSObject {
    var moviesToRate = [MovieModel]()
    var ratings = [RatingModel]()
    var moviesStorePath = MovieStore.ArchiveURL.path
    var ratingsStorePath = RatingStore.ArchiveURL.path
    var prefetcher: ImagePrefetcher?
    let host = "https://movie-rec-project.herokuapp.com"
    let defaultUser = "test_user_03"
    
    //var movieCounts: Int { return moviesToRate.count }
    
    override init() {
        super.init()
    }
    
    // fetch new movies
    
    func loadMovies(completion: @escaping (MovieModel) -> Void) {
        
        let moviesFromDisk = loadMoviesFromDisk(path: moviesStorePath)
        if let moviesFromDisk = moviesFromDisk, moviesFromDisk.count > 0 {
            moviesToRate = moviesFromDisk.map { MovieModel(title:$0.title, photoUrl:$0.photoUrl, movieId:$0.movieId) }
            print("Loaded \(moviesToRate.count) movie from disk")
            completion(loadCurrentMovie()!)
        } else {
            print("making api call to get movies")
            let url = "\(host)/api/start"
            NetworkManager.getRequest(endPoint: url, completionHandler: storeFetchedMovies(completion: completion))
        }
    }
    
    func storeRating(rating: String) {
        let currentMovie = loadCurrentMovie()
        let currentUser = loadCurrentUser()
        if let currentMovie = currentMovie {
            let rating = RatingModel(movieID: currentMovie.movieId, rating: rating, userID: currentUser)
            ratings.append(rating)
            print("Ratings size is now \(ratings.count)")
            
            saveCurrentRatingsToDisk(path: ratingsStorePath)
        }
    }
    
    func loadCurrentMovie() -> MovieModel? {
        if (moviesToRate.count > 0) {
            return moviesToRate.first
        }
        return nil
    }
    
    func removeFirstMovie() {
        if (moviesToRate.count > 0) {
            moviesToRate.remove(at: 0)
            print("movies length is now \(moviesToRate.count)")
            saveCurrentMoviesStateToDisk()
        }
    }
    
    func loadCurrentUser() -> String {
        if let userID = UserDefaults.standard.string(forKey: "userID") {
            return userID
        }   else {
            return defaultUser
        }
    }
    
    func loadRatings() {
        if let ratingsFromDisk = loadRatingsFromDisk(path: ratingsStorePath) {
            ratings = ratingsFromDisk.map { RatingModel(movieID: $0.movieID, rating: $0.rating, userID: $0.userID) }
            print("loaded \(ratings.count) from disk")
        } else {
            print("Could not unpack ratings from disk")
            return
        }
    }
    
    private func startImagePrefetcher(urls: [String]) {
        let urls = urls.map { URL(string: $0)! }
        prefetcher = ImagePrefetcher(urls: urls) {
            skippedResources, failedResources, completedResources in
            print("These resources are prefetched: \(completedResources)")
        }
        if let prefetcher = prefetcher {
            prefetcher.start()
        }
    }

    // define callback that will append new movies
    
    private func storeFetchedMovies(completion: @escaping (MovieModel) -> Void) -> ((Data) -> Void) {
        func storeFetchedMoviesHelper(data: Data) -> Void {
            if let newMovies = convertJSONtoMovies(data: data) {
                NSKeyedArchiver.archiveRootObject(newMovies, toFile: MovieStore.ArchiveURL.path)
                moviesToRate = newMovies.map { MovieModel(title:$0.title, photoUrl:$0.photoUrl, movieId:$0.movieId) }
                completion(loadCurrentMovie()!)
            }
        }
        return storeFetchedMoviesHelper
    }
    
    private func convertJSONtoMovies(data: Data) -> [MovieStore]? {
        let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
        if let responseJSON = responseJSON as? [[String: String]] {
            let newMovies = responseJSON.map {
                (movieToRate: [String: String]) -> MovieStore in
                let movieTitle = movieToRate["title"]!
                let movieId = movieToRate["movieId"]!
                let photoUrl = movieToRate["photoUrl"]!
                return MovieStore(title: movieTitle, movieId: movieId, photoUrl: photoUrl)
            }
            return newMovies
        }
        return nil
    }
    
    private func loadRatingsFromDisk(path: String) -> [RatingStore]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: path) as? [RatingStore]
    }
    
    private func loadMoviesFromDisk(path: String) -> [MovieStore]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: path) as? [MovieStore]
    }
    
    private func saveCurrentRatingsToDisk(path: String) {
        let ratingsStore = ratings.map { RatingStore(movieID: $0.movieID, rating: $0.rating, userID: $0.userID) }
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(ratingsStore, toFile: path)
        if isSuccessfulSave {
            os_log("Ratings successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save ratings", log: OSLog.default, type: .error)
        }
    }
    
    private func saveCurrentMoviesStateToDisk() {
        let moviesStore = moviesToRate.map { MovieStore(title: $0.title, movieId: $0.movieId, photoUrl: $0.photoUrl) }
        NSKeyedArchiver.archiveRootObject(moviesStore, toFile: MovieStore.ArchiveURL.path)
        print("successfully saved movies")
    }
}
