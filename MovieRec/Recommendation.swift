//
//  Recommendation.swift
//  MovieRec
//
//  Created by Yujin Cho on 5/27/17.
//  Copyright © 2017 Yujin Cho. All rights reserved.
//
import os.log
import UIKit

class Recommendation: NSObject, NSCoding {
    
    //MARK: Properties
    struct PropertyKey {
        static let title = "title"
    }
    
    var title: String
    
    init(title: String) {
        self.title = title
    }
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("recommendations")
    
    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: PropertyKey.title)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let title = aDecoder.decodeObject(forKey: PropertyKey.title) as? String else {
            os_log("Unable to decode the title for a Recommendation object.", log: OSLog.default, type: .debug)
            return nil
        }
        self.init(title: title)
        
    }
}
