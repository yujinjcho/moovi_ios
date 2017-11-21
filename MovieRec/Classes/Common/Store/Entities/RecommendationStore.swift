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
    }
    
    var movieTitle: String
    
    init(movieTitle: String) {
        self.movieTitle = movieTitle
    }
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("recommendationStore")
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(movieTitle, forKey: PropertyKey.movieTitle)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let movieTitle = aDecoder.decodeObject(forKey: PropertyKey.movieTitle) as? String
        self.init(movieTitle: movieTitle!)
    }
}
