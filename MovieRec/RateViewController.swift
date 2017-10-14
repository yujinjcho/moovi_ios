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

class RateViewController: UIViewController, RateViewInterface, Delegate {

    var eventHandler : RateModuleInterface?
    
    //MARK: Properties
    var ratings = Ratings()
    var movies = MoviesToRate()
    var userId: String?
    let reloadThreshold = 25
    
    @IBOutlet weak var titleNameLabel: UILabel!
    @IBOutlet weak var titleImage: UIImageView!
    
    @IBAction func rateLikeButton(_ sender: UIButton) {
        processRating(ratingType: "1")
    }
    
    @IBAction func rateSkipButton(_ sender: UIButton) {
        processRating(ratingType: "0")
    }
    
    @IBAction func rateDislikeButton(_ sender: UIButton) {
        processRating(ratingType: "-1")
    }
    
    override func viewDidLoad() {
        titleImage.clipsToBounds = true
        super.viewDidLoad()
        //loadNextMovieToRate()
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
        let currentMovie = movies.currentMovie()
        let url = URL(string: currentMovie.photoUrl)
        titleImage.kf.setImage(with: url, completionHandler: {(_, _, _, _) in self.changeTitle()})
    }
    
    private func addRating(rating: String) {
        let currentMovie = movies.currentMovie()
        let rating = Rating(movie: currentMovie, rating: rating)
        ratings.add(rating: rating)
        movies.removeCurrentMovie()
    }
    
    private func processRating(ratingType: String) {
        addRating(rating: ratingType)
        loadNextMovieToRate()
        if (movies.count() == reloadThreshold) {
            movies.downloadMoviesToRate(ratings: ratings)
        }
        print("Movie Count: \(movies.count())")
        print("Rating Count: \(ratings.count)")
    }
    
    func changeTitle(){
        let currentMovie = movies.currentMovie()
        titleNameLabel.text = currentMovie.title
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
