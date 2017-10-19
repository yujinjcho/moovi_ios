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
    var prefetcher: ImagePrefetcher?
    let host = "https://movie-rec-project.herokuapp.com"
    let defaultUser = "test_user_03"
    
    override init() {
        super.init()
        //maybe we should be loading the movies from here
        //keep the loadmovies generic because will need to use in the future
        loadRatingsFromDisk()
    }
    
    func loadMovies(completion: @escaping (MovieModel) -> Void) {
        let moviesFromDisk = loadMoviesFromDisk()
        if let moviesFromDisk = moviesFromDisk, moviesFromDisk.count > 0 {
            moviesToRate = moviesFromDisk.map { MovieModel(title:$0.title, photoUrl:$0.photoUrl, movieId:$0.movieId) }
            print("Loaded \(moviesToRate.count) from disk")
            completion(loadCurrentMovie()!)
        } else {
            print("making api call to get movies")
            let url = "\(host)/api/start"
            NetworkManager.getRequest(endPoint: url, completionHandler: storeFetchedMovies(completion: completion))
        }
    }
    
    func loadRatingsFromDisk() {
        let loadedRatings = NSKeyedUnarchiver.unarchiveObject(withFile: RatingStore.ArchiveURL.path) as? [RatingStore]
        if let loadedRatings = loadedRatings {
            ratings = loadedRatings.map { RatingModel(movieID: $0.movieID, rating: $0.rating, userID: $0.userID) }
        }
    }
    
    func storeRating(rating: String) {
        let currentMovie = loadCurrentMovie()
        let currentUser = loadCurrentUser()
        if let currentMovie = currentMovie {
            let rating = RatingModel(movieID: currentMovie.movieId, rating: rating, userID: currentUser)
            ratings.append(rating)
            saveRatings()
        }
        
        //
    }
//
//    struct RatingModel {
//        let movieID : String
//        let rating : String
//        let userID : String
//    }

    
    func loadCurrentMovie() -> MovieModel? {
        if (moviesToRate.count > 0) {
            return moviesToRate.first
        }
        return nil
    }
    
    func loadCurrentUser() -> String {
        if let userID = UserDefaults.standard.string(forKey: "userID") {
            return userID
        }   else {
            return defaultUser
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
    
    private func loadMoviesFromDisk() -> [MovieStore]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: MovieStore.ArchiveURL.path) as? [MovieStore]
    }
    
//    init(movieID: String, rating: String, userID: String) {
//        self.movieID = movieID
//        self.rating = rating
//        self.userID = userID
//    }
    
    func saveRatings() {
        let ratingsStore = ratings.map { RatingStore(movieID: $0.movieID, rating: $0.rating, userID: $0.userID) }
        NSKeyedArchiver.archiveRootObject(ratingsStore, toFile: RatingStore.ArchiveURL.path)
    }
    
    func storeFetchedMovies(completion: @escaping (MovieModel) -> Void) -> ((Data) -> Void) {
        func storeFetchedMoviesHelper(data: Data) -> Void {
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [[String: String]] {
                let newMovies = responseJSON.map {
                    (movieToRate: [String: String]) -> MovieStore in
                    let movieTitle = movieToRate["title"]!
                    let movieId = movieToRate["movieId"]!
                    let photoUrl = movieToRate["photoUrl"]!
                    return MovieStore(title: movieTitle, movieId: movieId, photoUrl: photoUrl)
                }
                NSKeyedArchiver.archiveRootObject(newMovies, toFile: MovieStore.ArchiveURL.path)
                loadMovies(completion: completion)
            }
        }
        return storeFetchedMoviesHelper
    }
    
}
