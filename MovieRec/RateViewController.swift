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

        
        let movie1 = Movie(title: "Alien Covenant", photoUrl: "https://resizing.flixster.com/IYbhKwXYWq1-xziwFgGpu5gasvM=/206x305/v1.bTsxMjM0NTY3NjtqOzE3MzMyOzEyMDA7NTM5OzgwMA")
        let movie2 = Movie(title: "Blame!", photoUrl: "https://resizing.flixster.com/g7JF5as1fPNkUt-JmEv-vYv-Auk=/206x305/v1.bTsxMjExOTczMTtqOzE3MzMwOzEyMDA7MTEwOzE1NA")
        let movie3 = Movie(title: "Guardians of the Galaxy 2", photoUrl: "https://resizing.flixster.com/POuQse1wJTE5kT-HsfwT9pIWRbI=/206x305/v1.bTsxMjMyMzE1NjtwOzE3MzMyOzEyMDA7NTkxOzg3Ng")
        let movie4 = Movie(title: "Logan", photoUrl: "https://resizing.flixster.com/0E6Et1Fi6wFzN9PFWdZdyIl2H_c=/206x305/v1.bTsxMjMwNDQ4NDtqOzE3MzMyOzEyMDA7NjI2OzkyNA")
        movies += [movie1, movie2, movie3, movie4]
    }
    
    private func loadMovie() {
        // get first item on the list
        let currentMovie = movies[0]
        
        // set name to be name of movie
        titleNameLabel.text = currentMovie.title
        
        // set photo to be movie
        // titleImage.image = currentMovie.photo
        let url = URL(string: currentMovie.photoUrl)
        // titleImage.image = UIImage(data: data!)
        
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!)
            DispatchQueue.main.async {
                self.titleImage.image = UIImage(data: data!)
            }
        }
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

