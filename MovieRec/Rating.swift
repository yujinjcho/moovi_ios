//
//  Rating.swift
//  MovieRec
//
//  Created by Yujin Cho on 5/27/17.
//  Copyright © 2017 Yujin Cho. All rights reserved.
//

import UIKit

class Rating: NSObject {
    
    //MARK: Properties

    var movie: Movie
    var rating: String
    var movieId: String {
        get { return movie.movieId }
    }
    
    init(movie: Movie, rating: String) {
        self.movie = movie
        self.rating = rating
    }
    
}
