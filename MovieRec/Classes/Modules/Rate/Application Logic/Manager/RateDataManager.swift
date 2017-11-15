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
    var networkManager : NetworkManagerFactory?
    var moviesToRate = [MovieModel]()
    var ratings = [RatingModel]()
    var moviesStorePath = MovieStore.ArchiveURL.path
    var ratingsStorePath = RatingStore.ArchiveURL.path
    var prefetcher: ImagePrefetcher?
    let host = "https://movie-rec-project.herokuapp.com"
    let defaultUser = "test_user_03"
    
    var movieCounts: Int { return moviesToRate.count }
    var currentUser: String {
        if let userID = UserDefaults.standard.string(forKey: "userID") {
            return userID
        }   else {
            return defaultUser
        }
    }
    var currentMovie: MovieModel? {
        if (moviesToRate.count > 0) {
            return moviesToRate.first
        }
        return nil
    }
    
    override init() {
        super.init()
        //saveCurrentRatingsToDisk(path: ratingsStorePath)
        //saveCurrentMoviesStateToDisk(path: moviesStorePath)
    }
    
    func loadMovies(completion: @escaping (MovieModel) -> Void) {
        
        let moviesFromDisk = loadMoviesFromDisk(path: moviesStorePath)
        if let moviesFromDisk = moviesFromDisk, moviesFromDisk.count > 0 {
            moviesToRate = moviesFromDisk.map { MovieModel(title:$0.title, photoUrl:$0.photoUrl, movieId:$0.movieId) }
            completion(currentMovie!)
        } else {
            print("Making API Call")
            let url = "\(host)/api/start"
            if let networkManager = networkManager {
                networkManager.getRequest(endPoint: url) {
                    (data: Data) -> Void in
                    if let newMovies = self.convertJSONtoMovies(data: data) {
                        self.moviesToRate = newMovies.map { MovieModel(title:$0.title, photoUrl:$0.photoUrl, movieId:$0.movieId) }
                        self.saveCurrentMoviesStateToDisk(path: self.moviesStorePath)
                        completion(self.currentMovie!)
                    }
                }
            }
        }
    }
    
    func storeRating(rating: String) {
        if let currentMovie = currentMovie {
            let rating = RatingModel(movieID: currentMovie.movieId, rating: rating, userID: currentUser)
            ratings.append(rating)
            saveCurrentRatingsToDisk(path: ratingsStorePath)
        }
    }
    
    func removeFirstMovie() {
        if (moviesToRate.count > 0) {
            moviesToRate.remove(at: 0)
            print("movies length is now \(moviesToRate.count)")
            saveCurrentMoviesStateToDisk(path: moviesStorePath)
        }
    }

    func loadRatings() {
        if let ratingsFromDisk = loadRatingsFromDisk(path: ratingsStorePath) {
            ratings = ratingsFromDisk.map { RatingModel(movieID: $0.movieID, rating: $0.rating, userID: $0.userID) }
        } else {
            return
        }
    }
    
    func getNewMoviesToRate() {
        let url = "\(host)/api/refresh"
        let postData = formatUploadDataForMovieFetch()
        
        if let networkManager = networkManager {
            networkManager.postRequest(endPoint: url, postData: postData, completionHandler: {
                (data:Data)->Void in
                if let newMovies = self.convertJSONtoMovies(data: data) {
                    let moviesToAdd = newMovies.map { MovieModel(title:$0.title, photoUrl:$0.photoUrl, movieId:$0.movieId) }
                    self.moviesToRate += moviesToAdd
                    self.saveCurrentMoviesStateToDisk(path: self.moviesStorePath)
                    self.startImagePrefetcher(urls: moviesToAdd.map { $0.photoUrl })
                }
            })
        }
    }
    
    private func startImagePrefetcher(urls: [String]) {
        let urls = urls.map { URL(string: $0)! }
        prefetcher = ImagePrefetcher(urls: urls) {
            skippedResources, failedResources, completedResources in
        }
        if let prefetcher = prefetcher {
            prefetcher.start()
        }
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
    
    private func saveCurrentMoviesStateToDisk(path: String) {
        let moviesStore = moviesToRate.map { MovieStore(title: $0.title, movieId: $0.movieId, photoUrl: $0.photoUrl) }
        NSKeyedArchiver.archiveRootObject(moviesStore, toFile: path)
    }
    
    private func formatUploadDataForMovieFetch() -> [String: Any] {
        let uploadRatings = ratings.map { ["movie_id": $0.movieID, "rating": $0.rating] }
        let unratedMovies = moviesToRate.map { $0.movieId }
        return [
            "user_id": currentUser,
            "ratings": uploadRatings,
            "not_rated_movies": unratedMovies
        ]
        
    }
}
