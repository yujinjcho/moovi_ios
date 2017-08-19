//
//  Movie.swift
//  MovieRec
//
//  Created by Yujin Cho on 5/27/17.
//  Copyright © 2017 Yujin Cho. All rights reserved.
//

import os.log
import UIKit

class Movie: NSObject, NSCoding {
    
    //MARK: Properties
    struct PropertyKey {
        static let title = "title"
        static let photoUrl = "photoUrl"
        static let movieId = "movieId"
    }
    
    var title: String
    var photoUrl: String
    var movieId: String
    
    init(title: String, movieId: String, photoUrl: String) {
        self.title = title
        self.photoUrl = photoUrl
        self.movieId = movieId
        
    }
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("movies")
    
    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: PropertyKey.title)
        aCoder.encode(photoUrl, forKey: PropertyKey.photoUrl)
        aCoder.encode(movieId, forKey: PropertyKey.movieId)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let movieId = aDecoder.decodeObject(forKey: PropertyKey.movieId) as? String else {
            os_log("Unable to decode the movieId for a Movie object.", log: OSLog.default, type: .debug)
            return nil
        }
        let title = aDecoder.decodeObject(forKey: PropertyKey.title) as? String
        let photoUrl = aDecoder.decodeObject(forKey: PropertyKey.photoUrl) as? String
        self.init(title: title!, movieId: movieId, photoUrl: photoUrl!)
        
        
    }
    
}
