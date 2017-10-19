//
//  RateInteractor.swift
//  MovieRec
//
//  Created by Yujin Cho on 10/8/17.
//  Copyright © 2017 Yujin Cho. All rights reserved.
//

import Foundation

class RateInteractor : NSObject, RateInteractorInput {
    var output : RateInteractorOutput?
    
    let dataManager : RateDataManager
    
    init(dataManager: RateDataManager) {
        self.dataManager = dataManager
    }
    
    func initializeMovies() {
        dataManager.loadMovies(completion: { (currentMovie: MovieModel) -> Void in
            self.showCurrentMovie(currentMovie: currentMovie)
        })
    }
    
    func storeRating(ratingType: String) {
        dataManager.storeRating(rating: ratingType)
        dataManager.removeFirstMovie()
        if let currentMovie = dataManager.loadCurrentMovie() {
            showCurrentMovie(currentMovie: currentMovie)
        }
    }
    
    func showCurrentMovie(currentMovie: MovieModel) {
        if let output = output {
            output.presentCurrentMovie(currentMovie: currentMovie)
        }
    }
}
