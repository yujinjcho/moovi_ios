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
    var selectedProvider = "box_office"
    var recommendations = [Recommendation]()
    
    var pollingAttempts = 0
    let pollingLimit = 8 // ~40 seconds is pretty painful
    let pollingInterval = 5
    
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
            
            // DEFINE A FAILURE METHOD
            recommendDataManager.uploadRatings(ratings: ratings, completion: startPolling, failureHandler: networkFailed)
        }
    }
    
    func networkFailed() -> Void {
        if let output = output {
            let title = "Network Error"
            let message = "There seems to be an issue with the network. Please try again at a later time."
            output.notifyError(title: title, message: message)
        }
    }
    
    func serverTimeOut() -> Void {
        if let output = output {
            let title = "Server Error"
            let message = "There seems to be an issue with our servers. We apologize for the inconvenience. Please try again at a later time."
            output.notifyError(title: title, message: message)
        }
    }
    
//    func pollWithLimit() -> (String) -> Void {
//        
//    }
    
    func startPolling(jobID: String) -> Void {
        print("starting polling with \(jobID)")
        pollingAttempts = 0
        let queue = DispatchQueue(label: "com.domain.app.timer")
        timer = DispatchSource.makeTimerSource(queue: queue)
        guard let timer = timer else {
            return
        }
        timer.scheduleRepeating(deadline: .now(), interval: .seconds(pollingInterval))
        timer.setEventHandler { [weak self] in
            if let recommendDataManager = self!.recommendDataManager {
                recommendDataManager.fetchJobStatus(jobID: jobID, completion: self!.checkJobStatus, failureHandler: self!.networkFailed)
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
            pollingAttempts += 1
            print("poll attempt \(pollingAttempts)")
        }
        
        if pollingAttempts == pollingLimit {
            serverTimeOut()
            deinitTimer()
        }
    }
    
    private func deinitTimer() {
        if let timer = timer {
            timer.cancel()
        }
        timer = nil
    }
}
