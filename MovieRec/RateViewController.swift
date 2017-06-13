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
        processRating(ratingType: "Like")
    }
    
    @IBAction func rateSkipButton(_ sender: UIButton) {
        print("Skip Pressed")
        processRating(ratingType: "Skip")

    }
    @IBAction func rateDislikeButton(_ sender: UIButton) {
        print("Dislike Pressed")
        processRating(ratingType: "Dislike")

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSampleMovies()
        loadMovie()
        
    }
    
    //MARK: Private Methods
    private func loadSampleMovies() {

        
        let movie1 = Movie(title: "The Mummy", photoUrl: "https://resizing.flixster.com/cF2J3F5DC4EpeAU17YPsymcsoPY=/758x1200/v1.bTsxMjQwNTk1MDtqOzE3NDEzOzIwNDg7NzkwOzEyNTE")
        let movie2 = Movie(title: "Wonder Woman", photoUrl: "https://resizing.flixster.com/KoHf19nmZ0qWgVnGPgVCW6TrSD4=/800x1185/v1.bTsxMjQxMTMzMTtqOzE3Mzk0OzIwNDg7NDA1MDs2MDAw")
        let movie3 = Movie(title: "Pirates of the Caribbean: Dead Men Tell No Tales", photoUrl: "https://resizing.flixster.com/eBYoZ0u2rTERYSPchsAmZFLXVmQ=/360x536/v1.bTsxMjMyMzIyNztwOzE3Mzk5OzIwNDg7MzYwOzUzNg")
        let movie4 = Movie(title: "Guardians of the Galaxy Vol. 2", photoUrl: "https://resizing.flixster.com/3mlqhwwH5MMp10l-Ue427fedkR0=/591x876/v1.bTsxMjMyMzE1NjtwOzE3NDE4OzIwNDg7NTkxOzg3Ng")
        let movie5 = Movie(title: "Baywatch", photoUrl: "https://resizing.flixster.com/PszYjP8rzP0GIlh0pEM47l1BH_E=/800x1185/v1.bTsxMjQwMTA1OTtqOzE3MzgyOzIwNDg7MTczMDsyNTYz")
        let movie6 = Movie(title: "Alien: Covenant", photoUrl: "https://resizing.flixster.com/jvTC-M74iG4O8UX9V3kvDVlEEZg=/539x800/v1.bTsxMjM0NTY3NjtqOzE3MzkzOzIwNDg7NTM5OzgwMA")



        movies += [movie1, movie2, movie3, movie4, movie5, movie6]
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
        let deviceId = UIDevice.current.identifierForVendor!.uuidString

        let rating = Rating(title: currentMovie.title, rating: ratingType, deviceId: deviceId)
        ratings += [rating]
        
        movies.remove(at: 0)
        if movies.count == 0 {
            loadSampleMovies()
        }
        loadMovie()

    }



}

