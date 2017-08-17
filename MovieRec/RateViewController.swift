//
//  RateViewController.swift
//  MovieRec
//
//  Created by Yujin Cho on 5/27/17.
//  Copyright © 2017 Yujin Cho. All rights reserved.
//

import os.log
import UIKit
import CloudKit

class RateViewController: UIViewController, Delegate {

    //MARK: Properties
    var ratings = [Rating]()
    var movies = [Movie]()
    var userId: String?
    let reloadThreshold = 25
    
    @IBOutlet weak var titleNameLabel: UILabel!
    @IBOutlet weak var titleImage: UIImageView!
    @IBAction func rateLikeButton(_ sender: UIButton) {
        processRating(ratingType: "1")
        print("movie count: \(movies.count)")
        print("ratings count: \(ratings.count)")

    }
    
    @IBAction func rateSkipButton(_ sender: UIButton) {
        processRating(ratingType: "0")
        
        iCloudUserIDAsync() {
            recordID, error in
            if let userID = recordID?.recordName {
                print("received iCloudID \(userID)")
            } else {
                print("Fetched iCloudID was nil")
            }
        }
    }
    
    @IBAction func rateDislikeButton(_ sender: UIButton) {
        processRating(ratingType: "-1")
        print("movie count: \(movies.count)")
        print("ratings count: \(ratings.count)")
    }
    
    func iCloudUserIDAsync(complete: @escaping (CKRecordID?, NSError?) -> ()) {
        let container = CKContainer.default()
        container.fetchUserRecordID() {
            recordID, error in
            if error != nil {
                print(error!.localizedDescription)
                complete(nil, error! as NSError)
            } else {
                print("fetched ID \(String(describing: recordID?.recordName))")
                complete(recordID, nil)
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkFirstLaunch()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let recommendationsTableViewController = segue.destination as? RecommendationsTableViewController {
            recommendationsTableViewController.ratings = ratings
            recommendationsTableViewController.delegate = self
        }
        
    }
    
    func clearRatings() {
        ratings.removeAll()
    }
    
    
    //MARK: Private Methods    
    private func loadNextMovieToRate() {
        let currentMovie = movies[0]
        titleImage.clipsToBounds = true
        titleImage.downloadedFrom(link: currentMovie.photoUrl, title: currentMovie.title, completion: changeTitle)
    }
    
    private func addRating(rating: String) {
        let currentMovie = movies[0]
        let rating = Rating(movieId: currentMovie.movieId, rating: rating)
        ratings += [rating]
        movies.remove(at: 0)
    }
    
    private func processRating(ratingType: String) {
        addRating(rating: ratingType)
        loadNextMovieToRate()
        if (movies.count == reloadThreshold) {
            
            downloadMoviesToRate()
        }
        saveMovies()
    }
    
    private func loadFirstMoviesToRate() {
        NetworkController.getRequest(endPoint: "api/start", completionHandler: updateMovies, user: nil)
    }

    private func downloadMoviesToRate() {
        
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
            NetworkController.postRequest(endPoint: "api/refresh", postData: postData, completionHandler: updateMovies)
            print("Post: \(postData)")
        } else {
            print("userId is not set")
        }
        
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
            self.loadNextMovieToRate()
            self.ratings.removeAll()
        }
    }

    private func checkFirstLaunch() {
        // UserDefaults.standard.set(false, forKey: "launchedBefore")
        let retrievedID = UserDefaults.standard.string(forKey: "userID")
        if let retrievedID = retrievedID {
            userId = retrievedID
            print("User is set to \(userId!)")
        }

        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        
        if launchedBefore  {
            print("Not first launch.")
            
            
            if let savedMovies = loadMovies() {
                movies += savedMovies
            }
            loadNextMovieToRate()
            print(movies.count)
        } else {
            print("First launch, setting UserDefault.")
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            
            
            loadFirstMoviesToRate()
        }

    }
    

    
    func changeTitle(title: String){
        titleNameLabel.text = title
    }
    
    private func saveMovies() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(movies, toFile: Movie.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Movies successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save movies...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadMovies() -> [Movie]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Movie.ArchiveURL.path) as? [Movie]
    }

}

extension UIImageView {
    func downloadedFrom(url: URL, title: String, contentMode mode: UIViewContentMode = .scaleAspectFit, completion: @escaping (String)->()) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { () -> Void in
                self.image = image
                completion(title)
            }
            }.resume()
    }
    func downloadedFrom(link: String, title: String, contentMode mode: UIViewContentMode = .scaleAspectFill, completion: @escaping (String)->()) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, title: title, contentMode: mode, completion: completion)
    }
}

