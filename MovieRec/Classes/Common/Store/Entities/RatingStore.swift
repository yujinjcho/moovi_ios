//
//  RatingStore.swift
//  MovieRec
//
//  Created by Yujin Cho on 10/17/17.
//  Copyright © 2017 Yujin Cho. All rights reserved.
//

import Foundation


class RatingStore: NSObject, NSCoding {
    
    struct PropertyKey {
        static let movieID = "movieID"
        static let rating = "rating"
        static let userID = "userID"
    }
    
    var movieID: String
    var rating: String
    var userID: String
    
    init(movieID: String, rating: String, userID: String) {
        self.movieID = movieID
        self.rating = rating
        self.userID = userID
    }
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("ratingStore")
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(movieID, forKey: PropertyKey.movieID)
        aCoder.encode(rating, forKey: PropertyKey.rating)
        aCoder.encode(userID, forKey: PropertyKey.userID)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let movieID = aDecoder.decodeObject(forKey: PropertyKey.movieID) as? String
        let rating = aDecoder.decodeObject(forKey: PropertyKey.rating) as? String
        let userID = aDecoder.decodeObject(forKey: PropertyKey.userID) as? String
        self.init(movieID: movieID!, rating: rating!, userID: userID!)
    }
}
