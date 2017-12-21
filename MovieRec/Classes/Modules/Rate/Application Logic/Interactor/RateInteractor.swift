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
    let movieThreshold = 25
    
    //var timer = Date()
    
    init(dataManager: RateDataManager) {
        self.dataManager = dataManager
    }
    
    func initializeDataManager() {
        dataManager.loadRatings()
        dataManager.loadMovies(completion: { (currentMovie: Movie) -> Void in
            self.showCurrentMovie(currentMovie: currentMovie)
        })
    }
    
    func storeRating(ratingType: String) {
        //timer = Date()
        //print("01_START: \(timer.timeIntervalSinceNow)")
        
        dataManager.storeRating(rating: ratingType)
        //print("02_STORE: \(timer.timeIntervalSinceNow)")
        
        dataManager.removeFirstMovie()
        //print("03_REMOVE: \(timer.timeIntervalSinceNow)")
        
        if dataManager.movieCounts == movieThreshold || dataManager.movieCounts == 0 {
            fetchNewMovies()
        }
        //print("04_FETCH: \(timer.timeIntervalSinceNow)")
        
        if let currentMovie = dataManager.currentMovie {
            showCurrentMovie(currentMovie: currentMovie)
        }
        //print("05_SHOW: \(timer.timeIntervalSinceNow)")
    }
    
    func showCurrentMovie(currentMovie: Movie) {
        if let output = output {
            output.presentCurrentMovie(currentMovie: currentMovie)
        }
    }
    
    func fetchNewMovies() {
        dataManager.getNewMoviesToRate()
    }
}
