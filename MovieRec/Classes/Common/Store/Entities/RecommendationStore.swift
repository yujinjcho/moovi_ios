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
    }
    
    var movieTitle: String
    var movieScore: Float
    
    init(movieTitle: String, movieScore: Float) {
        self.movieTitle = movieTitle
        self.movieScore = movieScore
    }
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("recommendationStore")
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(movieTitle, forKey: PropertyKey.movieTitle)
        aCoder.encode(movieScore, forKey: PropertyKey.movieScore)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let movieTitle = aDecoder.decodeObject(forKey: PropertyKey.movieTitle) as? String
        let movieScore = aDecoder.decodeFloat(forKey: PropertyKey.movieScore)// as? Float
        self.init(movieTitle: movieTitle!, movieScore: movieScore)
    }
}
