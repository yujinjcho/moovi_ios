//
//  Rating.swift
//  MovieRec
//
//  Created by Yujin Cho on 5/27/17.
//  Copyright © 2017 Yujin Cho. All rights reserved.
//

import UIKit

class Rating {
    
    //MARK: Properties

    var title: String
    var rating: String
    var deviceId: String
    
    init(title: String, rating: String, deviceId: String) {
        self.title = title
        self.rating = rating
        self.deviceId = deviceId
    }
    
}
