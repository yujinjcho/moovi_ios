//
//  MovieStore.swift
//  MovieRec
//
//  Created by Yujin Cho on 10/16/17.
//  Copyright © 2017 Yujin Cho. All rights reserved.
//

import Foundation

final class MovieStore: NSObject, NSCoding {
    
    struct PropertyKey {
        static let title = "title"
        static let photoUrl = "photoUrl"
        static let movieId = "movieId"
        static let createdDate = "createdDate"
    }
    
    var title: String
    var photoUrl: String
    var movieId: String
    var createdDate: Date
    
    init(title: String, movieId: String, photoUrl: String, createdDate: Date) {
        self.title = title
        self.photoUrl = photoUrl
        self.movieId = movieId
        self.createdDate = createdDate
    }
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("movieStore")
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: PropertyKey.title)
        aCoder.encode(photoUrl, forKey: PropertyKey.photoUrl)
        aCoder.encode(movieId, forKey: PropertyKey.movieId)
        aCoder.encode(createdDate, forKey: PropertyKey.createdDate)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let movieId = aDecoder.decodeObject(forKey: PropertyKey.movieId) as? String
        let title = aDecoder.decodeObject(forKey: PropertyKey.title) as? String
        let photoUrl = aDecoder.decodeObject(forKey: PropertyKey.photoUrl) as? String
        let createdDate = aDecoder.decodeObject(forKey: PropertyKey.createdDate) as? Date
        self.init(title: title!, movieId: movieId!, photoUrl: photoUrl!, createdDate: createdDate!)
    }
}
