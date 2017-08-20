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
    
    init() {
        setUserID()
        loadMovies()
    }
    
    func count() -> Int {
        return movies.count
    }
    
    func downloadMoviesToRate(ratings: [Rating]) {
        let uploadRatings = ratings.map({
            (rating:Rating) -> [String:String] in
            [
                "movie_id": rating.value(forKey: "movieId") as! String,
                "rating": rating.value(forKey: "rating") as! String
            ]
        })
        
        let unratedMovies = movies.map({
            (movie:Movie) -> String in
            movie.value(forKey: "movieId") as! String
        })
        
        if let userId = userId {
            let postData : [String: Any] = ["user_id": userId, "ratings": uploadRatings, "not_rated_movies": unratedMovies]
            print("Sending POST Request")
            NetworkController.postRequest(endPoint: "api/refresh", postData: postData, completionHandler: updateMovies)
        }
    }
    
    func currentMovie() -> Movie {
        return movies[0]
    }
    
    func removeCurrentMovie() {
        movies.remove(at: 0)
    }
    
    private func setUserID() {
        let retrievedID = UserDefaults.standard.string(forKey: "userID")
        if let retrievedID = retrievedID {
            userId = retrievedID
        }
    }
    
    private func loadMovies() {
        // UserDefaults.standard.set(false, forKey: "launchedBefore")
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if launchedBefore  {
            print("Launch Status: First")
            if let savedMovies = loadMoviesFromDisk() {
                movies += savedMovies
            }
        } else {
            print("First Status: Not First")
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
            for movieToRate in responseJSON {
                let movieTitle = movieToRate["title"]!
                let movieId = movieToRate["movieId"]!
                let photoUrl = movieToRate["photoUrl"]!
                self.movies += [Movie(title: movieTitle, movieId: movieId, photoUrl: photoUrl)]
            }
            self.saveMovies()
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
