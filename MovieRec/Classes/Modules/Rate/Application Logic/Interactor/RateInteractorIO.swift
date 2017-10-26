//
//  RateInteractorIO.swift
//  MovieRec
//
//  Created by Yujin Cho on 10/8/17.
//  Copyright © 2017 Yujin Cho. All rights reserved.
//

import Foundation

protocol RateInteractorInput {
    func initializeDataManager()
    func storeRating(ratingType: String)
    func fetchNewMovies()
}

protocol RateInteractorOutput {
    func presentCurrentMovie(currentMovie: MovieModel)
}
