//
//  Ratings.swift
//  MovieRec
//
//  Created by Yujin Cho on 8/19/17.
//  Copyright © 2017 Yujin Cho. All rights reserved.
//

import os.log
import UIKit

class Ratings {
    var ratings = [Rating]()
    var count: Int {
        get { return ratings.count }
    }
    
    init() {
        loadRatings()
    }
    
    func removeAll() {
        ratings.removeAll()
        saveRatings()
    }
    
    func add(rating: Rating) {
        ratings += [rating]
        saveRatings()
    }
    
    func uploadFormat() -> [[String:String]] {
        let uploadRatings = ratings.map({
            (rating:Rating) -> [String:String] in
            [
                "movie_id": rating.movieId,
                "rating": rating.value(forKey: "rating") as! String
            ]
        })
        return uploadRatings
    }
    
    private func saveRatings() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(ratings, toFile: Rating.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Ratings successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save ratings...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadRatings() {
        if let savedRatings = loadRatingsFromDisk() {
            ratings += savedRatings
        }
    }
    
    private func loadRatingsFromDisk() -> [Rating]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Rating.ArchiveURL.path) as? [Rating]
    }
}
