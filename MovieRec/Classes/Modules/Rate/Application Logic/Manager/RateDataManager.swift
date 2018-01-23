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
    var networkManager : NetworkManager?
    var moviesToRate = [Movie]()
    var ratings = [Rating]()
    var moviesStorePath = MovieStore.ArchiveURL.path
    var ratingsStorePath = RatingStore.ArchiveURL.path
    var prefetcher: ImagePrefetcher?
    let host = "https://movie-rec.com"
    let defaultUser = "test_user_03"
    
    var movieCounts: Int { return moviesToRate.count }
    var currentUser: String {
        if let userID = UserDefaults.standard.string(forKey: "userID") {
            return userID
        }   else {
            return defaultUser
        }
    }
    var currentMovie: Movie? {
        if (moviesToRate.count > 0) {
            return moviesToRate.first
        }
        return nil
    }
    
    override init() {
        super.init()
//        saveCurrentRatingsToDisk(path: ratingsStorePath)
//        saveCurrentMoviesStateToDisk(path: moviesStorePath)
    }
    
    func loadMovies(completion: @escaping (Movie) -> Void) {
        
        func requestMovies(data:Data) -> Void {
            if let newMovies = self.convertJSONtoMovies(data: data) {
                self.moviesToRate = newMovies.map { Movie(title:$0.title, photoUrl:$0.photoUrl, movieId:$0.movieId, createdDate: $0.createdDate) }
                self.saveCurrentMoviesStateToDisk(path: self.moviesStorePath)
                self.startImagePrefetcher(urls: self.moviesToRate.map { $0.photoUrl })
                completion(self.currentMovie!)
            }
        }
        
        let moviesFromDisk = loadMoviesFromDisk(path: moviesStorePath)
        if let moviesFromDisk = moviesFromDisk, moviesFromDisk.count > 0 {
            moviesToRate = moviesFromDisk.map { Movie(title:$0.title, photoUrl:$0.photoUrl, movieId:$0.movieId, createdDate: $0.createdDate) }
            self.startImagePrefetcher(urls: moviesToRate.map { $0.photoUrl })
            completion(currentMovie!)
        } else {
            os_log("Loading Movies via API call", log: OSLog.default, type: .debug)
            let url = "\(host)/api/start"
            print(url)
            if let networkManager = networkManager {
                networkManager.getRequest(endPoint: url, completionHandler: requestMovies)
                //networkManager.getRequest(endPoint: url) {
//                    (data: Data) -> Void in
//                    if let newMovies = self.convertJSONtoMovies(data: data) {
//                        self.moviesToRate = newMovies.map { Movie(title:$0.title, photoUrl:$0.photoUrl, movieId:$0.movieId, createdDate: $0.createdDate) }
//                        self.saveCurrentMoviesStateToDisk(path: self.moviesStorePath)
//                        self.startImagePrefetcher(urls: self.moviesToRate.map { $0.photoUrl })
//                        completion(self.currentMovie!)
//                    }
                //}
            }
        }
    }
    
    
    
    func storeRating(rating: String) {
        if let currentMovie = currentMovie {
            let rating = Rating(movieID: currentMovie.movieId, rating: rating, userID: currentUser)
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
            ratings = ratingsFromDisk.map { Rating(movieID: $0.movieID, rating: $0.rating, userID: $0.userID) }
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
                if let fetchedMovies = self.convertJSONtoMovies(data: data) {
                    let moviesToAdd = self.selectMoviesToAdd(moviesToAdd:
                        fetchedMovies.map { Movie(title:$0.title, photoUrl:$0.photoUrl, movieId:$0.movieId, createdDate: $0.createdDate) }
                    )
                    self.moviesToRate += moviesToAdd
                    self.startImagePrefetcher(urls: self.moviesToRate.map { $0.photoUrl })
                    self.saveCurrentMoviesStateToDisk(path: self.moviesStorePath)
                }
            })
        }
    }
    
    private func selectMoviesToAdd(moviesToAdd: [Movie]) -> [Movie] {
        let movieIds = Set(self.moviesToRate.map { $0.movieId })
        return moviesToAdd.filter { !movieIds.contains($0.movieId) }
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
                let createdDate = Date()
                return MovieStore(title: movieTitle, movieId: movieId, photoUrl: photoUrl, createdDate: createdDate)
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
        let moviesStore = moviesToRate.map { MovieStore(title: $0.title, movieId: $0.movieId, photoUrl: $0.photoUrl, createdDate: $0.createdDate) }
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
