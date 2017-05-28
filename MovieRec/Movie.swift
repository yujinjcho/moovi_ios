//
//  Movie.swift
//  MovieRec
//
//  Created by Yujin Cho on 5/27/17.
//  Copyright © 2017 Yujin Cho. All rights reserved.
//

import UIKit

class Movie {
    
    //MARK: Properties
    
    var title: String
    var photoUrl: String
    
    init(title: String, photoUrl: String) {
        self.title = title
        self.photoUrl = photoUrl
    }
    
}
