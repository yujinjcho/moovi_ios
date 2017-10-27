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
    var currentTitle : String?
    
    //MARK: Properties
    var ratings = Ratings()
    var movies = MoviesToRate()
    var userId: String?
    let reloadThreshold = 25
    
    @IBOutlet weak var titleNameLabel: UILabel!
    @IBOutlet weak var titleImage: UIImageView!
    
//    @IBAction func rateLikeButton(_ sender: UIButton) {
//        processRating(ratingType: "1")
//    }
    
    @IBAction func rateSkipButton(_ sender: UIButton) {
        processRating(ratingType: "0")
    }
    
    @IBAction func rateDislikeButton(_ sender: UIButton) {
        processRating(ratingType: "-1")
    }
    
    override func viewDidLoad() {
        titleImage.clipsToBounds = true
        super.viewDidLoad()
        configureView()
        //loadNextMovieToRate()
        
        eventHandler?.loadedView()
        
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let recommendationsTableViewController = segue.destination as? RecommendationsTableViewController {
//            recommendationsTableViewController.ratings = ratings
//            recommendationsTableViewController.delegate = self
//        }
//    }
    
    
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
    
    //
    // VIPER PART
    //
    @IBAction func rateLikeButton(_ sender: UIButton) {
        print("Pressed like button")
        eventHandler?.processRating(ratingType: "1")
    }

    
    func showCurrentMovie(title:String, photoUrl: String) {
        let url = URL(string: photoUrl)
        titleImage.kf.setImage(with: url, completionHandler: {(_, _, _, _) in self.titleNameLabel.text = title})
    }
    
    func configureView() {
        navigationItem.title = "Rate"
        let navigateToRecommendItem = UIBarButtonItem(title: "Movie List", style: UIBarButtonItemStyle.plain, target: self, action: #selector(RateViewController.didTapNavigateToRecommendItem))
        navigationItem.rightBarButtonItem = navigateToRecommendItem
    }
    
    func didTapNavigateToRecommendItem(){
        print("pressed the nav button")
        
        eventHandler?.presentRecommendView(navigationController: self.navigationController!)
        //eventHandler?.presentRecommendView()
    }
}



