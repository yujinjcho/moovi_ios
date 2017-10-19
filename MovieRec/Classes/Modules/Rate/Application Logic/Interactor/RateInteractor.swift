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
            if let output = self.output {
                output.presentCurrentMovie(currentMovie: currentMovie)
            }
        })
    }
    
    func storeRating(ratingType: String) {
        dataManager.storeRating(rating: ratingType)
        
        
        //let rating = RatingModel(movieID: currentMovie?.movieId, rating: ratingType, userID: currentUser)
        
        //let rating = RatingModel(movieID: currentMovie?.movieId, rating: ratingType, userID: currentUser!)
        
        
    }
    
    
//    private func processRating(ratingType: String) {
//        addRating(rating: ratingType)
//        loadNextMovieToRate()
//        if (movies.count() == reloadThreshold) {
//            movies.downloadMoviesToRate(ratings: ratings)
//        }
//        print("Movie Count: \(movies.count())")
//        print("Rating Count: \(ratings.count)")
//    }
}
