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
    
    func loadRecommendations() {
        //load recommendations from DM
        if let recommendDataManager = recommendDataManager, let output = output {
            let recommendations = recommendDataManager.fetchRecommendations()
            output.showRecommendations(recommendations: recommendations)
        }
        
        //present recommendations
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
    
    func checkJobStatus(data: Data) -> Void {
        let json = JSON(data: data)
        if json["status"].stringValue == "completed" {
            if let dataFromString = json["results"].stringValue.data(using: .utf8, allowLossyConversion: false) {
                let results = JSON(data: dataFromString)
                
                let newRecommendations = results.arrayValue.map({
                    (recommendation:JSON) -> Recommendation in
                    Recommendation(movieTitle: recommendation.stringValue)
                })
                
                if let recommendDataManager = recommendDataManager {
                    //recommendDataManager.saveCurrentRecommendationsStateToDisk(recommendations: newRecommendations, path: )
                    recommendDataManager.storeRecommendations(recommendations: newRecommendations)
                }
                
                if let output = output {
                    output.showRecommendations(recommendations: newRecommendations)
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
