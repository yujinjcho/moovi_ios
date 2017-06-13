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

    var movieId: String
    var rating: String
    
    init(movieId: String, rating: String) {
        self.movieId = movieId
        self.rating = rating
    }
    
}
