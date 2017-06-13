//
//  RateViewController.swift
//  MovieRec
//
//  Created by Yujin Cho on 5/27/17.
//  Copyright © 2017 Yujin Cho. All rights reserved.
//

import UIKit

class RateViewController: UIViewController {

    //MARK: Properties
    var ratings = [Rating]()
    var movies = [Movie]()
    
    @IBOutlet weak var titleNameLabel: UILabel!
    @IBOutlet weak var titleImage: UIImageView!
    @IBAction func rateLikeButton(_ sender: UIButton) {
        print("Like Pressed")
        processRating(ratingType: "1")
    }
    
    @IBAction func rateSkipButton(_ sender: UIButton) {
        print("Skip Pressed")
        print(ratings.count)
        movies.remove(at: 0)
        if movies.count == 0 {
            loadSampleMovies()
        }
        loadMovie()

    }
    @IBAction func rateDislikeButton(_ sender: UIButton) {
        print("Dislike Pressed")
        processRating(ratingType: "-1")

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkFirstLaunch()        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // pass ratings from RateViewController to RecommendationsViewController
        if let recommendationsTableViewController = segue.destination as? RecommendationsTableViewController {
            recommendationsTableViewController.ratings = ratings
        }
    }
    
    //MARK: Private Methods
    private func loadSampleMovies() {

        
        let movie1 = Movie(title: "Eye of the Beast", movieId: "770674011", photoUrl: "https://resizing.flixster.com/l33YTQ7OQjckGzyjz4Or2B5M7IY=/322x462/v1.bTsxMDgzOTc5MDtqOzE3NDE1OzIwNDg7MzIyOzQ2Mg")
        let movie2 = Movie(title: "Befikre", movieId: "771455920", photoUrl: "https://resizing.flixster.com/LFD-HnXFLYFpvihrAJdNF9XkG3s=/799x1066/v1.bTsxMjI0ODk3MztqOzE3Mzk0OzIwNDg7MjE4NzsyOTE2")
        let movie3 = Movie(title: "Hotel Reserve", movieId: "771046771", photoUrl: "https://resizing.flixster.com/1yzqLJeMc-OFV-_XiyLoIt0l_GI=/400x611/v1.bTsxMjA4ODk2NDtqOzE3NDAzOzIwNDg7NDAwOzYxMQ")
        let movie4 = Movie(title: "Nostradamus", movieId: "770680114", photoUrl: "https://resizing.flixster.com/C8R3lhW9v_Ec4RFn5BClTIoOZ5Q=/597x796/v1.bTsxMTU0NDIxNztqOzE3NDIwOzIwNDg7NTk3Ozc5Ng")
        movies += [movie1, movie2, movie3, movie4]
        
    }
    
    private func loadMovie() {
        // get first item on the list
        let currentMovie = movies[0]
        
        // set photo to be movie
        titleImage.clipsToBounds = true
        titleImage.downloadedFrom(link: currentMovie.photoUrl, title: currentMovie.title, completion: changeTitle)
        
    }
    
    private func processRating(ratingType: String) {
        // create rating
        let currentMovie = movies[0]

        let rating = Rating(movieId: currentMovie.movieId, rating: ratingType)
        ratings += [rating]
        
        movies.remove(at: 0)
        if movies.count == 0 {
            loadSampleMovies()
        }
        loadMovie()
    }
    
    private func loadFirstMoviesToRate() {
        let url = URL(string: "https://movie-rec-project.herokuapp.com/api/start")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            // let string = String(data: data, encoding: String.Encoding.utf8)
            // print(string!)
            
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [[String: String]] {
                for movieToRate in responseJSON {
                    let movieTitle = movieToRate["title"]!
                    let movieId = movieToRate["movieId"]!
                    let photoUrl = movieToRate["photoUrl"]!
                    self.movies += [Movie(title: movieTitle, movieId: movieId, photoUrl: photoUrl)]
                    
                }
            }
            self.loadMovie()
        }
        task.resume()
    }

    private func checkFirstLaunch() {
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if launchedBefore  {
            print("Not first launch.")
        } else {
            print("First launch, setting UserDefault.")
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            loadFirstMoviesToRate()
        }
        UserDefaults.standard.set(false, forKey: "launchedBefore")
    }
    
    func changeTitle(title: String){
        titleNameLabel.text = title
        
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

