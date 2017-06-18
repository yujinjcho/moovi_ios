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
        processRating(ratingType: "Skip")

    }
    @IBAction func rateDislikeButton(_ sender: UIButton) {
        print("Dislike Pressed")
        processRating(ratingType: "-1")

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSampleMovies()
        loadMovie()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
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
        
        // set name to be name of movie
        titleNameLabel.text = currentMovie.title
        
        // set photo to be movie
        titleImage.contentMode = .scaleAspectFill
        titleImage.clipsToBounds = true
        titleImage.image = currentMovie.movieImage
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

}

