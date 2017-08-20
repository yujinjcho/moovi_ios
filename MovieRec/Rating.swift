//
//  Rating.swift
//  MovieRec
//
//  Created by Yujin Cho on 5/27/17.
//  Copyright © 2017 Yujin Cho. All rights reserved.
//

import os.log
import UIKit

class Rating: NSObject, NSCoding {
    
    //MARK: Properties
    struct PropertyKey {
        static let movie = "movie"
        static let rating = "rating"
    }
    
    var movie: Movie
    var rating: String
    
    var movieId: String {
        get { return movie.movieId }
    }
    
    init(movie: Movie, rating: String) {
        self.movie = movie
        self.rating = rating
    }
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("ratings")

    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(movie, forKey: PropertyKey.movie)
        aCoder.encode(rating, forKey: PropertyKey.rating)
    }

    required convenience init?(coder aDecoder: NSCoder) {
        guard let movie = aDecoder.decodeObject(forKey: PropertyKey.movie) as? Movie else {
            os_log("Unable to decode the movie from Rating object.", log: OSLog.default, type: .debug)
            return nil
        }
        guard let rating = aDecoder.decodeObject(forKey: PropertyKey.rating) as? String else {
            os_log("Unable to decode the rating from Rating object.", log: OSLog.default, type: .debug)
            return nil
        }
        self.init(movie: movie, rating: rating)
    }
}
