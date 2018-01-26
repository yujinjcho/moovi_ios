//
//  RecommendationStore.swift
//  MovieRec
//
//  Created by Yujin Cho on 11/20/17.
//  Copyright © 2017 Yujin Cho. All rights reserved.
//

import Foundation

final class RecommendationStore: NSObject, NSCoding {
    
    struct PropertyKey {
        static let movieTitle = "movieTitle"
        static let movieScore = "movieScore"
        static let movieProvider = "movieProvider"
    }
    
    var movieTitle: String
    var movieScore: Float
    var movieProvider: String
    
    init(movieTitle: String, movieScore: Float, movieProvider: String) {
        self.movieTitle = movieTitle
        self.movieScore = movieScore
        self.movieProvider = movieProvider
    }
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("recommendationStore")
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(movieTitle, forKey: PropertyKey.movieTitle)
        aCoder.encode(movieScore, forKey: PropertyKey.movieScore)
        aCoder.encode(movieProvider, forKey: PropertyKey.movieProvider)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let movieTitle = aDecoder.decodeObject(forKey: PropertyKey.movieTitle) as? String
        let movieScore = aDecoder.decodeFloat(forKey: PropertyKey.movieScore)// as? Float
        let movieProvider = aDecoder.decodeObject(forKey: PropertyKey.movieProvider) as? String
        self.init(movieTitle: movieTitle!, movieScore: movieScore, movieProvider: movieProvider!)
    }
}
