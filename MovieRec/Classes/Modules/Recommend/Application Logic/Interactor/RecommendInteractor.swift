//
//  RecommendInteractor.swift
//  MovieRec
//
//  Created by Yujin Cho on 10/8/17.
//  Copyright © 2017 Yujin Cho. All rights reserved.
//

import SwiftyJSON
import Foundation

class RecommendInteractor : NSObject {
    var output : RecommendInteractorOutput?
    
    var recommendDataManager : RecommendDataManager?
    var timer: DispatchSourceTimer?
    var movieProviders = ["box_office", "netflix", "amazoninstant"]
    //["In Theaters", "Netflix", "iTunes", "Amazon Prime"]
    var selectedProvider = "box_office"
    var recommendations = [Recommendation]()
    //var defaultProvider = "netflix"
    
    func movieProviderIndex() -> Int {
        if let index = movieProviders.index(of: selectedProvider) {
            return index
        } else {
            return 0
        }
    }
    
    func loadRecommendations() {
        if let recommendDataManager = recommendDataManager, let output = output {
            recommendations = recommendDataManager.fetchRecommendations()
            output.showRecommendations(recommendations: recommendations.filter { $0.movieProvider == selectedProvider})
        }
    }
    
    func refreshRecommendations() {
        if let recommendDataManager = recommendDataManager {
            let ratings = recommendDataManager.fetchRatings()
            recommendDataManager.uploadRatings(ratings: ratings, completion: startPolling)
        }
    }
    
    func startPolling(jobID: String) -> Void {
        print("starting polling with \(jobID)")
        let queue = DispatchQueue(label: "com.domain.app.timer")
        timer = DispatchSource.makeTimerSource(queue: queue)
        guard let timer = timer else {
            print("Timer couldn't be created")
            return
        }
        timer.scheduleRepeating(deadline: .now(), interval: .seconds(5))
        timer.setEventHandler { [weak self] in
            if let recommendDataManager = self!.recommendDataManager {
                recommendDataManager.fetchJobStatus(jobID: jobID, completion: self!.checkJobStatus)
            }
        }
        timer.resume()
    }
    
    func retrieveProviderRecommendations(row: Int) {
        selectedProvider = movieProviders[row]
        let recommendationsFromProvider = recommendations.filter { $0.movieProvider == selectedProvider}
        if let output = output {
            output.showRecommendations(recommendations: recommendationsFromProvider)
        }
    }
    
    
    
    func checkJobStatus(data: Data) -> Void {
        let json = JSON(data: data)
        if json["status"].stringValue == "completed" {
            if let dataFromString = json["results"].stringValue.data(using: .utf8, allowLossyConversion: false) {
                let results = JSON(data: dataFromString)
                
                let newRecommendations = movieProviders.flatMap({
                    (provider:String) -> [Recommendation] in
                    results[provider].arrayValue.map({
                        (recommendation:JSON) -> Recommendation in
                        let movieTitle = recommendation.arrayValue[0]
                        let movieScore = recommendation.arrayValue[1]
                        let movieProvider = provider
                        return Recommendation(movieTitle: movieTitle.stringValue, movieScore: movieScore.floatValue, movieProvider: movieProvider)
                    })
                })
                recommendations = newRecommendations
                
                if let recommendDataManager = recommendDataManager {
                    recommendDataManager.storeRecommendations(recommendations: newRecommendations)
                }
                
                let recommendationsFromProvider = newRecommendations.filter { $0.movieProvider == selectedProvider}
                if let output = output {
                    output.showRecommendations(recommendations: recommendationsFromProvider)
                }
            }
            
            deinitTimer()
            print("job is completed")
            
        } else {
            print("job not completed")
        }
    }
    
    private func deinitTimer() {
        if let timer = timer {
            timer.cancel()
        }
        timer = nil
    }
}
