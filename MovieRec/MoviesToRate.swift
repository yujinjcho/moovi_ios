//
//  MoviesToRate.swift
//  MovieRec
//
//  Created by Yujin Cho on 8/18/17.
//  Copyright © 2017 Yujin Cho. All rights reserved.
//

import os.log
import UIKit

class MoviesToRate {
    
    var userId: String?
    var movies = [Movie]()
    var images: MovieImages?
    
    init() {
        setUserID()
        loadMovies()
        images = MovieImages(urls: movies.map { (movie: Movie) in movie.photoUrl })
    }
    
    func count() -> Int {
        return movies.count
    }
    
    func downloadMoviesToRate(ratings: Ratings) {
        let uploadRatings = ratings.uploadFormat()
        let unratedMovies = movies.map({
            (movie:Movie) -> String in
            movie.value(forKey: "movieId") as! String
        })
        
        if let userId = userId {
            let postData : [String: Any] = ["user_id": userId, "ratings": uploadRatings, "not_rated_movies": unratedMovies]
            //print("Sending POST Request")
            NetworkController.postRequest(endPoint: "api/refresh", postData: postData, completionHandler: updateMovies)
        }
    }
    
    func currentMovie() -> Movie {
        return movies[0]
    }
    
    func removeCurrentMovie() {
        movies.remove(at: 0)
        saveMovies()
    }
    
    private func setUserID() {
        let retrievedID = UserDefaults.standard.string(forKey: "userID")
        if let retrievedID = retrievedID {
            userId = retrievedID
        }
    }
    
    private func loadMovies() {
        //UserDefaults.standard.set(false, forKey: "launchedBefore")
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if launchedBefore  {
            //print("Launch Status: Not First")
            if let savedMovies = loadMoviesFromDisk() {
                movies += savedMovies
            }
        } else {
            //print("First Status: First")
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            loadFirstMoviesToRate()
        }
    }
    
    private func loadMoviesFromDisk() -> [Movie]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Movie.ArchiveURL.path) as? [Movie]
    }
    
    private func loadFirstMoviesToRate() {
        NetworkController.getRequest(endPoint: "api/start", completionHandler: updateMovies, user: nil)
    }
    
    private func updateMovies(data: Data) -> Void {
        let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
        if let responseJSON = responseJSON as? [[String: String]] {
            let newMovies = responseJSON.map {
                (movieToRate: [String: String]) -> Movie in
                let movieTitle = movieToRate["title"]!
                let movieId = movieToRate["movieId"]!
                let photoUrl = movieToRate["photoUrl"]!
                return Movie(title: movieTitle, movieId: movieId, photoUrl: photoUrl)
            }
            movies += newMovies
            images?.startPrefetcher(urls: newMovies.map { (movie:Movie) in movie.photoUrl })
            saveMovies()
        }
    }
    
    private func saveMovies() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(movies, toFile: Movie.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Movies successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save movies...", log: OSLog.default, type: .error)
        }
    }
}
